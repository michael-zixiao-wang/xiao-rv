`include "../include/define.svh"
module cpu#(
	 parameter AW = 32
	,parameter DW = 32
	,parameter string INST_FILE = "calc_itype.txt"
)(	
	 input	logic		clk
	,input	logic 		rst

);
	logic		pc_sel;
	logic [AW-1:0]	pc_next;
	assign pc_next = res_data;
	logic [AW-1:0]	pc;
	pc#(
		 .AW		(AW		)
		,.DW		(DW		)
	)u_pc(
		 .clk		(clk		)
		,.rst		(rst		)
		,.pc_sel	(pc_sel		)
		,.pc_next	(pc_next	)
		,.pc		(pc		)
	);	
	
	logic [DW-1:0]	instr;
	inst_rom#(
		 .AW		(AW		)
		,.DW		(DW		)
		,.FILE		(INST_FILE	)	
	)u_inst_rom(
		 .addr		(pc		)
		,.instr		(instr		)	
	);
	
	logic [DW-1:0]	instr_exp; // standerd instruction format for compressed instructions and other instruction 
	expander#(
		 .AW		(AW		)
		,.DW		(DW		)	
	)u_expander(
		 .instr		(instr		)
 		,.instr_exp	(instr_exp	)		 
	);


	logic [7-1:0]	opcode;
	logic [3-1:0]	func3;
	logic [7-1:0] 	func7;
	logic [5-1:0]	rd_addr;
	logic [5-1:0]	rs1_addr;
	logic [5-1:0]	rs2_addr;

	logic 	is_r_type;
	logic 	is_i_type;
	logic 	is_s_type;
	logic 	is_b_type;
	logic 	is_u_type;
	logic 	is_j_type;
			  
	logic	is_int_calc;
	logic	is_branch;
	logic 	is_mem_load;
	logic	is_mem_store;
	logic	is_mem_access;
	logic 	is_float_calc;
	logic 	is_system;
	logic	is_jal;
	logic	is_jalr;
	logic	is_auipc;
	logic	is_lui;

	decoder#(
		 .AW		(AW		)
		,.DW		(DW		)	
	)u_decoder(
		 .instr 	(instr_exp	)
		,.opcode	(opcode		)
		,.func3		(func3		)
		,.func7		(func7		)	
		,.rd_addr	(rd_addr	)
		,.rs1_addr	(rs1_addr	)
		,.rs2_addr	(rs2_addr	)

		,.is_r_type	(is_r_type	)
		,.is_i_type     (is_i_type	)
		,.is_s_type     (is_s_type	)
		,.is_b_type     (is_b_type	)
		,.is_u_type     (is_u_type	)
		,.is_j_type     (is_j_type	)
			                                          
		,.is_int_calc  	(is_int_calc	)
		,.is_branch   	(is_branch	)
		,.is_mem_load  	(is_mem_load	)
		,.is_mem_store  (is_mem_store	)
		,.is_mem_access (is_mem_access	)
		,.is_float_calc	(is_float_calc	)
		,.is_system    	(is_system	)
		,.is_jal	(is_jal		)
		,.is_jalr	(is_jalr	)
		,.is_auipc	(is_auipc	)
		,.is_lui	(is_lui		)
	);
	
	logic [DW-1:0]	imm;
	extender#(
		 .AW		(AW		)
		,.DW		(DW		)	
	)u_extender(
		 .instr		(instr		)
		//,.opcode(opcode)
		,.is_i_type	(is_i_type	)
		,.is_s_type	(is_s_type	)
		,.is_b_type	(is_b_type	)
		,.is_u_type	(is_u_type	)
		,.is_j_type	(is_j_type	)
		,.imm		(imm		)	
	);

	logic		rf_wr_en;
	logic [DW-1:0]	rd_data;
	logic [DW-1:0]	rs1_data;
	logic [DW-1:0]	rs2_data;
	rf#(
		 .AW		(AW		)
		,.DW		(DW		)
	)u_rf(
		 .clk		(clk		)
		,.rst		(rst		)
		,.wr_en		(rf_wr_en	)
		,.rd_addr	(rd_addr	)
		,.rd_data	(rd_data	)
		,.rs1_addr	(rs1_addr	)
		,.rs1_data	(rs1_data	)
		,.rs2_addr	(rs2_addr	)
		,.rs2_data	(rs2_data	)	
	);
	
	logic	[1:0]	rd_data_sel;
	logic		mem_en;
	logic	[4-1:0]	alu_sel;
	logic		rs1_pc_sel;
	logic		rs2_imm_sel;
	controller#(
		 .AW		(AW		)
		,.DW		(DW		)
	)u_controller(
		 .opcode 	(opcode		)
		,.func3		(func3		)
		,.func7		(func7		)
		
		,.is_r_type	(is_r_type	)
		,.is_i_type     (is_i_type	)
		,.is_s_type     (is_s_type	)
		,.is_b_type     (is_b_type	)
		,.is_u_type     (is_u_type	)
		,.is_j_type     (is_j_type	)
			                                          
		,.is_int_calc  	(is_int_calc	)
		,.is_branch   	(is_branch	)
		,.is_mem_load  	(is_mem_load	)
		,.is_mem_store  (is_mem_store	)
		,.is_mem_access (is_mem_access	)
		,.is_float_calc	(is_float_calc	)
		,.is_system    	(is_system	)
		,.is_jal	(is_jal		)
		,.is_jalr	(is_jalr	)
		,.is_auipc	(is_auipc	)
		,.is_lui	(is_lui		)

		,.rd_data_sel	(rd_data_sel	)
		,.mem_en	(mem_en		)
		,.alu_sel	(alu_sel	)
		,.rf_en		(rf_wr_en	)
		,.rs1_pc_sel	(rs1_pc_sel	)
		,.rs2_imm_sel	(rs2_imm_sel	)		
	);
	
	logic [DW-1:0]	op1_data;
	logic [DW-1:0]	op2_data;

	assign op1_data = rs1_pc_sel  ? rs1_data : pc;
	assign op2_data = rs2_imm_sel ? rs2_data : imm;
	
	logic [DW-1:0]	res_data;
	alu#(
		 .DW		(DW		)
		,.AW		(AW		)	
	)u_alu(
		 .alu_sel	(alu_sel	)
		,.op1		(op1_data	)
		,.op2		(op2_data	)
		,.res		(res_data	)	
	);
	
	//logic	pc_sel;
	brancher#(
		 .AW		(AW		)
		,.DW		(DW		)	
	)u_brancher(
		 .is_b_type	(is_b_type	)
		,.is_jal	(is_jal		)
		,.is_jalr	(is_jalr	)
		,.func3		(func3		)
		,.rs1_data	(rs1_data	)
		,.rs2_data	(rs2_data	)
		,.pc_sel 	(pc_sel		)	
	);
	
	logic [DW-1:0]	mem_data;
	data_ram#(
		 .RAM_NUM	(1000_0000	)
		,.AW		(AW		)
		,.DW		(DW		)	
	)u_data_ram(
		 .clk		(clk		)
		,.rst		(rst		)
		,.wr_en		(mem_en		)
		,.addr		(res_data	)
		,.data_in	(rs2_data	)
		,.data_out	(mem_data	)	
	);

	assign rd_data = (rd_data_sel == `RD_NONE	) ? 'h0:
			 (rd_data_sel == `RD_RES	) ? res_data:
			 (rd_data_sel == `RD_PC		) ? pc :
			 (rd_data_sel == `RD_MEM	) ? mem_data: 'h0;

endmodule
