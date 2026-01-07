module tb_cpu();

bit clk,rst;

always #5 clk = ~clk;

initial begin
	rst = 1;
	repeat(10) @(posedge clk);
	rst = 0;
end

cpu#(
	.INST_FILE("dummy.txt")
)dut(.*);

endmodule
