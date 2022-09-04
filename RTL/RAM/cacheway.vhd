-- Direct mapped Cache
-- Simplified version, with the host being responsible for collecting the first word from the burst.

-- 32 bit address and data.
-- 8 word bursts, 32-bit SDRAM interface, so cachelines of 8 32-bit words

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cacheway is
generic (
	cachemsb : integer := 11;
	burstlog2 : integer := 3
);
port (
	clk : in std_logic;
	reset : in std_logic;
	ready : out std_logic;
	cpu_addr : in std_logic_vector(31 downto 0);
	cpu_req : in std_logic;
	cpu_wr : in std_logic; -- 0 for read cycle, 1 for write cycles
	cpu_cachevalid : out std_logic;
	data_to_cpu : out std_logic_vector(31 downto 0);
	-- SDRAM interface
	data_from_sdram : in std_logic_vector(31 downto 0);
	sdram_req : out std_logic;
	sdram_burst : in std_logic;
	sdram_strobe : in std_logic;
	busy : out std_logic;
	flush : in std_logic
);
end entity;

architecture behavioural of cacheway is
	constant cachebits : integer := cachemsb-1;
	constant tagbits : integer := cachebits-burstlog2;
	constant taglsb : integer := burstlog2+2;	-- burst length * 32-bit words
	constant tagmsb : integer := taglsb+tagbits-1;

	-- States for state machine
	type states_t is (S_INIT, S_FLUSH1, S_FLUSH2, S_WAITING, S_WAITRD, S_WRITE1, S_WRITE2, S_WAITFILL,
		S_FILL, S_PAUSE1);
	signal state : states_t := S_INIT;

	signal readword_burst : std_logic;
	signal readword : unsigned(burstlog2-1 downto 0);

	signal latched_cpuaddr : std_logic_vector(31 downto 0);

	signal data_q : std_logic_vector(31 downto 0);
	signal data_w : std_logic_vector(31 downto 0);
	signal data_wren : std_logic;
	signal data_valid : std_logic;

	signal tag_q : std_logic_vector(31 downto 0);
	signal tag_w : std_logic_vector(31 downto 0);
	signal tag_wren : std_logic;
	signal tag_hit : std_logic;
	
	signal busy_i : std_logic;

begin

	-- RAM blocks
	
	tagblock : block
		type tagmem_t is array (0 to (2**tagbits)-1) of std_logic_vector(31 downto 0);
		signal tagmem : tagmem_t;
		signal tag_a : std_logic_vector(tagbits-1 downto 0);
	begin
		tag_a <= latched_cpuaddr(tagmsb downto taglsb) when readword_burst='1'
			else cpu_addr(tagmsb downto taglsb);
	
		process(clk) begin
			if rising_edge(clk) then
				if tag_wren='1' then
					tagmem(to_integer(unsigned(tag_a)))<=tag_w;
				end if;

				tag_q<=tagmem(to_integer(unsigned(tag_a)));
			end if;
		end process;

		tag_hit <= '1' when tag_q(26 downto cachemsb-4) = cpu_addr(31 downto cachemsb+1) else '0';
		data_valid <= tag_q(31);
		
	end block;


	datablock : block
		type datamem_t is array (0 to (2**cachebits)-1) of std_logic_vector(31 downto 0);
		signal datamem : datamem_t;
		signal data_a : std_logic_vector(cachebits-1 downto 0);
	begin
		
		-- In the data blockram the lower burstlog2 bits of the address determine
		-- which word of the burst we're reading.  When reading from the cache, this comes
		-- from the CPU address; when writing to the cache it's determined by the state
		-- machine.

		data_a <= latched_cpuaddr(cachemsb downto taglsb)&std_logic_vector(readword) when readword_burst='1'
			else cpu_addr(cachemsb downto 2);

		process(clk) begin
			if rising_edge(clk) then
				if data_wren='1' then
					datamem(to_integer(unsigned(data_a)))<=data_w;
				end if;

				data_q<=datamem(to_integer(unsigned(data_a)));
			end if;
		end process;
	end block;


	statemachine : block
		signal cpu_req_d : std_logic;
		signal flushpending : std_logic;
		signal newreq : std_logic;
	begin
		data_to_cpu <= data_q;
		busy <= busy_i;
		cpu_cachevalid <= '1' when (busy_i='0' and tag_hit='1' and data_valid='1' and cpu_wr='0') else '0';

		process(clk) begin
			if rising_edge(clk) then			
				-- Defaults
				tag_wren<='0';
				data_wren<='0';
				readword_burst<='0';
				
				busy_i <= '1';
				
				cpu_req_d<=cpu_req;
				
				if flush='1' then
					flushpending<='1';
				end if;

				if cpu_req='0' then
					newreq<='1';
				end if;
				
				case state is

					-- We use an init state here to loop through the data, clearing
					-- the valid flag - for which we'll use bit 31 of the tag entry.

					when S_INIT =>
						ready<='0';
						state<=S_FLUSH1;
						readword_burst<='1';

					when S_FLUSH1 =>
						latched_cpuaddr<=std_logic_vector(to_unsigned(2**taglsb,32));
						readword<=(0=>'1',others =>'0');
						tag_w <= (others => '0');
						tag_wren<='1';
						readword_burst<='1';
						state<=S_FLUSH2;

					when S_FLUSH2 =>
						readword_burst<='1';
						if readword=0 then
							latched_cpuaddr<=std_logic_vector(unsigned(latched_cpuaddr)+2**taglsb);
						end if;
						readword<=readword+1;
						tag_wren<='1';
						if unsigned(latched_cpuaddr(cachemsb+1 downto taglsb))=0 and readword=0 then
							state<=S_WAITING;
							flushpending<='0';
						end if;

					when S_WAITING =>
						state<=S_WAITING;
						ready<='1';
						busy_i <= '0';
						tag_w(31)<='1';
						tag_w(30 downto 32-taglsb)<=(others => '0');
						tag_w(26 downto 0) <= cpu_addr(31 downto 5);
						latched_cpuaddr<=cpu_addr;
						if cpu_req='1' then
							newreq<='0';
							if cpu_wr='0' then -- Read cycle
								state<=S_WAITRD;
							elsif newreq='1' then	-- Write cycle
								readword_burst<='1';
								if cpu_addr(30) = '0' then 	-- An upper image of the RAM with cache clear bypass.
									state<=S_WRITE1;
								end if;
							end if;
						end if;
						if flushpending='1' then
							state<=S_FLUSH1;
						end if;

					when S_WRITE1 =>
						if tag_hit='1' then 
							tag_w(31 downto 32-taglsb)<=(others => '0');
							tag_w(31-taglsb downto 0) <= cpu_addr(31 downto taglsb);
							tag_wren<='1';
						end if;
						state<=S_WAITING;

					when S_WAITRD =>
						if cpu_req='1' then -- Read cycle
							state<=S_PAUSE1;
						else
							state<=S_WAITING;
						end if;
						
						-- Check for a match...
						if tag_hit='0' or data_valid='0' then -- No hit, set the tag, start a request.
							tag_wren<='1';

							sdram_req<='1';
							state<=S_WAITFILL;
						end if;

					when S_PAUSE1 =>
						if cpu_req='0' then
							state<=S_WAITING;
						end if;
					
					when S_WAITFILL =>
						readword_burst<='1';
						-- In the interests of performance, read the word we're waiting for first.
						readword<=unsigned(latched_cpuaddr(burstlog2+1 downto 2));

						if sdram_strobe='1' then
							sdram_req<='0';
							-- write first word to Cache...
							data_w<=data_from_sdram;
							data_wren<='1';
							state<=S_FILL;
						end if;

					when S_FILL =>
						-- write next word to Cache...
						if sdram_strobe='1' then
							readword_burst<='1';
							readword<=readword+1;
							data_w<=data_from_sdram;
							data_wren<='1';
						end if;
						if sdram_burst='0' then
							readword<=unsigned(latched_cpuaddr(burstlog2+1 downto 2));
							state<=S_WAITING;
						end if;

					when others =>
						state<=S_WAITING;
				end case;

				if reset='0' then
					state<=S_INIT;
					sdram_req<='0';
				end if;
				
			end if;

		end process;

	end block;
	
end architecture;

