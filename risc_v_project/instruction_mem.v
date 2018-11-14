task instruction_mem_read;



		input [15:0]address;



		output [31:0]instruction;



		instruction= instruction_mem[address]; 



	endtask







	task instruction_mem_write;



		input [15:0]address;



		input [31:0]instruction;



		instruction_mem[address] = instruction; 



	endtask