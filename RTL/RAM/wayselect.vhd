-- Way selection logic for a four-way cache
-- Copyright 2022 by Alastair M. Robinson

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wayselect is
generic (
	cachelines : integer := 128;
	cacheline_slice_upper : integer := 25;
	cacheline_slice_lower : integer := 19
);
port (
	clk : in std_logic;
	reset_n : in std_logic;
	ready : out std_logic;
	addr_in : in std_logic_vector(31 downto 0);
	way_lru : out std_logic_vector(1 downto 0);
	req : in std_logic;
	way_mru : in std_logic_vector(1 downto 0)
);
end entity;

architecture rtl of wayselect is

type states is (RESET,CLEAR,ENDCLEAR,ENDCLEAR2,WAITREQ,WAITACK);
signal state : states := RESET;

type waystorage is array (0 to cachelines-1) of std_logic_vector(7 downto 0);
signal ways : waystorage;

signal wayidx : unsigned((cacheline_slice_upper-cacheline_slice_lower) downto 0) := (others => '0');
signal resetidx : unsigned((cacheline_slice_upper-cacheline_slice_lower) downto 0);
signal waywr : std_logic;
signal wayd : std_logic_vector(7 downto 0);
signal wayq : std_logic_vector(7 downto 0);
signal resetting : std_logic;

-- Tag RAM needs to store a history tag for each line:
-- In the case of a four-way cache, take four markers,
-- AABBCCDD, where each can be 00, 01, 10 or 11 to represent the different ways of the cache
-- AA represents the most recently used way
-- DD represents the least recently used way

-- To update the history tag with a new value, WWEEFFGG:
-- Four possible states after bumping a way:
-- AABBCCDD
-- BBAACCDD
-- CCAABBDD
-- DDAABBCC
-- WW <= selected way
-- EE is BB when AA=WW else AA;
-- FF is CC when AA=WW or BB=WW else BB;
-- GG is CC when DD=WW else DD;

signal newway : std_logic_vector(7 downto 0);

begin

	ready <= not resetting;
	wayidx<=resetidx when resetting='1' else unsigned(addr_in(cacheline_slice_upper downto cacheline_slice_lower));

	newway(7 downto 6) <= way_mru;
	newway(5 downto 4) <= wayq(5 downto 4) when wayq(7 downto 6) = way_mru else wayq(7 downto 6); 
	newway(3 downto 2) <= wayq(3 downto 2) when wayq(7 downto 6) = way_mru or wayq(5 downto 4) = way_mru else wayq(5 downto 4); 
	newway(1 downto 0) <= wayq(3 downto 2) when wayq(1 downto 0) = way_mru else wayq(1 downto 0); 

	process(clk,reset_n)
	begin
		if reset_n='0' then
			state<=RESET;
		elsif rising_edge(clk) then

			resetting<='0';
			waywr<='0';

			case state is
				when RESET =>
					resetting<='1';
					wayd<="00011011";
					resetidx<=(others=>'0');
					waywr<='1';
					state<=CLEAR;
					way_lru<="00";
				when CLEAR =>
					resetting<='1';
					resetidx<=resetidx+1;
					waywr<='1';
					if resetidx=cachelines-2 then
						state<=ENDCLEAR;
					end if;
					
				when ENDCLEAR =>
					resetting<='0';
					state<=ENDCLEAR2;

				when ENDCLEAR2 =>
					state<=WAITREQ;

				when WAITREQ =>
					way_lru <= wayq(1 downto 0);
					if req='1' then
						state <= WAITACK;
						wayd<=newway;
						waywr<='1';
					end if;
									
				when WAITACK =>
					if req='0' then
						state<=WAITREQ;
					end if;
			end case;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if waywr='1' then
				ways(to_integer(wayidx))<=wayd;
			end if;
			wayq<=ways(to_integer(wayidx));
		end if;
	end process;

end architecture;

