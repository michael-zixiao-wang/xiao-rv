module rf#(
	parameter AW = 32,
	parameter DW = 32
)(
	input logic 		clk	,
	input logic 		rst	,
	input logic		wr_en	,
	input logic [5-1:0]	rd_addr ,
	input logic [DW-1:0]	rd_data ,
	input logic [5-1:0]	rs1_addr,
	output logic [DW-1:0]	rs1_data,
	input logic [5-1:0]	rs2_addr,
	output logic [DW-1:0]	rs2_data
);

	logic [DW-1:0]	regs [32-1:0];
	always_ff @(posedge clk,posedge rst)begin
		if(rst)begin
			for(int i = 0;i <= 32-1;i++)begin
				regs[i] <= 'h0;
			end
		end else if(wr_en)
			regs[rd_addr] <= rd_data;
	end

	always_comb begin
		if(rs1_addr == 'h0)
			rs1_data = 'h0;
		//else if(wr_en && (rs1_addr == rd_addr)) // to: not generate comb logic
		//	rs1_data = rd_data;
		else 
			rs1_data = regs[rs1_addr];
	end

	always_comb begin
		if(rs2_addr == 'h0)
			rs2_data = 'h0;
		//else if(wr_en && (rs2_addr == rd_addr))
		//	rs2_data = rd_data;
		else 
			rs2_data = regs[rs2_addr];
	end
	
endmodule
