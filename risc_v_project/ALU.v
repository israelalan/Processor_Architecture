module ALU(clk,ain,bin,alu_op,result,z);
	input clk;
	input [15:0]ain;
	input [15:0]bin;
	output reg [15:0]result;
	reg carry,temp;
	integer i;
	input [6:0]alu_op;
	reg [15:0]mul_1,temp1;
	output reg z;
	always@(*)
	begin
		
	if(alu_op==7'b0000001)
		begin
			temp1 = ain;
			result = 0;
			for(i=0;i<16;i=i+1)
			begin
				if(bin[i] == 1'b1)
				begin
					result = result + temp1;
				end
				temp1 = temp1 << 1;
			end
		end
	else if(alu_op==7'b0100000)
		begin
			{temp,result} = ain - bin;
			carry = temp;
			if(result==0)
				z=1;
			else
				z=0;
		end
	else if(alu_op==7'b0000000)
		begin
			{temp,result} = ain + bin;
			carry = temp;
			if(result==0)
				z=1;
		end
	else begin 
		result = 16'bxxxxxxx;
		carry = 0;
	end//Default
	if(result==0)
		z = 1'b1;
	else
		z = 0;
	end

endmodule

