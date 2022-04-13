library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Toplevel_Config.all;

entity icesugarpro_top is
port(
	clk_i : in std_logic; -- 25MHz

	txd : out std_logic;
	rxd : in std_logic;

	led_red : out std_logic;
	led_green : out std_logic;
	led_blue : out std_logic;

	sdram_clk : out std_logic;
	sdram_a : out std_logic_vector(12 downto 0);
	sdram_dq : inout std_logic_vector(15 downto 0);
	sdram_we_n : out std_logic;
	sdram_ras_n : out std_logic;
	sdram_cas_n : out std_logic;
	sdram_cke : out std_logic;
	sdram_ba : out std_logic_vector(1 downto 0);
	sdram_dm : out std_logic_vector(1 downto 0);
	
	spisdcard_clk : out std_logic;
	spisdcard_mosi : out std_logic;
	spisdcard_cs_n : out std_logic;
	spisdcard_miso : in std_logic;

	gpdi_dp : out std_logic_vector(3 downto 0);	-- Quasi-differential output for digital video.
	gpdi_dn : out std_logic_vector(3 downto 0);

	P2_pmod_high : inout std_logic_vector(7 downto 0);
	P2_gpio : inout std_logic_vector(3 downto 0);
	P2_pmod_low : inout std_logic_vector(7 downto 0);
	P3_pmod_high : inout std_logic_vector(7 downto 0);
	P3_gpio : inout std_logic_vector(3 downto 0);
	P3_pmod_low : inout std_logic_vector(7 downto 0);
	P4_pmod_high : inout std_logic_vector(7 downto 0);
	P4_gpio : inout std_logic_vector(3 downto 0);
	P4_gpio2 : inout std_logic_vector(5 downto 0); -- Two pins not connected, so called GPIO instead of PMOD.
	P5_pmod_high : inout std_logic_vector(7 downto 0); -- Pins shared with breakout board's DAPLink.
	P5_gpio : inout std_logic_vector(3 downto 0);
	P5_pmod_low : inout std_logic_vector(7 downto 0);
	P6_pmod_high : inout std_logic_vector(7 downto 0);
	P6_gpio : inout std_logic_vector(3 downto 0);
	P6_pmod_low : inout std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of icesugarpro_top is

component pll is
port (
	clk_i : in std_logic;
	clk_o : out std_logic_vector(3 downto 0);
	reset : in std_logic :='0';
	locked : out std_logic
);
end component;

signal clk_sdram : std_logic;
signal clk_sys : std_logic;
signal clk_slow : std_logic;
signal clk_none : std_logic;

signal vga_r : unsigned(3 downto 0);
signal vga_g : unsigned(3 downto 0);
signal vga_b : unsigned(3 downto 0);
signal vga_hs : std_logic;
signal vga_vs : std_logic;

signal vga_r_i : unsigned(7 downto 0);
signal vga_g_i : unsigned(7 downto 0);
signal vga_b_i : unsigned(7 downto 0);
signal vga_window : std_logic;

signal vga_pmod_high : std_logic_vector(7 downto 0);
signal vga_pmod_low : std_logic_vector(7 downto 0);

begin

	led_red<='1';
	led_green<='0';
	led_blue<='0';

	P3_pmod_high<=vga_pmod_high;
	P3_pmod_low<=vga_pmod_low;

	clk : component pll
	port map (
		clk_i => clk_i,
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_none
	);

	vt : entity work.VirtualToplevel
	generic map(
		sysclk_frequency => 1000
	)
	port map(
		clk => clk_sys,
		slowclk => clk_slow,
		reset_in => '1',
		txd => txd,
		rxd => rxd,

		unsigned(vga_red) => vga_r_i,
		unsigned(vga_green) => vga_g_i,
		unsigned(vga_blue) => vga_b_i,
		vga_hsync => vga_hs,
		vga_vsync => vga_vs,
		vga_window => vga_window,

		spi_miso => spisdcard_miso,
		spi_mosi => spisdcard_mosi,	
		spi_cs => spisdcard_cs_n,	
		spi_clk => spisdcard_clk
	);

genvideo: if Toplevel_UseVGA=true generate
	-- Dither the video down to 4 bits per gun.

	mydither : entity work.video_vga_dither
		generic map(
			outbits => 4
		)
		port map(
			clk=>clk_sys,
			hsync=>vga_hs,
			vsync=>vga_vs,
			vid_ena=>vga_window,
			iRed => unsigned(vga_r_i),
			iGreen => unsigned(vga_g_i),
			iBlue => unsigned(vga_b_i),
			oRed => vga_r,
			oGreen => vga_g,
			oBlue => vga_b
		);
		
	vga_pmod_high(7 downto 4)<=std_logic_vector(vga_r);
	vga_pmod_high(3 downto 0)<=std_logic_vector(vga_b);
	vga_pmod_low(7 downto 4)<=std_logic_vector(vga_g);
	vga_pmod_low(3 downto 0)<="00"&vga_vs&vga_hs;
		
end generate;

end architecture;

