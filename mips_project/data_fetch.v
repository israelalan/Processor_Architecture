module data_fetch(input [7:0] address,input clk);

	`include "data_cache.v"
	`include "data_mem.v"	

	reg [7:0] data_mem[0:255];
	reg [34:0] data_cache [0:15];
	integer i;

	// import cache module

	// import instruction module

	initial begin
	for(i=0;i<16;i=i+1)
				data_cache[i]=0;
	end

	
	reg [1:0] tag;

	reg [3:0] index;

	reg [1:0] offset;

	reg [34:0] data_block;

	reg [15:0] data_out;
	reg hit;
	reg valid;
	
	always@(posedge clk)
	begin
	tag=  address[7:6];

	index = address[5:2];

	offset = address[1:0];
	
	data_cache_valid(tag,index,valid);
	data_cache_hit(tag,index,hit);
	if(hit==1)

		begin

			cache_data_read(tag,index,offset,data_block,data_out);

		end

	else

		begin
			if(valid == 1)
			begin
				cache_data_read(tag,index,offset,data_block,data_out);
				data_mem_update(tag,index,offset,data_block)
			end
			data_mem_read(tag,index,offset,data_block,data_out);
			data_cache_update(index,data_block);	
		end

	end

endmodule