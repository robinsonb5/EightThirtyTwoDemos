// FIFO queue for i2c
// Synchronous, fall-through semantics.

module i2cfifo #(parameter fifowidth = 8, parameter fifodepth = 8) (
	input wire clk,
	input wire reset_n,

	// Read side
	input wire rd_en,
	output reg [fifowidth-1:0] dout,
	output wire empty,
	
	// Write side
	input wire wr_en,
	input wire [fifowidth-1:0] din,
	output wire full
);


reg [fifowidth-1:0] storage [2**fifodepth];
reg [fifodepth-1:0] readptr;
reg [fifodepth-1:0] writeptr=0;
reg [fifodepth-1:0] writeptr_next=1;

// CDC on full and empty signals shouldn't be necessary since they will be accessed half-duplex.

assign empty = (readptr==writeptr) ? 1'b1 : 1'b0;
assign full = (readptr==writeptr_next) ? 1'b1 : 1'b0;

// Write logic
always @(posedge clk) begin
	if(wr_en && !full) begin
		storage[writeptr]<=din;
		writeptr <= writeptr_next;
		writeptr_next <= writeptr_next+1;
	end

	if(!reset_n) begin
		writeptr <= 0;
		writeptr_next <= 1;
	end
end

// Read logic

always @(posedge clk) begin
	dout <= storage[readptr];
	if(rd_en && !empty)
		readptr<=readptr+1;
	
	if(!reset_n)
		readptr<=0;
end

// Verification

`ifdef SOC_VERIFY
always @(posedge sysclk) begin
	a_fullempty : assert(full==1'b0 || empty==1'b0);
end
`endif

endmodule

