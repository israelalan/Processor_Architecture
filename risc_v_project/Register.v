module Register(reg_wrt,readA,clk,readB,dest,data,readA_out,readB_out,pc_sel);
	input pc_sel;
	input reg_wrt;
	input [4:0]readA,readB,dest;
	input [15:0]data;
	input clk;
	reg [15:0] Register [0:31];
	reg [4:0] gane;
	initial begin
	Register[0]=0;
	Register[1]=2;
	Register[2]=2;
	Register[3]=3;
	Register[4]=4;
	Register[5]=5;
	Register[6]=1;
	Register[7]=14;
	end
	output reg [15:0]readA_out,readB_out;
	always @(posedge clk)begin
	readA_out <= Register[readA];
	readB_out <= Register[readB];
	if(reg_wrt==1)
		begin
			Register[gane]=data;
			$display("dat inreg_file = %d",data);
		end
	else
		begin
			gane = dest;
		end
	end

endmodule

