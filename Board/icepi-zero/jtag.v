`include "uart_tx.v"

module top (
	// input hardware clock (25 MHz)
	input clk_i, 
	// UART lines
	output txd,
	output led_red,
	output led_green,
	output led_blue
);

	wire jtck,jtdi,jshift,jupdate,jrstn,jce1,jce2,jrti1,jtri2,jtdo1,jtdo2;

    JTAGG u_jtagg(
        .JTCK(jtck),
        .JTDI(jtdi),
        .JSHIFT(jshift),
        .JUPDATE(jupdate),
        .JRSTN(jrstn),
        .JCE1(jce1),
        .JCE2(jce2),
        .JRTI1(jrti1),
        .JRTI2(jrti2),
        .JTDO1(jtdo1),
        .JTDO2(jtdo2)
    );

	reg [1:0] jce_d;	// Detect rising edges of jce signals to create distinct capture signals for ER1 and ER2
	// (FIXME - there's no guarantee the JTAG SM will actually pass through the Capture state.  Perhaps we should
	// imitate Tom Verbeure's Intel JTAG example and include our own JTAG FSM to generate Capture signals?)
	
    always @(posedge jtck) begin
		jce_d <= {jce2,jce1};
	end
	wire [1:0] capture;
	wire [1:0] update;
	reg select;
	assign capture[1] = jce2 && !jce_d[1];
	assign capture[0] = jce1 && !jce_d[0];

	// Record which register is being accessed, and filter jupdate accordingly.
	always @(posedge jtck) begin
		if(jce2 && jshift)
			select<=1'b1;
		if(jce1 && jshift)
			select<=1'b0;
	end
	assign update[1] = jupdate & select;
	assign update[0] = jupdate & !select;	


	// Create a pair of registers to be accessed over the JTAG chain

	// First register, 8 bits long...
	
	wire [7:0] shift_next;
	reg [7:0] shift;
	assign jtdo1 = shift[0];

	reg [7:0] d;
	reg [7:0] q;

	always @(*) shift_next = {jtdi,shift[7:1]};

    always @(posedge jtck) begin
		if(capture[0]) begin
			shift<=d;
			d<=d+1'b1;
		end
		
		if(jshift)
			shift<=shift_next;
	end

	always @(posedge jtck) begin	
		if(update[0])
				q<=shift_next;
	end	


	// Second register, only 3 bits long...
	
	wire [2:0] shift2_next;
	reg [2:0] shift2;
	assign jtdo2 = shift2[0];

	reg [2:0] d2;
	reg [2:0] q2;

	always @(*) shift2_next = {jtdi,shift2[2:1]};
	
    always @(posedge jtck) begin
		if(capture[1]) begin
			shift2<=d2;
			d2<=d2+1'b1;
		end
		
		if(jshift)
			shift2<=shift2_next;
	end
	
	always @(posedge jtck) begin
		if(update[1])
				q2<=shift2_next;
	end
	
	// Finally, make the results visible...

    assign led_red = q[0]; // dr_shadow[0];
    assign led_green = q[1];//dr_shadow[1];
    assign led_blue = q2[0];//dr_shadow[2];

endmodule
