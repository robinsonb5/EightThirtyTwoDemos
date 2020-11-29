//============================================
//  	Toplevel for QMTECH EP4CE55F23 board
//============================================

module toplevel(
      input             CLOCK_50,
      input       		KEY,

      output      		LEDR,

      input            	RESET_N,

      ///////// DRAM /////////
      output    [12:0]	DRAM_ADDR,
      output    [1:0] 	DRAM_BA,
      output            DRAM_CAS_N,
      output          	DRAM_CKE,
      output            DRAM_CLK,
      output        		DRAM_CS_N,
      inout     [15:0]	DRAM_DQ,
      output            DRAM_LDQM,
      output            DRAM_RAS_N,
      output            DRAM_UDQM,
      output            DRAM_WE_N,

      input             UART_RX,
      output            UART_TX
);

wire sysclk;
wire slowclk;
wire pll_locked;

PLL01 U00
(
	.inclk0(CLOCK_50),
	.c0(sysclk),
	.c1(DRAM_CLK),
	.c2(slowclk),
	.locked(pll_locked)
);

wire [15:0] audio_l;
wire [15:0] audio_r;

VirtualToplevel #(.sdram_rows(13), .sdram_cols(9), .sysclk_frequency(1000)) virtualtoplevel
(
	.clk(sysclk),
	.slowclk(slowclk),
	.reset_in(RESET_N & pll_locked),

	// VGA
//		vga_red 		: out unsigned(7 downto 0);
//		vga_green 	: out unsigned(7 downto 0);
//		vga_blue 	: out unsigned(7 downto 0);
//		vga_hsync 	: out std_logic;
//		vga_vsync 	: buffer std_logic;
//		vga_window	: out std_logic;

	.sdr_data(DRAM_DQ),
	.sdr_addr(DRAM_ADDR),
	.sdr_dqm({DRAM_UDQM,DRAM_LDQM}),
	.sdr_we(DRAM_WE_N),
	.sdr_cas(DRAM_CAS_N),
	.sdr_ras(DRAM_RAS_N),
	.sdr_cs(DRAM_CS_N),
	.sdr_ba(DRAM_BA),
	.sdr_cke(DRAM_CKE),

//	-- SPI signals
//	spi_miso		: in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
//	spi_mosi		: out std_logic;
//	spi_clk		: out std_logic;
//	spi_cs 		: out std_logic;
//	
//	-- PS/2 signals
//	ps2k_clk_in : in std_logic := '1';
//	ps2k_dat_in : in std_logic := '1';
//	ps2k_clk_out : out std_logic;
//	ps2k_dat_out : out std_logic;
//	ps2m_clk_in : in std_logic := '1';
//	ps2m_dat_in : in std_logic := '1';
//	ps2m_clk_out : out std_logic;
//	ps2m_dat_out : out std_logic;
//
//	-- UART
	.rxd(UART_RX),
	.txd(UART_TX),
//	
//	-- Audio
	.audio_l(audio_l),
	.audio_r(audio_r)
);

endmodule
