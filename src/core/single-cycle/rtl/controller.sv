module controller#(
	parameter AW = 32,
	parameter DW = 32	
)(
	input 	logic [7-1:0]	opcode		,
	input	logic [3-1:0]	func3		,
	input	logic [7-1:0]	func7		,

	output	logic [1:0]	rd_data_sel	,
	output	logic 		mem_en		,
	output 	logic [4-1:0]	alu_sel		,
	output  logic		rf_en		,
	output 	logic		rs1_pc_sel	,
	output 	logic		rs2_imm_sel	
);

	assign rd_data_sel = 'h0;
	assign mem_en = 'h0;
	
	always_comb begin
		if(opcode == 7'b0010111 /*auipc*/ || 
		   opcode == 7'b1100011 /*branch*/ )
			alu_sel = 4'h1; // +
		else if(opcode == 7'b0110011	||
			opcode == 7'b0010011)begin
			case(func3)
				3'h0:	alu_sel = 4'h1; // +

				default: alu_sel = 4'h0; // none(alu output is zero)
			endcase
		end


	end

endmodule
