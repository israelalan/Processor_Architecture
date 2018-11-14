module control(alu_op,opcode,clk,carry,reset,reg_wrt,re,wr,Mux1,Mux2,branch,pc_sel,im_select,funct7);
	input clk,carry,reset;
	input [6:0] opcode,funct7;
	output reg[6:0]alu_op;
	output reg reg_wrt,re,wr,Mux2,branch,pc_sel,im_select;
	output reg Mux1;
	reg [1:0]pstate;
	parameter s0 = 2'b00,s1 = 2'b01,s2 = 2'b10;
	initial
	begin
		pstate = s0;
	end
	always @(posedge clk)begin
	case(pstate)
	s0:begin
	$display("I am in state S0");
	reg_wrt<=1'b0;
	re<=1'b0;
	wr<=1'b0;
	Mux1<=1'b1;
	Mux2<=1'b1;
	alu_op<=7'bxxxxxxx;
	branch<=1'b0;
	pc_sel<=1'b1;
	im_select<=1'b1;
	pstate<=s1;
	end
	s1:begin // ADD
	$display("I am in state S1");
	case(opcode)
	7'b0000000:begin
	alu_op<=7'b0;
	reg_wrt<=1'b1;
	re<=1'b0;
	wr<=1'b0;
	Mux1<=1'b0;
	Mux2<=1'b0;
	branch<=1'b0;
	pc_sel<=1'b0;
	im_select<=1'b1;
	$display("I am in state S1 00000000");
	pstate<=s0;
	end
	7'b0110011:begin
		case(funct7)
		7'b0000001:begin //MUL
		alu_op<=7'b0000001;
		reg_wrt<=1'b1;
		re<=1'b0;
		wr<=1'b0;
		Mux1<=1'b0;
		Mux2<=1'b0;
		branch<=1'b0;
		pc_sel<=1'b0;
		im_select<=1'b1;
		$display("I am in state S1 00000001");
		pstate<=s0;
		end
		7'b0100000:begin// SUB
		alu_op<=7'b0100000;    
		reg_wrt<=1'b1;
		re<=1'b0;
		wr<=1'b0;
		Mux1<=2'b0;
		Mux2<=1'b0;
		branch<=1'b0;
		pc_sel<=1'b0;
		im_select<=1'b1;
		$display("I am in state S1 01000000");
		pstate<=s0;
		end
		endcase
	end
	7'b0000011:begin	//LOAD
	$display("I am in state-1 0000011");
	alu_op=7'b0;
	reg_wrt<=1'b1;
	re=1'b1;
	wr<=1'b0;
	Mux1<=2'b1;
	Mux2<=1'b1;
	branch<=1'b0;
	pc_sel<=1'b0;
	im_select<=1'b1;
	
	pstate=s0;
	end
	7'b0100011:begin/*STORE*/
	alu_op<=7'b0;
	reg_wrt<=1'b0;
	re<=1'b0;
	wr<=1'b1;
	Mux1<=2'b1;
	Mux2<=1'b1;
	branch<=1'b0;
	pc_sel<=1'b0;
	im_select<=1'b1;
	$display("I am in state S1 00100011");
	pstate<=s0;
	end
	7'b1100011:begin /*BEQ  */
	alu_op<=7'b0100000;
	reg_wrt<=1'b0;
	re<=1'b0;
	wr<=1'b0;
	Mux1<=2'b0;
	Mux2<=1'b0;
	branch<=1'b1;
	pc_sel<=1'b0;
	im_select<=1'b1;
	$display("I am in state S1 011000011");
	pstate<=s0;
	end
	endcase
	end
	
//	s2:begin	/*LOAD*/
/*	alu_op<=7'bx;
	reg_wrt<=1'b1;
	re<=1'b1;
	wr<=1'b0;
	Mux1<=2'bx;
	Mux2<=1'bx;
	branch<=1'bx;
	pc_sel<=1'b1;
	im_select<=1'bx;
	pstate<=s1;
	end 
*/

	endcase
	end
	

endmodule