module datapath(alu_op,opcode,clk,carry,sel1,sel2,re,wr,reg_wrt,reset,pc_sel,im_select,branch,funct7);
	input clk;
	output carry;
	input sel1;
	input sel2,re,wr;
	input reg_wrt;
	input reset;
	output [6:0]opcode;
	input [6:0]alu_op;
	input im_select;
	input branch,pc_sel;
	reg x;
	wire [15:0] next_alu_out;
	reg [15:0] gane,jump_add;
	wire [11:0] jump;
	and(sel3,branch,~zero);

	wire [15:0]out;
	wire [15:0]pc_out;
	wire [11:0] iformat;
	wire [4:0] addA,addB,write_add;
	wire [15:0]data_out;
	wire [15:0]result;
	wire [15:0]regData,aluMux;
	wire [15:0] dataA,dataB,xtended,out2,latchout;
	wire [1:0] sel;
	wire [15:0] op3;
	wire [4:0] out1;
	input [6:0] funct7;
	wire [2:0]funct3;
	wire [11:0] immediate_addr;


	PC programcounter(op3,clk,pc_out,pc_sel,reset);
	instruction_fetch im(pc_out,clk,pc_sel,opcode,jump,addA,addB,write_add,funct3,funct7,immediate_addr,iformat);
	
	Register regfile(reg_wrt,addA,clk,addB,write_add,regData,dataA,dataB,pc_sel);
	sign xtend(immediate_addr,xtended);
	latch latch1(xtended,latchout,clk);
	
	Mux multi2(dataB,latchout,sel1,out2);
	ALU alux(clk,dataA,out2,alu_op,result,zero);
	data_fetch datamemory(result,clk,dataB,data_out,re,wr);
	Mux multi3(result,data_out,sel2,regData);
	assign next_alu_out = latchout + pc_out;
	always@(*)
	begin
		if(branch==1)
		begin
			jump_add = gane;		 // behave similar to a latch
		end
	else
		begin
			gane = {pc_out[15:12],iformat};
		end
	end

	Mux multi5(pc_out,jump_add,sel3,op3);
	
endmodule
