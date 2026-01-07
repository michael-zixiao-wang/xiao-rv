module extender#(
	parameter AW = 32,
	parameter DW = 32
)(
	input	logic [DW-1:0]	instr,
	input 	logic [7-1:0]	opcode,
	output	logic [DW-1:0]  imm
);
	always_comb begin
		case(opcode)
			7'b0010011: imm = {20{instr[31]},instr[31:20]}; // I
			7'b0000011: imm = {20{instr[31]},instr[31:20]};
			7'b0100011: imm = {20{instr[31]},instr[31:20]};
			7'b1100011: imm = 'h0;
			7'b1101111: imm = 'h0;
			7'b1100111: imm = 'h0;
			default: imm = 'h0;
		endcase
	end

endmodule
