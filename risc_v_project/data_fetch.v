module data_fetch(input [15:0]address,input clk,input [15:0]data_in,output reg [15:0]data_out,input re,input wr);

	reg [15:0] data_mem[0:65535];

	integer i;



	initial begin
	for(i=0;i<1000;i=i+1)

				data_mem[i]=0;

	data_mem[0] = 16'b0000_0000_0000_0001;
	data_mem[1] = 16'b0000_0000_0000_1000;
	end
	reg [15:0]gane1;



	always@(*)

	begin
		$display("re= %d",re);

		if(wr)

		begin

				data_mem[address] = data_in;

		end
		if(re)

		begin
			data_out = data_mem[address]; 

		end

	end



endmodule