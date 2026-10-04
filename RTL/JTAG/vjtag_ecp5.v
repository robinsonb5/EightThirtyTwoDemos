// VJTAG implementation for Lattice ECP5

// Implement a register of selectable width, accessible over JTAG
// but with operations happening in the system clock domain.
// (Hopefully will solve issues with JTAG becoming unreliable in busy designs.)

`default_nettype none

module vjtag_register #(parameter bits=32) (
	input wire sysclk,
	input wire tck,
	input wire tdi,
	input wire sel,
	input wire shift,
	input wire capture, // Not available on ECP5 / GW2AR
	input wire update,
	output reg tdo,
	input wire [bits-1:0] d,
	output reg [bits-1:0] q,
	output reg upd
);

reg [2:0] tck_s; // JTAG clock synced to sysclk domain

always @(posedge sysclk) begin
	tck_s <= {tck_s[1:0],tck};
end

wire tck_p,tck_n; // Rising and falling edges of JTAG clock, in sysclk domain
assign tck_p=tck_s[2:1]==2'b01 ? 1'b1 : 1'b0;
assign tck_n=tck_s[2:1]==2'b10 ? 1'b1 : 1'b0;


// As we leave the shift state we latch the previous value of tdi.
// Without this, we lose the last bit shifted when doing a multi-part
// shift interspersed with the DR_PAUSE state.
reg shift_d;
reg tdi_latched;
always @(posedge sysclk) begin
	if(tck_p) begin
		shift_d <= shift;
		if(shift_d)
			tdi_latched <= tdi;
	end
end

wire tdi_mux = shift_d ? tdi : tdi_latched;

reg [bits-1:0] shiftreg;
wire [bits-1:0] shiftnext = {tdi_mux,shiftreg[bits-1:1]};
reg selected;

always @(posedge sysclk) begin
	upd <= 1'b0;

	if(tck_p) begin

		if(sel && !shift) // Work around the lack of a capture signal
			shiftreg <= d;
	
		if(shift)
			selected <= sel;

		if(shift && sel) begin
			tdo <= shiftreg[0];
			shiftreg <= shiftnext;
		end

		if(update && selected) begin
			q <= shiftnext;
			upd <= 1'b1;
		end
	end
end

endmodule 


// Instantate the JTAG primitive, and wire it up to a pair of jtag_to_reg bundles,
// one for each of the two USER JTAG scan codes offered by the ECP5.

module vjtag (
	output [1:0] tck,
	output [1:0] tdi,
	output [1:0] sel,
	output [1:0] shift,
	output [1:0] capture, // Not available on ECP5 / GW2AR
	output [1:0] update,
	input [1:0] tdo,
	output reset_n
);

assign capture = 2'b00;

wire jtck,jtdi,jshift,jupdate,jrstn,jce1,jce2;

JTAGG jtag_inst (
	.JTCK(jtck),
	.JTDI(jtdi),
	.JSHIFT(jshift),
	.JUPDATE(jupdate),
	.JRSTN(jrstn),
	.JCE1(jce1),
	.JCE2(jce2),
	.JRTI1(),
	.JRTI2(),
	.JTDO1(tdo[0]),
	.JTDO2(tdo[1])
);

assign reset_n = jrstn;

assign tck[0] = jtck;
assign tdi[0] = jtdi;
assign shift[0] = jshift;
assign update[0] = jupdate;
assign sel[0] = jce1;

assign tck[1] = jtck;
assign tdi[1] = jtdi;
assign shift[1] = jshift;
assign update[1] = jupdate;
assign sel[1] = jce2;

endmodule

