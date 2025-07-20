-- Minimig toplevel file
-- 
-- This file is part of Minimig
-- 
-- Minimig is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
-- 
-- Minimig is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http:-- www.gnu.org/licenses/>.
--
-- Toplevel converted to VHDL by Alastair M. Robinson

-- NOTE - Minimig's FPGA doesn't support byte enables on block RAM, thus
-- can't support the current "ROMs".


library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library work;
use work.Toplevel_Config.ALL;


entity panologic_g1_toplevel is
port (
	-- system	pins
	clk_i : in std_logic;				-- master system clock (4.433619MHz)
	-- rs232 pins
	led_red : out std_logic;
	led_green : out std_logic;
	led_blue : out std_logic
);
end entity;

architecture RTL of panologic_g1_toplevel is

signal sysclk : std_logic;
signal slowclk : std_logic;
signal clk_internal : std_logic;
signal clklocked : std_logic;
signal clklocked2 : std_logic;

signal counter : unsigned(31 downto 0);

begin

mypll1 : entity work.pll
port map(
	CLKIN_IN => clk_i,
	RST_IN => '0',
	CLKFX_OUT => clk_internal,
	LOCKED_OUT => clklocked
);

mypll2 : entity work.splitpll
port map(
	CLKIN_IN => clk_internal,
	RST_IN => '0',
	CLK0_OUT => slowclk,
	CLK2X_OUT => sysclk,
	LOCKED_OUT => clklocked2
);

project: entity work.VirtualToplevel
	generic map (
		sysclk_frequency => 1108 -- Sysclk frequency * 10
	)
	port map (
		clk => sysclk,
		slowclk => slowclk,
		reset_in => '1'

		-- VGA
--		vga_red => vga_red,
--		vga_green => vga_green,
--		vga_blue => vga_blue,
--		vga_hsync 	=> n_hsync,
--		vga_vsync 	=> n_vsync,
--		vga_window	: out std_logic;

		-- SDRAM
--		sdr_data		: inout std_logic_vector(15 downto 0);
--		sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
--		sdr_dqm 		: out std_logic_vector(1 downto 0);
--		sdr_we 		: out std_logic;
--		sdr_cas 		: out std_logic;
--		sdr_ras 		: out std_logic;
--		sdr_cs		: out std_logic;
--		sdr_ba		: out std_logic_vector(1 downto 0);
--		sdr_clk		: out std_logic;
--		sdr_cke		: out std_logic;

		-- SPI signals
--		spi_miso		: in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
--		spi_mosi		: out std_logic;
--		spi_clk		: out std_logic;
--		spi_cs 		: out std_logic;
		
		-- UART
--		rxd => rxd,
--		txd => txd,
			
		-- PS/2
--		ps2k_clk_in => ps2k_clk_in,
--		ps2k_dat_in => ps2k_dat_in,
--		ps2k_clk_out => ps2k_clk_out,
--		ps2k_dat_out => ps2k_dat_out,
--		ps2m_clk_in => ps2m_clk_in,
--		ps2m_dat_in => ps2m_dat_in,
--		ps2m_clk_out => ps2m_clk_out,
--		ps2m_dat_out => ps2m_dat_out,

		-- Audio
--		audio_l => audiol,
--		audio_r => audior
);

led_red <= '1';
led_green <= '1';
led_blue <= '0';

end architecture;
