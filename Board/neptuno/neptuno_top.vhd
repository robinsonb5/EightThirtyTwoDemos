library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Toplevel_Config.all;

-- -----------------------------------------------------------------------

entity neptuno_top is
	port
	(
		clock_50_i	:	 IN STD_LOGIC;
		LED         :   OUT STD_LOGIC;
		DRAM_CLK		:	 OUT STD_LOGIC;
		DRAM_CKE		:	 OUT STD_LOGIC;
		DRAM_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_LDQM		:	 OUT STD_LOGIC;
		DRAM_UDQM		:	 OUT STD_LOGIC;
		DRAM_CS_N		:	 OUT STD_LOGIC;
		DRAM_WE_N		:	 OUT STD_LOGIC;
		DRAM_CAS_N		:	 OUT STD_LOGIC;
		DRAM_RAS_N		:	 OUT STD_LOGIC;
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT UNSIGNED(5 DOWNTO 0);
		VGA_G		:	 OUT UNSIGNED(5 DOWNTO 0);
		VGA_B		:	 OUT UNSIGNED(5 DOWNTO 0);
		-- AUDIO
		SIGMA_R                     : OUT STD_LOGIC;
		SIGMA_L                     : OUT STD_LOGIC;
				-- I2S audio		
		I2S_BCLK				: out   std_logic								:= '0';
		I2S_LRCLK			: out   std_logic								:= '0';
		I2S_DATA				: out   std_logic								:= '0';		
      
		-- JOYSTICK 
		JOY_CLK				: out   std_logic;
		JOY_LOAD 			: out   std_logic;
		JOY_DATA 			: in    std_logic;
		joyP7_o			   : out   std_logic								:= '1';

		-- PS2
		PS2_KEYBOARD_CLK            :    INOUT STD_LOGIC;
		PS2_KEYBOARD_DAT            :    INOUT STD_LOGIC;
		PS2_MOUSE_CLK               :    INOUT STD_LOGIC;
		PS2_MOUSE_DAT               :    INOUT STD_LOGIC;
		-- UART
		AUDIO_INPUT                 : IN STD_LOGIC;
		--STM32
      stm_rx_o            : out std_logic     := 'Z'; -- stm RX pin, so, is OUT on the slave
      stm_tx_i            : in  std_logic     := 'Z'; -- stm TX pin, so, is IN on the slave
      stm_rst_o           : out std_logic     := 'Z'; -- '0' to hold the microcontroller reset line, to free the SD card

		-- SD Card
		sd_cs_n_o                      : out   std_logic := '1';
		sd_sclk_o                      : out   std_logic := '0';
		sd_mosi_o                      : out   std_logic := '0';
		sd_miso_i                      : in    std_logic;
		
		serial_tx : out std_logic;
		serial_rx : in std_logic
	);
END entity;

architecture RTL of neptuno_top is
	
-- System clocks

	signal slowclk : std_logic;
	signal fastclk : std_logic;
	signal pll_locked : std_logic;

	
-- Video
	signal vga_red: std_logic_vector(7 downto 0);
	signal vga_green: std_logic_vector(7 downto 0);
	signal vga_blue: std_logic_vector(7 downto 0);
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	signal vga_window : std_logic;

-- IO

-- PS/2 Keyboard socket - used for second mouse
	signal ps2_keyboard_clk_in : std_logic;
	signal ps2_keyboard_dat_in : std_logic;
	signal ps2_keyboard_clk_out : std_logic;
	signal ps2_keyboard_dat_out : std_logic;

-- PS/2 Mouse
	signal ps2_mouse_clk_in: std_logic;
	signal ps2_mouse_dat_in: std_logic;
	signal ps2_mouse_clk_out: std_logic;
	signal ps2_mouse_dat_out: std_logic;

	signal joya : std_logic_vector(7 downto 0);
	signal joyb : std_logic_vector(7 downto 0);
	signal joyc : std_logic_vector(7 downto 0);
	signal joyd : std_logic_vector(7 downto 0);

-- Sigma Delta audio
	COMPONENT hybrid_pwm_sd
--	generic ( depop : integer := 1 );
	PORT
	(
		clk	:	IN STD_LOGIC;
--		reset_n : in std_logic;
		terminate : in std_logic :='0';
		d_l	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_l	:	OUT STD_LOGIC;
		d_r	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_r	:	OUT STD_LOGIC
	);
	END COMPONENT;

	component audio_top is
Port ( 	
		clk_50MHz : in STD_LOGIC; -- system clock (50 MHz)
		dac_MCLK : out STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : out STD_LOGIC;
		dac_SCLK : out STD_LOGIC;
		dac_SDIN : out STD_LOGIC;
		L_data : 	in std_logic_vector(15 downto 0);  	-- LEFT data (15-bit signed)
		R_data : 	in std_logic_vector(15 downto 0)  	-- RIGHT data (15-bit signed) 
);
end component;	

-- DAC AUDIO     
signal dac_l: signed(15 downto 0);
signal dac_r: signed(15 downto 0);

--signal audio_l_s			: std_logic_vector(15 downto 0);
--signal audio_r_s			: std_logic_vector(15 downto 0);


component joydecoder is
Port ( 	
		clk 			: in std_logic; 
		joy_data    : in std_logic;
		joy_clk		: out std_logic;
		joy_load_n	: out std_logic;
		joy1up		: out std_logic;
		joy1down		: out std_logic;
		joy1left		: out std_logic;
		joy1right	: out std_logic;
		joy1fire1	: out std_logic;
		joy1fire2	: out std_logic;
		joy2up		: out std_logic;
		joy2down		: out std_logic;
		joy2left		: out std_logic;
		joy2right	: out std_logic;
		joy2fire1	: out std_logic;
		joy2fire2	: out std_logic
);
end component;

-- JOYSTICKS
	signal joy1up			: std_logic								:= '1';
	signal joy1down		: std_logic								:= '1';
	signal joy1left		: std_logic								:= '1';
	signal joy1right		: std_logic								:= '1';
	signal joy1fire1		: std_logic								:= '1';
	signal joy1fire2		: std_logic								:= '1';
	signal joy2up			: std_logic								:= '1';
	signal joy2down		: std_logic								:= '1';
	signal joy2left		: std_logic								:= '1';
	signal joy2right		: std_logic								:= '1';
	signal joy2fire1		: std_logic								:= '1';
	signal joy2fire2		: std_logic								:= '1';
	signal clk_sys_out   : std_logic;
	-- i2s 
	signal i2s_mclk		    : std_logic;
	
begin

-- SPI

-- External devices tied to GPIOs

ps2_mouse_dat_in<=PS2_MOUSE_DAT;
PS2_MOUSE_DAT <= '0' when ps2_mouse_dat_out='0' else 'Z';
ps2_mouse_clk_in<=PS2_MOUSE_CLK;
PS2_MOUSE_CLK <= '0' when ps2_mouse_clk_out='0' else 'Z';

ps2_keyboard_dat_in <=PS2_KEYBOARD_DAT;
PS2_KEYBOARD_DAT <= '0' when ps2_keyboard_dat_out='0' else 'Z';
ps2_keyboard_clk_in<=PS2_KEYBOARD_CLK;
PS2_KEYBOARD_CLK <= '0' when ps2_keyboard_clk_out='0' else 'Z';

joya<="11" & joy1fire2 & joy1fire1 & joy1right & joy1left & joy1down & joy1up;
joyb<="11" & joy2fire2 & joy2fire1 & joy2right & joy2left & joy2down & joy2up;

stm_rst_o <= '0';

-- I2S audio
	
audio_i2s: entity work.audio_top
port map(
	clk_50MHz => clock_50_i,
	dac_MCLK  => I2S_MCLK,
	dac_LRCK  => I2S_LRCLK,
	dac_SCLK  => I2S_BCLK,
	dac_SDIN  => I2S_DATA,
	L_data    => std_logic_vector(dac_l),
	R_data    => std_logic_vector(dac_r)
);		

--audio_l_s <= '0' & DAC_L & "00000";
--audio_r_s <= '0' & DAC_R & "00000";

	-- JOYSTICKS
joy: joydecoder
	  port map (
		clk				=> clock_50_i,
		joy_clk			=> JOY_CLK,
		joy_load_n 		=> JOY_LOAD,
		joy_data			=> JOY_DATA,		
		joy1up  			=> joy1up,
		joy1down			=> joy1down,
		joy1left			=> joy1left,
		joy1right		=> joy1right,
		joy1fire1		=> joy1fire1,
		joy1fire2		=> joy1fire2,
		joy2up  			=> joy2up,
		joy2down			=> joy2down,
		joy2left			=> joy2left,
		joy2right		=> joy2right,
		joy2fire1		=> joy2fire1,
		joy2fire2		=> joy2fire2
	);
	
U00 : entity work.pll
	port map(
		inclk0 => clock_50_i,       -- 50 MHz external
		c0     => DRAM_CLK,        -- Fast clock - external
		c1     => fastclk,         -- Fast clock - internal
		c2     => slowclk,         -- Slow clock - internal
		locked => pll_locked
	);

	virtualtoplevel : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => 1000, -- Sysclk frequency * 10
		jtag_uart => false
	)
	port map(
		clk => fastclk,
		slowclk => slowclk,
		reset_in => pll_locked,

		-- VGA
		unsigned(vga_red) => vga_red,
		unsigned(vga_green) => vga_green,
		unsigned(vga_blue) => vga_blue,
		vga_hsync => vga_hsync,
		vga_vsync => vga_vsync,
		vga_window => open,

		-- SDRAM
		sdr_data_in => DRAM_DQ,
		sdr_data_out => DRAM_DQ,
		sdr_addr	=> DRAM_ADDR,
		sdr_dqm(1) => DRAM_UDQM,
		sdr_dqm(0) => DRAM_LDQM,
		sdr_we => DRAM_WE_N,
		sdr_cas => DRAM_CAS_N,
		sdr_ras => DRAM_RAS_N,
		sdr_ba => DRAM_BA,
		sdr_cs => DRAM_CS_N,
		sdr_cke => DRAM_CKE,

		
    -- PS/2 keyboard ports
	 ps2k_clk_out => ps2_keyboard_clk_out,
	 ps2k_dat_out => ps2_keyboard_dat_out,
	 ps2k_clk_in => ps2_keyboard_clk_in,
	 ps2k_dat_in => ps2_keyboard_dat_in,

	 ps2m_clk_out => ps2_mouse_clk_out,
	 ps2m_dat_out => ps2_mouse_dat_out,
	 ps2m_clk_in => ps2_mouse_clk_in,
	 ps2m_dat_in => ps2_mouse_dat_in,
 
    -- SD/MMC slot ports
	spi_clk => sd_sclk_o,
	spi_mosi => sd_mosi_o,
	spi_cs => sd_cs_n_o,
	spi_miso => sd_miso_i,

	signed(audio_l) => dac_l,
	signed(audio_r) => dac_r,
	 
	rxd => serial_rx,
	txd => serial_tx
);

genvideo: if Toplevel_UseVGA=true generate
-- Dither the video down to 6 bits per gun.
	vga_window<='1';
	VGA_HS<=vga_hsync;
	VGA_VS<=vga_vsync;	

	mydither : entity work.video_vga_dither
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
--		terminate => '0',
		d_l(15) => not dac_l(15),
		d_l(14 downto 0) => std_logic_vector(dac_l(14 downto 0)),
		q_l => SIGMA_L,
		d_r(15) => not dac_r(15),
		d_r(14 downto 0) => std_logic_vector(dac_r(14 downto 0)),
		q_r => SIGMA_R
	);
end generate;	

end rtl;

