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
	,input	logic [AW-1:0]	pc_next	
	,output logic [AW-1:0]	pc
		
	);
	
	//logic [AW-1:0]	pc;
	always_ff@(posedge clk, posedge rst)begin
		if(rst)
			pc <= `PC_RST_ADDR;
		else if(pc_sel)
			pc <= pc_next;
		else 
			pc <= pc + 'h4; // 4 for 32 isa
	end

endmodule
