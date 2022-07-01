module hybrid_2ndorder #(parameter signalwidth=16)
(
	input clk,
	input reset_n,
	input [signalwidth-1:0] d, 
	output q
);

	reg newval;
 
	reg [signalwidth+2:0] acc1;
	reg [signalwidth+2:0] acc2;

	reg [4:0] pwmthreshold;
	reg [signalwidth+1:0] d_offset;
	reg [signalwidth+2:0] d_ext;
	
	always @(posedge clk) begin
		d_offset <= {{2{!d[signalwidth-1]}},d[signalwidth-2:0]} - {7'h1,{signalwidth-5{1'b0}}}; // Offset to correct for slight asymmetry in PWM
		d_ext <= {{3{d_offset[signalwidth]}},d_offset[signalwidth-1:0]}; // Sign extend
	end
			
	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			acc1={signalwidth+3{1'b0}};
			acc2={signalwidth+3{1'b0}};
		end	else begin
			if(newval) begin
				acc1 = acc1 + d_ext - {{3{pwmthreshold[4]}},pwmthreshold[3:0],{signalwidth-4{1'b0}}};
				acc2 = acc2 + acc1		 - {{3{pwmthreshold[4]}},pwmthreshold[3:0],{signalwidth-4{1'b0}}};

				pwmthreshold <= acc2[signalwidth+2:signalwidth-2];
			end
		end
	end
		
	reg q_i;
	reg [4:0] pwmcounter;
	wire [4:0] pwmt;
	
	assign pwmt = {!pwmthreshold[4],pwmthreshold[3:0]};

	always @(posedge clk or negedge reset_n) begin
		if(!reset_n)
			pwmcounter<=5'b0;
		else begin
			newval <= 1'b0;

			pwmcounter<=pwmcounter+1;

			if(pwmcounter==5'h1e) begin
				newval<=1'b1;
			end
			if(&pwmcounter) begin
				q_i <= |pwmt;
			end
			if(pwmcounter==pwmt)
				q_i<=1'b0;
			
		end			
	end

	assign q=q_i;
		
endmodule


