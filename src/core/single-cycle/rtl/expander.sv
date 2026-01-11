/* Expander for risc-v C */
module expander#(
	 parameter AW = 32
	,parameter DW = 32
)(
	 input	logic [DW-1:0]	instr
	,output	logic [DW-1:0]	instr_exp
	);

	logic is_compressed = (instr[1:0] != 2'b11); // is a compress instruction
	
	// TODO add expand logic here
	logic [DW-1:0] instr_tp = 'h0;
	assign instr_exp = is_compressed ? instr_tp : instr;

endmodule
