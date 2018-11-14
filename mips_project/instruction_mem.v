task instruction_mem_read;

		input [1:0] tag;

		input [3:0] index;

		input [1:0] offset;

		output [66:0] instruction_block;

		output [15:0] instruction_out;

		begin

		instruction_out = instruction_mem[tag*64+index*4+offset];



		instruction_block[15:0] = instruction_mem[tag*64+index*4];

		instruction_block[31:16] = instruction_mem[tag*64+index*4+1];

		instruction_block[47:32] = instruction_mem[tag*64+index*4+2];

		instruction_block[63:48] = instruction_mem[tag*64+index*4+3];

		instruction_block[65:64] = tag;

		instruction_block[66] = 1;

		end

	endtask



	task instruction_mem_write;

		input [7:0]address;

		input [15:0]instruction;

		instruction_mem[address] = instruction; 

	endtask