library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library work;
use work.Toplevel_Config.all;

entity DE1_Toplevel is
	port
	(
		CLOCK_24		:	 in std_logic_vector(1 downto 0);
		CLOCK_27		:	 in std_logic_vector(1 downto 0);
		CLOCK_50		:	 in STD_LOGIC;
		EXT_CLOCK		:	 in STD_LOGIC;
		KEY		:	 in std_logic_vector(3 downto 0);
		SW		:	 in std_logic_vector(9 downto 0);
		HEX0		:	 out std_logic_vector(6 downto 0);
		HEX1		:	 out std_logic_vector(6 downto 0);
		HEX2		:	 out std_logic_vector(6 downto 0);
		HEX3		:	 out std_logic_vector(6 downto 0);
		LEDG		:	 out std_logic_vector(7 downto 0);
		LEDR		:	 out std_logic_vector(9 downto 0);
		UART_TXD		:	 out STD_LOGIC;
		UART_RXD		:	 in STD_LOGIC;
		DRAM_DQ		:	 inout std_logic_vector(15 downto 0);
		DRAM_ADDR		:	 out std_logic_vector(11 downto 0);
		DRAM_LDQM		:	 out STD_LOGIC;
		DRAM_UDQM		:	 out STD_LOGIC;
		DRAM_WE_N		:	 out STD_LOGIC;
		DRAM_CAS_N		:	 out STD_LOGIC;
		DRAM_RAS_N		:	 out STD_LOGIC;
		DRAM_CS_N		:	 out STD_LOGIC;
		DRAM_BA_0		:	 out STD_LOGIC;
		DRAM_BA_1		:	 out STD_LOGIC;
		DRAM_CLK		:	 out STD_LOGIC;
		DRAM_CKE		:	 out STD_LOGIC;
		FL_DQ		:	 inout std_logic_vector(7 downto 0);
		FL_ADDR		:	 out std_logic_vector(21 downto 0);
		FL_WE_N		:	 out STD_LOGIC;
		FL_RST_N		:	 out STD_LOGIC;
		FL_OE_N		:	 out STD_LOGIC;
		FL_CE_N		:	 out STD_LOGIC;
		SRAM_DQ		:	 inout std_logic_vector(15 downto 0);
		SRAM_ADDR		:	 out std_logic_vector(17 downto 0);
		SRAM_UB_N		:	 out STD_LOGIC;
		SRAM_LB_N		:	 out STD_LOGIC;
		SRAM_WE_N		:	 out STD_LOGIC;
		SRAM_CE_N		:	 out STD_LOGIC;
		SRAM_OE_N		:	 out STD_LOGIC;
		SD_DAT		:	 in STD_LOGIC;
		SD_DAT3		:	 out STD_LOGIC;
		SD_CMD		:	 out STD_LOGIC;
		SD_CLK		:	 out STD_LOGIC;
		TDI		:	 in STD_LOGIC;
		TCK		:	 in STD_LOGIC;
		TCS		:	 in STD_LOGIC;
		TDO		:	 out STD_LOGIC;
		I2C_SDAT		:	 inout STD_LOGIC;
		I2C_SCLK		:	 out STD_LOGIC;
		PS2_DAT		:	 inout STD_LOGIC;
		PS2_CLK		:	 inout STD_LOGIC;
		VGA_HS		:	 buffer STD_LOGIC;
		VGA_VS		:	 buffer STD_LOGIC;
		VGA_R		:	 out unsigned(3 downto 0);
		VGA_G		:	 out unsigned(3 downto 0);
		VGA_B		:	 out unsigned(3 downto 0);
		AUD_ADCLRCK		:	 out STD_LOGIC;
		AUD_ADCDAT		:	 in STD_LOGIC;
		AUD_DACLRCK		:	 out STD_LOGIC;
		AUD_DACDAT		:	 out STD_LOGIC;
		AUD_BCLK		:	 inout STD_LOGIC;
		AUD_XCK		:	 out STD_LOGIC;
		GPIO_0		:	 inout std_logic_vector(35 downto 0);
		GPIO_1		:	 inout std_logic_vector(35 downto 0)
	);
END entity;

architecture rtl of DE1_Toplevel is

signal reset : std_logic;
signal sysclk : std_logic;
signal pll_locked : std_logic;

signal audio_l : signed(15 downto 0);
signal audio_r : signed(15 downto 0);


signal ps2m_clk_in : std_logic;
signal ps2m_clk_out : std_logic;
signal ps2m_dat_in : std_logic;
signal ps2m_dat_out : std_logic;

signal ps2k_clk_in : std_logic;
signal ps2k_clk_out : std_logic;
signal ps2k_dat_in : std_logic;
signal ps2k_dat_out : std_logic;

alias PS2_MDAT : std_logic is GPIO_1(19);
alias PS2_MCLK : std_logic is GPIO_1(18);


signal vga_tred : unsigned(7 downto 0);
signal vga_tgreen : unsigned(7 downto 0);
signal vga_tblue : unsigned(7 downto 0);
signal vga_window : std_logic;

COMPONENT audio_top
	PORT
	(
		clk		:	 IN STD_LOGIC;
		rst_n		:	 IN STD_LOGIC;
		rdata		:	 IN SIGNED(15 DOWNTO 0);
		ldata		:	 IN SIGNED(15 DOWNTO 0);
		aud_bclk		:	 OUT STD_LOGIC;
		aud_daclrck		:	 OUT STD_LOGIC;
		aud_dacdat		:	 OUT STD_LOGIC;
		aud_xck		:	 OUT STD_LOGIC;
		i2c_sclk		:	 OUT STD_LOGIC;
		i2c_sdat		:	 INOUT STD_LOGIC
	);
END COMPONENT;

COMPONENT video_vga_dither
	GENERIC ( outbits : INTEGER := 4 );
	PORT
	(
		clk		:	 IN STD_LOGIC;
		hsync		:	 IN STD_LOGIC;
		vsync		:	 IN STD_LOGIC;
		vid_ena		:	 IN STD_LOGIC;
		iRed		:	 IN UNSIGNED(7 DOWNTO 0);
		iGreen		:	 IN UNSIGNED(7 DOWNTO 0);
		iBlue		:	 IN UNSIGNED(7 DOWNTO 0);
		oRed		:	 OUT UNSIGNED(outbits-1 DOWNTO 0);
		oGreen		:	 OUT UNSIGNED(outbits-1 DOWNTO 0);
		oBlue		:	 OUT UNSIGNED(outbits-1 DOWNTO 0)
	);
END COMPONENT;

begin

--	All bidir ports tri-stated
FL_DQ <= (others => 'Z');
SRAM_DQ <= (others => 'Z');
I2C_SDAT	<= 'Z';
GPIO_0 <= (others => 'Z');
GPIO_1 <= (others => 'Z');

-- PS2 keyboard & mouse
ps2m_dat_in<=PS2_MDAT;
PS2_MDAT <= '0' when ps2m_dat_out='0' else 'Z';
ps2m_clk_in<=PS2_MCLK;
PS2_MCLK <= '0' when ps2m_clk_out='0' else 'Z';

ps2k_dat_in<=PS2_DAT;
PS2_DAT <= '0' when ps2k_dat_out='0' else 'Z';
ps2k_clk_in<=PS2_CLK;
PS2_CLK <= '0' when ps2k_clk_out='0' else 'Z';



mypll : entity work.Clock_50to100
port map
(
	inclk0 => CLOCK_50,
	c0 => DRAM_CLK,
	c1 => sysclk,
	locked => pll_locked
);

reset<=(not SW(0) xor KEY(0)) and pll_locked;


myVirtualToplevel : entity work.VirtualToplevel
generic map
(
	sdram_rows => 12,
	sdram_cols => 8,
	sysclk_frequency => 1000
)
port map
(	
	clk => sysclk,
	reset_in => reset,

	-- video
	vga_hsync => VGA_HS,
	vga_vsync => VGA_VS,
	vga_red => vga_tred,
	vga_green => vga_tgreen,
	vga_blue => vga_tblue,
	vga_window => vga_window,
	
	-- sdram
	sdr_data => DRAM_DQ,
	sdr_addr => DRAM_ADDR,
	sdr_dqm(1) => DRAM_UDQM,
	sdr_dqm(0) => DRAM_LDQM,
	sdr_we => DRAM_WE_N,
	sdr_cas => DRAM_CAS_N,
	sdr_ras => DRAM_RAS_N,
	sdr_cs => DRAM_CS_N,
	sdr_ba(1) => DRAM_BA_1,
	sdr_ba(0) => DRAM_BA_0,
--	sdr_clk => DRAM_CLK,
	sdr_cke => DRAM_CKE,

	-- RS232
	rxd => UART_RXD,
	txd => UART_TXD,

	-- SD Card
	spi_cs => SD_DAT3,
	spi_miso => SD_DAT,
	spi_mosi => SD_CMD,
	spi_clk => SD_CLK,
	
	-- PS/2
	ps2k_clk_in => ps2k_clk_in,
	ps2k_dat_in => ps2k_dat_in,
	ps2k_clk_out => ps2k_clk_out,
	ps2k_dat_out => ps2k_dat_out,
	ps2m_clk_in => ps2m_clk_in,
	ps2m_dat_in => ps2m_dat_in,
	ps2m_clk_out => ps2m_clk_out,
	ps2m_dat_out => ps2m_dat_out,

	-- Audio
	audio_l => audio_l,
	audio_r => audio_r
);

dither1: if Toplevel_UseVGA=true generate
-- Dither the video down to 4 bits per gun.
mydither : component video_vga_dither
	generic map (
		outbits => 4
	)
	port map (
		clk => sysclk,
		hsync => VGA_HS,
		vsync => VGA_VS,
		vid_ena => vga_window,
		iRed => vga_tred,
		iGreen => vga_tgreen,
		iBlue => vga_tblue,
		oRed => VGA_R,
		oGreen => VGA_G,
		oBlue => VGA_B
	);

end generate;

sound1: if Toplevel_UseAudio=true generate

myaudio: component audio_top
port map(
  clk=>sysclk,
  rst_n=>reset,
  -- audio shifter,
  rdata=>audio_r,
  ldata=>audio_l,
  aud_bclk=>AUD_BCLK, -- CODEC data clock
  aud_daclrck=>AUD_DACLRCK, -- CODEC data clock
  aud_dacdat=>AUD_DACDAT, -- CODEC data
  aud_xck=>AUD_XCK, -- CODEC data clock
  -- I2C audio config
  i2c_sclk=>I2C_SCLK, -- CODEC config clock
  i2c_sdat=>I2C_SDAT -- CODEC config data
);

-- FIXME - make use of the DE1 board's codec
end generate;

sound2: if Toplevel_UseAudio=false generate
-- FIXME - set safe defaults for the audio codec
	aud_xck <= '0';
	aud_daclrck <= '0';
	i2c_sclk <='0';
end generate;

end architecture;
