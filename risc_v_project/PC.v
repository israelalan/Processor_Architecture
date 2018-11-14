module PC(in,clk,out,pc_sel,reset);
	input [15:0]in;
	input clk,reset,pc_sel;
	output reg[15:0]out;
	initial
		begin
			out = 0;
		end
	always @(posedge clk)begin
		if(reset==1)
			out <= 16'bx;
		else if(pc_sel==1)
			out <= in+16'b0000_0000_0000_0001;
		else if(pc_sel==0)
			out <= in;
	$display("PC = %d",out);
	end
endmodule
