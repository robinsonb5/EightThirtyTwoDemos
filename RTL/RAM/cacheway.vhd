------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Direct mapped cacheway                                                   --
--                                                                          --
-- Copyright (c) 2022 Alastair M. Robinson                                  -- 
--                                                                          --
-- This source file is free software: you can redistribute it and/or modify --
-- it under the terms of the GNU General Public License as published        --
-- by the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                      --
--                                                                          --
-- This source file is distributed in the hope that it will be useful,      --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU General Public License for more details.                             --
--                                                                          --
-- You should have received a copy of the GNU General Public License        --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
--                                                                          --
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Simplified version, with the host being responsible for collecting the first word from the burst.

-- 32 bit address and data.
-- Intended to be used with 8 word bursts, but at 32-bit width, so if the SDRAM is only
-- 16 bits wide, the bursts will be effectively half the length.


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

	attribute no_rw_check : boolean;
begin

	-- RAM blocks
	
	tagblock : block
		type tagmem_t is array (0 to (2**tagbits)-1) of std_logic_vector(31 downto 0);
		signal tagmem : tagmem_t;
		attribute no_rw_check of tagmem : signal is true;
		signal tag_ra : std_logic_vector(tagbits-1 downto 0);
		signal tag_wa : std_logic_vector(tagbits-1 downto 0);
	begin
		tag_wa <= latched_cpuaddr(tagmsb downto taglsb);
		tag_ra <= cpu_addr(tagmsb downto taglsb);
	
		process(clk) begin
			if rising_edge(clk) then
				if tag_wren='1' then
					tagmem(to_integer(unsigned(tag_wa)))<=tag_w;
				end if;
			end if;
		end process;

		process(clk) begin
			if rising_edge(clk) then
				tag_q<=tagmem(to_integer(unsigned(tag_ra)));
			end if;
		end process;

		tag_hit <= '1' when tag_q(31-taglsb downto 0) = cpu_addr(31 downto taglsb) else '0';
		data_valid <= tag_q(31);
		
	end block;


	datablock : block
		type datamem_t is array (0 to (2**cachebits)-1) of std_logic_vector(31 downto 0);
		signal datamem : datamem_t;
		attribute no_rw_check of datamem : signal is true;
		signal data_ra : std_logic_vector(cachebits-1 downto 0);
		signal data_wa : std_logic_vector(cachebits-1 downto 0);
	begin
		
		-- In the data blockram the lower burstlog2 bits of the address determine
		-- which word of the burst we're reading.  When reading from the cache, this comes
		-- from the CPU address; when writing to the cache it's determined by the state
		-- machine.

		data_wa <= latched_cpuaddr(cachemsb downto taglsb)&std_logic_vector(readword);
		data_ra <= cpu_addr(cachemsb downto 2);

		process(clk) begin
			if rising_edge(clk) then
				if data_wren='1' then
					datamem(to_integer(unsigned(data_wa)))<=data_w;
				end if;
			end if;
		end process;
		
		process(clk) begin
			if rising_edge(clk) then
				data_q<=datamem(to_integer(unsigned(data_ra)));
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
				data_wren<='0';
				readword_burst<='0';

				busy_i <= '1';

				-- Setting tag_wren to '1' will invalidate the cacheline unless tag_w(31) is also set to '1'
				tag_wren<='0';
				tag_w(31 downto 32-taglsb)<=(others => '0');
				tag_w(31-taglsb downto 0) <= latched_cpuaddr(31 downto taglsb);
				
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
						tag_wren<='1';	-- Invalidate the cacheline
						readword_burst<='1';
						state<=S_FLUSH2;

					when S_FLUSH2 =>
						readword_burst<='1';
						if readword=0 then
							latched_cpuaddr<=std_logic_vector(unsigned(latched_cpuaddr)+2**taglsb);
						end if;
						readword<=readword+1;
						tag_wren<='1';	-- Invalidate the cacheline
						if unsigned(latched_cpuaddr(cachemsb+1 downto taglsb))=0 and readword=0 then
							state<=S_WAITING;
							flushpending<='0';
						end if;

					when S_WAITING =>
						state<=S_WAITING;
						ready<='1';
						busy_i <= '0';
						latched_cpuaddr<=cpu_addr;
						if cpu_req='1' then
							newreq<='0';
							if cpu_wr='0' then -- Read cycle
								state<=S_WAITRD;
							elsif newreq='1' then	-- Write cycle
								readword_burst<='1';
								if cpu_addr(30) = '0' then 	-- An upper image of the RAM with cache clear bypass.
									tag_wren<='1';	-- Invalidate the cacheline
								end if;
							end if;
						end if;
						if flushpending='1' then
							state<=S_FLUSH1;
						end if;

					when S_WRITE1 =>
						readword_burst<='1';
						if tag_hit='1' then 
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
							tag_wren<='1';	-- Mark the cacheline temporarily invalid

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
							tag_w(31)<='1';	-- Mark the cacheline as valid.
							tag_wren<='1';
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

