module decoder#(
	 parameter AW = 32
	,parameter DW = 32	
)(
	 input 	logic [DW-1:0] instr
	
	// basic decode meta messages
	,output	logic [7-1:0] 	opcode	// to extender
	,output	logic [3-1:0] 	func3 
	,output	logic [7-1:0] 	func7	
	,output	logic [5-1:0] 	rd_addr
	,output	logic [5-1:0] 	rs1_addr
	,output	logic [5-1:0]	rs2_addr

	// to imm extender and controller
	,output logic 	is_r_type
	,output logic 	is_i_type
	,output logic 	is_s_type
	,output logic 	is_b_type
	,output logic 	is_u_type
	,output logic 	is_j_type

	// to controller
	,output logic	is_int_calc
	,output logic	is_branch
	,output logic 	is_mem_load
	,output	logic	is_mem_store
	,output logic	is_mem_access
	,output logic 	is_float_calc
	,output logic 	is_system
	
	,output logic	is_jal
	,output logic	is_jalr
	,output	logic 	is_auipc
	,output	logic	is_lui

	// general decode status
	//,output logic	illegal
	);
	
	// basic meta data
	assign opcode = instr[6:0];
	assign func3 = instr [14:12];
        assign func7 = instr [31:25];
	assign rd_addr = instr[11:7];
	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];	
	
	// to imm extender
	assign is_r_type = (instr[6:2] == `OPCODE_TYPE_R_CALC);
	assign is_i_type = (instr[6:2] == `OPCODE_TYPE_I_CALC) ||
	       		   (instr[6:2] == `OPCODE_TYPE_I_LOAD) ||
	       		   (instr[6:2] == `OPCODE_TYPE_I_ENV ) ||
			   is_jalr;
			   //(instr[6:2] == `OPCODE_JALR) /*jalr*/ ;
	assign is_s_type = (instr[6:2] == `OPCODE_TYPE_S);
	assign is_b_type = (instr[6:2] == `OPCODE_TYPE_B);
	//TODO opt is_u_type by only use 4 bits
	assign is_u_type = is_lui || is_auipc;
			   //(instr[6:2] == `OPCODE_LUI) /*lui*/ ||
		           //(instr[6:2] == `OPCODE_AUIPC) /*auipc*/;
	assign is_j_type = (instr[6:2] == `OPCODE_TYPE_J);

	// to controller 
	assign is_int_calc = 	(instr[6:2] == `OPCODE_TYPE_R_CALC) ||
		   	     	(instr[6:2] == `OPCODE_TYPE_I_CALC);
	assign is_mem_load = 	(instr[6:2] == `OPCODE_TYPE_I_LOAD);
	assign is_mem_store = 	(instr[6:2] == `OPCODE_TYPE_S);
	assign is_mem_access = 	is_mem_load || is_mem_store;
	assign is_branch = 	(instr[6:2] == `OPCODE_TYPE_B) /*|| is_jal || is_jalr*/;

	// something special to decode
	assign is_jal = 	(instr[6:2] == `OPCODE_JAL);
	assign is_jalr = 	(instr[6:2] == `OPCODE_JALR);
	assign is_auipc =	(instr[6:2] == `OPCODE_AUIPC);
	assign is_lui =		(instr[6:2] == `OPCODE_LUI);

	//TODO
	assign is_float_calc = 'h0;
	assign is_system = 'h0;
endmodule
