// Simple single burst cache using logic rather than RAM

// 32 bit address and data.
// 8 word bursts, 16-bit SDRAM interface, so a single cacheline of 4 32-bit words


module BurstCache
(
	input clk,
	input reset, // active low
	output ready,
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

reg [31:0] word0;
reg [31:0] word1;
reg [31:0] word2;
reg [31:0] word3;
reg [31:0] cacheaddr;
reg [3:0] valid;

assign sdram_addr=cacheaddr;

// States for state machine
localparam	INIT1=0, INIT2=1, WAITING=2, WAITRD=3, PAUSE1=4;
localparam	WRITE1=5, WRITE2=6, FILL1=7, FILL2=8, FILL3=9;
localparam 	FILL4=10, FILL5=11, FILL6=12, FILL7=13, FILL8=14, FILL9=15;

reg [15:0] state = INIT1;
reg init;
assign ready=~init;

reg cpu_req_d;

wire hit;
assign hit = cacheaddr[31:4]==cpu_addr[31:4];
assign cpu_cachevalid = valid[cpu_addr[3:2]] && cpu_rw && hit && !busy;
assign cpu_ack = cpu_req_d && cpu_cachevalid && cpu_rw;

assign data_to_cpu = cpu_addr[3] ? 
	(cpu_addr[2] ? word3 : word2) : (cpu_addr[2] ? word1 : word0);
			
always @(posedge clk)
begin

	// Defaults
	init<=1'b0;
		
	cpu_req_d<=cpu_req;
	
	case(state)

		// We use an init state here to loop through the data, clearing
		// the valid flag - for which we'll use bit 17 of the data entry.
	
		INIT1:
		begin
			init<=1'b1;	// need to mark the entire cache as invalid before starting.
			busy <=1'b1;
			valid<=1'b0;
			state<=WAITING;
		end
		
		WAITING:
		begin
			state<=WAITING;
			busy <= 1'b0;
			if(cpu_req)
			begin
				if(cpu_rw==1'b1 & !cpu_cachevalid)	// Read cycle
				begin
					sdram_req<=1'b1;
					sdram_rw<=1'b1;	// Read cycle
					cacheaddr<=cpu_addr;
					valid<=4'b0000;
					case(cpu_addr[3:2])
						2'b00 : state<=FILL1;
						2'b01 : state<=FILL3;
						2'b10 : state<=FILL5;
						2'b11 : state<=FILL7;
					endcase
				end
			end
		end
		
		PAUSE1: 
		begin
			if(sdram_fill==1'b0)
				state<=WAITING;
		end
		
		FILL1:
		begin
			if(!sdram_req)
				state<=WAITING;
			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				word0[31:16] <= data_from_sdram;
				state<=FILL2;
			end
		end

		FILL2:
		begin
			word0[15:0]<=data_from_sdram;
			valid[0]<=1'b1;
			state<=FILL3;
		end

		FILL3:
		begin
			if(!sdram_req)
				state<=WAITING;
			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				word1[31:16]<=data_from_sdram;
				state<=FILL4;
			end
		end

		FILL4:
		begin
			word1[15:0]<=data_from_sdram;
			valid[1]<=1'b1;
			state<=FILL5;
		end

		FILL5:
		begin
			if(!sdram_req)
				state<=WAITING;
			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				word2[31:16]<=data_from_sdram;
				state<=FILL6;
			end
		end

		FILL6:
		begin
			word2[15:0]<=data_from_sdram;
			valid[2]<=1'b1;
			state<=FILL7;
		end

		FILL7:
		begin
			if(!sdram_req)
				state<=WAITING;
			if (sdram_fill==1'b1)
			begin
				sdram_req<=1'b0;
				word3[31:16]<=data_from_sdram;
				state<=FILL8;
			end
		end
		
		FILL8:
		begin
			word3[15:0]<=data_from_sdram;
			valid[3]<=1'b1;
			state<=FILL1;
		end

		default:
			state<=WAITING;
	endcase

	if (flush || (cpu_req && !cpu_rw))// && hit))	// Write cycle - if we have an address hit, abandon any lingering
	// burst, invalidate the cacheline and return to the waiting state.
	begin
		valid<=4'b0000;
		state<=PAUSE1;
	end;

	
	if(reset==1'b0)
		state<=INIT1;
end


endmodule
