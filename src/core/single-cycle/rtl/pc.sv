`include "../include/define.svh"
module pc#(
	 parameter AW = 32
	,parameter DW = 32
)(
	 input	logic		clk
	,input	logic		rst
	// control logic
	,input	logic		pc_sel // 0 for default
	// data path
	,input	logic [AW-1:0]	pc_jump	
	,output logic [AW-1:0]	pc
	,output	logic [AW-1:0]	pc_next // pc + 4	
	);
	
	//logic [AW-1:0]	pc;
	logic [AW-1:0] pcr; //pc register
	assign pc_next = pcr + 'h4;
	

	logic [AW-1:0] pc_new;
	assign pc_new = pc_sel ? pc_jump : pc_next;

	always_ff @ (posedge clk, posedge rst)begin
		if(rst)
			pcr <= `PC_RST_ADDR;
		else 
			pcr <= pc_new;
	end

	assign pc = pcr;

	/*
	always_ff@(posedge clk, posedge rst)begin
		if(rst)
			pc <= `PC_RST_ADDR;
		else if(pc_sel)
			pc <= pc_jump;
		else 
			pc <= pc + 'h4; // 4 for 32 isa
	end
	*/
endmodule
