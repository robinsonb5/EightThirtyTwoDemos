module usb_input_sync (
	input clk_signal,
	input dp_i,
	input dm_i,
	output dp_o,
	output dm_o,
	output edgesense
);
	
reg [2:0] dp_s;
reg [2:0] dm_s;
wire dp_raw_edge = dp_s[2] ^ dp_s[1];
wire dm_raw_edge = dm_s[2] ^ dm_s[1];

always @(posedge clk_signal) begin
	dp_s <= {dp_s[1:0],dp_i};
	dm_s <= {dm_s[1:0],dm_i};
end

assign dp_o = dp_s[2];
assign dm_o = dm_s[2];

assign edgesense = dp_raw_edge | dm_raw_edge;

endmodule
