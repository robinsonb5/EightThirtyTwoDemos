------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Scheduler for manually refreshing SDRAM                                  --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdram_refresh_schedule is
generic (
	tCK : integer := 10000;
	tREF : integer := 64;
	rowbits : integer := 13
);
port (
	clk : in std_logic;
	reset_n : in std_logic;
	refreshing : in std_logic;
	req : out std_logic;
	pri : out std_logic;
	addr : out std_logic_vector(rowbits-1 downto 0)
);
end entity;

architecture rtl of sdram_refresh_schedule is
	-- Refresh timing: (2*rowbits) refreshes = tREF milliseconds
	-- 1 refresh = tREF/(2**rowbit) ms
	-- 1 ms = 10^9 / tCK cycles
	-- 1 refresh = (10^9*tREF)/(tCK * 2**rowbit) cycles;
	constant khz : integer := (10**9)/tCK;
	constant ticksperrefresh : integer := (khz * tREF)/(2**rowbits)-2;
	constant forcetime : integer := ticksperrefresh-32;

	signal refresh_count : unsigned(19 downto 0);
	signal need_refresh : std_logic;
	signal force_refresh : std_logic;

	signal addr_r : unsigned(rowbits-1 downto 0);
begin

	req <= need_refresh or force_refresh;
	pri <= force_refresh;

	process(clk, reset_n) begin
		if reset_n='0' then
			addr_r <= (others => '0');
			refresh_count<=(others => '0');
			need_refresh<='0';
			force_refresh<='0';
		elsif rising_edge(clk) then
			refresh_count<=refresh_count+1;		
			
			if refreshing='1' then
				need_refresh<='0';
				force_refresh<='0';
				addr_r<=addr_r+1;
			end if;
			
			if refresh_count=ticksperrefresh then
				need_refresh<='1';
				refresh_count<=(others => '0');
			end if;
			
			if refresh_count=forcetime then
				force_refresh<=need_refresh;
			end if;
		end if;
	end process;

	addr <= std_logic_vector(addr_r);

end architecture;

