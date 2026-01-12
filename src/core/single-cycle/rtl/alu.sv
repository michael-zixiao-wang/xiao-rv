
`include "../include/define.svh"
module alu#(
	 parameter DW = 32
	,parameter AW = 32
)(
	 input	logic [4-1:0]	alu_sel
	,input	logic [DW-1:0]	op1
	,input	logic [DW-1:0]	op2
	,output logic [DW-1:0]	res // result
);

	always_comb begin
		case(alu_sel)
			`ALU_NONE	: res = 'h0;
			`ALU_ADD	: res = op1 + op2;
			`ALU_SUB	: res = op1 - op2;
			`ALU_XOR	: res = op1 ^ op2;
			`ALU_OR		: res = op1 | op2;
			`ALU_AND	: res = op1 & op2;
			`ALU_SLL	: res = op1 << op2;
			`ALU_SRL	: res = op1 >> op2;
			`ALU_SRA	: res = $signed(op1) >>> op2; // note: this $signed is must fot >>>
			`ALU_SLT	: res = ($signed(op1) < $signed(op2)) ? 'b1 : 'b0;
			`ALU_SLTU	: res = (op1 < op2) ? 'b1 : 'b0; 
			default: res = 'h0;
		endcase
	end


endmodule
