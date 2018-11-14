task data_mem_update;
		input [1:0] tag;

		input [3:0] index;

		input [1:0] offset;

		input [34:0] data_block;
		
		data_mem[tag*64+index*4] = data_block[31:0];

		data_mem[tag*64+index*4] = data_block[7:0];
		data_mem[tag*64+index*4+1] = data_block[15:8];
		data_mem[tag*64+index*4+2] = data_block[23:16];
		data_mem[tag*64+index*4+3] = data_block[31:24];

endtask


task data_mem_read;

		input [1:0] tag;

		input [3:0] index;

		input [1:0] offset;

		output [34:0] data_block;

		output [7:0] data_out;

		begin

		data_out = data_mem[tag*64+index*4+offset];



		data_block[7:0] = data_mem[tag*64+index*4];

		data_block[15:8] = data_mem[tag*64+index*4+1];

		data_block[23:16] = data_mem[tag*64+index*4+2];

		data_block[31:24] = data_mem[tag*64+index*4+3];

		data_block[33:32] = tag;

		data_block[34] = 1;

		end

	endtask



	task data_mem_write;

		input [7:0]address;

		input [7:0]data;

		data_mem[address] = data; 

	endtask