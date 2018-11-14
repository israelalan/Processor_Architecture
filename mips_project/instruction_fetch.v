module instruction_fetch(input [7:0] address,input clk);

	`include "cache.v"
	`include "instruction_mem.v"	

	reg [15:0] instruction_mem[0:255];
	reg [66:0] cache [0:15];
	integer i;

	// import cache module

	// import instruction module

	initial begin
	for(i=0;i<16;i=i+1)
				cache[i]=0;
	for(i=0;i<256;i=i+1)
				instruction_mem[i]=0;
	instruction_mem[2]<=16'b0000_0000_0000_0101; 
	instruction_mem[1]<=16'b0001_0010_0011_0011; 
	instruction_mem[3]<=16'b0010_0100_0010_0011;
	instruction_mem[0]<=16'b0010_0000_0000_0101;
	instruction_mem[4]<=16'b0010_0111_0010_0011;
	instruction_mem[5]<=16'b0011_0010_0011_0010;
	instruction_mem[6]<=16'b0110_0001_0001_0011;
	instruction_mem[7]<=16'b0001_0110_0001_0011;
	instruction_mem[8]<=16'b0110_0001_0011_0001; 
	end

	
	reg [1:0] tag;

	reg [3:0] index;

	reg [1:0] offset;

	reg [66:0] instruction_block;

	reg [15:0] instruction_out;
	reg hit;
	
	always@(posedge clk)
	begin
	tag=  address[7:6];

	index = address[5:2];

	offset = address[1:0];
		
	cache_hit(tag,index,hit);
	if(hit==1)

		begin

			cache_instruction_read(tag,index,offset,instruction_out);

		end

	else

		begin

			instruction_mem_read(tag,index,offset,instruction_block,instruction_out);

			cache_update(index,instruction_block);

		end
	

	end

endmodule