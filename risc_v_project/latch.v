module latch(in,out,clk);
	input [15:0] in;
	input clk;
	output reg[15:0] out;
	reg [15:0]memdataout;
	always @ (posedge clk)
	out<=in;
endmodule
