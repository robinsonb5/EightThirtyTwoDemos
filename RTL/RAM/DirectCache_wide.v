// Direct mapped Cache

// 32 bit address and data.
// 8 word bursts, 32-bit SDRAM interface, so cachelines of 8 32-bit words


module DirectMappedCache #(parameter cachemsb=11,parameter burstlog2=3)
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

	input [31:0] data_from_sdram,
	output [31:0] sdram_addr,
	output reg sdram_req,
	input sdram_fill,
	output reg busy,
	input flush
);

localparam cachebits = cachemsb-1;
localparam tagbits = cachebits-3;

// States for state machine
localparam	INIT=0, FLUSH1=1, WAITING=2, WAITRD=3, PAUSE1=4;
localparam	WRITE1=5, WRITE2=6, WAITFILL=7, FILL2=8, FILL3=9;
localparam 	FILL4=10, FILL5=11, FILL6=12, FILL7=13, FILL8=14, FILL9=15;
localparam  FLUSH2=16;

reg [15:0] state = INIT;

reg readword_burst; // Set to 1 when the lsb of the cache address should
							// track the SDRAM controller.
reg [2:0] readword;

reg [31:0] latched_cpuaddr;
assign sdram_addr = latched_cpuaddr;

// BlockRAM and related signals for data

wire [cachebits-1:0] data_a;
wire [31:0] data_q;
reg[31:0] data_w;
reg data_wren;

reg tagwrite;
reg [cachebits-1:0] tag_writea;
wire [tagbits-1:0] tag_a;
wire [31:0] tag_q;
reg [31:0] tag_w;
reg tag_wren;

DirectCacheRAM #(.addrbits(cachebits)) dataram (
	.clk(clk),
	.address(data_a),
	.data(data_w),
	.q(data_q),
	.wren(data_wren)
);

DirectCacheRAM #(.addrbits(tagbits)) tagram (
	.clk(clk),
	.address(tag_a),
	.data(tag_w),
	.q(tag_q),
	.wren(tag_wren)
);

assign tag_a = readword_burst ? latched_cpuaddr[cachebits+1:burstlog2+2] :
			{cpu_addr[cachebits+1:burstlog2+2]};

wire tag_hit;
assign tag_hit = tag_q[26:cachemsb-(burstlog2+2)]==cpu_addr[31:cachemsb];

wire data_valid;

assign data_valid = tag_q[31];

reg [31:0] firstword;
reg firstword_ready;
assign data_to_cpu = (firstword_ready ? firstword : data_q);

reg cpu_req_d;

assign cpu_cachevalid = firstword_ready | ((tag_hit && data_valid) && cpu_req && cpu_rw && !busy);
assign cpu_ack = 1'b0; // (cpu_req_d && cpu_cachevalid && cpu_rw) || fill_ack || write_ack;


// Boolean signals to indicate cache hits.

// In the data blockram the lower two bits of the address determine
// which word of the burst we're reading.  When reading from the cache, this comes
// from the CPU address; when writing to the cache it's determined by the state
// machine.

assign data_a = readword_burst ? {latched_cpuaddr[cachebits+1:burstlog2+2],readword} : {cpu_addr[cachebits+1:2]};

reg flushpending;
			
always @(posedge clk)
begin

	// Defaults
	tag_wren<=1'b0;
	data_wren<=1'b0;
	readword_burst<=1'b0;
	
	busy <=1'b1;
	
	cpu_req_d<=cpu_req;
	
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
			readword_burst<=1'b1;
		end
		
		FLUSH1:
		begin
			latched_cpuaddr<=2**(burstlog2+2);
			readword<=3'b1;
			tag_w = 32'h00000000;
			tag_wren<=1'b1;
			readword_burst<=1'b1;
			state<=FLUSH2;
		end
		
		FLUSH2:
		begin
			readword_burst<=1'b1;
			if(readword==0)
				latched_cpuaddr<=latched_cpuaddr+2**(burstlog2+2);
			readword<=readword+1'b1;
			tag_wren<=1'b1;
			if(latched_cpuaddr[cachemsb+1:burstlog2+2]==0 && readword==0)
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
			tag_w = {5'b11110,cpu_addr[31:burstlog2+2]};
			latched_cpuaddr<=cpu_addr;
			if(!firstword_ready  && cpu_req)
			begin
				if(cpu_rw==1'b1)	// Read cycle
					state<=WAITRD;
				else	// Write cycle
				begin
					readword_burst<=1'b1;
//					if(tag_hit) // FIXME - brute force clear the tag.
					if(cpu_addr[30]==1'b0)	// An upper image of the RAM with cache clear bypass.
						state<=WRITE1;
				end
			end
			if(flushpending)
				state<=FLUSH1;

		end

		WRITE1:
			begin
				if(tag_hit) begin
					tag_w = {5'b00000,cpu_addr[31:burstlog2+2]};
					tag_wren<=1'b1;
				end
				state<=WAITING;
			end

		WAITRD:
			begin
				if(cpu_req)
					state<=PAUSE1;
				else
					state<=WAITING;
				// Check both tags for a match...
				if(!tag_hit || !data_valid)	// No matches?
				begin
					tag_wren<=1'b1;

					sdram_req<=1'b1;
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
			readword<=latched_cpuaddr[4:2];

			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				// Forward data to CPU
				firstword <= data_from_sdram;
				firstword_ready<=1'b1;

				// write first word to Cache...
				data_w<=data_from_sdram;
				data_wren<=1'b1;
				state<=FILL2;
			end
		end

		FILL2:
		begin
			// Forward data to CPU
			// write second word to Cache...
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL3;
		end

		FILL3:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL4;
		end

		FILL4:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL5;
		end

		FILL5:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL6;
		end

		FILL6:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL7;
		end

		FILL7:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL8;
		end
		
		FILL8:
		begin
			readword_burst<=1'b1;
			readword<=readword+1'b1;
			data_w<=data_from_sdram;
			data_wren<=1'b1;
			state<=FILL9;
		end
		
		FILL9:
		begin
			readword<=latched_cpuaddr[4:2];
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
