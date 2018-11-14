module instruction_fetch(address,clk,im_select,opcode,jump,rs1,rs2,rd,funct3,funct7,immediate_addr,iformat);


input [15:0] address;
input clk;
input im_select;
output reg [6:0] opcode;
output reg [2:0] funct3;
output reg [6:0] funct7;

output reg [11:0] immediate_addr;
reg [11:0] sw_immediate;

reg [11:0] lw_immediate;
output reg [11:0] jump;
output reg [4:0] rs1,rs2,rd;

output reg [11:0] iformat;


	`include "instruction_mem.v"	



	reg [31:0] instruction_mem[0:65535];

	integer i;



	initial begin

	for(i=0;i<256;i=i+1)

				instruction_mem[i]=0;

	instruction_mem[0]<=32'b000000000000_00000_010_00001_0000011;//R1 = 1 			// LW R1,R0+data_loc(0);
	instruction_mem[1]<=32'b000000000001_00000_010_00010_0000011;//R2 = n			// LW R2,R0+data_loc(1);
	instruction_mem[2]<=32'b000000000000_00000_010_00011_0000011;//R3 = 1			// LW R3,R0+data_loc(0);
	
	instruction_mem[3]<=32'b0000001_00001_00010_000_00001_0110011;//R1=R2*R1		//	MUL R1,R2,R1;
	instruction_mem[4]<=32'b0100000_00011_00010_000_00010_0110011;//R2=R2-R3		//	SUB R2,R2,R3;
	instruction_mem[5]<=32'b0000000_00011_00010_000_00011_1100011;//BNE R2,R3		// BNE R2,R3,instruction_loc(3);
	instruction_mem[6]<=32'b0000000_00001_00010_000_00001_0100011;//SW R2			// SW R1,R2+data_loc(2);
	instruction_mem[7]<=32'b000000000000_00000_010_00001_0000011;//R1 = 1			// -------------------



	end



	reg [31:0] instruction_out;	

	always @(im_select)

	begin


		instruction_mem_read(address,instruction_out);



		opcode = instruction_out[6:0];

		funct3 = instruction_out[14:12];
		sw_immediate = {instruction_out[31:25],instruction_out[11:7]};
		lw_immediate = instruction_out[31:20];
		
		rs1 = instruction_out[19:15]; 
		rs2 = instruction_out[24:20];
		rd = instruction_out[11:7];
		funct7 = instruction_out[31:25];
		if(opcode==7'b0100011)
		begin
			$display("sw_immediate");
			immediate_addr = sw_immediate;
		end
		else
		begin
			$display("lw_immediate");
			immediate_addr = lw_immediate;
		end
		iformat = {instruction_out[31:25],instruction_out[11:7]};


	end

endmodule
