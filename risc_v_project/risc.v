module risc(clk,reset);
	input clk,reset;
	wire [6:0] opcode;
	wire [6:0] funct7;
	wire [6:0] alu_op;
	wire [2:0] alu_sel;
	reg [15:0] in;
	wire [15:0] out;
	reg pc_s, im_sel;
	wire [15:0] pc_out;
	wire [11:0] jump;
	wire Mux2;
	wire [4:0] addA;
	wire sel2;
	wire [4:0] addB;
	wire [4:0] write_add;
	wire [3:0] iformat;
	wire sel6;
	wire sel3,sel5;
	reg crry;
	
	wire carry,reset,reg_wrt,re,wr,Mux1,Mux3,branch,im_wrt,sel1;
	control control_path(alu_op,opcode,clk,crry,reset,reg_wrt,re,wr,sel1,sel2,branch,pc_sel,im_select,funct7);
	datapath data_path(alu_op,opcode,clk,carry,sel1,sel2,re,wr,reg_wrt,reset,pc_sel,im_select,branch,funct7);

endmodule