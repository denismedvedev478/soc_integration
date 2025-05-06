/*
c.	входные параметры a, b, c, d являются целыми числами со знаком (signed)
d.	набор параметров a, b, c, d должен подаваться на вход схемы синхронно 
e.	разрядность данных должна определяться параметром
f.	схема должна обеспечивать возможность получения нового набора входных параметров a, b, c, d каждый такт
g.	латентность схемы должна быть оптимальной
h.	по возможности реализовать подтверждение входных и выходных данных сигналом valid
*/

//Q = ((a-b) * (1+3*c) - 4*d) / 2
module funcQ #(
    parameter DATA_WIDTH = 16
)
(
    input clk,
    input rst,

    input data_vld,
    input signed [DATA_WIDTH-1:0] a,
    input signed [DATA_WIDTH-1:0] b,
    input signed [DATA_WIDTH-1:0] c,
    input signed [DATA_WIDTH-1:0] d,

    output reg Q_vld,
    output reg signed [DATA_WIDTH-1:0] Q
);

reg signed [2*DATA_WIDTH-1:0] tmp1;
reg signed [2*DATA_WIDTH-1:0] tmp2;
reg signed [2*DATA_WIDTH-1:0] tmp3;
reg signed [2*DATA_WIDTH-1:0] result;


reg signed [DATA_WIDTH-1:0] d_r;
reg signed [DATA_WIDTH-1:0] d_r2;

reg vld_r;
reg vld_r2;
reg vld_r3;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		tmp1 <= 0;
		tmp2 <= 0;
		tmp3 <= 0;
		result <= 0;
		Q <= 0;
		d_r <=0;
		d_r2 <= 0;
		Q_vld <= 0;
		vld_r <= 0;
		vld_r2 <= 0;
		vld_r3 <= 0;
	end 
	else begin
		if (data_vld) begin
			tmp1 <= a - b;
			tmp2 <= 1 + 3 * c;
			d_r <= d;
			d_r2 <= d_r;
		end
		
		// vld propagation
		vld_r <= data_vld;
		vld_r2 <= vld_r;
		vld_r3 <= vld_r2;
		
		tmp3 <= tmp1 * tmp2;
		result <= tmp3 - (4 * d_r2);
		Q <= result >>> 1;
		Q_vld <= vld_r3;
	end
end




endmodule
