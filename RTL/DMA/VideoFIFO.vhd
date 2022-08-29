-- New video stream for EightThirtyTwoDemos 

-- Paramters: width, depth, burstlength.


-- SOC Ports:
--    sys_clk - clock for SoC and RAM
--    sys_reset_n - reset for write side of FIFO
--    sys_baseaddr - address of the framebuffer.  Should be burst-aligned (if not we will need to ignore a few output words)
--    sys_req - 1 to indicate the fifo should latch the base address.

-- RAM Ports:
--   to_sdram.req  -  1 to indicate the FIFO wants data
--   to_sdram.pri -  1 to indicate the FIFO is less than half full
--   to_sdram.addr - address of the burst currently being requested
--   from_sdram.ack - 1 to indicate that the current request has been acknowledge and addr can be bumped
--   from_sdram.burst - 1 to indicate that a word is on the bus
--   from_sdram.q - data from memory

-- Video ports: (can be on a different clock domain)
--   video_clk - clock for read side of FIFO
--   video_newframe - causes the FIFO to be emptied and the base address to be copied to to_sdram.addr
--   video_req - advance the read side of the FIFO by one word
--   video_q - output data
--   video_underrun - 1 if the FIFO ran dry.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.sdram_controller_pkg.all;


entity VideoFIFO is
generic (
	width : integer := 32;
	depth : integer := 8; -- Log 2
	burstlength : integer := 8
);
port (
	-- SOC Ports:
	sys_clk : in std_logic;
	sys_reset_n : in std_logic;
	sys_baseaddr : in std_logic_vector(31 downto 0);
	sys_req : in std_logic;
	sys_newframe : out std_logic;

	-- RAM Ports:
	to_sdram : out sdram_port_request;
	from_sdram : in sdram_port_response;

	-- Video ports: (can be on a different clock domain)
	video_clk : in std_logic;
	video_newframe : in std_logic; 
	video_req : in std_logic;
	video_q : out std_logic_vector(31 downto 0);
	video_underrun : out std_logic 
);
end entity;

-- Need an empty signal in the Video domain and a full signal in the RAM domain.
-- The full signal is more important, so cdc the read pointer across to the RAM domain.

-- (Actually we won't bother with an empty signal, since if the video FIFO runs dry we're toast anyway.
-- Any attempt to minimise visual glitches is unlikely to be worth the logic cost of implementation.)

architecture rtl of VideoFIFO is
	signal rdptr : unsigned(depth-1 downto 0) :=(others => '0');
	signal wrptr : unsigned(depth-1 downto 0) :=(others => '0');
	type storage_t is array (0 to 2**depth-1) of std_logic_vector(width-1 downto 0);
	signal storage : storage_t;
	signal video_q_i : std_logic_vector(width-1 downto 0);
begin

	readlogic : block

	begin
		process(video_clk) begin
			if rising_edge(video_clk) then
				if video_req='1' then
					video_q<=video_q_i;
					rdptr<=rdptr+1;
				end if;
				video_q_i <= storage(to_integer(rdptr));
				if video_newframe='1' then
					rdptr<=(others => '0');
				end if;
			end if;
		end process;
	end block;


	writelogic : block
		signal rdptr_latched : std_logic_vector(depth-1 downto 0);
		signal latchctr : unsigned(2 downto 0) :="000";
		signal latch_rdptr : std_logic;
		signal rdptr_ram : std_logic_vector(depth-1 downto 0);
		signal ptrcmp : unsigned(depth-1 downto 0);
		signal newframe_pending : std_logic:='0';
		signal newframe_ram : std_logic; 
		signal addr : unsigned(31 downto 0);
		signal req_i : std_logic :='0';
		signal full : std_logic;
		signal toggle : std_logic;
		signal firstword : std_logic_vector(15 downto 0);
	begin

		wr_32bit : if width=32 generate
			-- Write incoming data from RAM
			process(sys_clk) begin
				if rising_edge(sys_clk) then
					if from_sdram.burst='1' then
						storage(to_integer(wrptr)) <= from_sdram.q;
						wrptr <= wrptr+1;
					end if;	
					if newframe_pending='1' and req_i='0' and from_sdram.burst='0' then
						wrptr<=(others => '0');
					end if;
				end if;
			end process;
		end generate;

		wr_16bit : if width=16 generate
			-- Write incoming data from RAM
			process(sys_clk) begin
				if rising_edge(sys_clk) then
				
					if from_sdram.burst='1' and toggle='0' then
						firstword<=from_sdram.q(15 downto 0);
						toggle<='1';
					end if;
				
					if from_sdram.burst='1' and toggle='1' then
						storage(to_integer(wrptr)) <= firstword&from_sdram.q(15 downto 0);
						toggle<='0';
						wrptr <= wrptr+1;
					end if;	
					if newframe_pending='1' and req_i='0' and from_sdram.burst='0' then
						wrptr<=(others => '0');
						toggle<='0';
					end if;
				end if;
			end process;
		end generate;

		-- Create a pulse every eight clocks to strobe the rdptr's conversion into the RAM clock domain.
		process (video_clk) begin
			if rising_edge(video_clk) then
				latchctr<=latchctr+1;
				latch_rdptr<='0';
				if latchctr="000" then
					rdptr_latched<=std_logic_vector(rdptr);
					latch_rdptr<='1';
				end if;
			end if;
		end process;
	
		-- Bring (a late copy of) the read pointer into the RAM clock domain.
		cdc_readptr : entity work.cdc_bus
		generic map (
			width => depth
		)
		port map (
			clk_d => video_clk,
			d => rdptr_latched,
			d_stb => latch_rdptr,
			
			clk_q => sys_clk,
			q => rdptr_ram
		);

		-- Now we have a clean copy of the read pointer which we can compare against the write pointer.

		ptrcmp <= wrptr-unsigned(rdptr_ram);
		full <= '1' when ptrcmp(ptrcmp'high downto 4) = (2**(depth-4)-1) else '0';

		-- Manage the RAM port

		-- The newframe signal is on the video clock...	
		cdc_newframe : entity work.cdc_pulse
		port map (
			clk_d => video_clk,
			d => video_newframe,
			clk_q => sys_clk,
			q => newframe_ram
		);

		sys_newframe<=newframe_ram;

		process(sys_clk) begin
			if rising_edge(sys_clk) then
				
				if from_sdram.ack='1' then
					addr <= addr + (width/8) * burstlength;
				end if;

				if from_sdram.burst='1' or req_i='0' then
					req_i <= not full and not newframe_pending; -- FIXME - count down the number of words in a frame?
					-- If the read pointer is in danger of catching up, increase the priority.
					to_sdram.pri <= not (ptrcmp(ptrcmp'high) and ptrcmp(ptrcmp'high-1));
				end if;
				
				if newframe_ram='1' then
					newframe_pending <= '1';
				end if;

				if newframe_pending='1' and req_i='0' and from_sdram.burst='0' then
					addr <= unsigned(sys_baseaddr);
					req_i <= '1'; -- New request - high priority.
					to_sdram.pri <= '1';
					newframe_pending<='0';
				end if;
				
			end if;
		end process;

		to_sdram.addr <= std_logic_vector(addr);
		to_sdram.req <= req_i;

		video_underrun <= '1' when ptrcmp=0 else '0';
		
	end block;

end architecture;


