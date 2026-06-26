module usb_interface #(parameter portslog2=0, parameter ports=1, parameter signalclk_freq=142) (
	// System clock
	input clk_sys,
	input reset_n_sys,

	// Signal clock - should ideally be an integer multiple of 12MHz, but failing that
	// it should be fast enough to fractionally divide to 12MHz with minimal jitter.
	input clk_signal,
	input reset_n_signal,

	// Physical signals (leaving toplevel to handle tristating)
	input [ports-1:0] dp_i,
	input [ports-1:0] dm_i,
	output reg [ports-1:0] dp_o,
	output reg [ports-1:0] dm_o,
	output reg [ports-1:0] d_oe,

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
	output [7:0] portstatus	// Status of the selected port : 0 p, 1 m, 2 rx empty, 3 tx full
);

localparam maxport = ports-1;

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

genvar genport;
generate
	for (genport=0; genport<ports; ++genport) begin
		usb_input_sync gensync (
			.clk_signal(clk_signal),
			.dp_i(dp_i[genport]),
			.dm_i(dm_i[genport]),
			.dp_o(dp_s[genport]),
			.dm_o(dm_s[genport]),
			.edgesense(edgesense[genport])
		);
	end
endgenerate


// Divide the signalclock to provide a 12MHz strobe signal (with some jitter)
wire stb_12mhz;

reg port_edge;
always @(posedge clk_signal)
	port_edge <= edgesense[portselect];

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

reg fullspeed=1'b1;
wire sample_stb = fullspeed ? stb_12mhz : stb_lowspeed;

// Sample incoming data on the relevant strobe signal.

reg dp_sample;
reg dm_sample;

always @(posedge clk_signal) begin
	if(sample_stb) begin
		dp_sample <= dp_s[portselect];
		dm_sample <= dm_s[portselect];
	end 
end

wire dif0 = (dm_sample & (~dp_sample));
wire dif1 = (dp_sample & (~dm_sample));
wire jstate = fullspeed ? dif0 : dif1;
wire kstate = fullspeed ? dif1 : dif0;
wire seo = dp_sample & dm_sample;
wire sez = ~(dp_sample | dm_sample);

// Shift incoming data into a register, and attend to the removal of bitstuffing.

reg [2:0] in_bitstuff;
reg sample_prev;

reg [7:0] recv_data;
reg bitrecv;
reg receiving;

wire fifo_rx_empty;

// When the line goes from idle (constant single-ended zero) to connected 
// we evaluate which line was pulled up, and set fullspeed accordingly.
// (Since every packet ends in single-ended zero we're re-evaluating this
// constantly, but should be harmless.)

// Need to do this on port change, too.

reg sez_d;

always @(posedge clk_signal) begin
	if(sample_stb) begin
		sez_d <= sez;

		if(!d_oe && sez_d && dp_sample && !dm_sample)
			fullspeed <= 1'b1;

		if(!d_oe && sez_d && dm_sample && !dp_sample)
			fullspeed <= 1'b0;
	end

	// Optional: On reset reevaluate the connection speed.
	if(!reset_n_signal) begin
		sez_d <= 1'b1;	
		fullspeed <= 1'b1;
	end
end

always @(posedge clk_signal) begin
	bitrecv<=1'b0;
	if(sample_stb) begin
		sample_prev <= jstate;
		if(seo || sez) begin
			in_bitstuff<=5;
			receiving<=1'b0;
			if(!fifo_rx_empty)
				q_ready <= 1'b1;
		end else if (!d_oe & !sez_d) begin // Don't want to react to the transition immediately following a SEZ condition
			if(jstate ^ sample_prev) begin // Level change - 0 received.
				receiving <= 1'b1;
				if(|in_bitstuff) begin // bitstuff count not yet depleted
					recv_data <= {1'b0,recv_data[7:1]};
					bitrecv<=1'b1;
				end
				in_bitstuff<=5;
			end else begin // no level change, so 1 received
				recv_data <= {1'b1,recv_data[7:1]};
				in_bitstuff<=in_bitstuff-1;
				bitrecv<=1'b1;
			end
		end
	end

	// Drop the ready signal again when the last byte has been read by the host
	if(fifo_rx_empty)
		q_ready <=1'b0;

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
	.reset_n_rd(reset_n_sys),
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
		if(sample_stb) begin

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
					sending <= 1'b0;
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
			if(fifo_tx_empty) begin	// Single-ended zero at end of packet
				tx_sez<=1'b1;
			end
		end
		out_bit <= out_bit-1;
	end

	if(d_send) begin
		dp_t <= fullspeed;
		dm_t <= ~fullspeed;
		out_prev <= 1'b0;
		if(!fifo_tx_empty) begin
			out_data <= fifo_tx_q;
			fifo_tx_next<=1'b1;
			out_bit<=7;
			sending <= 1'b1;
			tx_sez<=1'b0;
		end
	end

	// FIXME - insert keepalive here.
	
	
	// FIXME - trigger rewind for SoF here.
	

	if(!sending) begin
		out_bitstuff=5;
	end

	if(portreset) begin	// Force a single-ended zero for as long as portreset is high
		dp_t <= 1'b0;
		dm_t <= 1'b1;
	end

	if(!reset_n_signal) begin
		sending <= 1'b0;
	end
end


always @(posedge clk_signal) begin
	dp_o <= dp_t;
	dm_o <= dm_t;
	d_oe <= oe_t;
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
	.reset_n_wr(reset_n_sys),
	.wr_en(d_stb),
	.din(d),
	.full(fifo_tx_full)
);

always @(posedge clk_signal) begin
	fifo_tx_q <= fifo_tx_t;
end

always @(posedge clk_sys) begin
	portstatus <= {4'b0,fifo_tx_full,fifo_rx_empty,dp_sample,dm_sample};
end

endmodule
