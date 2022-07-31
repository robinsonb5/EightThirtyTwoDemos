-- Direct mapped Cache

-- 32 bit address and data.
-- 8 word bursts, 32-bit SDRAM interface, so cachelines of 8 32-bit words

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DirectMappedCache is
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
	cpu_cachevalid : out std_logic;
	cpu_rw : in std_logic; -- 1 for read cycle, 0 for write cycles
	bytesel : in std_logic_vector(3 downto 0);
	data_from_cpu : in std_logic_vector(31 downto 0);
	data_to_cpu : out std_logic_vector(31 downto 0);
	-- SDRAM interface
	data_from_sdram : in std_logic_vector(31 downto 0);
	sdram_addr : out std_logic_vector(31 downto 0);
	sdram_req : out std_logic;
	sdram_fill : in std_logic;
	busy : out std_logic;
	flush : in std_logic
);
end entity;

architecture behavioural of DirectMappedCache is
	constant cachebits : integer := cachemsb-1;
	constant tagbits : integer := cachebits-3;

	-- States for state machine
	type states_t is (S_INIT, S_FLUSH1, S_FLUSH2, S_WAITING, S_WAITRD, S_WRITE1, S_WRITE2, S_WAITFILL,
		S_FILL2, S_FILL3, S_FILL4, S_FILL5, S_FILL6, S_FILL7, S_FILL8, S_FILL9, S_PAUSE1);
	signal state : states_t := S_INIT;

	signal readword_burst : std_logic;
	signal readword : unsigned(burstlog2-1 downto 0);

	signal latched_cpuaddr : std_logic_vector(31 downto 0);

	signal data_q : std_logic_vector(31 downto 0);
	signal data_w : std_logic_vector(31 downto 0);
	signal data_wren : std_logic;
	signal data_valid : std_logic;

	signal tagwrite : std_logic;
	signal tagwrite_a : std_logic_vector(cachebits-1 downto 0);
	signal tag_q : std_logic_vector(31 downto 0);
	signal tag_w : std_logic_vector(31 downto 0);
	signal tag_wren : std_logic;
	signal tag_hit : std_logic;
	
	signal busy_i : std_logic;

begin

	sdram_addr <= latched_cpuaddr;

	-- RAM blocks
	
	tagblock : block
		type tagmem_t is array (0 to (2**tagbits)-1) of std_logic_vector(31 downto 0);
		signal tagmem : tagmem_t;
		signal tag_a : std_logic_vector(tagbits-1 downto 0);
	begin
		tag_a <= latched_cpuaddr(cachebits+1 downto burstlog2+2) when readword_burst='1'
			else cpu_addr(cachebits+1 downto burstlog2+2);
	
		process(clk) begin
			if rising_edge(clk) then
				if tag_wren='1' then
					tagmem(to_integer(unsigned(tag_a)))<=tag_w;
				end if;

				tag_q<=tagmem(to_integer(unsigned(tag_a)));
			end if;
		end process;

		tag_hit <= '1' when tag_q(26 downto cachemsb-(burstlog2+2)) = cpu_addr(31 downto cachemsb) else '0';
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

		data_a <= latched_cpuaddr(cachebits+1 downto burstlog2+2)&std_logic_vector(readword) when readword_burst='1'
			else cpu_addr(cachebits+1 downto 2);

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
		signal firstword : std_logic_vector(31 downto 0);
		signal firstword_ready : std_logic := '0';
		signal cpu_req_d : std_logic;
		signal flushpending : std_logic;
	begin
		data_to_cpu <= firstword when firstword_ready='1' else data_q;
		busy <= busy_i;
		cpu_cachevalid <= '1' when firstword_ready='1'
				 or (busy_i='0' and tag_hit='1' and data_valid='1' and cpu_req='1' and cpu_rw='1')
				 	else '0';
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

				case state is

					-- We use an init state here to loop through the data, clearing
					-- the valid flag - for which we'll use bit 17 of the data entry.
				
					when S_INIT =>
						ready<='0';
						state<=S_FLUSH1;
						firstword_ready<='0';
						readword_burst<='1';
					
					when S_FLUSH1 =>
						latched_cpuaddr<=std_logic_vector(to_unsigned(2**(burstlog2+2),32));
						readword<=(0=>'1',others =>'0');
						tag_w <= (others => '0');
						tag_wren<='1';
						readword_burst<='1';
						state<=S_FLUSH2;
					
					when S_FLUSH2 =>
						readword_burst<='1';
						if readword=0 then
							latched_cpuaddr<=std_logic_vector(unsigned(latched_cpuaddr)+2**(burstlog2+2));
						end if;
						readword<=readword+1;
						tag_wren<='1';
						if unsigned(latched_cpuaddr(cachemsb+1 downto burstlog2+2))=0 and readword=0 then
							state<=S_WAITING;
							flushpending<='0';
						end if;

					when S_WAITING =>
						state<=S_WAITING;
						ready<='1';
						busy_i <= '0';
						tag_w(31)<='1';
						tag_w(20 downto burstlog2+3)<=(others => '0');
						tag_w(31-(burstlog2+2) downto 0) <= cpu_addr(31 downto burstlog2+2);
						latched_cpuaddr<=cpu_addr;
						if firstword_ready='0' and cpu_req='1' then
							if cpu_rw='1' then -- Read cycle
								state<=S_WAITRD;
							else	-- Write cycle
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
							tag_w(31 downto burstlog2+3)<=(others => '0');
							tag_w(31-(burstlog2+2) downto 0) <= cpu_addr(31 downto burstlog2+2);
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

						if sdram_fill='1' then
							sdram_req<='0';
							-- Forward data to CPU
							firstword <= data_from_sdram;
							firstword_ready<='1';

							-- write first word to Cache...
							data_w<=data_from_sdram;
							data_wren<='1';
							state<=S_FILL2;
						end if;

					when S_FILL2 =>
						-- write second word to Cache...
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL3;

					when S_FILL3 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL4;

					when S_FILL4 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL5;

					when S_FILL5 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL6;

					when S_FILL6 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL7;

					when S_FILL7 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL8;
					
					when S_FILL8 =>
						readword_burst<='1';
						readword<=readword+1;
						data_w<=data_from_sdram;
						data_wren<='1';
						state<=S_FILL9;
					
					when S_FILL9 =>
						readword<=unsigned(latched_cpuaddr(4 downto 2));
						state<=S_WAITING;

					when others =>
						state<=S_WAITING;
				end case;

				if cpu_req='0' then
					firstword_ready<='0';
				end if;

				if reset='0' then
					state<=S_INIT;
					sdram_req<='0';
					firstword_ready<='0';
				end if;
				
			end if;

		end process;

	end block;
	
end architecture;

