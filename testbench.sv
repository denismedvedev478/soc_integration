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

initial clk <= 0;
always #5 clk <= ~clk;

initial begin
	rst <= 1;
	repeat (10) begin
		@(posedge clk)
		rst <= 0;
	end
end

initial begin
	// Настройка waveform
	// Необходимо для создание временных диаграмм 
	$dumpvars();
//	$dumpvars(0, tbrt_map_gray); 

	#10000 $finish;
end


// hardcoded tests
reg signed [DATA_WIDTH-1:0] a1 = 11, b1 = 5, c1 = -1, d1 = 5;

reg signed [DATA_WIDTH-1:0] a2 = 12, b2 = 3, c2 = -2, d2 = 1;
	
	
initial begin
    repeat (4) begin
        @(posedge clk);
        data_vld <= 0;
        a <= 0; b <= 0; c <= 0; d <= 0;
    end

    @(posedge clk);
    data_vld <= 1;
    a <= 11; b <= 5; c <= -1; d <= 5;
    //signed [DATA_WIDTH-1:0] a1 = 11, b1 = 5, c1 = -1, d1 = 5;

    @(posedge clk);
    a <= 12; b <= 3; c <= -2; d <= 1;
    //signed [DATA_WIDTH-1:0] a2 = 12, b2 = 3, c2 = -2, d2 = 1;

    @(posedge clk);
    data_vld <= 0;
    a <= 0; b <= 0; c <= 0; d <= 0;
end

initial begin
    check_result(a1, b1, c1, d1);
    check_result(a2, b2, c2, d2);

    $finish;
end


task automatic check_result;
    input signed [DATA_WIDTH-1:0] a_in;
    input signed [DATA_WIDTH-1:0] b_in;
    input signed [DATA_WIDTH-1:0] c_in;
    input signed [DATA_WIDTH-1:0] d_in;

    reg signed [DATA_WIDTH-1:0] expected;
    begin
        expected = ref_funcQ(a_in, b_in, c_in, d_in);

        @(posedge clk);
        wait (Q_vld);

        if (Q !== expected)
            $display("FAIL: expected %0d, got %0d", expected, Q);
        else
            $display("PASS: Q = %0d", Q);

        @(posedge clk);
        wait (!Q_vld);
    end
endtask


endmodule
