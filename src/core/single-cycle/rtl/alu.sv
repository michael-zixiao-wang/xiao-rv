module alu#(
	parameter DW = 32,
	parameter AW = 32
)(
	input	logic [4-1:0]	alu_sel,
	input	logic [DW-1:0]	op1,
	input	logic [DW-1:0]	op2,
	output 	logic [DW-1:0]	res // result
);

	always_comb begin
		case(alu_sel)
			4'b0000: res  = 'h0;
			4'b0001: res  = op1 + op2;

			default: res = 'h0;
		endcase
	end


endmodule
