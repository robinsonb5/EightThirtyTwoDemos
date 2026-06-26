// USB FIFO queue
// Synchronous, fall-through semantics.

module usb_fifo #(parameter fifowidth = 8, parameter fifodepth = 8) (
	input wire clk_rd,
	input wire reset_n_rd,

	input wire clk_wr,
	input wire reset_n_wr,
	
	input rewind,	// Allows a message to be replayed repeatedly - i.e keep-alive pulses.

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
always @(posedge clk_wr) begin
	if(wr_en && !full) begin
		storage[writeptr]<=din;
		writeptr <= writeptr_next;
		writeptr_next <= writeptr_next+1;
	end

	if(!reset_n_wr) begin
		writeptr <= 0;
		writeptr_next <= 1;
	end
end

// Read logic

// When the FIFO is empty the first write will cause the current
// read pointer to be saved, so that a message (such as the keep-alive pulse
// or SoF message) can be replayed periodically without software intervention.

reg [fifodepth-1:0] readptr_saved;

// Shouldn't need CDC for readptr_saved or empty since they're updated
// on a half-duplex basis.

always @(posedge clk_wr) begin
	if(empty && wr_en)
		readptr_saved <= readptr;
end

always @(posedge clk_rd) begin
	dout <= storage[readptr];
	if(rd_en && !empty)
		readptr<=readptr+1;

	if(rewind)
		readptr <= readptr_saved;
	
	if(!reset_n_rd)
		readptr<=0;
end

// Verification

`ifdef SOC_VERIFY
always @(posedge sysclk) begin
	a_fullempty : assert(full==1'b0 || empty==1'b0);
end
`endif

endmodule

