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
	output [12:0] SDRAM_A,
	output  [1:0] SDRAM_BA,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQMH,
	output        SDRAM_DQML,
	output        SDRAM_CKE,
	output        SDRAM_nCS,
	output        SDRAM_nWE,
	output        SDRAM_nRAS,
	output        SDRAM_nCAS,
	output        SDRAM_CLK,
	
	output VGA_HS,
	output VGA_VS,
	output [2:0] VGA_R,
	output [2:0] VGA_G,
	output [2:0] VGA_B
);

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

assign SDRAM_CLK = ramclk;

wire vga_hsync;
wire vga_vsync;
wire vga_window;
wire [7:0] vga_red;
wire [7:0] vga_green;
wire [7:0] vga_blue;

assign VGA_R=vga_window ? vga_red[7:5] : 3'b000;
assign VGA_G=vga_window ? vga_green[7:5] : 3'b000;
assign VGA_B=vga_window ? vga_blue[7:5] : 3'b000;
assign VGA_HS=vga_hsync;
assign VGA_VS=vga_vsync;

VirtualToplevel #(.sdram_rows(13),.sdram_cols(9),.sysclk_frequency(1000),.jtag_uart("true")) virtualtoplevel
(
	.clk(sysclk),
	.slowclk(slowclk),
	.reset_in(KEY[0] & pll_locked),

	// VGA
	.vga_red(vga_red),
	.vga_green(vga_green),
	.vga_blue(vga_blue),
	.vga_hsync(vga_hsync),
	.vga_vsync(vga_vsync),
	.vga_window(vga_window),

	// SDRAM
	.sdr_data_in(SDRAM_DQ),//	: inout std_logic_vector(15 downto 0);
	.sdr_data_out(SDRAM_DQ),//	: inout std_logic_vector(15 downto 0);
	.sdr_addr(SDRAM_A),//		: out std_logic_vector((sdram_rows-1) downto 0);
	.sdr_dqm({SDRAM_DQMH,SDRAM_DQML}),// 		: out std_logic_vector(1 downto 0);
	.sdr_we(SDRAM_nWE),//		: out std_logic;
	.sdr_cas(SDRAM_nCAS),// 		: out std_logic;
	.sdr_ras(SDRAM_nRAS),// 		: out std_logic;
	.sdr_cs(SDRAM_nCS),//		: out std_logic;
	.sdr_ba(SDRAM_BA),//		: out std_logic_vector(1 downto 0);
	.sdr_cke(SDRAM_CKE),//		: out std_logic;

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

