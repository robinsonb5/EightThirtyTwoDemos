`default_nettype none

// For SMBUS operation we need to be able to queue up events
// including a 2- or 3-byte write followed by an n-byte read.
// There needs to be a start condition between the two, but no stop condition.
//
// Since the bus is relatively slow we should be able to feed it in realtime.
// The first byte of each event will be the byte count.
//

module i2chost #(parameter clkfreq=100) (
	input wire clk,
	input wire reset_n,
	
	// Soft interface
	input wire [7:0] d,   // Data to be sent to a target device
	input wire d_stb,     // Begin a transaction
	input wire go,

	output reg [7:0] q,   // Data received from the target device
	input wire q_stb,     // Advance the output FIFO.
	output wire q_ready,  // Data available to read
	
    output wire busy,     // A transaction is in progress
    output wire err,      // Transaction failed
    
	// Hardware interface
	input wire scl_in,
	input wire sda_in,
	output reg scl_out,
	output reg sda_out
);

// Input FIFO

wire if_empty;
wire if_full;
wire [7:0] if_d;
reg if_rd;

i2cfifo infifo (
	.clk(clk),
	.reset_n(reset_n),
	
	.rd_en(if_rd),
	.dout(if_d),
	.empty(if_empty),
	
	.wr_en(d_stb),
	.din(d),
	.full(if_full)
);

// Output FIFO

wire of_full;
wire of_empty;
reg [7:0] of_d;
reg of_wr;

i2cfifo outfifo (
	.clk(clk),
	.reset_n(reset_n),
	
	.rd_en(q_stb),
	.dout(q),
	.empty(of_empty),
	
	.wr_en(of_wr),
	.din(of_d),
	.full(of_full)
);

assign q_ready = ~of_empty;

// Clock division - for 100KHz output clock rate we need a 400KHz pulse rate.
localparam outfreq = 100000;
localparam freqdiv = (clkfreq * 1000000) / (outfreq * 4) - 2;
reg tick;

reg [31:0] tickctr;
always @(posedge clk) begin
	tickctr<=tickctr-1;
	tick <= 1'b0;
	if(tickctr[15]) begin // Underflow
		tick <= 1'b1;
		tickctr <= freqdiv;
	end

	if(!reset_n)
		tickctr <= freqdiv;
end


// Detect contention

wire contention = scl_out && (~scl_in || (sda_out != sda_in)) ? 1'b1 : 1'b0; // During address or write, if sda in and out fail to match when scl is high, we have two devices fighting over the bus.

// Detect clock stretching

wire clockstretch = scl_out && !scl_in ? 1'b1 : 1'b0;



localparam IDLE=4'd0;
localparam START=4'd1;
localparam SHIFT_LOW=4'd2;
localparam SHIFT_OUT=4'd3;
localparam SHIFT_HIGH=4'd4;
localparam SHIFT_IN=4'd5;
localparam STOP=4'd6;

reg [3:0] state;
reg [9:0] shift;
reg [3:0] shiftctr;
reg [7:0] bytectr;
reg failed;
reg wr;
reg store;

wire finished = ~(|bytectr);

reg go_pending;
always @(posedge clk) begin

	of_wr <= 1'b0;
	if_rd <= 1'b0;
	
	if(go)
		go_pending <= 1'b1;

	case(state)
		IDLE : begin
			sda_out <= 1'b1;
			scl_out <= 1'b1;
			if(!if_empty) begin
				if(finished) begin
					bytectr <= d;     // First transaction byte is the count (should still be on the bus).
					if_rd <= 1'b1;    // Advance the FIFO
				end	else if (go_pending && scl_in & tick) begin
					state <= START;
				end
			end
		end
		
		START : begin
			go_pending <= 1'b0;
			failed <= 1'b0;
			sda_out <= 1'b0; // Start condition	
			if(tick && !clockstretch) begin
				shift <= {if_d,1'b1,1'b0}; // Address, 0 for write, 1 for read, ack, 8 data bits, ack, stop condition.
				wr <= ~if_d[0];
				store <= 1'b0; // Only write result of read transactions to the FIFO.
				if_rd <= 1'b1;    // advance the FIFO
				shiftctr <= 4'd9; // 9 bits for address phase - 7 addr, 1 r/w, 1 ack.
				state <= SHIFT_LOW;
			end
		end

		SHIFT_LOW : begin
			if(tick && !clockstretch) begin
				scl_out <= 1'b0;
				state <= SHIFT_OUT;
			end
		end
		
		SHIFT_OUT : begin
			if(tick) begin
				sda_out <= shift[9];
				state <= SHIFT_HIGH;
			end
		end

		SHIFT_HIGH : begin
			if(tick) begin
				scl_out <= 1'b1;
				state <= SHIFT_IN;
			end
		end
		
		SHIFT_IN : begin
			if(tick && !clockstretch) begin

				shift <= {shift[8:0],sda_in};	// Shift in received data.
				shiftctr <= shiftctr - 1;

				state <= SHIFT_LOW;

				case(shiftctr)
					4'd1 : begin
						of_d <= shift[7:0];
						of_wr <= store;	// Latch only incoming bytes, not address byte or outgoing bytes.
						store <= ~wr;
						failed <= (sda_in & ~store) | of_full; // Trigger an error if target doesn't ack outgoing bytes, or if FIFO fills up.
						if(sda_in | (&shiftctr)) begin // underflow or NAK
							state <= STOP;
						end else if(|bytectr) begin
							// Ack bit will be high throughout writes, so device can pull it low.  Low for reads, except for the last byte.
							shift <= {wr ? if_d : 8'hff,wr | (~|bytectr[7:1]),1'b0};
							if_rd <= wr;
							shiftctr <= 4'd9;
							bytectr <= bytectr-1;
						end else
							shift[9] <= ~if_empty; // If the FIFO stll contains data, we perform a repeated start rather than a stop.
					end
					// if we have more bytes to process, go straight to START without passing through STOP.
					4'd0 : begin
						if(if_empty)
							state <= STOP;
						else begin
							bytectr <= if_d;
							if_rd <= 1'b1;
							state <= START;
						end
					end
					default : ;
				endcase
			end
		end

		STOP : begin
			if(tick) begin
				sda_out <= 1'b1;
				state <= IDLE;
			end
		end
		
		default : 
			state <= IDLE;

	endcase

	if(!reset_n) begin
		state <= IDLE;
		failed <= 1'b0;
		go_pending <= 1'b0;
	end

end

assign err = failed;
assign busy = state==IDLE ? 1'b0 : 1'b1;

endmodule
