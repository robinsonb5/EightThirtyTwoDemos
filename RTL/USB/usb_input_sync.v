module usb_input_sync (
	input clk_signal,
	input reset_n,
	input dp_i,
	input dm_i,
	input oe,
	input stb_fullspeed,
	input stb_lowspeed,
	output sample, // Input sample '1' for transition, '0' for no transition
	output sample_stb, // Strobe signal selected for linkspeed.
	output sez, // Single-ended zero
	output edgesense,
	output reg linkspeed
);


// Synchronise the incoming signals and generate an edgesense
// signal when either half of the pair changes. (Will be used to
// align the sampling strobes.)

reg [2:0] dp_s;
reg [2:0] dm_s;
always @(posedge clk_signal) begin
	dp_s <= {dp_s[1:0],dp_i};
	dm_s <= {dm_s[1:0],dm_i};
end

wire dp_raw_edge = dp_s[2] ^ dp_s[1];
wire dm_raw_edge = dm_s[2] ^ dm_s[1];
assign edgesense = dp_raw_edge | dm_raw_edge;


// Sample the synchronised data using one of the two strobes,
// based on link speed.

wire sample_stb_i = linkspeed ? stb_fullspeed : stb_lowspeed;

// Filter the strobe signal so the core ignores the
// transition immediately following a SEZ

assign sample_stb = sez_d && !oe ? 1'b0 : sample_stb_i;

reg dp_sample;
reg dm_sample;

always @(posedge clk_signal) begin
	if(sample_stb_i) begin
		dp_sample <= dp_s[2];
		dm_sample <= dm_s[2];
	end 
end

wire dif0 = (dm_sample & (~dp_sample));
wire dif1 = (dp_sample & (~dm_sample));
assign sez = ~(dp_sample | dm_sample);

reg sez_d;
reg sample_prev;
always @(posedge clk_signal) begin
	if(sample_stb_i) begin
		sample_prev <= dif1;
		sez_d <= sez;
	end

	if(!reset_n)
		sez_d <= 1'b1;	
end

assign sample = connected & (dif1 ^ sample_prev);

// When the line goes from idle (constant single-ended zero) to connected 
// we evaluate which line was pulled up, and set fullspeed accordingly.
// (Since every packet ends in single-ended zero we're re-evaluating this
// constantly, but that should be harmless.)

reg connected;

always @(posedge clk_signal) begin

	if(sample_stb_i) begin

		if(sez_d && dp_sample && !dm_sample) begin
			linkspeed <= 1'b1;
			connected <= 1'b1;
		end
		
		if(sez_d && dm_sample && !dp_sample) begin
			linkspeed <= 1'b0;
			connected <= 1'b1;
		end
	end

	// Optional: On reset reevaluate the connection speed.
	if(!reset_n) begin
		linkspeed <= 1'b1;
		connected <= 1'b0;
	end
end


endmodule
