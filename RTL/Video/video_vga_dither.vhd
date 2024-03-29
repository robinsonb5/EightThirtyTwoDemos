-- A component to dither a video signal, by Alastair M. Robinson
-- Adds one bit of temporal dithering and one bit of spatial dithering,
-- allowing the 4-bit video output of the DE1 to approach 6-bit colour resolution,
-- and the MIST 6-bit resistor ladder DAC to approach 8-bit resolution.
-- Copyright (c) 2014 - 2022 by Alastair M. Robinson

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
use IEEE.numeric_std.ALL;

entity video_vga_dither is
	generic (
		outbits : integer :=4
	);
	port (
		clk : in std_logic;
		hsync : in std_logic;
		vsync : in std_logic;
		vid_ena : in std_logic;
		iRed : in unsigned(7 downto 0);
		iGreen : in unsigned(7 downto 0);
		iBlue : in unsigned(7 downto 0);
		ohsync : out std_logic;
		ovsync : out std_logic;
		oRed : out unsigned(outbits-1 downto 0);
		oGreen : out unsigned(outbits-1 downto 0);
		oBlue : out unsigned(outbits-1 downto 0)		
	);
end entity;

architecture rtl of video_vga_dither is
	signal field : std_logic := '0';
	signal row : std_logic := '0';
	signal red : unsigned(7 downto 0);
	signal green : unsigned(7 downto 0);
	signal blue : unsigned(7 downto 0);
	signal hsync_d : std_logic;
	signal vsync_d : std_logic;
	signal dither : unsigned(7 downto 0);
	signal ctr : unsigned(2 downto 0);
	signal prevhsync : std_logic :='0';
	signal prevvsync : std_logic :='0';
	signal vid_ena_d : std_logic :='0';
	signal vid_ena_d2 : std_logic :='0';
	constant vidmax : unsigned(7 downto 0) := "11111111";
begin

	process(clk)
	begin
		if rising_edge(clk) then
			ctr <= ctr+1;

--			vid_ena_d2<=vid_ena; -- Delay by the same amount as the video itself.
			vid_ena_d<=vid_ena; -- Delay by the same amount as the video itself.

			if prevhsync='0' and hsync='1' then
				row<=not row;
				ctr<=(others =>'0');
			end if;
			prevhsync<=hsync;

			if prevvsync='0' and vsync='1' then
				field<=not field;
			end if;
			prevvsync<=vsync;

			dither<=(others => '0');
			dither(7-outbits)<=field xor row;
			dither(6-outbits)<=ctr(2) xor row;
		
			if iRed(7 downto (8-outbits))=vidmax(7 downto (8-outbits)) then
				red <= iRed;
			else
				red <= (iRed + dither);
			end if;
			
			if iGreen(7 downto (8-outbits))=vidmax(7 downto (8-outbits)) then
				green <= iGreen;
			else
				green <= (iGreen + dither);
			end if;

			if iBlue(7 downto (8-outbits))=vidmax(7 downto (8-outbits)) then
				blue <= iBlue;
			else
				blue <= (iBlue+ dither);
			end if;
			
			-- Delay sync signals by the same amount as the actual video.
			hsync_d <= hsync;
			ohsync <= hsync_d;

			vsync_d <= vsync;
			ovsync <= vsync_d;

			if vid_ena_d='1' then
				oRed <= red(7 downto (8-outbits));
				oGreen <= green(7 downto (8-outbits));
				oBlue <= blue(7 downto (8-outbits));
			else
				oRed <= (others => '0');
				oGreen <= (others => '0');
				oBlue <= (others => '0');
			end if;
		end if;
	end process;
end architecture;
