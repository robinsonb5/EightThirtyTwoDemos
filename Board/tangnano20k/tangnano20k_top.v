/*
    top.sv - for tang nano 20k
*/ 

 
module tangnano20k_top(
  input			clk,

  input			reset, // button S2
  input			user,  // button S1

  input         uart_rx,
  output        uart_tx,

  output [5:0]	leds_n,
  output		ws2812,

  // spi flash interface
  output		mspi_cs,
  output		mspi_clk,
  inout			mspi_di,
  inout			mspi_hold,
  inout			mspi_wp,
  inout			mspi_do,

  // "Magic" port names that the gowin compiler connects to the on-chip SDRAM
  output		O_sdram_clk,
  output		O_sdram_cke,
  output		O_sdram_cs_n,  // chip select
  output		O_sdram_cas_n, // columns address select
  output		O_sdram_ras_n, // row address select
  output		O_sdram_wen_n, // write enable
  inout [31:0]	IO_sdram_dq, // 32 bit bidirectional data bus
  output [10:0]	O_sdram_addr, // 11 bit multiplexed address bus
  output [1:0]	O_sdram_ba, // two banks
  output [3:0]	O_sdram_dqm, // 32/4

  // generic IO, used for mouse/joystick/...
  input [7:0]	io,

  // interface to external BL616/M0S
  inout [5:0]	m0s,

  // MIDI/UART
  input			midi_in,
  output		midi_out,
		   
  // SD card slot
  output		sd_clk,
  inout			sd_cmd, // MOSI
  inout [3:0]	sd_dat, // 0: MISO, 3: CS
	   
  // SPI connection to ob-board BL616. By default an external
  // connection is used with a M0S Dock
  input			spi_sclk, // in... 
  input			spi_csn, // in (io?)
  output		spi_dir, // out
  input			spi_dat, // in (io?)

  // hdmi/tdms
  output		tmds_clk_n,
  output		tmds_clk_p,
  output [2:0]	tmds_d_n,
  output [2:0]	tmds_d_p
);

assign m0s = 6'bZZZZZZ;

// physcial dsub9 joystick  
wire [5:0] db9_joy = { !io[5], !io[0], !io[2], !io[1], !io[4], !io[3] };   
   
wire [5:0]	leds;
assign leds = 6'b0;

// ============================== clock generation ===========================

wire videoclk;
wire sysclk;
wire slowclk;   
wire locked;
wire sdramclk;

pll clocks (
    .clkout(sysclk),
    .clkoutp(sdramclk),
    .clkoutd(slowclk),
    .lock(locked),
    .clkin(clk)
);

assign O_sdram_clk = sdramclk;

wire [31:0] sdr_dout;
wire [31:0] sdr_din;
wire sdr_drive;

assign sdr_in = IO_sdram_dq;
assign IO_sdram_dq = sdr_drive ? sdr_dout : 32'bZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ_ZZZZZZZZ;

VirtualTopLevel #(
    .sysclk_frequency(1000),
    .sdram_rows(11),
    .sdram_cols(8)
) vt (
    .clk(sysclk),
    .slowclk(slowclk),
    .videoclk(videoclk),
    .reset_in(locked & ~reset),

    .vga_red(red),
    .vga_green(green),
    .vga_blue(blue),
    .vga_hsync(hsync),
    .vga_vsync(vsync),
    .vga_window(window),
    .vga_pixel(pixel),

    .sdr_drive_data(sdr_drive),
    .sdr_data_out(sdr_dout),
    .sdr_data_in(sdr_din),
    .sdr_addr(O_sdram_addr),
    .sdr_dqm(O_sdram_dqm),
    .sdr_we(O_sdram_wen_n),
    .sdr_cas(O_sdram_cas_n),
    .sdr_ras(O_sdram_ras_n),
    .sdr_cs(O_sdram_cs_n),
    .sdr_ba(O_sdram_ba),
    .sdr_cke(O_sdram_cke),

    .spi_miso(sd_dat[0]),
    .spi_mosi(sd_cmd),
    .spi_clk(sd_clk),
    .spi_cs(sd_dat[3]),

    .ps2k_clk_in(1'b1),
    .ps2k_dat_in(1'b1),
    .ps2m_clk_in(1'b1),
    .ps2m_dat_in(1'b1),

    .rxd(uart_rx),
    .txd(uart_tx)
);


// differential output
//ELVDS_OBUF tmds_bufds [3:0] (
//        .I({tmds_clock, tmds}),
//        .O({tmds_clk_p, tmds_d_p}),
//        .OB({tmds_clk_n, tmds_d_n})
//);
   
endmodule

