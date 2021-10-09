library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Toplevel_Config.all;

library pll;
use pll.all;

-- -----------------------------------------------------------------------

entity de10nano_top is
	port
	(
		FPGA_CLK1_50	:	 IN STD_LOGIC;
		FPGA_CLK2_50	:	 IN STD_LOGIC;
		FPGA_CLK3_50	:	 IN STD_LOGIC;

		SDRAM_CLK		:	 OUT STD_LOGIC;
		SDRAM_CKE		:	 OUT STD_LOGIC;
		SDRAM_A			:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		SDRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		SDRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SDRAM_DQML		:	 OUT STD_LOGIC;
		SDRAM_DQMH		:	 OUT STD_LOGIC;
		SDRAM_nCS		:	 OUT STD_LOGIC;
		SDRAM_nWE		:	 OUT STD_LOGIC;
		SDRAM_nCAS		:	 OUT STD_LOGIC;
		SDRAM_nRAS		:	 OUT STD_LOGIC;

		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT UNSIGNED(5 DOWNTO 0);
		VGA_G		:	 OUT UNSIGNED(5 DOWNTO 0);
		VGA_B		:	 OUT UNSIGNED(5 DOWNTO 0);

		AUDIO_L : out std_logic;
		AUDIO_R : out std_logic;

		LED_USER : out std_logic;
		LED_HDD : out std_logic;
		LED_POWER : out std_logic;

		BTN_USER : in std_logic;
		BTN_OSD : in std_logic;
		BTN_RESET : in std_logic;

		SD_SPI_CS : out std_logic;
		SD_SPI_MISO : in std_logic;
		SD_SPI_MOSI : out std_logic;
		SD_SPI_CLK : out std_logic
	);
END entity;

architecture RTL of de10nano_top is
   constant reset_cycles : integer := 131071;
	
-- System clocks

	signal slowclk : std_logic;
	signal fastclk : std_logic;
	signal pll_locked : std_logic;

-- SPI signals

	signal spi_clk : std_logic;
	signal spi_cs : std_logic;
	signal spi_mosi : std_logic;
	signal spi_miso : std_logic;
	
-- Global signals
	signal n_reset : std_logic;

	
-- Video
	signal vga_red: std_logic_vector(7 downto 0);
	signal vga_green: std_logic_vector(7 downto 0);
	signal vga_blue: std_logic_vector(7 downto 0);
	signal vga_window : std_logic;
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	
	
-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;

-- ESP8266 serial
	signal esp_rxd : std_logic;
	signal esp_txd : std_logic;

-- Sound
	signal audio_left : std_logic_vector(15 downto 0);
	signal audio_right : std_logic_vector(15 downto 0);

	
-- IO


-- Sigma Delta audio
	COMPONENT hybrid_pwm_sd
--	generic ( depop : integer := 1 );
	PORT
	(
		clk	:	IN STD_LOGIC;
--		reset_n : in std_logic;
		terminate : in std_logic;
		d_l	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_l	:	OUT STD_LOGIC;
		d_r	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_r	:	OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT video_vga_dither
	GENERIC ( outbits : INTEGER := 4 );
	PORT
	(
		clk	:	IN STD_LOGIC;
		hsync	:	IN STD_LOGIC;
		vsync	:	IN STD_LOGIC;
		vid_ena	:	IN STD_LOGIC;
		iRed	:	IN UNSIGNED(7 DOWNTO 0);
		iGreen	:	IN UNSIGNED(7 DOWNTO 0);
		iBlue	:	IN UNSIGNED(7 DOWNTO 0);
		oRed	:	OUT UNSIGNED(outbits-1 DOWNTO 0);
		oGreen	:	OUT UNSIGNED(outbits-1 DOWNTO 0);
		oBlue	:	OUT UNSIGNED(outbits-1 DOWNTO 0)
	);
	END COMPONENT;

begin


U00 : entity pll.pll
	port map(
		refclk => FPGA_CLK1_50,       -- 50 MHz external
		outclk_0     => SDRAM_CLK,        -- Fast clock - external
		outclk_1     => fastclk,         -- Fast clock - internal
		outclk_2     => slowclk,         -- Slow clock - internal
		locked => pll_locked
	);

vga_window<='1';

n_reset<=BTN_USER and pll_locked;

virtualtoplevel : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 10,
		sysclk_frequency => 1000, -- Sysclk frequency * 10
		jtag_uart => true,
		debug=>false
	)
	port map(
		clk => fastclk,
		slowclk => slowclk,
		reset_in => n_reset,

		-- VGA
		unsigned(vga_red) => vga_red,
		unsigned(vga_green) => vga_green,
		unsigned(vga_blue) => vga_blue,
		vga_hsync => vga_hsync,
		vga_vsync => vga_vsync,
		vga_window => open,

		-- SDRAM
		sdr_data => SDRAM_DQ,
		sdr_addr	=> SDRAM_A,
		sdr_dqm(1) => SDRAM_DQMH,
		sdr_dqm(0) => SDRAM_DQML,
		sdr_we => SDRAM_nWE,
		sdr_cas => SDRAM_nCAS,
		sdr_ras => SDRAM_nRAS,
		sdr_ba => SDRAM_BA,
		sdr_cs => SDRAM_nCS,
		sdr_cke => SDRAM_CKE,
 
    -- SD/MMC slot ports
	spi_clk => SD_SPI_CLK,
	spi_mosi => SD_SPI_MOSI,
	spi_cs => SD_SPI_CS,
	spi_miso => SD_SPI_MISO,

	signed(audio_l) => audio_left,
	signed(audio_r) => audio_right,

	rxd => '1'
--	txd => rs232_txd,
--	rxd2 => esp_rxd,
--	txd2 => esp_txd
);

genvideo: if Toplevel_UseVGA=true generate
-- Dither the video down to 5 bits per gun.
	vga_window<='1';
	VGA_HS<= not vga_hsync;
	VGA_VS<= not vga_vsync;	

	mydither : component video_vga_dither
		generic map(
			outbits => 6
		)
		port map(
			clk=>fastclk,
			hsync=>vga_hsync,
			vsync=>vga_vsync,
			vid_ena=>vga_window,
			iRed => unsigned(vga_red),
			iGreen => unsigned(vga_green),
			iBlue => unsigned(vga_blue),
			oRed => VGA_R,
			oGreen => VGA_G,
			oBlue => VGA_B
		);
end generate;

genaudio: if Toplevel_UseAudio=true generate
audio_sd: component hybrid_pwm_sd
	port map
	(
		clk => slowclk,
--		reset_n => n_reset,
		terminate => '0',
		d_l(15) => not audio_left(15),
		d_l(14 downto 0) => std_logic_vector(audio_left(14 downto 0)),
		q_l => AUDIO_L,
		d_r(15) => not audio_right(15),
		d_r(14 downto 0) => std_logic_vector(audio_right(14 downto 0)),
		q_r => AUDIO_R
	);
end generate;	


end architecture;
