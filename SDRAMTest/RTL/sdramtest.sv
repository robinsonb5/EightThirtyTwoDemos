// SDRAM testbench

module sdramtest #(parameter sysclk_frequency=1000) (
	input  wire       clk,
	input  wire       reset_in,
	inout [15:0] DRAM_DQ,
	output [`SDRAM_ROWBITS-1:0]	DRAM_ADDR,
	output DRAM_LDQM,
	output DRAM_UDQM,
	output DRAM_WE_N,
	output DRAM_RAS_N,
	output DRAM_CAS_N,
	output DRAM_CS_N,
	output [1:0] DRAM_BA
);

reg jtag_reset=1'b1;
wire reset_n;
assign reset_n = jtag_reset & reset_in;

// 5 ports under test

wire [4:0] errors;
wire [15:0] errorbits[5];
wire [31:0] readcount[5];
wire [31:0] errorcount[5];


// Test the ROM ports

localparam rom_high=21;
wire [rom_high:1] rom_addr;
wire rom_we;
wire romwr_req;
wire romrd_req;
wire rom_req;
wire rom_req_ack;
wire [15:0] rom_din;
wire [15:0] rom_dout;

assign rom_req = rom_we ? romwr_req : romrd_req;

porttest #(.addrwidth(rom_high),.datawidth(16),.cyclewidth(4)) romport
(
	.clk(clk),
	.reset_n(reset_n),

	.a(rom_addr),
	.rd_req(romrd_req),
	.rd_ack(rom_req_ack),
	.d(rom_dout),

	.wr_req(romwr_req),
	.wr_ack(rom_req_ack),
	.q(rom_din),
	.we(rom_we),
	.err(errors[0]),
	.errbits(errorbits[0]),
	.readcount(readcount[0]),
	.errorcount(errorcount[0])
);


// Test the WRAM port
localparam wram_high=22;
wire wram_we;
wire wram_req;
wire wram_rd_req;
wire wram_wr_req;
wire wram_req_ack;
wire [wram_high:1] wram_addr;
wire [7:0] wram_din;
wire [15:0] wram_dout;

assign wram_req = wram_we ? wram_wr_req : wram_rd_req;

porttest #(.addrwidth(wram_high),.datawidth(8),.cyclewidth(4)) wramport
(
	.clk(clk),
	.reset_n(reset_n),

	.a(wram_addr),
	.rd_req(wram_rd_req),
	.rd_ack(wram_req_ack),
	.d(wram_addr[1] ? wram_dout[15:8] : wram_dout[7:0]),

	.wr_req(wram_wr_req),
	.wr_ack(wram_req_ack),
	.q(wram_din),
	.we(wram_we),
	.err(errors[1]),
	.errbits(errorbits[1]),
	.readcount(readcount[1]),
	.errorcount(errorcount[1])
);


// Test the VRAM0 port
localparam vram0_high=15;
wire vram0_we;
wire vram0_req;
wire vram0_rd_req;
wire vram0_wr_req;
wire vram0_ack;
wire [vram0_high:1] vram0_addr;
wire [15:0] vram0_din;
wire [15:0] vram0_dout;

assign vram0_req = vram0_we ? vram0_wr_req : vram0_rd_req;

porttest #(.addrwidth(vram0_high),.datawidth(16),.cyclewidth(3)) vram0port
(
	.clk(clk),
	.reset_n(reset_n),

	.a(vram0_addr),
	.rd_req(vram0_rd_req),
	.rd_ack(vram0_ack),
	.d(vram0_dout),

	.wr_req(vram0_wr_req),
	.wr_ack(vram0_ack),
	.q(vram0_din),
	.we(vram0_we),
	.err(errors[2]),
	.errbits(errorbits[2]),
	.readcount(readcount[2]),
	.errorcount(errorcount[2])
);


// Test the VRAM1 port
localparam vram1_high=15;
wire vram1_we;
wire vram1_req;
wire vram1_rd_req;
wire vram1_wr_req;
wire vram1_ack;
wire [vram1_high:1] vram1_addr;
wire [15:0] vram1_din;
wire [15:0] vram1_dout;

assign vram1_req = vram1_we ? vram1_wr_req : vram1_rd_req;

porttest #(.addrwidth(vram1_high),.datawidth(16),.cyclewidth(3)) vram1port
(
	.clk(clk),
	.reset_n(reset_n),

	.a(vram1_addr),
	.rd_req(vram1_rd_req),
	.rd_ack(vram1_ack),
	.d(vram1_dout),

	.wr_req(vram1_wr_req),
	.wr_ack(vram1_ack),
	.q(vram1_din),
	.we(vram1_we),
	.err(errors[3]),
	.errbits(errorbits[3]),
	.readcount(readcount[3]),
	.errorcount(errorcount[3])
);


// Test the ARAM port
localparam aram_high=17;
wire aram_we;
wire aram_req;
wire aram_rd_req;
wire aram_wr_req;
wire aram_req_ack;
wire [aram_high:1] aram_addr;
wire [7:0] aram_din;
wire [15:0] aram_dout;

assign aram_req = aram_we ? aram_wr_req : aram_rd_req;

porttest #(.addrwidth(aram_high),.datawidth(8),.cyclewidth(4)) aramport
(
	.clk(clk),
	.reset_n(reset_n),

	.a(aram_addr),
	.rd_req(aram_rd_req),
	.rd_ack(aram_req_ack),
	.d(aram_addr[1] ? aram_dout[15:8] : aram_dout[7:0]),

	.wr_req(aram_wr_req),
	.wr_ack(aram_req_ack),
	.q(aram_din),
	.we(aram_we),
	.err(errors[4]),
	.errbits(errorbits[4]),
	.readcount(readcount[4]),
	.errorcount(errorcount[4])
);


reg [3:0] clkref=4'b0000;
always @(posedge clk) begin
	clkref<=clkref+1'b1;
	if(clkref==4'd5)
		clkref<=4'd0;
end
	
// SDRAM controller
sdram #(.SDRAM_tCK(10000000/sysclk_frequency)) sdram_ctrl (
	.SDRAM_DQ(DRAM_DQ),   // 16 bit bidirectional data bus
	.SDRAM_A(DRAM_ADDR),    // 13 bit multiplexed address bus
	.SDRAM_DQML(DRAM_LDQM), // two byte masks
	.SDRAM_DQMH(DRAM_UDQM), // two byte masks
	.SDRAM_BA(DRAM_BA),   // two banks
	.SDRAM_nCS(DRAM_CS_N),  // a single chip select
	.SDRAM_nWE(DRAM_WE_N),  // write enable
	.SDRAM_nRAS(DRAM_RAS_N), // row address select
	.SDRAM_nCAS(DRAM_CAS_N), // columns address select

	.clk(clk),
	.init_n(reset_n),
	.clkref(clkref==4'h0 ? 1'b1 : 1'b0),
	.sync_en(1'b1),

	.*
);


localparam jtag_cmd=0;
localparam jtag_idx=1;
localparam jtag_errbits=2;
localparam jtag_failures=3;
localparam jtag_cycles=4;
localparam jtag_wait=5;
localparam jtag_doreset=6;
reg [2:0] jtag_nextstate;
reg [2:0] jtag_state;
wire jtag_req;
wire jtag_ack;
wire jtag_wr;
wire [31:0] jtag_d;
wire [31:0] jtag_q;

always @(posedge clk or negedge reset_in) begin
	if(!reset_in) begin
		jtag_state<=jtag_cmd;
		jtag_nextstate<=jtag_cmd;
		jtag_req<=1'b0;
		jtag_wr<=1'b0;
		jtag_reset<=1'b1;
	end else begin

		case(jtag_state)
			jtag_cmd: begin
					jtag_reset<=1'b1;
					jtag_wr<=1'b0;
					jtag_req<=1'b1;
					jtag_state<=jtag_wait;
					jtag_nextstate<=jtag_idx;
				end
			jtag_idx: begin
					jtag_wr<=1'b1;
					jtag_req<=1'b1;
					jtag_state<=jtag_wait;
					jtag_nextstate<=jtag_cycles;		
					jtag_d<=readcount[jtag_q];
					if(jtag_q[7:0]==8'hff) begin
						jtag_reset<=1'b0;
						jtag_state<=jtag_doreset;
					end
				end
			jtag_cycles: begin
					jtag_wr<=1'b1;
					jtag_req<=1'b1;
					jtag_state<=jtag_wait;
					jtag_nextstate<=jtag_failures;		
					jtag_d<=errorcount[jtag_q];
				end
			jtag_failures: begin
					jtag_wr<=1'b1;
					jtag_req<=1'b1;
					jtag_state<=jtag_wait;
					jtag_nextstate<=jtag_cmd;		
					jtag_d<={16'b0,errorbits[jtag_q]};
				end
			jtag_doreset: begin
					jtag_state<=jtag_cmd;
				end
			jtag_wait: begin
					if(jtag_ack) begin
						jtag_state<=jtag_nextstate;
						jtag_req<=1'b0;
						jtag_wr<=1'b1;
					end
				end
		endcase
	
	end
end

// This bridge is borrowed from the EightThirtyTwo debug interface

debug_bridge_jtag bridge (
	.clk(clk),
	.reset_n(reset_n),
	.d(jtag_d),
	.q(jtag_q),
	.req(jtag_req),
	.wr(jtag_wr),
	.ack(jtag_ack)
);


endmodule

