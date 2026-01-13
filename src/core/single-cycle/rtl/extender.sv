module extender#(
	 parameter AW = 32
	,parameter DW = 32
)(
	 input	logic [DW-1:0]	instr
	//input 	logic [7-1:0]	opcode,
	//,input	logic		is_r_type // no need for imm extend for R type
        ,input	logic          	is_i_type
        ,input	logic         	is_s_type
        ,input	logic          	is_b_type
        ,input	logic          	is_u_type
        ,input	logic          	is_j_type

	,output	logic [DW-1:0]  imm
);
	always_comb begin
		case({is_i_type,is_s_type,is_b_type,is_u_type,is_j_type})
			5'b10_000: imm = {{20{instr[31]}},instr[31:20]}; // I
			5'b01_000: imm = {{20{instr[31]}},instr[31:25],instr[11:7]}; // S
			5'b00_100: imm = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0}; // B
			5'b00_010: imm = {instr[31:12],12'b0000_0000_0000}; // U
			5'b00_001: imm = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0}; // J
			default:   imm = 'h0;
		endcase
	end

	/*
	always_comb begin
		case(opcode)
			7'b0010011: imm = {{20{instr[31]}},instr[31:20]}; // I
			7'b0000011: imm = {{20{instr[31]}},instr[31:20]};
			7'b0100011: imm = {{20{instr[31]}},instr[31:20]};
			7'b1100011: imm = 'h0;
			7'b1101111: imm = 'h0;
			7'b1100111: imm = 'h0;
			default: imm = 'h0;
		endcase
	end
	*/
endmodule
