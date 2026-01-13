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
	,input	logic		is_jal
	,input	logic		is_jalr
	,input	logic		is_auipc
	,input	logic		is_lui

	,output	logic [1:0]	rd_data_sel	
	,output	logic 		mem_en		
	,output logic [4-1:0]	alu_sel		
	,output logic		rf_en		
	,output logic		rs1_pc_sel	
	,output logic		rs2_imm_sel	
);
	// rf write control
	assign rf_en = (is_r_type || is_i_type /*include jalr*/ || is_u_type || is_jal ) ? 'h1 : 'h0; 
	
	// rs1_pc_sel control	
	assign rs1_pc_sel = (is_b_type || is_jal || is_auipc) ? 'h0 : 'h1;
	
	// rs2_imm_sel control
	assign rs2_imm_sel = is_r_type ? 'h1 : 'h0;
	/*assign rs2_imm_sel = (opcode == 7'b0110011) ? 'h1 : // R 
			     (opcode == 7'b0010011 || opcode == 7'b0000011) ? 'h0 : 'h0; // I */

	// alu control
	always_comb begin
		if(is_lui)
			alu_sel = `ALU_LUI;	
		else if(is_b_type || is_jal || is_jalr || is_auipc)
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
	
	// TODO add always_comb logic here
	//assign rd_data_sel = 2'h1; // test addi first
	always_comb begin
		if(is_jal || is_jalr) // note jalr is I type 
			rd_data_sel = `RD_PC;
		else if(is_mem_load) // note load is I type
			rd_data_sel = `RD_MEM;
		else if(is_r_type || is_i_type || is_u_type)
			rd_data_sel = `RD_RES;
		else 
			rd_data_sel = `RD_NONE;
	end

	assign mem_en = 'h0;




endmodule
