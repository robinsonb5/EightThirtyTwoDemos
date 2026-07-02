`default_nettype none

module usb_interface #(parameter portslog2=0, parameter ports=1, parameter signalclk_freq=100) (
	// System clock
	input clk_sys,
	input reset_n_sys,

	// Signal clock - should ideally be an integer multiple of 12MHz, but failing that
	// it should be fast enough to fractionally divide to 12MHz with minimal jitter.
	input clk_signal,
	input reset_n_signal,

	// Physical signals (leaving toplevel to handle tristating)
	// (These signals are on the clk_signal domain)
	input [ports-1:0] dp_i,
	input [ports-1:0] dm_i,
	output reg [ports-1:0] dp_o,
	output reg [ports-1:0] dm_o,
	output reg [ports-1:0] d_oe,

	// (The following signals are on the clk_sys domain)

	// Outgoing data
	input d_stb,	// Queue up an outgoing byte
	input d_send,	// Send the contents of the output buffer
	input [7:0] d,

	// Incoming data
	output reg q_ready,	// Incoming data is available
	input q_ack,	// Acknowledge an incoming byte
	output [7:0] q,

	// Control signals
	input rewind, // Temporary
	input [portslog2:0] portselect,
	input portreset, // active high - force SEZ.
	output [7:0] portstatus	// Status of the selected port :
	                        // : 0 m, 1 p, 2 rx empty, 3 tx full, 4 tx empty, 5 q_ready
);

localparam maxport = ports-1;

reg jtag_reset_n = 1'b1;

// ToDo
// | mux multiple incoming USB diff pairs.
// | Must lockout most of the edge-sensitive logic when switching ports.
// | How to handle ports running on different speeds?
// |   Perhaps do the synchronisation and edge detection separately for each port?
// | On port change check for sez, dif0 or dif1.
// | Make raw line state visible from SoC.
// Each port needs to track the speed, too.
//
// Potentially make FIFO 16-bits wide rather than 8?
// Incoming bytes can then be tagged with a port number
// | Need to be able to force sez from software to reset devices on a specific port.
// | Need to be able to monitor current port levels.

// How to deal with recurring outgoing messages? Keep alive and SoF?
// Perhaps have the FIFO pin the read pointer when a write happens
// and rewind when a signal is triggered?

// Only problem is when there are multiple ports running at different speeds, need
// to send different messages to each one.
// Maybe multicast to all fullspeed ports, then to all lowspeed ports?
// Lowspeed keepalive is just one byte - maybe bypass the fifo for that?

// Synchronise and detect edges on each port separately.

reg [maxport:0] dp_s;
reg [maxport:0] dm_s;
wire [maxport:0] edgesense;
wire [maxport:0] sample;
wire [maxport:0] sample_stb;
wire [maxport:0] sez;
wire [maxport:0] linkspeed;
reg [maxport:0] oe_local=0;

genvar genport;
generate
	for (genport=0; genport<ports; ++genport) begin
		usb_input_sync gensync (
			.clk_signal(clk_signal),
			.reset_n(reset_n_signal),
			.dp_i(dp_i[genport]),
			.dm_i(dm_i[genport]),
			.oe(oe_local[genport]),
			.stb_fullspeed(stb_12mhz),
			.stb_lowspeed(stb_lowspeed),
			.sample(sample[genport]),
			.sample_stb(sample_stb[genport]),
			.sez(sez[genport]),
			.edgesense(edgesense[genport]),
			.linkspeed(linkspeed[genport])
		);
	end
endgenerate


// Divide the signalclock to provide a 12MHz strobe signal (with some jitter)
wire stb_12mhz;

reg fullspeed;
reg port_edge;
always @(posedge clk_signal) begin
	port_edge <= edgesense[portselect] & ~sending;
	fullspeed <= linkspeed[portselect];
end

frac_pulse #(.freq_in(signalclk_freq),.freq_out(12),.counterwidth(10)) clkdiv (
	.clk(clk_signal),
	.q(stb_12mhz),
	.reset_n(~port_edge)
);

// Create a sample strobe from stb_12mhz
// dividing by 8 for low speed devices.

reg [2:0] lowspeed_prescale;
reg stb_lowspeed;

always @(posedge clk_signal) begin

	stb_lowspeed<=1'b0;
	if(stb_12mhz) begin
		lowspeed_prescale<=lowspeed_prescale-1;
		stb_lowspeed<=~(|lowspeed_prescale);
	end

	if(port_edge)
		lowspeed_prescale<=3;
end

// Shift incoming data into a register, and attend to the removal of bitstuffing.

reg [2:0] in_bitstuff;

reg [7:0] recv_data;
reg bitrecv;
reg receiving;

wire fifo_rx_empty;

reg q_ready_sig;

always @(posedge clk_signal) begin
	bitrecv<=1'b0;
	if(sample_stb[portselect]) begin
		if(sez[portselect]) begin
			in_bitstuff<=5;
			q_ready_sig <= receiving;
			receiving<=1'b0;
		end else if (!d_oe) begin
			if(sample[portselect]) begin // Level change - 0 received.
				receiving <= 1'b1;
				if(|in_bitstuff) begin // bitstuff count not yet depleted
					recv_data <= {1'b0,recv_data[7:1]};
					bitrecv<=1'b1;
				end
				in_bitstuff<=5;
			end else begin // no level change, so 1 received
				if(receiving) begin
					recv_data <= {1'b1,recv_data[7:1]};
					in_bitstuff<=in_bitstuff-1;
					bitrecv<=1'b1;
				end
			end
		end
	end

	// Drop the ready signal again when the last byte has been read by the host
	if(fifo_rx_empty)
		q_ready_sig <=1'b0;

end

// Cross q_ready into the system clock domain
reg q_ready_s;
always @(posedge clk_sys) begin
	q_ready_s <= q_ready_sig;
	q_ready <= q_ready_s;
end


// True dual port fifo required to bridge from the signal clock to host clock domain

reg fifo_rx_wr;
reg [7:0] fifo_rx_d;

reg fifo_rx_rd;
reg [7:0] fifo_rx_q;

reg [2:0] recv_count;

always @(posedge clk_signal) begin
	fifo_rx_wr <= 1'b0;
	if(receiving & bitrecv) begin
		recv_count <= recv_count-1;
		if(recv_count==0) begin
			fifo_rx_d <= recv_data;
			fifo_rx_wr <= 1'b1;
		end
	end
	if(!receiving)
		recv_count<=7;
end

usb_fifo rx_fifo (
	// Read side - system clock
	.clk_rd(clk_sys),
	.reset_n_rd(reset_n_sys & jtag_reset_n),
	.rewind(1'b0),
	.rd_en(q_ack),
	.dout(q),
	.empty(fifo_rx_empty),
	
	// Write side - signal clock
	.clk_wr(clk_signal),
	.reset_n_wr(reset_n_signal),
	.wr_en(fifo_rx_wr),
	.din(fifo_rx_d),
	.full()
);


// Transmit side:

// States:
// IDLE
// TX (8 x n bytes)
// SEZ
// SEZ2
// J
// HiZ

wire fifo_tx_empty;
wire fifo_tx_full;
reg fifo_tx_next;
reg [7:0] fifo_tx_q;

reg tx_shift;
reg tx_sez;
reg tx_sez_d;
reg sending=1'b0;
reg [2:0] out_bit;
reg [2:0] out_bitstuff;
reg [7:0] out_data;
reg out_prev;

reg dp_t;
reg dm_t;
reg oe_t;

always @(posedge clk_signal) begin
	tx_shift <= 1'b0;

	oe_t <= 1'b0;

	if (sending && !receiving) begin
		oe_t <= 1'b1;
		if(sample_stb[portselect]) begin

			// Output with bit stuffing, LSB first
			if(out_data[0])	begin // One bit, no change unless bitstuffing required.
				if(out_bitstuff==0) begin
					out_prev <= ~out_prev;
					dp_t <= ~out_prev ^ fullspeed;
					dm_t <= out_prev ^ fullspeed;
					out_bitstuff<=5;
				end else begin // No bitstuffing required, just decrement and shift
					out_bitstuff<=out_bitstuff-1;
					tx_shift <= 1'b1;
				end
			end else begin // Zero bit, invert and shift
				out_prev <= ~out_prev;
				dp_t <= ~out_prev ^ fullspeed;
				dm_t <= out_prev ^ fullspeed;
				out_bitstuff<=5;
				tx_shift <= 1'b1;
			end

			if(tx_sez) begin	// Single-ended zero at end of packet
				dp_t <= 1'b0;
				dm_t <= 1'b0;
				if(out_bit==5) begin
					dp_t <= fullspeed;
					dm_t <= ~fullspeed;
					tx_sez_d <= 1'b1;
				end
				if(tx_sez_d) begin
					dp_t <= fullspeed;
					dm_t <= ~fullspeed;
					sending <= 1'b0;
					tx_sez_d<=1'b0;
				end
			end
		end
	end

	fifo_tx_next <= 1'b0;

	if(tx_shift) begin
		out_data <= {1'b0,out_data[7:1]};
		if(out_bit==0) begin
			out_data <= fifo_tx_q;
			fifo_tx_next<=1'b1;
			tx_sez<=fifo_tx_empty;
		end
		out_bit <= out_bit-1;
	end

	// Trigger a send operation. If the fifo is empty we just send an SEZ,
	// to serve as a low-speed keepalive.
	if(d_send) begin
		dp_t <= fullspeed;
		dm_t <= ~fullspeed;
		out_prev <= 1'b0;
		out_bit<=7;
		sending <= 1'b1;
		out_data <= fifo_tx_q;
		fifo_tx_next<=1'b1;
		tx_sez<=fifo_tx_empty;
	end

	// FIXME - insert keepalive here.
	
	
	// FIXME - trigger rewind for SoF here.
	

	if(!sending) begin
		out_bitstuff=5;
	end

	if(portreset) begin	// Force a single-ended zero for as long as portreset is high
		dp_t <= 1'b0;
		dm_t <= 1'b0;
		oe_t <= 1'b1;
	end

	if(!reset_n_signal) begin
		sending <= 1'b0;
	end
end


always @(posedge clk_signal) begin
	dp_o[portselect] <= dp_t;
	dm_o[portselect] <= dm_t;
	d_oe[portselect] <= oe_t;
	oe_local[portselect] <= oe_t; // FIXME - must be a more elegant way to solve this.
end

reg [7:0] fifo_tx_t;

usb_fifo tx_fifo (
	// Read side - signal clock
	.clk_rd(clk_signal),
	.reset_n_rd(reset_n_signal),
	.rewind(rewind),

	.rd_en(fifo_tx_next),
	.dout(fifo_tx_t),
	.empty(fifo_tx_empty),
	
	// Write side - sys clock
	.clk_wr(clk_sys),
	.reset_n_wr(reset_n_sys & jtag_reset_n),
	.wr_en(d_stb),
	.din(d),
	.full(fifo_tx_full)
);

always @(posedge clk_signal) begin
	fifo_tx_q <= fifo_tx_t;
end

always @(posedge clk_sys) begin
	portstatus <= {2'b0,q_ready_s,sending,fifo_tx_full,fifo_rx_empty,dp_i,dm_i};
end


// Debugging
localparam capturewidth=32;
wire [capturewidth-1:0] capture_d;

assign capture_d[1:0] = dp_i;
assign capture_d[3:2] = dm_i;
assign capture_d[5:4] = dp_o;
assign capture_d[7:6] = dm_o;
assign capture_d[9:8] = d_oe;

assign capture_d[10] = d_stb;
assign capture_d[11] = d_send;

assign capture_d[12] = sending;
assign capture_d[13] = stb_lowspeed;
assign capture_d[15:14] = sample;
assign capture_d[17:16] = sample_stb;
assign capture_d[19:18] = edgesense;
assign capture_d[20] = fifo_rx_wr;
assign capture_d[28:21] = fifo_rx_d;
assign capture_d[29] = fifo_rx_rd;
assign capture_d[30] = receiving;
assign capture_d[31] = 0;

wire [3:0] juser_ir;
wire [31:0] juser_q;
wire juser_update;

jcapture #(
	.capturewidth(capturewidth),
	.capturedepth(13),
	.designid(16'haa55)
) capture (
	.clk(clk_sys),
	.reset_n(reset_n_sys),
	.stb(1'b1),
	.capture_d(capture_d),
	.user_ir(juser_ir),
	.user_ir_update(),
	.user_d(0),
	.user_q(juser_q),
	.user_update(juser_update)
);

always @(posedge clk_sys) begin
	if(juser_update) begin
		case (juser_ir)
			4'b0000 : begin // Reset
				jtag_reset_n <= ~juser_q[0];
			end
			default : ;
		endcase
	end
end

endmodule
