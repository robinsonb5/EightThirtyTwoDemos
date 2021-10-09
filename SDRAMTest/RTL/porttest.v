module porttest #(parameter addrwidth=16, parameter datawidth=16, parameter cyclewidth=6)
(
	input clk,
	input reset_n,
	output reg [addrwidth:1] a,
	input [datawidth-1:0] d,
	output reg [datawidth-1:0] q,
	output rd_req,
	input rd_ack,
	output wr_req,
	input wr_ack,
	output reg we,
	output reg err,
	output reg [datawidth-1:0] errbits,
	output reg [31:0] readcount,
	output reg [31:0] errorcount
);

// First, a cycle counter which pseudo-randomly picks a cycle length for the test

reg cycle_next;
wire [cyclewidth-1:0] cycle_len;
lfsr #(.width(cyclewidth)) cyclelfsr
(
	.clk(clk),
	.reset_n(reset_n),
	.e(cycle_next),
	.q(cycle_len),
	.save(1'b0),
	.restore(1'b0)
);


reg lfsr_next;
reg	lfsr_save;
reg	lfsr_restore;
wire [addrwidth-1:0] lfsr_a_q;
wire [datawidth-1:0] lfsr_d_q;

lfsr #(.width(addrwidth)) addrlfsr
(
	.clk(clk),
	.reset_n(reset_n),
	.e(lfsr_next),
	.q(lfsr_a_q),
	.save(lfsr_save),
	.restore(lfsr_restore)
);

lfsr #(.width(datawidth)) datalfsr
(
	.clk(clk),
	.reset_n(reset_n),
	.e(lfsr_next),
	.q(lfsr_d_q),
	.save(lfsr_save),
	.restore(lfsr_restore)
);

reg [cyclewidth-1:0] cycle_counter;
reg [3:0] state;


localparam INIT=4'b0;
localparam WRITE1=4'h1;
localparam WRITE2=4'h2;
localparam WRITE3=4'h3;
localparam READ1=4'h4;
localparam READ2=4'h5;
localparam READ3=4'h6;
localparam PAUSE=4'h7;

reg ram_rd_req;
assign rd_req=ram_rd_req;
reg ram_wr_req;
assign wr_req=ram_wr_req;

reg [3:0] initctr;

always @(posedge clk,negedge reset_n)
begin
	if(!reset_n) begin
		state<=INIT;
		we<=1'b0;
		err<=1'b0;
		errbits<={datawidth{1'b0}};
		readcount<=32'b0;
		errorcount<=32'b0;
		initctr<=4'b1;
		lfsr_next<=1'b0;
		lfsr_save<=1'b0;
		lfsr_restore<=1'b0;
		cycle_next<=1'b0;
	end	else begin
		lfsr_next<=1'b0;
		lfsr_save<=1'b0;
		lfsr_restore<=1'b0;
		cycle_next<=1'b0;

		case(state)
			INIT: begin
				ram_rd_req<=rd_ack;
				ram_wr_req<=wr_ack;
				cycle_counter<=cycle_len;
				lfsr_save<=1'b1;
				initctr<=initctr+1'b1;
				if(!(|initctr))
					state<=WRITE1;
			end

			WRITE1: begin
				err<=1'b0;
				a<=lfsr_a_q;
				ram_wr_req<=!wr_ack;
				q<=lfsr_d_q;
				we<=1'b1;
				lfsr_next<=1'b1;
				state<=WRITE2;
			end

			WRITE2: begin
				if(wr_ack==ram_wr_req) begin
					ram_rd_req<=rd_ack; // Make sure the next request doesn't kick off prematurely
					if(cycle_counter!=0) begin
						cycle_counter<=cycle_counter-1;
						state<=WRITE1;
					end else begin
						lfsr_restore<=1'b1;
						cycle_counter<=cycle_len;
						cycle_next<=1'b1;
						we<=1'b0;
						state<=WRITE3;
					end
				end
			end

			WRITE3: begin // Extra cycle for the LFSR to restore
				state<=READ1;
			end

			READ1: begin
				ram_rd_req<=!rd_ack;
				a<=lfsr_a_q;
				state <= READ2;
			end

			READ2: begin
				if(ram_rd_req==rd_ack) begin
					if(d==lfsr_d_q) begin
						// Using != doesn't seem to work with Icarus Verilog when the incoming signal is high-z
					end else begin
						$display("READ error, mismatch");
						errorcount<=errorcount+1;
						err<=1'b1;
					end
					if(cycle_counter!=0) begin
						lfsr_next<=1'b1;
					end
					readcount<=readcount+1;
					errbits<=errbits | (d ^ lfsr_d_q);
					state<=READ3;
				end
			end

			READ3: begin	// Let the LFSR cycle
				if(cycle_counter!=0) begin
					cycle_counter<=cycle_counter-1;
					state<=READ1;
				end else begin
					cycle_counter<={cyclewidth{1'b1}};
					state<=PAUSE;
				end
			end

			PAUSE: begin
				if(cycle_counter!=0) begin
					cycle_counter<=cycle_counter-1;
					state<=PAUSE;
				end else begin
					cycle_counter<=cycle_len;
					lfsr_save<=1'b1;
					state<=WRITE1;
				end
			end

			default:
				state<=INIT;
		endcase
	end
end

endmodule
