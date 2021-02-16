// Stereo Hybrid PWM / Sigma Delta converter
//
// Uses 5-bit PWM, wrapped within a 10-bit Sigma Delta, with the intention of
// increasing the pulse width, since narrower pulses seem to equate to more noise
//
// Copyright 2012,2020,2021 by Alastair M. Robinson
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that they will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>
//

module hybrid_pwm_sd
(
	input clk,
	input [15:0] d_l,
	input [15:0] d_r,
	output reg q_l,
	output reg q_r
);


reg [4:0] pwmcounter;
reg [4:0] pwmthreshold_l = 5'd31;
reg [4:0] pwmthreshold_r = 5'd31;
reg [33:0] scaledin_l;
reg [33:0] scaledin_r;
reg [15:0] sigma_l;
reg [15:0] sigma_r;


// Anti-pop - at power-on ramp smoothly from max to midpoint, then 
// cut over to the core's audio output

reg init = 1'b1;
reg [13:0] initctr = 16'h3fff;
wire [15:0] l;
wire [15:0] r;

assign l = init ? {initctr[13:0],2'b00} : d_l;
assign r = init ? {initctr[13:0],2'b00} : d_r;

always @(posedge clk)
begin
	if(init) begin
		if(dump) begin
			initctr <= initctr-1;
			if (!initctr[13])
				init<=1'b0;
		end
	end
end

// Periodic dumping of the accumulator to kill standing tones.
reg [7:0] dumpcounter;
reg dump;
reg dump_d;

always @(posedge clk)
begin
	dump <=1'b0;
	if(pwmcounter==5'b00000)
	begin
		dumpcounter<=dumpcounter+1;
		dump<=dumpcounter==0 ? 1'b1 : 1'b0;
	end
end

always @(posedge clk)
begin
	pwmcounter<=pwmcounter+5'b1;

	if(pwmcounter==pwmthreshold_l)
		q_l<=1'b0;

	if(pwmcounter==pwmthreshold_r)
		q_r<=1'b0;

	if(pwmcounter==5'b00000) // Update threshold when pwmcounter reaches zero
	begin
		// Pick a new PWM threshold using a Sigma Delta
		scaledin_l<=33'h8000000 // (1<<(16-5))<<16     offset to keep centre aligned.
			+({1'b0,l}*16'hf000); // + d_l * 30<<(16-5);
		sigma_l<=scaledin_l[31:16]+{5'b00000,sigma_l[10:0]};	// Will use previous iteration's scaledin value
		pwmthreshold_l<=sigma_l[15:11]; // Will lag 2 cycles behind, but shouldn't matter.
		q_l<=1'b1;

		scaledin_r<=33'h8000000 // (1<<(16-5))<<16     offset to keep centre aligned.
			+({1'b0,r}*16'hf000); // + d_r * 30<<(16-5);
		sigma_r<=scaledin_r[31:16]+{5'b00000,sigma_r[10:0]};	// Will use previous iteration's scaledin value
		pwmthreshold_r<=sigma_r[15:11]; // Will lag 2 cycles behind, but shouldn't matter.
		q_r<=1'b1;
	end

	if(dump)	// Falling edge of reset, dump the accumulator
	begin
		sigma_l[10:0]<=11'b100_00000000;
		sigma_r[10:0]<=11'b100_00000000;
	end

end

endmodule
