library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

entity bemicro_cv_top is
	PORT
	(
		clk_50		: IN STD_LOGIC;
		clk_24		: IN std_logic;
		user_dipsw_n		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		user_button_n		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		user_led_n		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		gpio		: OUT STD_LOGIC_VECTOR(7 downto 0);
		sd_mosi	: out std_logic;
		sd_clk 	: out std_logic;
		sd_miso 	: in std_logic;
		sd_d1 	: in std_logic;
		sd_d2 	: in std_logic;
		sd_cs 	: out std_logic
	);
END entity;

architecture RTL of bemicro_cv_top is

signal reset_n : std_logic;
signal ps2k_clk_in : std_logic;
signal ps2k_clk_out : std_logic;
signal ps2k_dat_in : std_logic;
signal ps2k_dat_out : std_logic;
signal ps2m_clk_in : std_logic;
signal ps2m_clk_out : std_logic;
signal ps2m_dat_in : std_logic;
signal ps2m_dat_out : std_logic;

signal pll_locked : std_logic;

signal clk_fast : std_logic;
signal clk_slow : std_logic;
signal clk_ram : std_logic;

component pll is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		outclk_1 : out std_logic;        -- outclk1.clk
		outclk_2 : out std_logic;        -- outclk2.clk
		locked   : out std_logic         --  locked.export
	);
end component;

begin

reset_n <= user_button_n(0);

	myclocks : component pll
	port map (
		refclk => clk_50,
		outclk_0 => clk_fast,
		outclk_1 => clk_ram,
		outclk_2 => clk_slow,
		locked => pll_locked
	);

	myvirtualtoplevel : entity work.VirtualToplevel
		generic map(
			sysclk_frequency => 1000,
			jtag_uart => true
		)
		port map(
			clk => clk_fast,
			slowclk => clk_slow,
			reset_in => reset_n and pll_locked,
			
			-- SDRAM - presenting a single interface to both chips.
--			sdr_addr => sdr_addr,
--			sdr_data => sd2_data,
--			sdr_ba => sdr_ba,
--			sdr_cke => sdr_cke,
--			sdr_dqm => sdr_dqm,
--			sdr_cs => sdr_cs,
--			sdr_we => sdr_we,
--			sdr_cas => sdr_cas,
--			sdr_ras => sdr_ras,
			
			-- VGA
--			vga_red => vga_r,
--			vga_green => vga_g,
--			vga_blue => vga_b,

--			vga_hsync => vga_hsync,
--			vga_vsync => vga_vsync,
			
--			vga_window => vga_window,

			-- UART
			rxd => '1',
--			txd => rs232_txd,
				
--			-- PS/2
			ps2k_clk_in => ps2k_clk_in,
			ps2k_dat_in => ps2k_dat_in,
			ps2k_clk_out => ps2k_clk_out,
			ps2k_dat_out => ps2k_dat_out,
			ps2m_clk_in => ps2m_clk_in,
			ps2m_dat_in => ps2m_dat_in,
			ps2m_clk_out => ps2m_clk_out,
			ps2m_dat_out => ps2m_dat_out,
			
			-- SD Card interface
			spi_cs => sd_cs,
			spi_miso => sd_miso,
			spi_mosi => sd_mosi,
			spi_clk => sd_clk
			
			-- Audio - FIXME abstract this out, too.
--			audio_l => audio_l,
--			audio_r => audio_r
			
			-- LEDs
		);


end architecture;
