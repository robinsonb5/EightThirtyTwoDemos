// Configurable Linear Feedback Shift Register with 2 or 4 taps
// Copyright 2021 by Alastair M. Robinson

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with with this program.  If not, see <https://www.gnu.org/licenses/>.

// Tap positions taken from Xilinx XAPP210,
// One tap is always the last bit in the register; the position of the others
// is looked up based on the "width" parameter.
//
// Supports widths from 3 to 128

// There are two extra inputs to aid in replaying a sequence:
// Pulse the save input high to store the current value for later recall
// Pulse the restore input high to restore a saved value.

module lfsr #(parameter width=128, parameter seed=123456789) 
(
	input clk,
	input reset_n,
	input e,
	input save,
	input restore,
	output [width-1:0] q
);

reg [width-1:0] shift;
reg [width-1:0] saved;

reg [7:0] tap1=tap(width);

function [7:0] tap(input [7:0] w);
	case(w)
		3:	tap=2;
		4:	tap=3;
		5:	tap=3;
		6:	tap=5;
		7:	tap=6;
		8:	tap=6;
		9:	tap=5;
		10:	tap=7;
		11:	tap=9;
		12:	tap=6;
		13:	tap=4;
		14:	tap=5;
		15:	tap=14;
		16:	tap=15;
		17:	tap=14;
		18:	tap=11;
		19:	tap=6;
		20:	tap=17;
		21:	tap=19;
		22:	tap=21;
		23:	tap=18;
		24:	tap=23;
		25:	tap=22;
		26:	tap=6;
		27:	tap=5;
		28:	tap=25;
		29:	tap=27;
		30:	tap=6;
		31:	tap=28;
		32:	tap=22;
		33:	tap=20;
		34:	tap=27;
		35: tap=33;
		36:	tap=25;
		37:	tap=5;
		39:	tap=35;
		40:	tap=38;
		41:	tap=38;
		42:	tap=41;
		43:	tap=42;
		45:	tap=44;
		46:	tap=45;
		47:	tap=42;
		48:	tap=47;
		49:	tap=40;
		50:	tap=49;
		51:	tap=50;
		52:	tap=49;
		53:	tap=52;
		54:	tap=53;
		55:	tap=31;
		56:	tap=55;
		57:	tap=50;
		58:	tap=39;
		59:	tap=58;
		60:	tap=59;
		61:	tap=60;
		62:	tap=61;
		63:	tap=62;
		64:	tap=63;
		65:	tap=47;
		66:	tap=65;
		67:	tap=66;
		68:	tap=59;
		69:	tap=67;
		70:	tap=69;
		71:	tap=65;
		72:	tap=66;
		73:	tap=48;
		74:	tap=73;
		75:	tap=74;
		76:	tap=75;
		77:	tap=76;
		78:	tap=77;
		79:	tap=70;
		80:	tap=79;
		81:	tap=77;
		82:	tap=79;
		83:	tap=82;
		84:	tap=71;
		85:	tap=84;
		86:	tap=85;
		87:	tap=74;
		88:	tap=87;
		89:	tap=51;
		90:	tap=89;
		91:	tap=90;
		92:	tap=91;
		93:	tap=91;
		94:	tap=73;
		95:	tap=84;
		96:	tap=94;
		97:	tap=91;
		98:	tap=87;
		99:	tap=97;
		100:	tap=64;
		101:	tap=100;
		102:	tap=101;
		103:	tap=94;
		104:	tap=103;
		105:	tap=89;
		106:	tap=91;
		107:	tap=105;
		108:	tap=77;
		109:	tap=108;
		110:	tap=109;
		111:	tap=101;
		112:	tap=110;
		113:	tap=104;
		114:	tap=113;
		115:	tap=114;
		116:	tap=115;
		117:	tap=115;
		118:	tap=85;
		119:	tap=111;
		120:	tap=113;
		121:	tap=103;
		122:	tap=121;
		123:	tap=121;
		124:	tap=87;
		125:	tap=124;
		126:	tap=125;
		127:	tap=126;
		128:	tap=126;
		default: tap=-1; // Error condition if we don't support the requested width
	endcase
endfunction

// Extra taps for LFSRs requiring four taps.
// For 2-tap LFSRs these are set to 1, used later to select a feedback path.

wire [7:0] tap2;
wire [7:0] tap3;
reg [15:0] twotap_tmp=twotaps(width);
assign tap2=twotap_tmp[15:8];
assign tap3=twotap_tmp[7:0];

function [15:0] twotaps(input [7:0] w);
	case(w)
		8:	begin 	twotaps[15:8]=5;	twotaps[7:0]=4;	end
		12:	begin 	twotaps[15:8]=4;	twotaps[7:0]=1;	end
		13:	begin 	twotaps[15:8]=3;	twotaps[7:0]=1;	end
		14:	begin 	twotaps[15:8]=3;	twotaps[7:0]=1;	end
		15:	begin	twotaps[15:8]=1; twotaps[7:0]=1; end
		16:	begin 	twotaps[15:8]=13;	twotaps[7:0]=4;	end
		19:	begin 	twotaps[15:8]=2;	twotaps[7:0]=1;	end
		24:	begin 	twotaps[15:8]=22;	twotaps[7:0]=17;	end
		26:	begin 	twotaps[15:8]=2;	twotaps[7:0]=1;	end
		27:	begin 	twotaps[15:8]=2;	twotaps[7:0]=1;	end
		37:	begin 	twotaps[15:8]=4;	twotaps[7:0]=3;	end
		40:	begin 	twotaps[15:8]=21;	twotaps[7:0]=19;	end
		42:	begin 	twotaps[15:8]=20;	twotaps[7:0]=19;	end
		43:	begin 	twotaps[15:8]=38;	twotaps[7:0]=37;	end
		44:	begin 	twotaps[15:8]=18;	twotaps[7:0]=17;	end
		45:	begin 	twotaps[15:8]=42;	twotaps[7:0]=41;	end
		46:	begin 	twotaps[15:8]=26;	twotaps[7:0]=25;	end
		48:	begin 	twotaps[15:8]=21;	twotaps[7:0]=20;	end
		50:	begin 	twotaps[15:8]=24;	twotaps[7:0]=23;	end
		51:	begin 	twotaps[15:8]=36;	twotaps[7:0]=35;	end
		53:	begin 	twotaps[15:8]=38;	twotaps[7:0]=37;	end
		54:	begin 	twotaps[15:8]=18;	twotaps[7:0]=17;	end
		56:	begin 	twotaps[15:8]=35;	twotaps[7:0]=34;	end
		59:	begin 	twotaps[15:8]=38;	twotaps[7:0]=37;	end
		61:	begin 	twotaps[15:8]=46;	twotaps[7:0]=45;	end
		62:	begin 	twotaps[15:8]=6;	twotaps[7:0]=5;	end
		64:	begin 	twotaps[15:8]=61;	twotaps[7:0]=60;	end
		66:	begin 	twotaps[15:8]=57;	twotaps[7:0]=56;	end
		67:	begin 	twotaps[15:8]=58;	twotaps[7:0]=57;	end
		69:	begin 	twotaps[15:8]=42;	twotaps[7:0]=40;	end
		70:	begin 	twotaps[15:8]=55;	twotaps[7:0]=54;	end
		72:	begin 	twotaps[15:8]=25;	twotaps[7:0]=19;	end
		74:	begin 	twotaps[15:8]=59;	twotaps[7:0]=58;	end
		75:	begin 	twotaps[15:8]=65;	twotaps[7:0]=64;	end
		76:	begin 	twotaps[15:8]=41;	twotaps[7:0]=40;	end
		77:	begin 	twotaps[15:8]=47;	twotaps[7:0]=46;	end
		78:	begin 	twotaps[15:8]=59;	twotaps[7:0]=58;	end
		80:	begin 	twotaps[15:8]=43;	twotaps[7:0]=42;	end
		82:	begin 	twotaps[15:8]=47;	twotaps[7:0]=44;	end
		83:	begin 	twotaps[15:8]=38;	twotaps[7:0]=37;	end
		85:	begin 	twotaps[15:8]=58;	twotaps[7:0]=57;	end
		86:	begin 	twotaps[15:8]=74;	twotaps[7:0]=73;	end
		88:	begin 	twotaps[15:8]=17;	twotaps[7:0]=16;	end
		90:	begin 	twotaps[15:8]=72;	twotaps[7:0]=71;	end
		92:	begin 	twotaps[15:8]=80;	twotaps[7:0]=79;	end
		96:	begin 	twotaps[15:8]=49;	twotaps[7:0]=47;	end
		99:	begin 	twotaps[15:8]=54;	twotaps[7:0]=52;	end
		101:	begin 	twotaps[15:8]=95;	twotaps[7:0]=94;	end
		102:	begin 	twotaps[15:8]=36;	twotaps[7:0]=35;	end
		104:	begin 	twotaps[15:8]=94;	twotaps[7:0]=93;	end
		107:	begin 	twotaps[15:8]=44;	twotaps[7:0]=42;	end
		109:	begin 	twotaps[15:8]=103;	twotaps[7:0]=102;	end
		110:	begin 	twotaps[15:8]=98;	twotaps[7:0]=97;	end
		112:	begin 	twotaps[15:8]=69;	twotaps[7:0]=67;	end
		114:	begin 	twotaps[15:8]=33;	twotaps[7:0]=32;	end
		115:	begin 	twotaps[15:8]=101;	twotaps[7:0]=100;	end
		116:	begin 	twotaps[15:8]=46;	twotaps[7:0]=45;	end
		117:	begin 	twotaps[15:8]=99;	twotaps[7:0]=97;	end
		120:	begin 	twotaps[15:8]=9;	twotaps[7:0]=2;	end
		122:	begin 	twotaps[15:8]=63;	twotaps[7:0]=62;	end
		125:	begin 	twotaps[15:8]=18;	twotaps[7:0]=17;	end
		126:	begin 	twotaps[15:8]=90;	twotaps[7:0]=89;	end
		128:	begin 	twotaps[15:8]=101;	twotaps[7:0]=99;	end
		default:	begin  twotaps[15:8]=1;	twotaps[7:0]=1;	end
	endcase
endfunction

wire fourtaps = (tap2>1) ? 1'b1 : 1'b0;

// Extra taps required for width 37
wire [7:0] tap4=2;
wire [7:0] tap5=1;
wire sixtaps;
assign sixtaps = (width==37) ? 1'b1 : 1'b0;


// Seed can't be more than 32-bit, so duplicate it across the entire width

wire [width-1:0] extendedseed;
genvar i;
generate
for(i=0;i<(width-1);i=i+32) begin : extendloop
	if((width-i)>=32)
		assign extendedseed[i+31:i]=seed;
	else
		assign extendedseed[width-1:i]=seed[width-i-1:0];
end
endgenerate

// Perform the actual LFSR

assign q=shift;
always @(posedge clk, negedge reset_n) begin
	if(!reset_n) begin
		shift<=extendedseed;
	end
	else begin
		if(save)
			saved<=shift;
		if(restore)
			shift<=saved;
		if(e) begin
			if(sixtaps) begin // Six taps
				shift<={shift[width-2:0],!shift[width-1]^!shift[tap1-1]^
					!shift[tap2-1]^!shift[tap3-1]^!shift[tap4-1]^!shift[tap5-1]};
			end else if(fourtaps) begin // Four taps
				shift<={shift[width-2:0],!shift[width-1]^!shift[tap1-1]^!shift[tap2-1]^!shift[tap3-1]};
			end else begin // Two taps
				shift<={shift[width-2:0],!shift[width-1]^!shift[tap1-1]};
			end
		end
	end
end

endmodule

