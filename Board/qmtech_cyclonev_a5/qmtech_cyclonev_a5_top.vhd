library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Toplevel_Config.all;
use work.pmod_pkg.all;

-- -----------------------------------------------------------------------

entity qmtech_cyclonev_a5_top is
	port
	(
		CLOCK_50		:	 IN STD_LOGIC;
		RESET_N : in std_logic;
		DRAM_CLK		:	 OUT STD_LOGIC;
		DRAM_CKE		:	 OUT STD_LOGIC;
		DRAM_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DRAM_DQM		:	 OUT STD_LOGIC_vector(3 downto 0);
		DRAM_CS_N		:	 OUT STD_LOGIC;
		DRAM_WE_N		:	 OUT STD_LOGIC;
		DRAM_CAS_N		:	 OUT STD_LOGIC;
		DRAM_RAS_N		:	 OUT STD_LOGIC;
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT UNSIGNED(4 DOWNTO 0);
		VGA_G		:	 OUT UNSIGNED(5 DOWNTO 0);
		VGA_B		:	 OUT UNSIGNED(4 DOWNTO 0);
		UART_RX : in STD_LOGIC;
		UART_TX : out std_logic;
		
		-- Daughterboard signals
		DB_SD_CS : out std_logic;
		DB_SD_CLK : out std_logic;
		DB_SD_MISO : in std_logic;
		DB_SD_MOSI : out std_logic;
		DB_LED : out std_logic_vector(4 downto 0);
		DB_KEY : in std_logic_vector(4 downto 0);
		DB_PMOD_J10 : inout std_logic_vector(7 downto 0);
		DB_PMOD_J11 : inout std_logic_vector(7 downto 0);
		DB_GPIO_J1 : inout std_logic_vector(13 downto 0)
	);
END entity;

architecture RTL of qmtech_cyclonev_a5_top is
   constant reset_cycles : integer := 131071; 
  
-- System clocks

	signal slowclk : std_logic;
	signal fastclk : std_logic;
	signal videoclk : std_logic;
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

-- Keyboard and mouse
	signal ps2k_dat_in : std_logic;
	signal ps2k_dat_out : std_logic;
	signal ps2k_clk_in : std_logic;
	signal ps2k_clk_out : std_logic;
	signal ps2m_dat_in : std_logic;
	signal ps2m_dat_out : std_logic;
	signal ps2m_clk_in : std_logic;
	signal ps2m_clk_out : std_logic;

	constant ps2_pmod_offset : integer := 0;
	alias ps2_pmod is DB_PMOD_J11;

-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;

-- ESP8266 serial
	signal esp_rxd : std_logic;
	signal esp_txd : std_logic;

-- Sound
	signal audio_l : std_logic_vector(15 downto 0);
	signal audio_r : std_logic_vector(15 downto 0);
	
	alias sigma_l is DB_GPIO_J1(0);
	alias sigma_r is DB_GPIO_J1(1);
	
-- IO

	component pll is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;        -- clk
			outclk_1 : out std_logic;        -- clk
			outclk_2 : out std_logic;        -- clk
			outclk_3 : out std_logic;        -- clk
			locked   : out std_logic         -- export
		);
	end component pll;
	
	signal sdram_dq : std_logic_vector(31 downto 0);
	signal drive_dq : std_logic;
	
begin

	U00 : component pll
	port map(
		refclk => CLOCK_50,       -- 50 MHz external
		outclk_0     => DRAM_CLK,        -- Fast clock - external
		outclk_1     => fastclk,         -- Fast clock - internal
		outclk_2     => slowclk,         -- Slow clock - internal
		outclk_3     => videoclk,
		locked => pll_locked
	);

	n_reset<=RESET_N and pll_locked;

	DRAM_DQ<=sdram_dq when drive_dq='1' else (others => 'Z');

	virtualtoplevel : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => Toplevel_Frequency*10, -- Sysclk frequency * 10
		debug => false
	)
	port map(
		clk => fastclk,
		slowclk => slowclk,
		videoclk => videoclk,
		reset_in => n_reset,

		-- VGA
		unsigned(vga_red) => vga_red,
		unsigned(vga_green) => vga_green,
		unsigned(vga_blue) => vga_blue,
		vga_hsync => vga_hsync,
		vga_vsync => vga_vsync,
		vga_window => vga_window,

		-- SDRAM
		sdr_drive_data => drive_dq,
		sdr_data_in => DRAM_DQ(Toplevel_SDRAMWidth-1 downto 0),
		sdr_data_out => sdram_dq(Toplevel_SDRAMWidth-1 downto 0),
		sdr_addr	=> DRAM_ADDR,
		sdr_dqm => DRAM_DQM(Toplevel_SDRAMWidth/8-1 downto 0),
		sdr_we => DRAM_WE_N,
		sdr_cas => DRAM_CAS_N,
		sdr_ras => DRAM_RAS_N,
		sdr_ba => DRAM_BA,
		sdr_cs => DRAM_CS_N,
		sdr_cke => DRAM_CKE,

		-- PS/2 keyboard ports
		ps2k_clk_out => ps2k_clk_out,
		ps2k_dat_out => ps2k_dat_out,
		ps2k_clk_in => ps2k_clk_in,
		ps2k_dat_in => ps2k_dat_in,

		ps2m_clk_out => ps2m_clk_out,
		ps2m_dat_out => ps2m_dat_out,
		ps2m_clk_in => ps2m_clk_in,
		ps2m_dat_in => ps2m_dat_in,
	 
		-- SD/MMC slot ports
		spi_clk => spi_clk,
		spi_mosi => spi_mosi,
		spi_cs => spi_cs,
		spi_miso => spi_miso,

		signed(audio_l) => audio_l,
		signed(audio_r) => audio_r,
		 
		rxd => UART_RX,
		txd => UART_TX
	);

	DB_SD_CLK <= spi_clk;
	DB_SD_CS <= spi_cs;
	DB_SD_MOSI <= spi_mosi;
	spi_miso <= DB_SD_MISO;
	
	-- Wire keyboard to PMOD with open-collector semantics.
	ps2_pmod(PMOD_PS2_KDAT+ps2_pmod_offset) <= '0' when ps2k_dat_out='0' else 'Z';
	ps2_pmod(PMOD_PS2_KCLK+ps2_pmod_offset) <= '0' when ps2k_clk_out='0' else 'Z';
	ps2_pmod(PMOD_PS2_MDAT+ps2_pmod_offset) <= '0' when ps2m_dat_out='0' else 'Z';
	ps2_pmod(PMOD_PS2_MCLK+ps2_pmod_offset) <= '0' when ps2m_clk_out='0' else 'Z';
	ps2k_dat_in <= ps2_pmod(PMOD_PS2_KDAT+ps2_pmod_offset);
	ps2k_clk_in <= ps2_pmod(PMOD_PS2_KCLK+ps2_pmod_offset);
	ps2m_dat_in <= ps2_pmod(PMOD_PS2_MDAT+ps2_pmod_offset);
	ps2m_clk_in <= ps2_pmod(PMOD_PS2_MCLK+ps2_pmod_offset);
	
	-- Dither the video down to 5 bits per gun.
	
	mydither : entity work.video_vga_dither
		generic map(
			outbits => 6
		)
		port map(
			clk=>videoclk,
			hsync=>vga_hsync,
			vsync=>vga_vsync,
			vid_ena=>vga_window,
			iRed => unsigned(vga_red),
			iGreen => unsigned(vga_green),
			iBlue => unsigned(vga_blue),
			oRed(5 downto 1) => VGA_R,
			oGreen => VGA_G,
			oBlue(5 downto 1) => VGA_B
		);
	
	VGA_HS<=vga_hsync;
	VGA_VS<=vga_vsync;
	
	audio : block
		-- Sigma Delta audio
		COMPONENT hybrid_pwm_sd
		generic ( depop : integer := 1 );
		PORT
		(
			clk	:	IN STD_LOGIC;
			terminate : in std_logic;
			d_l	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			q_l	:	OUT STD_LOGIC;
			d_r	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			q_r	:	OUT STD_LOGIC
		);
		END COMPONENT;
	begin

		audio_sd: component hybrid_pwm_sd
		port map
		(
			clk => fastclk,
			terminate => '0',
			d_l(15) => not audio_l(15),
			d_l(14 downto 0) => std_logic_vector(audio_l(14 downto 0)),
			q_l => sigma_l,
			d_r(15) => not audio_r(15),
			d_r(14 downto 0) => std_logic_vector(audio_r(14 downto 0)),
			q_r => sigma_r
		);
	end block;

	-- LEDS.  Not so much a "blinky" as a "pulsey"...
	pwmblock : block
		signal pwmcounter : unsigned(16 downto 0);
		signal redctr : unsigned(16 downto 0);
		signal greenctr : unsigned(16 downto 0);
		signal redctr_i : unsigned(15 downto 0);
		signal greenctr_i : unsigned(15 downto 0);
		signal led1 : std_logic;
		signal led2 : std_logic;
	begin
		redctr_i <= redctr(16 downto 1) when redctr(16)='0' else not redctr(16 downto 1);
		greenctr_i <= greenctr(16 downto 1) when greenctr(16)='0' else not greenctr(16 downto 1);
		process(fastclk) begin
			if rising_edge(fastclk) then
				pwmcounter<=pwmcounter + 1;
				if pwmcounter='1'&X"FFFF" then
					redctr<=redctr+13;
					greenctr<=greenctr+7;
					led1<='1';
					led2<='1';
				end if;
				if redctr_i = pwmcounter then
					led1<='0';
				end if; 
				if greenctr_i = pwmcounter then
					led2<='0';
				end if; 
			end if;
		end process;
		
		DB_LED(0) <= led1;
		DB_LED(1) <= led2;
		DB_LED(2) <= not led1;
		DB_LED(3) <= not led2;
		DB_LED(4) <= led1 xor led2;
	end block;

end architecture;
