// JTAG Logic capture module with triggers, for Lattice ECP5 / Yosys / Trellis / NextPnR flow.

// Copyright (c) 2025, 2026 by Alastair M. Robinson

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.


// Triggers can be set for absolute values or for rising or falling edges (but not currently both edges)
// To save logic, the triggers can be narrower than the capture bus; signals to be included in trigger
// conditions should be in the lowest-order bits of the port.

// Use JTAG commands to set the following registers:
// Mask: '1' bits select which signals should be included in the trigger condition.
// Invert: The trigger will match '0' bits unless the corresponding bit in this register is set.
// Edge: For bits set in both Edge and Mask, the trigger will match on falling edges,
// unless the corresponding invert bit is set.

`default_nettype none

module jcapture #(
	parameter userwidth=32,
	parameter capturewidth=31,     // Run-length encoding costs 1 bit
	parameter capturedepth=9,
	parameter triggerwidth=0,      // Reducing the trigger width can reduce footprint and increase speed
	parameter userirwidth=4,       // Can be a maxmium of 4.
	parameter runlengthencoding=1, // Disable to reduce logic footprint and increase speed.
	parameter designid = 16'h35ac
) (
	input wire clk,
	input wire reset_n,
	input wire stb,
	input wire [capturewidth-1:0] capture_d,
	output reg trigger_match,		// Strobe on trigger, when enabled by host
	output reg [userirwidth-1:0] user_ir,
	output reg user_ir_update,
	input wire [userwidth-1:0] user_d,
	output reg [userwidth-1:0] user_q,
	output reg user_update
);

localparam triggersize = triggerwidth ? triggerwidth : capturewidth;

localparam jcapture_irwidth = 4;
localparam jcapture_ir_cmd          = 4'd0;
localparam jcapture_ir_read         = 4'd1;
localparam jcapture_ir_write        = 4'd2;
localparam jcapture_ir_setleadin    = 4'd3;
localparam jcapture_ir_setmask      = 4'd4;
localparam jcapture_ir_setinvert    = 4'd5;
localparam jcapture_ir_setedge      = 4'd6;
localparam jcapture_ir_capturewidth = 4'd7;
localparam jcapture_ir_capturedepth = 4'd8;
localparam jcapture_ir_triggerwidth = 4'd9;
localparam jcapture_ir_subsample    = 4'ha;
localparam jcapture_ir_status       = 4'hb;
localparam jcapture_ir_spare2       = 4'hc;
localparam jcapture_ir_spare3       = 4'hd;
localparam jcapture_ir_spare4       = 4'he;
localparam jcapture_ir_spare5       = 4'hf;

localparam jtag_irsize = jcapture_irwidth + 1;
localparam jtag_drsize = capturewidth < 24 ? 24 : (userwidth < capturewidth ? capturewidth + 1 : userwidth);
// JTAG signals

wire irupdate;
wire [jtag_irsize-1:0] irfromjtag;

wire drupdate;
wire [jtag_drsize-1:0] drfromjtag;
reg  [jtag_drsize-1:0] drtojtag;

// FIFO signals
reg [1:0] leadin;
reg fifo_wr;
wire fifo_full;
wire fifo_empty;

// Capture triggering logic

// From the current and previous incoming values, a mask, invert and edge signal
// we digest a zero value if the trigger condition is satisfied.
// Mask is a bitmap of bits to be included in the trigger condition
// Invert reverses the sense of the comparison: value triggers match '0' by default
// and '1' if the corresponding bit in invert is set.  Edge triggers match a falling
// edge by default and a rising edge if the invert bit is set.

// if V is a bit from the incoming value, and P is its previous value, then
// V' is (V^I) and P' is (P^I), where I is the corresponding bit from the invert register.
// M comes from the mask register, and E comes from the edge register.
// The active-low trigger value for each bit = ((not P') and M and E) or (V' and M)


wire trigger;

reg [triggersize-1:0] prev;
reg [triggersize-1:0] trigedge;
reg [triggersize-1:0] triginvert;
reg [triggersize-1:0] trigmask;
reg [triggersize-1:0] triggers;
wire [triggersize-1:0] inverted;

// User IR code
always @(posedge clk) begin
	user_ir_update <= 1'b0;
	if (irupdate) begin
		if(irfromjtag=={jtag_irsize{1'b1}}) begin
			// FIXME - implement proper bypass mode

		end else if(irfromjtag[jtag_irsize-1]) begin
			// User IR code
			user_ir <= irfromjtag[userirwidth-1:0];
			user_ir_update <= 1'b1;
		end
	end
end


// Record the mask, invert and edge signals
// and set the trigger signal when conditions are met.

always @(posedge clk) begin
	if (drupdate) begin
		if(!irfromjtag[jtag_irsize-1]) begin
			// JCapture IR code
			case (irfromjtag[jcapture_irwidth-1:0])
				jcapture_ir_setmask   : trigmask   <= drfromjtag[triggersize-1:0];
				jcapture_ir_setinvert : triginvert <= drfromjtag[triggersize-1:0];
				jcapture_ir_setedge   : trigedge   <= drfromjtag[triggersize-1:0];
				default : ;
			endcase
		end
	end
	if(!reset_n) begin
		trigmask <= 0;
		triginvert <= 0;
		trigedge <=0;
	end
end

assign inverted = capture_d[triggersize-1:0] ^ triginvert;

always @(posedge clk) begin
	prev <= inverted;
	triggers <= ((~prev) & trigmask & trigedge) | (inverted & trigmask);
	if(!reset_n)
		prev <= 0;
end

assign trigger = (|triggers) ? 1'b0 : 1'b1;


// Subsampling logic

// Allow the host to select a number of clocks to skip between samples, and also optionally
// wait for either a trigger or an external strobe signal between successive samples.
// When trigger or strobe are selected, the counter won't reset after underflow until
// the strobe /trigger arrives.

reg [5:0] subsample_ctr;
reg [5:0] subsample_schedule=0;
reg subsample_stb_sel;
reg subsample_trigger_sel;

wire subsample_stb = (trigger | ~subsample_trigger_sel) & (stb | ~subsample_stb_sel) & ~(|subsample_ctr);

always @(posedge clk) begin
	if(|subsample_ctr)
		subsample_ctr <= subsample_ctr - 1;
	if(subsample_stb)
		subsample_ctr <= subsample_schedule;
end

always @(posedge clk) begin
	if (drupdate) begin
		case (irfromjtag[jcapture_irwidth-1:0])
			jcapture_ir_subsample : begin
				subsample_schedule <= drfromjtag[5:0];
				subsample_trigger_sel <= drfromjtag[6];
				subsample_stb_sel <= drfromjtag[7];
			end
			default :
				;
		endcase
	end
	if(!reset_n) begin
		subsample_schedule <= 6'b0;
		subsample_stb_sel <= 1'b0;
	end
end


// Commands from jcapture_ir_cmd

localparam jcapture_cmd_bits        = 4;
localparam jcapture_cmd_nop         = 4'd0;
localparam jcapture_cmd_sample      = 4'd1;
localparam jcapture_cmd_capture     = 4'd2;
localparam jcapture_cmd_abort       = 4'd3;
localparam jcapture_cmd_flush       = 4'd4;
localparam jcapture_cmd_notify_trigger = 4'd5;

// Capture logic
// We imitate the semantics of JTAG - i.e. a read-only Instruction Register
// and read-write Data Registers even though we'll generally be implementing
// it in terms of a pair of user registers - this gives us the flexibility to
// connect directly to a true JTAG TAP or the Intel Virtual JTAG module in
// future.

localparam STATE_IDLE = 4'd0;
localparam STATE_CAPTURE = 4'd1;
localparam STATE_FILL = 4'd2;
localparam STATE_READ = 4'd3;
localparam STATE_NOTIFY_TRIGGER = 4'd4;
reg [3:0] capstate;

reg fifo_reset_n;

// Condition the reset signal from the JTAG TAP

wire jtag_reset_u; // Unsynchronised
reg [1:0] jtag_reset_s;
wire jtag_reset_n; // Synchronised reset

always @(posedge clk)
	jtag_reset_s <= {jtag_reset_u,jtag_reset_s[1]};

assign jtag_reset_n = jtag_reset_s[0];

// Instantiate the TAP
wire [1:0] jtck;
wire [1:0] jtdi;
wire [1:0] jsel;
wire [1:0] jshift;
wire [1:0] jupdate;
wire [1:0] jcapture;
wire [1:0] jtdo;

vjtag jtag_inst (
	.tck(jtck),
	.tdi(jtdi),
	.sel(jsel),
	.shift(jshift),
	.capture(jcapture),
	.update(jupdate),
	.tdo(jtdo),
	.reset_n(jtag_reset_u)
);

reg [3:0] ircmd;

always @(posedge clk) begin
	fifo_wr <= 1'b0;
	
	trigger_match <= 1'b0;

	case(capstate)
		STATE_CAPTURE : begin
			if(trigger) begin
				capstate <= STATE_FILL;
				leadin <= 2'b00;
				fifo_wr <= subsample_stb;
			end else begin
				if(|leadin)
					fifo_wr <= subsample_stb;
			end
		end
		
		STATE_FILL : begin
			if(fifo_full)
				capstate <= STATE_IDLE;
			else
				fifo_wr <= subsample_stb;
		end
		
		STATE_READ : begin
			if(fifo_empty)
				capstate <= STATE_IDLE;
		end
		
		STATE_NOTIFY_TRIGGER : begin
			if(trigger) begin
				trigger_match <= 1'b1;
				capstate <= STATE_IDLE;
			end
		end
		
		default :
			capstate <= STATE_IDLE;
	endcase

	fifo_reset_n <= jtag_reset_n & reset_n;
	user_update <= 1'b0;
	if(drupdate) begin
		if (irfromjtag[jtag_irsize-1]) begin // User command
			user_q <= drfromjtag;
			user_update <= 1'b1;
		end else begin                                // System command
			case (irfromjtag[jcapture_irwidth-1:0])       
				// Pass shifted data to the parent module
				jcapture_ir_write : begin
					user_q <= drfromjtag;
					user_update <= 1'b1;
				end

				// Set lead-in mode for capture - 0: no lead-in, 1: 75% lead-in, 2: 50% lead-in, 3: 25% lead-in
				jcapture_ir_setleadin : begin
					leadin <= drfromjtag[1:0];
				end

				// Interpet shifted value as a command
				jcapture_ir_cmd : begin
					ircmd <= drfromjtag[jcapture_cmd_bits-1:0];

					case (drfromjtag[jcapture_cmd_bits-1:0])

						jcapture_cmd_sample : begin // Take a one-shot sample
							leadin <= 2'b00;
							fifo_wr <= 1'b1;  // Capture a single sample
						end

						jcapture_cmd_capture : begin // Begin capturing
							capstate <= STATE_CAPTURE;
						end

						jcapture_cmd_abort : begin
							leadin <= 2'b00;
							capstate <= STATE_IDLE;
						end

						jcapture_cmd_flush : begin
							leadin <= 2'b00;
							fifo_reset_n <= 1'b0;
						end

						jcapture_cmd_notify_trigger : begin
							capstate <= STATE_NOTIFY_TRIGGER;
						end

						default : 
							;

					endcase
				end

				default :
					;
			endcase
		end
	end

	if(!reset_n) begin
		leadin <= 2'b00;
		fifo_wr <= 1'b0;
		capstate <= STATE_IDLE;
		user_q <= 0;
	end
end


wire frd_en;
wire [capturewidth:0] frd; // One extra bit for RLE

vjtag_sync_fifo #(.fifowidth(capturewidth+1),.fifodepth(capturedepth),.runlengthencoding(runlengthencoding)) fifo (
	.sysclk(clk),
	.reset_n(fifo_reset_n),
	
	.rd_en(frd_en),
	.dout(frd),
	.empty(fifo_empty),
	
	.wr_en(fifo_wr),
	.din(capture_d),
	.full(fifo_full),
	
	.leadin(leadin)
);


// Create a pair of registers to be accessed over the JTAG chain

vjtag_register #(.bits(jtag_irsize)) vir (
	// JTAG plumbing and system clock (must be significantly faster than the JTAG clock)
	.sysclk(clk),
	.tck(jtck[0]),
	.tdi(jtdi[0]),
	.sel(jsel[0]),
	.shift(jshift[0]),
	.capture(jcapture[0]),
	.update(jupdate[0]),
	.tdo(jtdo[0]),
	// Input, output and update signal.
	.d({jtag_irsize{1'b0}}),
	.q(irfromjtag),
	.upd(irupdate)
);

wire busy = capstate==STATE_IDLE ? 1'b0 : 1'b1;
wire capturing = capstate==STATE_CAPTURE ? 1'b1 : 1'b0;

always @(posedge clk) begin
	if(irfromjtag[jtag_irsize-1]) begin  // User command
		drtojtag <= user_d;
	end else begin  // System command
		case(irfromjtag[jcapture_irwidth-1:0])
			jcapture_ir_cmd :
				drtojtag <= {designid,capturing,fifo_empty,fifo_full,busy};
			jcapture_ir_status :
				drtojtag <= {reset_n,capstate,ircmd,designid,capturing,fifo_empty,fifo_full,busy};
			jcapture_ir_capturewidth :
				drtojtag <= jtag_drsize; // capturewidth+1;
			jcapture_ir_capturedepth :
				drtojtag <= capturedepth;
			jcapture_ir_triggerwidth :
				drtojtag <= triggersize;
			default:
				drtojtag <= frd;
		endcase
	end
end

// FIXME - if we ever connect to a true TAP we need to implement Bypass mode.
vjtag_register #(.bits(jtag_drsize)) vdr (
	// JTAG plumbing and system clock (must be significantly faster than the JTAG clock)
	.sysclk(clk),
	.tck(jtck[1]),
	.tdi(jtdi[1]),
	.sel(jsel[1]),
	.shift(jshift[1]),
	.capture(jcapture[1]),
	.update(jupdate[1]),
	.tdo(jtdo[1]),
	// Input, output and update signal.
	.d(drtojtag),
	.q(drfromjtag),
	.upd(drupdate)
);


// Advance the FIFO on Update rather than Capture because neither the Intel raw JTAG, the Lattice JTAGG primitive
// nor the Gowin GWJTAG primitive supply a capture signal.

assign frd_en = irfromjtag == jcapture_ir_read ? drupdate : 1'b0;


endmodule

