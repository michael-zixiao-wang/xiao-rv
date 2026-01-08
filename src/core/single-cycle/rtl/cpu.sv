module cpu#(
	parameter AW = 32,
	parameter DW = 32,
	parameter string INST_FILE = "addi.txt"
)(	
	input	logic		clk,
	input	logic 		rst

);
	logic		pc_sel;
	logic [AW-1:0]	pc_next;
	assign pc_next = res_data;
	logic [AW-1:0]	pc;
	pc#(
		.AW	(AW	),
		.DW	(DW	)
	)u_pc(
		.clk	(clk	),
		.rst	(rst	),
		.pc_sel (pc_sel	),
		.pc_next(pc_next),
		.pc	(pc	)
	);	
	
	logic [DW-1:0]	instr;
	inst_rom#(
		.AW	(AW	),
		.DW	(DW	),
		.FILE	(INST_FILE)	
	)u_inst_rom(
		.addr	(pc	),
		.instr	(instr	)	
	);

	logic [7-1:0]	opcode;
	logic [3-1:0]	func3;
	logic [7-1:0] 	func7;
	logic [5-1:0]	rd_addr;
	logic [5-1:0]	rs1_addr;
	logic [5-1:0]	rs2_addr;
	decoder#(
		.AW	(AW	),
		.DW	(DW	)	
	)u_decoder(
		.instr 	(instr	),
		.opcode	(opcode	),
		.func3	(func3	),
		.func7	(func7	),	
		.rd_addr(rd_addr),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr)
	);
	
	logic [DW-1:0]	imm;
	extender#(
		.AW	(AW	),
		.DW	(DW	)	
	)u_extender(
		.instr	(instr	),
		.opcode	(opcode	),
		.imm	(imm	)	
	);

	logic		rf_wr_en;
	logic [DW-1:0]	rd_data;
	logic [DW-1:0]	rs1_data;
	logic [DW-1:0]	rs2_data;
	rf#(
		.AW	(AW	),
		.DW	(DW	)
	)u_rf(
		.clk	(clk	),
		.rst	(rst	),
		.wr_en	(rf_wr_en),
		.rd_addr(rd_addr),
		.rd_data(rd_data),
		.rs1_addr(rs1_addr),
		.rs1_data(rs1_data),
		.rs2_addr(rs2_addr),
		.rs2_data(rs2_data)	
	);
	
	logic	[1:0]	rd_data_sel;
	logic		mem_en;
	logic	[4-1:0]	alu_sel;
	logic		rs1_pc_sel;
	logic		rs2_imm_sel;
	controller#(
		.AW	(AW	),
		.DW	(DW	)
	)u_controller(
		.opcode (opcode	),
		.func3	(func3	),
		.func7	(func7	),
		.rd_data_sel(rd_data_sel),
		.mem_en	(mem_en	),
		.alu_sel(alu_sel),
		.rf_en	(rf_wr_en),
		.rs1_pc_sel(rs1_pc_sel),
		.rs2_imm_sel(rs2_imm_sel)		
	);
	
	logic [DW-1:0]	op1_data;
	logic [DW-1:0]	op2_data;

	assign op1_data = rs1_pc_sel ? pc : rs1_data;
	assign op2_data = rs2_imm_sel ? imm : rs2_data;
	
	logic [DW-1:0]	res_data;
	alu#(
		.DW	(DW	),
		.AW	(AW	)	
	)u_alu(
		.alu_sel(alu_sel),
		.op1(op1_data	),
		.op2(op2_data	),
		.res(res_data	)	
	);
	
	//logic	pc_sel;
	brancher#(
		.AW	(AW	),
		.DW	(DW	)	
	)u_brancher(
		.func3	(func3	),
		.rs1_data(rs1_data),
		.rs2_data(rs2_data),
		.pc_sel	(pc_sel	)	
	);
	
	logic [DW-1:0]	mem_data;
	data_ram#(
		.RAM_NUM	(1000_0000),
		.AW	(AW	),
		.DW	(DW	)	
	)u_data_ram(
		.clk	(clk	),
		.rst	(rst	),
		.wr_en	(mem_en	),
		.addr	(res_data),
		.data_in(rs2_data),
		.data_out(mem_data)	
	);

	assign rd_data = (rd_data_sel == 2'b00) ? 'h0:
			 (rd_data_sel == 2'b10) ? pc :
			 (rd_data_sel == 2'b01) ? res_data:
			 (rd_data_sel == 2'b11) ? mem_data: 'h0;

endmodule
