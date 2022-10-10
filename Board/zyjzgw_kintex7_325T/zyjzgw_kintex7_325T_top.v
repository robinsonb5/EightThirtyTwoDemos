`timescale 1ns / 1ps

// Toplevel file for QMTech Kintex 7 board, using (mostly)
// Neptuno pin mappings.
// UART is connected to U4 Pin 8 (AE21) for Rx and U4 Pin 7 (AD21) for Tx.
//
// Be aware that there are two versions of this board.  One has all pins
// on U4 mapped to banks 12 and 13 - that's the version targetted by
// this project.
// 
// On the other version, some pins on U4 are mapped to HP Banks which don't
// support 3.3v IO.  This version of the board doesn't supply power to
// pins 1&2 of U4, leaving the host application to supply 1.8v or lower,
// as appropriate.

module zyjzgw_kintex7_325T_top(
	input  CLK50,
	output [4:0] LED, // (1:0 not populated)
	input  [7:0] SW,
	input  [4:0] KEY,
	output sd_cs,
	output sd_sclk,
	output sd_mosi,
	input  sd_miso,
	output SIGMA_L,
	output SIGMA_R,
	output VGA_HS,
	output VGA_VS,
	output [4:0] VGA_R,
	output [5:0] VGA_G,
	output [4:0] VGA_B,
	inout [7:0] IO_A
);

wire [15:0] audio_l,audio_r;
wire serial_rx;
wire serial_tx;

// Adjusted to match the pin mapping in SaxonSoC
assign IO_A[7] = 1'bz;
assign serial_rx = IO_A[7];
assign IO_A[6] = serial_tx;
assign IO_A[5:0] = 6'bzzzzzzz;

wire sysclk,slowclk,pll_locked;

pll clks
(
	.RESET(1'b0),
	.CLK_IN1(CLK50),
	.CLK_OUT1(sysclk),
	.CLK_OUT2(slowclk),
	.LOCKED(pll_locked)
);

wire ps2k_clk_in;
wire ps2k_dat_in;
wire ps2m_clk_in;
wire ps2m_dat_in;
wire ps2k_clk_out;
wire ps2k_dat_out;
wire ps2m_clk_out;
wire ps2m_dat_out;

//assign PS2_KEYBOARD_CLK = ps2k_clk_out == 1'b1 ? 1'bz : 1'b0;
//assign PS2_KEYBOARD_DAT = ps2k_dat_out == 1'b1 ? 1'bz : 1'b0;
//assign PS2_MOUSE_CLK = ps2m_clk_out == 1'b1 ? 1'bz : 1'b0;
//assign PS2_MOUSE_DAT = ps2m_dat_out == 1'b1 ? 1'bz : 1'b0;
assign ps2k_clk_in = 1'b1; //PS2_KEYBOARD_CLK;
assign ps2k_dat_in = 1'b1; //PS2_KEYBOARD_DAT;
assign ps2m_clk_in = 1'b1; //PS2_MOUSE_CLK;
assign ps2m_dat_in = 1'b1; //PS2_MOUSE_DAT;

wire [7:0] vga_red;
wire [7:0] vga_green;
wire [7:0] vga_blue;
wire vga_hsync;
wire vga_vsync;
wire vga_window;
wire vga_pixel;

wire reset_n = KEY[2] & pll_locked;

VirtualToplevel #(.sysclk_frequency(1700),.jtag_uart(0)) vt
(
	.clk(sysclk),
	.slowclk(slowclk),
	.reset_in(reset_n),

	.vga_red(vga_red),
	.vga_green(vga_green),
	.vga_blue(vga_blue),
	.vga_hsync(vga_hsync),
	.vga_vsync(vga_vsync),
	.vga_window(vga_window),
//	.vga_pixel(vga_pixel),

//	-- SPI signals
	.spi_miso(sd_miso),
	.spi_mosi(sd_mosi),
	.spi_clk(sd_sclk),
	.spi_cs(sd_cs),
	
//	-- PS/2 signals
	.ps2k_clk_in(ps2k_clk_in),
	.ps2k_dat_in(ps2k_dat_in),
	.ps2k_clk_out(ps2k_clk_out),
	.ps2k_dat_out(ps2k_dat_out),
	.ps2m_clk_in(ps2m_clk_in),
	.ps2m_dat_in(ps2m_dat_in),
	.ps2m_clk_out(ps2m_clk_out),
	.ps2m_dat_out(ps2m_dat_out),

//	-- UART
	.rxd(serial_rx),
	.txd(serial_tx),
//	rxd2 : in std_logic := '1';
//	txd2 : out std_logic;

//	-- Audio
	.audio_l(audio_l),
	.audio_r(audio_r)
);

reg [1:0] leds;

assign LED[0]=leds[0];
assign LED[1]=leds[1];
assign LED[4:2]=KEY[4:2];

always @(posedge sysclk) begin
	leds[0]<=KEY[1];
	leds[1]<=KEY[2];
end

wire [5:0] out_r;
wire [5:0] out_g;
wire [5:0] out_b;

video_vga_dither #(.outbits(6)) dither
(
	.clk(sysclk),
	.vid_ena(vga_window),
	.hsync(vga_hsync),
	.vsync(vga_vsync),
	.iRed(vga_red),
	.iGreen(vga_green),
	.iBlue(vga_blue),
	.oRed(out_r),
	.oGreen(out_g),
	.oBlue(out_b)
);

assign VGA_VS=vga_vsync;
assign VGA_HS=vga_hsync;
assign VGA_R=out_r[5:1];
assign VGA_G=out_g[5:0];
assign VGA_B=out_b[5:1];

hybrid_pwm_sd audio
(
	.clk(slowclk),
	.terminate(1'b0),	// Avoid pop at core change by ramping from quiescent to maximum.
	.d_l(16'h8000),
	.d_r(16'h8000),
	.q_l(SIGMA_L),
	.q_r(SIGMA_R)
);

endmodule
