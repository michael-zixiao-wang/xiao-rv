module inst_rom#(
	 parameter string FILE = "dummy.txt"
	,parameter	AW = 32
	,parameter	DW = 32
)(
	 input 	logic [AW-1:0]	addr	
	,output	logic [DW-1:0]	instr	
);
/* verilator lint_off WIDTHTRUNC */
	logic	[DW-1:0] rom [1000_0000-1:0];
	always_comb begin
		//instr = rom[addr];
		instr = rom[addr[AW-1:2]]; // 2 for pc plus 4 each time
	end
	
	static string path = "../../test_data/";
	static string loc = {path,FILE};
	initial begin 
		$readmemh(loc,rom);
	end

endmodule
