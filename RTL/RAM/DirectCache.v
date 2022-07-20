// Direct mapped Cache

// 32 bit address and data.
// 8 word bursts, 16-bit SDRAM interface, so cachelines of 4 32-bit words
// m9k organised as 256 x 32bit.

// minimal implementation: dual port ram, split between
// data and tag. (Wasteful, but only uses one memory block)
// larger implementation: four times as many data blocks as tag block
// implemented as two single-port RAMs.

// Minimal mode:
// tag_a <= {3'b100,cpu_addr[8:4]}; // 5 bits for tag address, since the tag is constant for a cacheline
// data_a <= {1'b0,cpu_addr[8:2]}; // 7 bits for data address
// Need to latch the incoming address, but have it fed directly when not communicating with SDRAM.
// Need to ensure that we don't get spurious results if the CPU address changes.
// Easiest way to do that is simply to do away with the ack signal and
// rely entirely on the valid signal.  Will slow down cache misses.

// Alternatively, delay writing the tag until the first word is in,
// and allow the valid flag to trigger immediately - but does that run afoul of
// read-during-write limitations?

// To do - can we create an L1 cache that tracks the address immediately?


module DirectMappedCache #(parameter cachebits=11)
(
	input clk,
	input reset, // active low
	output reg ready,
	input [31:0] cpu_addr,
	input cpu_req,	// 1 to request attention
	output cpu_ack,	// 1 to signal that data is ready.
	output cpu_cachevalid, // 1 to indicate that data is already cached and valid
	input cpu_rw, // 1 for read cycles, 0 for write cycles
	input [3:0] bytesel,
	input [31:0] data_from_cpu,
	output [31:0] data_to_cpu,

	input [15:0] data_from_sdram,
	output reg [15:0] data_to_sdram,
	output [31:0] sdram_addr,
	output reg sdram_req,
	input sdram_fill,
	output reg sdram_rw,	// 1 for read cycles, 0 for write cycles
	output reg busy,
	input flush,
	output [2:0] debug
);

// Debugging
reg cache_error;
assign debug[0]=cache_error;
assign debug[1]=tag_hit;
reg debug_hit;


// States for state machine
localparam	INIT=0, FLUSH1=1, WAITING=2, WAITRD=3, PAUSE1=4;
localparam	WRITE1=5, WRITE2=6, WAITFILL=7, FILL2=8, FILL3=9;
localparam 	FILL4=10, FILL5=11, FILL6=12, FILL7=13, FILL8=14, FILL9=15;
localparam  FLUSH2=16;

reg [15:0] state = INIT;
reg init;
reg [cachebits-2:0] initctr;

// BlockRAM and related signals for data

wire [cachebits-1:0] data_a;
wire [31:0] data_q;
reg[31:0] data_w;
reg data_wren;

wire [cachebits-2:0] tag_a;
wire [31:0] tag_q;
reg [31:0] tag_w;
reg tag_wren;

//defparam dataram.addrbits = cachebits;
//defparam dataram.databits = 32;

DirectCacheRAM #(.addrbits(cachebits)) dataram (
	.clk(clk),
	.address(data_a),
	.data(data_w),
	.q(data_q),
	.wren(data_wren)
);

DirectCacheRAM #(.addrbits(cachebits-1)) tagram (
	.clk(clk),
	.address(tag_a),
	.data(tag_w),
	.q(tag_q),
	.wren(tag_wren)
);

wire data_valid;

assign data_valid = tag_q[31];

//   bits 3:2 specify which words of a burst we're interested in.
//   Bits 10:4 specify the seven bit address of the cachelines;
//   Since we're building a 2-way cache, we'll map this to 
//   {1'b0,addr[10:4]} and {1;b1,addr[10:4]} respectively.

wire [cachebits-1:0] cacheline;

reg [31:0] latched_cpuaddr;
assign sdram_addr = latched_cpuaddr;

reg [31:0] firstword;
reg firstword_ready;
assign data_to_cpu = (firstword_ready ? firstword : data_q);

reg cpu_req_d;
reg cpu_req_d2;
reg [31:0] cpu_addr_d;
reg fill_ack;
reg write_ack;

assign cpu_cachevalid = firstword_ready | ((tag_hit && data_valid) && cpu_rw && !busy);
assign cpu_ack = 1'b0; // (cpu_req_d && cpu_cachevalid && cpu_rw) || fill_ack || write_ack;

reg readword_burst; // Set to 1 when the lsb of the cache address should
							// track the SDRAM controller.
reg [1:0] readword;

assign cacheline = {1'b0,cpu_addr[cachebits:4],(readword_burst ? readword : cpu_addr[3:2])};

assign tag_a = init ? initctr :
			{2'b00,cpu_addr[cachebits:4]};

wire tag_hit;
assign tag_hit = tag_q[27:0]==cpu_addr[31:4];

// Boolean signals to indicate cache hits.

// In the data blockram the lower two bits of the address determine
// which word of the burst we're reading.  When reading from the cache, this comes
// from the CPU address; when writing to the cache it's determined by the state
// machine.

assign data_a = init ? {1'b0,initctr} :
			readword_burst ? {1'b0,latched_cpuaddr[cachebits:4],readword} : cacheline;

reg flushpending;
			
always @(posedge clk)
begin

	// Defaults
	tag_wren<=1'b0;
	data_wren<=1'b0;
//	cpu_ack<=1'b0;
	init<=1'b0;
	readword_burst<=1'b0;
	cache_error<=1'b0;

	write_ack<=1'b0;
	
	busy <=1'b1;
	
	cpu_req_d<=cpu_req;
	cpu_req_d2<=cpu_req_d;
	cpu_addr_d <= cpu_addr;
	
	debug_hit=tag_hit;
	
	if(flush)
		flushpending<=1'b1;

	case(state)

		// We use an init state here to loop through the data, clearing
		// the valid flag - for which we'll use bit 17 of the data entry.
	
		INIT:
		begin
			ready<=1'b0;
			state<=FLUSH1;
			firstword_ready<=1'b0;
		end
		
		FLUSH1:
		begin
			init<=1'b1;	// need to mark the entire cache as invalid before starting.
			initctr<=32'h00000001;
			tag_w = 32'h00000000;
			tag_wren<=1'b1;
			state<=FLUSH2;
			fill_ack<=1'b0;
		end
		
		FLUSH2:
		begin
			init<=1'b1;
			initctr<=initctr+1;
			tag_wren<=1'b1;
			if(initctr==0)
			begin
				state<=WAITING;
				ready<=1'b1;
				flushpending<=1'b0;
			end
		end

		WAITING:
		begin
			state<=WAITING;
			busy <= 1'b0;
			tag_w = {4'b1111,cpu_addr[31:4]};
			latched_cpuaddr<=cpu_addr;
			if(!firstword_ready  && cpu_req)
			begin
				if(cpu_rw==1'b1)	// Read cycle
					state<=WAITRD;
				else	// Write cycle
				begin
					tag_w = {4'b0000,cpu_addr[31:4]};
//					if(tag_hit) // FIXME - brute force clear the tag.
					if(cpu_addr[30]==1'b0)	// An upper image of the RAM with cache clear bypass.
						tag_wren<=1'b1;
				end
			end
			if(flushpending)
				state<=FLUSH1;

		end
		WRITE1:
			begin
				busy <= 1'b0;
				// If the current address is in cache,
				// we must update the appropriate cacheline

				// FIXME - this gets more complicated for a 32-bit cache.
				// For now, we simply invalidate the cacheline if the write
				// is anything other than 32 bit.
				tag_w = {4'b0000,cpu_addr[31:4]};

 				if(tag_hit)
				begin
					tag_wren<=1'b1;
				end
				state<=WAITING;
			end

		WRITE2:
			begin
				busy <= 1'b0;
				if(cpu_req==1'b0)	// Wait for the write cycle to finish
					state<=WAITING;
			end

		WAITRD:
			begin
				if(cpu_req)
					state<=PAUSE1;
				else
					state<=WAITING;
				// Check both tags for a match...
				if(tag_hit && data_valid)
				begin

				end
				else	// No matches?
				begin
					tag_wren<=1'b1;

					sdram_req<=1'b1;
					sdram_rw<=1'b1;	// Read cycle
					state<=WAITFILL;
				end
			end

		PAUSE1:
		begin
			if(cpu_req==1'b0)
				state<=WAITING;
		end
		
		WAITFILL:
		begin
			readword_burst<=1'b1;
			// In the interests of performance, read the word we're waiting for first.
			readword<=latched_cpuaddr[3:2];

			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				// Forward data to CPU
				firstword[31:16] <= data_from_sdram;

				// write first word to Cache...
				data_w[31:16]<=data_from_sdram;
				state<=FILL2;
			end
		end

		FILL2:
		begin
			fill_ack<=1'b1; // Maintain ack signal if necessary
			// Forward data to CPU
			firstword[15:0] <= data_from_sdram;
			firstword_ready<=1'b1;
			// write second word to Cache...
			readword_burst<=1'b1;
			data_w[15:0]<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL3;
		end

		FILL3:
		begin
			if(!cpu_req)
				fill_ack<=1'b0;
			readword_burst<=1'b1;
			data_w[31:16]<=data_from_sdram;
			state<=FILL4;
		end

		FILL4:
		begin
			if(!cpu_req)
				fill_ack<=1'b0;
			readword_burst<=1'b1;
			readword<=readword+1;
			data_w[15:0]<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL5;
		end

		FILL5:
		begin
			fill_ack<=1'b0;
			readword_burst<=1'b1;
			data_w[31:16]<=data_from_sdram;
			state<=FILL6;
		end

		FILL6:
		begin
			readword_burst<=1'b1;
			readword<=readword+1;
			data_w[15:0]<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL7;
		end

		FILL7:
		begin
			readword_burst<=1'b1;
			data_w[31:16]<=data_from_sdram;
			state<=FILL8;
		end
		
		FILL8:
		begin
			readword_burst<=1'b1;
			readword<=readword+1;
			data_w[15:0]<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL9;
		end
		
		FILL9:
		begin
			readword<=latched_cpuaddr[3:2];
			state<=WAITING;
		end

		default:
			state<=WAITING;
	endcase

	if(!cpu_req)
		firstword_ready<=1'b0;

	if(reset==1'b0)
		state<=INIT;
end


endmodule

module DirectCacheRAM #(parameter addrbits=10) (
	input clk,
	input [addrbits-1:0] address,
	input [31:0] data,
	output reg [31:0] q,
	input wren
);

reg [31:0] storage[0:(2**addrbits)-1];

always @(posedge clk) begin
	if(wren) begin
		storage[address]<=data;
		q<=data;
	end else
		q<=storage[address];
end

endmodule
