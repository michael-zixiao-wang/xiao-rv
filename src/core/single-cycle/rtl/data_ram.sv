module data_ram#(
	parameter RAM_NUM = 1000_0000
	parameter AW = 32,
	parameter DW = 32
)(
	input 	logic		clk,
	input	logic		rst, // not used
	
	input	logic		wr_en,
	input	logic [AW-1:0]	addr,
	input	logic [DW-1:0]	data_in,
	output	logic [DW-1:0]	data_out
);
	logic [DW-1:0] ram [RAM_NUM-1:0];

	always_ff@(posedge clk,posedge rst)begin
		if(rst) 
			for(int i = 0;i < RAM_NUM;i++) ram[i] <= 'h0;
		else
	       	if(wr_en)
			ram[addr] <= data_in;
	end

	always_comb begin
		data_out = ram[addr];
	end

endmodule
