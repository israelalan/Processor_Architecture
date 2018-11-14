module Mux(a,b,sel,c);
	input [15:0] a,b;
	input sel;
	output reg [15:0]c;
	always @(*)begin
	if(sel==1'b0)
	c = a;
	else if(sel==1'b1)
	c = b;
	end
endmodule
