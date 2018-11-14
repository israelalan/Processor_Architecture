module sign(a,b);
	input [11:0]a;
	output reg[15:0]b;
	always @(a or b)begin
	if(a[11]==1)
	begin
		b = {5'b00000,a[10:0]};
		b = ~b;
		b = b +16'b0000_0000_0000_0001;
	end
	else
	b = {5'b00000,a[10:0]};
	end
endmodule
