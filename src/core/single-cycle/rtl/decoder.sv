module decoder#(
	parameter AW = 32,
	parameter DW = 32	
)(
	input 	logic [DW-1:0] instr,
	
	output 	logic [7-1:0] opcode,	// to extender
	output	logic [3-1:0] func3, 
	output	logic [7-1:0] func7,	
	
	output	logic [5-1:0]	rd_addr,
	output	logic [5-1:0]	rs1_addr,
	output	logic [5-1:0]	rs2_addr
	);

	assign opcode = instr[6:0];
	assign func3 = instr [14:12];
        assign func7 = instr [31:25];
	assign rd_addr = instr[11:7];
	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];	
	
endmodule
