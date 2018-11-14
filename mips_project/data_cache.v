task data_cache_valid;
		input [1:0]tag;

		input [3:0]index;

		output valid;
		begin

		if(data_cache[index][34]==1)

			begin

				hit = 1'b1;

			end

		else

			begin

				hit = 1'b0;

			end
		end

	endtask


task data_cache_hit;

		input [1:0]tag;

		input [3:0]index;

		output hit;
		begin

		if(data_cache[index][34]==1 && data_cache[index][33:32] == tag)

			begin

				hit = 1'b1;

			end

		else

			begin

				hit = 1'b0;

			end
		end

	endtask

	

task cache_data_read;

		input [1:0] tag;

		input [3:0] index;
		input [1:0] offset;
		output [34:0] data_block = data_cache[index];
		output [7:0] data_out;
		begin

			if(offset == 2'b00)
				data_out = data_cache[index][7:0];
			else if(offset == 2'b01)
				data_out = data_cache[index][15:8];
			else if(offset == 2'b10)
				data_out = data_cache[index][23:16];
			else if(offset == 2'b11)
				data_out = data_cache[index][31:24];
		end
endtask



task data_cache_update;

	input [3:0] index;

	input [34:0] data_block;

	data_cache[index] = data_block;

endtask