`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIITB
// Engineer: Alan
// Module Name: processor
//////////////////////////////////////////////////////////////////////////////////
module processor(clk,reset,Anode_Activate,LED_out);

input clk,reset;
output reg [3:0] Anode_Activate;
output reg [6:0] LED_out;

reg [7:0] AD_H; // Bus lines MSB
reg [7:0] AD_L; // LSB

reg [7:0] A; //Accumulator
reg [7:0] B,C,D,E,H,L; //user registers
reg [15:0] PC; //program counter
reg [7:0] IR; //instruction register
reg [7:0] W; //Temporary Register
reg [7:0] X; //Temporary Register

reg s0,s1; //status signals
reg ale; //Address Latch Enable
reg rd; //read enable
reg wr; //write enable
reg [7:0] mem [0:63];

reg reg_sel; //to select temp regs
reg finish_read; //for more than one Read machine cycle
reg Z; //zero flag
//reg read_state2;

reg hlt_wait; //Halt state transfer to Seven Segment Display

//Seven Segment Display registers
reg [3:0] LED_BCD=0;
reg [1:0] LED_activating_counter;
reg [19:0] refresh_counter;

initial 
	begin 
		s0 = 1;
		s1 = 1;
		PC = 16'b0;
		B = 8'b0000_0000;
		D = 8'b0000_0101;
		
		C = 8'b1111_0000;
		H = 8'b0;
		
	    A = 8'b1010_0101;
	    E = 8'b0;
	    
		ale = 1;
		Z = 0;
		
		LED_BCD=0;
		refresh_counter = 0;
		LED_activating_counter=0;
        
        //5 Factorial
        mem[32]= 8'b0000_0100; //memory
        mem[0] = 8'b0011_1010; // lda
        mem[1] = 8'b0010_0000; // AD_L
        mem[2] = 8'b0000_0000; // AD_H
        mem[3] = 8'b0100_0111; // MOV B,A
        mem[4] = 8'b0100_1111; // MOV C,A
        mem[5] = 8'b0000_0101; // DCR B
        mem[6] = 8'b0101_0000; // MOV D,B
        mem[7] = 8'b0011_1110; // MVI A,00H
        mem[8] = 8'b0000_0000; // 00H
        mem[9] = 8'b1000_0001; // ADD C
        mem[10] = 8'b0001_0101; // DCR D
        mem[11] = 8'b1100_0010; // JNZ 9
        mem[12] = 8'b0000_1001; // AD_L
        mem[13] = 8'b0000_0000; // AD_H
        mem[14] = 8'b0100_1111; // MOV C,A
        mem[15] = 8'b0000_0101; // DCR B
        mem[16] = 8'b1100_0010; // JNZ 6
        mem[17] = 8'b0000_0110; // AD_L
        mem[18] = 8'b0000_0000; // AD_H
        mem[19] = 8'b0111_0110; //HLT
	end

always @(posedge clk) begin  //Opcode Fetch Machine Cycle
	if(reset) begin
	PC=16'b0; ale=1;
	end
	if(s0 && s1) begin
	
        if(ale == 1) begin //T1 state
            AD_H = PC[15:8];
            AD_L = PC[7:0];
            ale = 0;
            rd = 1;
            wr = 0;
            PC = PC+1;
            end
        else if(rd) begin //T2 state 
            IR = mem[{AD_H,AD_L}];
            rd = 0;
            wr = 0;
            end
        //Halt instruction wait states
        else if(hlt_wait) begin
            s0=0;s1=0;hlt_wait=0;
            end
        //Decoding 
        else if(~rd) begin //T3 state
            case (IR[7:6])
                2'b00: begin
                 case (IR[2:0])
                     3'b101: begin //DCR
                         case(IR[5:3])
                             3'b000: begin B=B-1;
                                 if (B==0) Z=1;
                                 end
                             3'b001: begin C=C-1;
                                 if (C==0) Z=1;
                                 end
                             3'b010: begin D=D-1;
                                 if (D==0) Z=1;
                                end
                             3'b011: begin E=E-1;
                                 if (E==0) Z=1;
                                 end
                             3'b100: begin H=H-1;
                                 if (H==0) Z=1;
                                 end
                             3'b101: begin L=L-1;
                                 if (B==0) Z=1;
                                 end
                             /*3'b110: begin B=B-1;
                                 if (M==0) Z=1;
                                 end */
                             3'b111: begin A=A-1;
                                 if (A==0) Z=1;
                                 end
                         endcase 
                         ale = 1; 
                         end
                     3'b110: begin //MVI 
                        //rd = 1;
                        ale = 1;
                        s0=0;
                        s1=1;
                        end
                 endcase
                 if(IR[5:0] == 6'b111010 || IR[5:0] == 6'b110010) begin //LDA STA 
                     ale = 1;
                     s0=0;
                     s1=1;
                 end
                end
                
                2'b01: begin //ONLY MOV BEGIN
                    case(IR[5:3]) 
                        3'b000:
                            case(IR[2:0]) 
                                3'b000: B=B;
                                3'b001: B=C;
                                3'b010: B=D;
                                3'b011: B=E;
                                3'b100: B=H;
                                3'b101: B=L;
                                //3'b110: B=;
                                3'b111: B=A;
                            endcase
                        3'b001:
                            case(IR[2:0]) 
                                3'b000: C=B;
                                3'b001: C=C;
                                3'b010: C=D;
                                3'b011: C=E;
                                3'b100: C=H;
                                3'b101: C=L;
                                //3'b110: B=;
                                3'b111: C=A;
                            endcase						
                        3'b010:
                            case(IR[2:0])
                                3'b000: D=B;
                                3'b001: D=C;
                                3'b010: D=D;
                                3'b011: D=E;
                                3'b100: D=H;
                                3'b101: D=L;
                                //3'b110: B=;
                                3'b111: D=A;
                            endcase
                        3'b011:
                            case(IR[2:0])
                                3'b000: E=B;
                                3'b001: E=C;
                                3'b010: E=D;
                                3'b011: E=E;
                                3'b100: E=H;
                                3'b101: E=L;
                                //3'b110: B=;
                                3'b111: E=A;
                            endcase
                        3'b100:
                            case(IR[2:0])
                                3'b000: H=B;
                                3'b001: H=C;
                                3'b010: H=D;
                                3'b011: H=E;
                                3'b100: H=H;
                                3'b101: H=L;
                                //3'b110: B=;
                                3'b111: H=A;
                            endcase
                        3'b101:
                            case(IR[2:0])
                                3'b000: L=B;
                                3'b001: L=C;
                                3'b010: L=D;
                                3'b011: L=E;
                                3'b100: L=H;
                                3'b101: L=L;
                                //3'b110: B=;
                                3'b111: L=A;
                            endcase
                        //3'b110: 
                            /*case(IR[2:0])
                                3'b000: M=B;
                                3'b001: M=C;
                                3'b010: M=D;
                                3'b011: M=E;
                                3'b100: M=H;
                                3'b101: M=L;
                                //3'b110: B=;
                                3'b111: M=A;
                            endcase*/
                        3'b111:
                            case(IR[2:0])
                                3'b000: A=B;
                                3'b001: A=C;
                                3'b010: A=D;
                                3'b011: A=E;
                                3'b100: A=H;
                                3'b101: A=L;
                                //3'b110: B=;
                                3'b111: A=A;
                            endcase
                        endcase
                        ale = 1;
                        
                        if (IR[5:0]==6'b110110) begin //HLT instruction
                           hlt_wait=1;
                           ale=0;       
                        end
                end //MOV and HLT END
                
                2'b10: begin //ADD instruction
                 if(IR[5:3]==3'b000) begin
                     case(IR[2:0])
                         3'b000: A=A+B;
                         3'b001: A=A+C;
                         3'b010: A=A+D;
                         3'b011: A=A+E;
                         3'b100: A=A+H;
                         3'b101: A=A+L;
                         //3'b110: B=;
                         3'b111: A=A+A;
                     endcase
                     ale=1;
                 end
                end
                2'b11: begin //JNZ instruction
                        ale = 1;
                        s0=0;
                        s1=1;
                end
            endcase
        end //ELSE-IF END
        
        end //IF OPCODE END

//always @(posedge clk && ~s0 && s1) begin  //Memory Read Machine Cycle
	else if(~s0 && s1) begin
	
        if(ale == 1) begin //T4,T7 state
            AD_H = PC[15:8];
            AD_L = PC[7:0];
            ale = 0;
            rd = 1;
            wr = 0;
            PC = PC+1;
            end
        else if(rd) begin //T8 state 
            if(reg_sel) begin
               W = mem[{AD_H,AD_L}]; //MSB - second_fetch
               finish_read = 1;
            end
            else begin
                X = mem[{AD_H,AD_L}]; //LSB - first_fetch -- T5 state
            end
            rd = 0;
            reg_sel = 0;
            //wr = 0;
            end
       
        else if(~rd) begin //T6,T9 state
            case (IR[2:0])
                     3'b110: begin //MVI
                        case(IR[5:3])
                            3'b000: B=X;
                            3'b001: C=X;
                            3'b010: D=X;
                            3'b011: E=X;
                            3'b100: H=X;
                            3'b101: L=X;
                            //3'b110: B=B-1;
                            3'b111: A=X;
                        endcase
                        ale = 1;
                        s0=1;
                        s1=1;
                        end
            endcase
            if(IR[5:0] == 6'b111010 || IR[5:0] == 6'b110010) begin //LDA STA
                if(finish_read) begin //T9
                    ale = 1; 
                    s0 = 1;
                    s1 = 0;
                    finish_read = 0;
                end
                else begin //T6
                    ale = 1;
                    s0=0;
                    s1=1;
                    reg_sel = 1;
                    end
            end
            else if(IR[5:0] == 6'b000010) begin //JNZ
                if(~Z) begin 
                    if (finish_read) begin //T9
                        PC = ({W,X});
                        finish_read = 0;
                        ale = 1;
                        s0=1;
                        s1=1;
                    end
                    else begin //T6
                        ale = 1;
                        s0=0;
                        s1=1;
                        reg_sel = 1;
                        end  
                end    
                else if(Z) begin //T6 FAIL
                    PC = PC+1;
                    ale = 1;
                    s0=1;
                    s1=1;
                    Z = 0;
                end
            end
         end //ELSE-IF_MAIN END
        end // ELSE IF READ END
	
//always @(posedge clk && s0 && ~s1) begin  //Write-Back Machine Cycle
    else if(s0 && ~s1) begin
      
    if(ale == 1) begin //T10 state
		ale = 0;
		rd = 0;
		wr = 1;
    end
	else if(wr) begin //T11 state 
        if(IR[5:0] == 6'b111010) begin //LDA
            A = mem[{W,X}]; 
        end
        else if(IR[5:0] == 6'b110010) begin //STA
            mem[{W,X}] = A;
        end
        rd = 0;
        wr = 0;
    end
    else if(~wr) begin //T12
        ale = 1;
        s0=1;
        s1=1;
    end
    
    end //ELSE IF WRITE END
    
    //Interfacing Seven Segment Display
    else if(~s0 && ~s1) begin
        refresh_counter = refresh_counter + 1;
        LED_activating_counter = refresh_counter[11:10];
    end
    end // END ALWAYS

always @(*)
   begin
       case(LED_activating_counter)
       2'b00: begin
           Anode_Activate = 4'b0111; 
           // activate LED1 and Deactivate LED2, LED3, LED4
           LED_BCD = C/1000;
           // the first digit of the 16-bit number
             end
       2'b01: begin
           Anode_Activate = 4'b1011; 
           // activate LED2 and Deactivate LED1, LED3, LED4
           LED_BCD = (C % 1000)/100;
           // the second digit of the 16-bit number
             end
       2'b10: begin
           Anode_Activate = 4'b1101; 
           // activate LED3 and Deactivate LED2, LED1, LED4
           LED_BCD = ((C % 1000)%100)/10;
           // the third digit of the 16-bit number
               end
       2'b11: begin
           Anode_Activate = 4'b1110; 
           // activate LED4 and Deactivate LED2, LED3, LED1
           LED_BCD = ((C % 1000)%100)%10;
           // the fourth digit of the 16-bit number    
              end
       endcase
   end
   // Cathode patterns of the 7-segment LED display 
   always @(*)
   begin
       case(LED_BCD)
       4'b0000: LED_out = 7'b0000001; // "0"     
       4'b0001: LED_out = 7'b1001111; // "1" 
       4'b0010: LED_out = 7'b0010010; // "2" 
       4'b0011: LED_out = 7'b0000110; // "3" 
       4'b0100: LED_out = 7'b1001100; // "4" 
       4'b0101: LED_out = 7'b0100100; // "5" 
       4'b0110: LED_out = 7'b0100000; // "6" 
       4'b0111: LED_out = 7'b0001111; // "7" 
       4'b1000: LED_out = 7'b0000000; // "8"     
       4'b1001: LED_out = 7'b0000100; // "9" 
       default: LED_out = 7'b0000001; // "0"
       endcase
   end

endmodule
