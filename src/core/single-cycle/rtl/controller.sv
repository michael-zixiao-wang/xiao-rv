`include "../include/define.svh"
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
	
	// TODO add always_comb logic here
	assign rd_data_sel = 2'h1; // test addi first
	assign mem_en = 'h0;
	assign rs1_pc_sel = 'h0;
	assign rs2_imm_sel = 'h1; // test addi first
	assign rf_en = 'h1; // test addi first
	
	always_comb begin
		if(opcode == 7'b0010111 /*auipc*/ || 
		   opcode == 7'b1100011 /*branch*/ )
			alu_sel = 4'h1; // +
		else if(opcode == 7'b0110011)begin //TODO opt the decode logic by alu_sel
			case(func3)
				3'h0:	alu_sel = (func7 == 7'h00) ? `ALU_ADD :            // +
						  (func7 == 7'h20) ? `ALU_SUB : `ALU_NONE; // -
				3'h4:	alu_sel = (func7 == 7'h00) ? `ALU_XOR : `ALU_NONE; // ^
				3'h6:	alu_sel = (func7 == 7'h00) ? `ALU_OR  : `ALU_NONE; // |
				3'h7:	alu_sel = (func7 == 7'h00) ? `ALU_AND : `ALU_NONE; // &
				3'h1:	alu_sel = (func7 == 7'h00) ? `ALU_SLL : `ALU_NONE; // 
				3'h5:	alu_sel = (func7 == 7'h00) ? `ALU_SRL : 
						  (func7 == 7'h20) ? `ALU_SRA : `ALU_NONE; // 
				3'h2:	alu_sel = (func7 == 7'h00) ? `ALU_SLT : `ALU_NONE; // 
				3'h3:	alu_sel = (func7 == 7'h00) ? `ALU_SLTU: `ALU_NONE; // 
				default: alu_sel = `ALU_NONE; // none(alu output is zero)
			endcase
		end else if(opcode == 7'b0010011)begin
			case(func3)
				3'h0:	alu_sel = `ALU_ADD; // +
				3'h4:	alu_sel = `ALU_XOR; // ^
				3'h6:	alu_sel = `ALU_OR ; // |
				3'h7:	alu_sel = `ALU_AND; // &
				3'h1:	alu_sel = (func7 == 7'h00) ? `ALU_SLL : `ALU_NONE; // 
				3'h5:	alu_sel = (func7 == 7'h00) ? `ALU_SRL : 
						  (func7 == 7'h20) ? `ALU_SRA : `ALU_NONE; // 
				3'h2:	alu_sel = `ALU_SLT ; // 
				3'h3:	alu_sel = `ALU_SLTU; // 
				default: alu_sel = `ALU_NONE; // none(alu output is zero)
	

			endcase
		end else begin
			alu_sel = 'h0;
		end


	end

endmodule
