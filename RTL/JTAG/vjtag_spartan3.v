// VJTAG implementation for Spartan3

// Implement a register of selectable width, accessible over JTAG
// but with operations happening in the system clock domain.
// (Hopefully will solve issues with JTAG becoming unreliable in busy designs.)

module vjtag_register #(parameter bits=32) (
	input sysclk,
	input tck,
	input tdi,
	input sel,
	input shift,
	input update,
	input capture,
	output tdo,
	input [bits-1:0] d,
	output reg [bits-1:0] q,
	output reg upd
);

`default_nettype none

reg [2:0] tck_s; // JTAG clock synced to sysclk domain

always @(posedge sysclk) begin
	tck_s <= {tck_s[1:0],tck};
end

wire tck_p,tck_n; // Rising and falling edges of JTAG clock, in sysclk domain
assign tck_p=tck_s[2:1]==2'b01 ? 1'b1 : 1'b0;
assign tck_n=tck_s[2:1]==2'b10 ? 1'b1 : 1'b0;

reg [2:0] update_s; // Update signal synced to sysclk domain

always @(posedge sysclk) begin
	update_s <= {update_s[1:0],update};
end

wire update_p;
assign update_p = update_s[2:1] == 2'b01 ? 1'b1 : 1'b0;

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
wire [bits-1:0] shiftnext = {tdi,shiftreg[bits-1:1]};
reg selected;


assign tdo = shiftreg[0];

always @(posedge sysclk) begin
	upd <= 1'b0;

	if(tck_p) begin

		if(capture)
			shiftreg <= d;

		if(shift)
			selected <= sel;

		if(shift && sel) begin
			shiftreg <= shiftnext;
		end
	end

	if(update_p && selected) begin
		q <= shiftreg;
		upd <= 1'b1;
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
	output [1:0] update,
	output [1:0] capture,
	input [1:0] tdo,
	output reset_n
);

wire jtck1,jtck2,jtdi,jshift,jcapture,jupdate,jrst,jce1,jce2;

BSCAN_SPARTAN3 jtag_inst (
	.DRCK1(jtck1),
	.DRCK2(jtck2),
	.TDI(jtdi),
	.SHIFT(jshift),
	.CAPTURE(jcapture),
	.UPDATE(jupdate),
	.RESET(jrst),
	.SEL1(jce1),
	.SEL2(jce2),
	.TDO1(tdo[0]),
	.TDO2(tdo[1])
);


assign reset_n = ~jrst;

assign tck[0] = jtck1;
assign tdi[0] = jtdi;
assign shift[0] = jshift;
assign capture[0] = jcapture;
assign update[0] = jupdate;
assign sel[0] = jce1;

assign tck[1] = jtck2;
assign tdi[1] = jtdi;
assign shift[1] = jshift;
assign capture[1] = jcapture;
assign update[1] = jupdate;
assign sel[1] = jce2;

endmodule

