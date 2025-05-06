`include "func.v"
`include "ref.svf"

module tb_funcQ;

parameter DATA_WIDTH = 16;

logic clk;
logic rst;


logic data_vld;
logic signed [DATA_WIDTH-1:0] a, b, c, d;
logic Q_vld;
logic signed [DATA_WIDTH-1:0] Q;


funcQ #(.DATA_WIDTH(DATA_WIDTH)) DUT (.* );

initial clk = 0;
always #5 clk = ~clk;

initial begin
rst = 1;
repeat (2) @(posedge clk);
rst = 0;
end

initial begin
	// Настройка waveform
	// Необходимо для создание временных диаграмм 
	$dumpvars();
//	$dumpvars(0, tbrt_map_gray); 

	#10000 $finish;
end


initial begin
	@(negedge rst);

	a = 12; b = 5; c = -2; d = 3;
	data_vld = 1;
	@(posedge clk);
	data_vld = 0;

	wait (Q_vld) begin
		if (Q !== ref_funcQ(a, b, c, d))
		  $display("FAIL: expected %0d, got %0d", ref_funcQ(a, b, c, d), Q);
		else
		  $display("PASS: Q = %0d", Q);
	end
	$finish;
end

endmodule
