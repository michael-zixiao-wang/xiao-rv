module brancher#(
	parameter AW = 32,
	parameter DW = 32
)(	
	input	logic [3-1:0]	func3,
	input	logic [DW-1:0]	rs1_data,
	input	logic [DW-1:0]	rs2_data,
	output 	logic 		pc_sel
);
	always_comb begin
		case(func3)
			3'b000: pc_sel = (rs1_data == rs2_data); // beq
			3'b001: pc_sel = (rs1_data != rs2_data); // bne
			3'b100: pc_sel = (rs1_data <  rs2_data); // blt
			3'b101: pc_sel = (rs1_data >= rs2_data); // bge
			3'b110: pc_sel = (rs1_data <  rs2_data); // bltu 
			3'b111: pc_sel = (rs1_data >= rs2_data); // bgeu
			default: pc_sel = 'b0;
		endcase
	end

endmodule
