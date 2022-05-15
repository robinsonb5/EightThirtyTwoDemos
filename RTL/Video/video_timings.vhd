-- VGA Timing generator
-- Copyright (c) 2021 by Alastair M. Robinson

-- This source file is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This source file is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- -----------------------------------------------------------------------

entity video_timings is
	generic (
		clkdivBits : integer := 4;
		hFramingBits : integer := 11;
		vFramingBits : integer := 11
	);
	port (
		-- System
		clk : in std_logic;
		reset_n : in std_logic;
		
		-- Sync / blanking
		pixel_stb : out std_logic;
		hsync_n : out std_logic;
		vsync_n : out std_logic;
		hblank_n : out std_logic;
		vblank_n : out std_logic;
		hblank_stb : out std_logic;
		vblank_stb : out std_logic;
		
		-- Pixel positions
		xpos : out unsigned(hFramingBits-1 downto 0);
		ypos : out unsigned(vFramingBits-1 downto 0);

		-- Framing parameters
		clkdiv : in unsigned(clkdivBits-1 downto 0) := to_unsigned(3,clkdivBits);
		htotal : in unsigned(hFramingBits-1 downto 0) := to_unsigned(800,hFramingBits);
		hbstart : in unsigned(hFramingBits-1 downto 0) := to_unsigned(640,hFramingBits);
		hsstart : in unsigned(hFramingBits-1 downto 0) := to_unsigned(656,hFramingBits);
		hsstop : in unsigned(hFramingBits-1 downto 0) := to_unsigned(752,hFramingBits);

		vtotal : in unsigned(vFramingBits-1 downto 0) := to_unsigned(525,vFramingBits) ;
		vbstart : in unsigned(vFramingBits-1 downto 0) := to_unsigned(480,vFramingBits) ;
		vsstart : in unsigned(vFramingBits-1 downto 0) := to_unsigned(490,vFramingBits) ;
		vsstop : in unsigned(vFramingBits-1 downto 0) := to_unsigned(492,vFramingBits) 
	);
end entity;

-- -----------------------------------------------------------------------

architecture rtl of video_timings is
	signal clkdivCnt : unsigned(clkdivBits-1 downto 0);
	signal hcounter : unsigned(hFramingBits-1 downto 0);
	signal vcounter : unsigned(vFramingBits-1 downto 0);
	signal pixel_stb_r : std_logic;
	signal hb_internal : std_logic;
	signal vb_internal : std_logic;
begin

pixel_stb<=pixel_stb_r;
hblank_n <= hb_internal;
vblank_n <= vb_internal;
xpos <= hcounter when hb_internal='1' else (others => '0');
ypos <= vcounter when vb_internal='1' else (others => '0');

process(clk,reset_n)
begin

	if reset_n='0' then
		clkdivCnt<=(others=>'0');
		hcounter<=(others=>'0');
		vcounter<=(others=>'0');
		hsync_n<='1';
		vsync_n<='1';
		hb_internal<='1';
		vb_internal<='1';
	elsif rising_edge(clk) then	
		hblank_stb<='0';
		vblank_stb<='0';
		pixel_stb_r<='0';
		clkdivCnt<=clkdivCnt+1;

		if clkdivCnt=clkdiv then -- new pixel
			pixel_stb_r<='1';
			
			-- Horizontal counters
			
			hcounter<=hcounter+1;

			if hcounter=hbstart then
				hblank_stb<='1';
				hb_internal<='0';
			end if;
			
			if hcounter=hsstart then
				hsync_n<='0';
			end if;
			
			if hcounter=hsstop then
				hsync_n<='1';
				vcounter<=vcounter+1;			
			end if;

			if hcounter=htotal then -- New row
				hb_internal<='1';
				hcounter<=(others=>'0');
			end if;
			
			-- Vertical counters

			if hcounter=hsstop and vcounter=vbstart then
				vblank_stb<='1';
				vb_internal<='0';
			end if;
			
			if vcounter=vsstart then
				vsync_n<='0';
			end if;
			
			if vcounter=vsstop then
				vsync_n<='1';
			end if;
			
			if hcounter=hsstop and vcounter=vtotal then -- New frame
				vb_internal<='1';
				vcounter<=(others=>'0');
			end if;
			
			clkdivCnt<=(others=>'0');
		end if;
	end if;

end process;

end architecture;
