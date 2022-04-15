module pll (
	input clk_i,
	output [3:0] clk_o,
	input reset,
	input locked
);

ecp5pll
#(
	.in_hz(25000000),
	.out0_hz(100000000),
	.out1_hz(100000000),
	.out1_deg(270),
	.out2_hz(50000000)
) pll (
	.clk_i(clk_i),
	.clk_o(clk_o),
	.reset(reset),
	.locked(locked)
);

endmodule

