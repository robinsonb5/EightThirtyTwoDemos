`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:40:55 02/28/2016 
// Design Name: 
// Module Name:    led_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module qmtech_kintex7_325T_top(
	input  clock_50_i,
	input  reset_button,
	output led_1,
	output led_2,
	input  serial_rx,
	output serial_tx,
	output sd_cs_n_o,
	output sd_sclk_o,
	output sd_mosi_o,
	input  sd_miso_i,
	output SIGMA_L,
	output SIGMA_R,
	inout PS2_KEYBOARD_CLK,
	inout PS2_KEYBOARD_DAT,
	inout PS2_MOUSE_CLK,
	inout PS2_MOUSE_DAT
);

wire [15:0] audio_l,audio_r;

wire sysclk,slowclk,pll_locked;

pll clks
(
	.RESET(1'b0),
	.CLK_IN1(clock_50_i),
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

assign PS2_KEYBOARD_CLK = ps2k_clk_out == 1'b1 ? 1'bz : 1'b0;
assign PS2_KEYBOARD_DAT = ps2k_dat_out == 1'b1 ? 1'bz : 1'b0;
assign PS2_MOUSE_CLK = ps2m_clk_out == 1'b1 ? 1'bz : 1'b0;
assign PS2_MOUSE_DAT = ps2m_dat_out == 1'b1 ? 1'bz : 1'b0;
assign ps2k_clk_in = PS2_KEYBOARD_CLK;
assign ps2k_dat_in = PS2_KEYBOARD_DAT;
assign ps2m_clk_in = PS2_MOUSE_CLK;
assign ps2m_dat_in = PS2_MOUSE_DAT;

VirtualToplevel #(.sysclk_frequency(1000)) vt
(
	.clk(sysclk),
	.slowclk(slowclk),
	.reset_in(reset_button & pll_locked),

//	vga_red 		: out unsigned(7 downto 0);
//	vga_green 	: out unsigned(7 downto 0);
//	vga_blue 	: out unsigned(7 downto 0);
//	vga_hsync 	: out std_logic;
//	vga_vsync 	: buffer std_logic;
//	vga_window	: out std_logic;

//	-- SPI signals
	.spi_miso(sd_miso_i),
	.spi_mosi(sd_mosi_o),
	.spi_clk(sd_sclk_o),
	.spi_cs(sd_cs_n_o),
	
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

assign SIGMA_L=1'b0;
assign SIGMA_R=1'b0;

reg [1:0] leds;

assign led_1=leds[0];
assign led_2=leds[1];

always @(posedge sysclk) begin
	leds[0]<=reset_button;
	leds[1]<=reset_button&pll_locked;
end


endmodule
