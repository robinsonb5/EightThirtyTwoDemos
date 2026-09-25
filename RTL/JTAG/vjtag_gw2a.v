// VJTAG implementation for Gowin GW2A 

// Implement a register of selectable width, accessible over JTAG
// but with operations happening in the system clock domain.
// (Hopefully will solve issues with JTAG becoming unreliable in busy designs.)

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

`default_nettype none

reg [2:0] tck_s; // JTAG clock synced to sysclk domain

always @(posedge sysclk) begin
	tck_s <= {tck_s[1:0],tck};
end

wire tck_p,tck_n; // Rising and falling edges of JTAG clock, in sysclk domain
assign tck_p=tck_s[2:1]==2'b01 ? 1'b1 : 1'b0;
assign tck_n=tck_s[2:1]==2'b10 ? 1'b1 : 1'b0;

reg shift_d;

reg [bits-1:0] shiftreg;
wire [bits-1:0] shiftnext = {tdi,shiftreg[bits-1:1]};

// The GWJTAG primitive doesn't supply a capture signal, so we
// just capture any time we're not shifting or updating.
// This works OK provided no action is taken on capture other than
// loading the shift register.
// Advancing a FIFO or acknowledging a shift should be done on update instead.

reg jhold;

always @(posedge sysclk) begin
	if(tck_p) begin
		if(shift)
			jhold <= 1'b1;
		else if(update)
			jhold <= 1'b0;
	end
end

wire docapture = sel & (~shift) & (~jhold);

always @(posedge sysclk) begin
	upd <= 1'b0;

	if(tck_p) begin

		if(docapture)
			shiftreg <= d;

		if(shift && sel) begin
			tdo <= shiftreg[0];
			shiftreg <= shiftnext;
		end

		if(update && sel) begin
			q <= shiftnext;
			upd <= 1'b1;
		end
	end
end

endmodule 


// A wrapper for the Gowin GW_JTAG primitive.

// It doesn't seem to be possible to instantiate this directly from VHDL
// for two reasons:

// * Setting the syn_black_box attribute to true from VHDL doesn't seem to work,

// * In order to have the *_pad_* signals implicitly connected to the internal JTAG signals,
// they must be left unconnected in the instantiation, which is not  legal in VHDL.
// Hence a thin wrapper in Verilog which leaved the pad signals unconnected.

module GW_JTAG (
	tck_pad_i,
	tms_pad_i,
	tdi_pad_i,
	tdo_pad_o,
	tck_o,                //DRCK_IN
	tdi_o,                //TDI_IN
	test_logic_reset_o,   //RESET_IN
	run_test_idle_er1_o,   
	run_test_idle_er2_o,   
	shift_dr_capture_dr_o,//SHIFT_IN|CAPTURE_IN
	pause_dr_o,     
	update_dr_o,          //UPDATE_IN
	enable_er1_o,         //SEL_IN
	enable_er2_o,         //SEL_IN
	tdo_er1_i,            //TDO_OUT
	tdo_er2_i             //TDO_OUT
)/* synthesis syn_black_box  */;

input wire tck_pad_i;
input wire tms_pad_i;
input wire tdi_pad_i;
output wire tdo_pad_o;
input wire tdo_er1_i;
input wire tdo_er2_i;
output wire tck_o;
output wire tdi_o;
output wire test_logic_reset_o;
output wire run_test_idle_er1_o;
output wire run_test_idle_er2_o;
output wire shift_dr_capture_dr_o;
output wire pause_dr_o;
output wire update_dr_o;
output wire enable_er1_o;
output wire enable_er2_o;

endmodule


// Wrap the GW_JTAG module leaving the physical pins unconnected - should then be usable from VHDL
module gwjtag_wrapper (
	tck_o,                //DRCK_IN
	tdi_o,                //TDI_IN
	test_logic_reset_o,   //RESET_IN
	run_test_idle_er1_o,   
	run_test_idle_er2_o,   
	shift_dr_capture_dr_o,//SHIFT_IN|CAPTURE_IN
	pause_dr_o,     
	update_dr_o,          //UPDATE_IN
	enable_er1_o,         //SEL_IN
	enable_er2_o,         //SEL_IN
	tdo_er1_i,            //TDO_OUT
	tdo_er2_i             //TDO_OUT
);

input wire tdo_er1_i;
input wire tdo_er2_i;
output wire tck_o;
output wire tdi_o;
output wire test_logic_reset_o;
output wire run_test_idle_er1_o;
output wire run_test_idle_er2_o;
output wire shift_dr_capture_dr_o;
output wire pause_dr_o;
output wire update_dr_o;
output wire enable_er1_o;
output wire enable_er2_o;

GW_JTAG jtagshim (
	.tck_o(tck_o),                //DRCK_IN
	.tdi_o(tdi_o),                //TDI_IN
	.test_logic_reset_o(test_logic_reset_o),   //RESET_IN
	.run_test_idle_er1_o(run_test_idle_er1_o),   
	.run_test_idle_er2_o(run_test_idle_er2_o),   
	.shift_dr_capture_dr_o(shift_dr_capture_dr_o),//SHIFT_IN|CAPTURE_IN
	.pause_dr_o(pause_dr_o),     
	.update_dr_o(update_dr_o),          //UPDATE_IN
	.enable_er1_o(enable_er1_o),         //SEL_IN
	.enable_er2_o(enable_er2_o),         //SEL_IN
	.tdo_er1_i(tdo_er1_i),            //TDO_OUT
	.tdo_er2_i(tdo_er2_i)             //TDO_OUT
);

endmodule


// Instantate the JTAG primitive, and wire it up to a pair of jtag_to_reg bundles,
// one for each of the two USER JTAG scan codes offered by the ECP5.

module vjtag (
	output wire [1:0] tck,
	output wire [1:0] tdi,
	output wire [1:0] sel,
	output wire [1:0] shift,
	output wire [1:0] capture, // Not available on ECP5 / GW2AR
	output wire [1:0] update,
	input wire [1:0] tdo,
	output wire reset_n
);

assign capture = 2'b00;

wire jtck,jtdi,jshift,jupdate,jrstn,jce1,jce2;

gwjtag_wrapper jtag_inst (
	.tck_o(jtck),
	.tdi_o(jtdi),
	.shift_dr_capture_dr_o(jshift),
	.update_dr_o(jupdate),
	.test_logic_reset_o(jrstn),
	.enable_er1_o(jce1),
	.enable_er2_o(jce2),
	.tdo_er1_i(tdo[0]),
	.tdo_er2_i(tdo[1])
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

