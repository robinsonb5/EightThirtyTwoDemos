// FIFO queue for debug channel.
// Synchronous, fall-through semantics.

// Also has a lead-in mode, activated by setting "leadin" to "01", "10" or "11".
// While lead in"mode is active, the read pointer will be forced to track the 
// write pointer with an offset of 1/4, 1/2 or 3/4 of the FIFO depth,
// effectively disabling the full / empty logic.

module vjtag_sync_fifo #(parameter fifowidth = 32, parameter fifodepth = 6) (
	input wire sysclk,
	input wire reset_n,
	
	// Read side
	input wire rd_en,
	output reg [fifowidth-1:0] dout,
	output wire empty,
	
	// Write side
	input wire wr_en,
	input wire [fifowidth-1:0] din,
	output wire full,
	
	input wire [1:0] leadin
);

reg [fifowidth-1:0] storage [2**fifodepth];
reg [fifodepth-1:0] readptr;
reg [fifodepth-1:0] writeptr=0;
reg [fifodepth-1:0] writeptr_next=1;

assign empty = (readptr==writeptr) ? 1'b1 : 1'b0;
assign full = (leadin==2'b00 && readptr==writeptr_next) ? 1'b1 : 1'b0;


// Compare and count logic

reg wr_en_d;
reg wr_fifo;
reg [fifowidth-1:0] prev;
reg [fifowidth-1:0] changed_w;
wire changed = changed_w == 0 ? 1'b0 : 1'b1;
reg changed_d;

always @(posedge sysclk) begin
	if(wr_en) begin
		changed_w <= prev ^ din;
		changed_d <= changed;
		prev <= din;
	end
	wr_en_d <= wr_en;

	if(!reset_n)
		prev <= 0;
end

reg [7:0] runlength;
reg [fifowidth-1:0] tofifo;
always @(posedge sysclk) begin
	wr_fifo <= 1'b0;

	if(wr_en_d && !full) begin
		tofifo <= prev;
		if(changed) begin
			tofifo[fifowidth-1] <= 1'b0;	// Literal data
			runlength<=0;
			wr_fifo <= 1'b1;		
		end else begin
			tofifo[fifowidth-1] <= 1'b1;	// Run length
			tofifo[7:0] <= runlength;
			wr_fifo <= 1'b1;
			runlength<=runlength+1;
		end
		
		if(changed | changed_d) begin
			writeptr <= writeptr_next;
			writeptr_next <= writeptr_next+1;
		end

	end
	if(!reset_n) begin
		writeptr <= 0;
		writeptr_next <= 1;
		runlength <= 0;
	end
end


// Write logic

always @(posedge sysclk) begin
	if(wr_fifo && !full) begin
		storage[writeptr]<=tofifo;
	end
end


// Read logic

always @(posedge sysclk) begin

	dout <= storage[readptr];
	if(rd_en && !empty) begin
		readptr<=readptr+1;
	end
	
	// In leadin mode, make the read pointer track the write pointer with an offset determined by leadin.
	if(wr_en_d && !full) begin
		if(|leadin)
			readptr <= {writeptr[fifodepth-1 : fifodepth-2] + leadin,writeptr[fifodepth-3:0]};
	end
	
	if(!reset_n) begin
		readptr<=0;
	end
	
end

// Verification

`ifdef SOC_VERIFY
always @(posedge sysclk) begin
	a_fullempty : assert(full==1'b0 || empty==1'b0);
end
`endif

endmodule

