`include "../include/define.svh"
module controller#(
	 parameter AW = 32
	,parameter DW = 32	
)(
	 input 	logic [7-1:0]	opcode		
	,input	logic [3-1:0]	func3		
	,input	logic [7-1:0]	func7		

	,input 	logic 		is_r_type
	,input 	logic 		is_i_type
	,input 	logic 		is_s_type
	,input 	logic 		is_b_type
	,input 	logic 		is_u_type
	,input 	logic 		is_j_type
	
	,input	logic		is_int_calc
	,input	logic		is_branch
	,input	logic		is_mem_load
	,input	logic		is_mem_store
	,input	logic		is_mem_access
	,input	logic		is_float_calc
	,input	logic		is_system

	,output	logic [1:0]	rd_data_sel	
	,output	logic 		mem_en		
	,output logic [4-1:0]	alu_sel		
	,output logic		rf_en		
	,output logic		rs1_pc_sel	
	,output logic		rs2_imm_sel	
);
	
	// TODO add always_comb logic here
	assign rd_data_sel = 2'h1; // test addi first
	assign mem_en = 'h0;
	assign rf_en = 'h1; // test addi first
	
	// rs1_pc_sel control	
	assign rs1_pc_sel = 'h1; // test addi first
	// rs2_imm_sel control
	assign rs2_imm_sel = is_r_type ? 'h1 : 'h0;
	/*
	// TODO opt this control
	assign rs2_imm_sel = (opcode == 7'b0110011) ? 'h1 : // R 
			     (opcode == 7'b0010011 || opcode == 7'b0000011) ? 'h0 : 'h0; // I	
	*/

	// ALU control
	
	always_comb begin
		if(is_b_type || opcode[6:2] == `OPCODE_AUIPC /*alupc*/)
		   	alu_sel = `ALU_ADD;
		else if(is_r_type)begin //TODO opt the decode logic by alu_sel
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
		end else if(is_i_type)begin
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
			alu_sel = `ALU_NONE;
		end
	end
	/*	
	always_comb begin
		if(opcode == 7'b0010111 /*auipc*//* || 
		   opcode == 7'b1100011 /*branch*/ /*)
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
	*/
endmodule
