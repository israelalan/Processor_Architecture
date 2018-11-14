task cache_hit;

		input [1:0]tag;

		input [3:0]index;

		output hit;
		begin

		if(cache[index][66]==1 && cache[index][65:64] == tag)

			begin

				hit = 1'b1;

			end

		else

			begin

				hit = 1'b0;

			end
		end

	endtask

	

	task cache_instruction_read;

		input [1:0] tag;

		input [3:0] index;
		input [1:0] offset;
		output [15:0] instruction_out;
		begin

			if(offset == 2'b00)
				instruction_out = cache[index][15:0];
			else if(offset == 2'b01)
				instruction_out = cache[index][31:16];
			else if(offset == 2'b10)
				instruction_out = cache[index][47:32];
			else if(offset == 2'b11)
				instruction_out = cache[index][63:48];
			end
endtask



	task cache_update;

		input [3:0] index;

		input [66:0] instruction_block;

		cache[index] = instruction_block;

	endtask