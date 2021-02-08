module deca_top(
	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// CapSense Button //////////
	inout 		          		CAP_SENSE_I2C_SCL,
	inout 		          		CAP_SENSE_I2C_SDA,

	//////////// Audio //////////
	inout 		          		AUDIO_BCLK,
	output		          		AUDIO_DIN_MFP1,
	input 		          		AUDIO_DOUT_MFP2,
	inout 		          		AUDIO_GPIO_MFP5,
	output		          		AUDIO_MCLK,
	input 		          		AUDIO_MISO_MFP4,
	inout 		          		AUDIO_RESET_n,
	output		          		AUDIO_SCL_SS_n,
	output		          		AUDIO_SCLK_MFP3,
	output		          		AUDIO_SDA_MOSI,
	output		          		AUDIO_SPI_SELECT,
	inout 		          		AUDIO_WCLK,

	//////////// Flash //////////
	inout 		     [3:0]		FLASH_DATA,
	output		          		FLASH_DCLK,
	output		          		FLASH_NCSO,
	output		          		FLASH_RESET_n,

	//////////// G-Sensor //////////
	output		          		GSENSOR_PD,
	output		          		GSENSOR_ST,

	//////////// HDMI-TX //////////
	inout 		          		HDMI_I2C_SCL,
	inout 		          		HDMI_I2C_SDA,
	inout 		     [3:0]		HDMI_I2S,
	inout 		          		HDMI_LRCLK,
	inout 		          		HDMI_MCLK,
	inout 		          		HDMI_SCLK,
	output		          		HDMI_TX_CLK,
	output		    [23:0]		HDMI_TX_D,
	output		          		HDMI_TX_DE,
	output		          		HDMI_TX_HS,
	input 		          		HDMI_TX_INT,
	output		          		HDMI_TX_VS,

	//////////// Light Sensor //////////
	output		          		LIGHT_I2C_SCL,
	inout 		          		LIGHT_I2C_SDA,
	inout 		          		LIGHT_INT,

	//////////// Ethernet //////////
	input 		          		NET_COL,
	input 		          		NET_CRS,
	output		          		NET_MDC,
	inout 		          		NET_MDIO,
	output		          		NET_PCF_EN,
	output		          		NET_RESET_n,
	input 		          		NET_RX_CLK,
	input 		          		NET_RX_DV,
	input 		          		NET_RX_ER,
	input 		     [3:0]		NET_RXD,
	input 		          		NET_TX_CLK,
	output		          		NET_TX_EN,
	output		     [3:0]		NET_TXD,

	//////////// Power Monitor //////////
	input 		          		PMONITOR_ALERT,
	output		          		PMONITOR_I2C_SCL,
	inout 		          		PMONITOR_I2C_SDA,

	//////////// Humidity and Temperature Sensor //////////
	input 		          		RH_TEMP_DRDY_n,
	output		          		RH_TEMP_I2C_SCL,
	inout 		          		RH_TEMP_I2C_SDA,

	//////////// MicroSD Card //////////
	output		          		SD_CLK,
	inout 		          		SD_CMD,
	output		          		SD_CMD_DIR,
	output		          		SD_D0_DIR,
	inout 		          		SD_D123_DIR,
	inout 		     [3:0]		SD_DAT,
	input 		          		SD_FB_CLK,
	output		          		SD_SEL,

	//////////// SW //////////
	input 		     [1:0]		SW,

	//////////// Board Temperature Sensor //////////
	output		          		TEMP_CS_n,
	output		          		TEMP_SC,
	inout 		          		TEMP_SIO,

	//////////// USB //////////
	input 		          		USB_CLKIN,
	output		          		USB_CS,
	inout 		     [7:0]		USB_DATA,
	input 		          		USB_DIR,
	input 		          		USB_FAULT_n,
	input 		          		USB_NXT,
	output		          		USB_RESET_n,
	output		          		USB_STP,

	//////////// BBB Conector //////////
	input 		          		BBB_PWR_BUT,
	input 		          		BBB_SYS_RESET_n,
	inout 		    [43:0]		GPIO0_D,
	inout 		    [22:0]		GPIO1_D
);

assign reset_n = 1'b1;
assign LED = 8'hff;

assign SD_CMD_DIR = 1'b1; // Must be output in SPI mode
assign SD_D0_DIR = 1'b0; // Must be input in SPI mode
assign SD_D123_DIR = 1'b1; // Must be output in SPI mode

wire pll_locked;
wire ramclk;
wire sysclk;
wire slowclk;

pll sysclks
(
	.inclk0(MAX10_CLK1_50),
	.c0(ramclk),
	.c1(sysclk),
	.c2(slowclk),
	.locked(pll_locked)
);

VirtualToplevel #(.sysclk_frequency(1000),.jtag_uart("true")) virtualtoplevel
(
	.clk(sysclk),
	.slowclk(slowclk),
	.reset_in(KEY[0] & pll_locked),

	// VGA
	.vga_red(HDMI_TX_D[23:16]),
	.vga_green(HDMI_TX_D[15:8]),
	.vga_blue(HDMI_TX_D[7:0]),
	.vga_hsync(HDMI_TX_HS),
	.vga_vsync(HDMI_TX_VS),
	.vga_window(HDMI_TX_DE),

	// SDRAM
	.sdr_data(16'h0000),//	: inout std_logic_vector(15 downto 0);
//	sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
//	sdr_dqm 		: out std_logic_vector(1 downto 0);
//	sdr_we 		: out std_logic;
//	sdr_cas 		: out std_logic;
//	sdr_ras 		: out std_logic;
//	sdr_cs		: out std_logic;
//	sdr_ba		: out std_logic_vector(1 downto 0);
//	sdr_cke		: out std_logic;

	// SPI signals
	.spi_miso(SD_DAT[0]),
	.spi_mosi(SD_CMD),
	.spi_clk(SD_CLK),
	.spi_cs(SD_DAT[3]),
	
//	-- PS/2 signals
//	ps2k_clk_in : in std_logic := '1';
//	ps2k_dat_in : in std_logic := '1';
//	ps2k_clk_out : out std_logic;
//	ps2k_dat_out : out std_logic;
//	ps2m_clk_in : in std_logic := '1';
//	ps2m_dat_in : in std_logic := '1';
//	ps2m_clk_out : out std_logic;
//	ps2m_dat_out : out std_logic;

//	-- UART
	.rxd(1'b1)
//	txd	: out std_logic;
	
//	-- Audio
//	audio_l : out signed(15 downto 0);
//	audio_r : out signed(15 downto 0)
);

endmodule

