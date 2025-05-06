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
reg signed [2*DATA_WIDTH-1:0] tmp4;


reg signed [DATA_WIDTH-1:0] a_r;
reg signed [DATA_WIDTH-1:0] b_r;
reg signed [DATA_WIDTH-1:0] c_r;

reg signed [DATA_WIDTH-1:0] d_r;
reg signed [DATA_WIDTH-1:0] d_r2;
reg signed [DATA_WIDTH-1:0] d_r3;

reg vld_r;
reg vld_r2;
reg vld_r3;
reg vld_r4;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		tmp1 <= 0;
		tmp2 <= 0;
		tmp3 <= 0;
		tmp4 <= 0;
		Q <= 0;
		Q_vld <= 0;
		
		a_r <= 0;
		b_r <= 0;
		c_r <= 0;
		d_r <= 0;
		d_r2 <= 0;
		
		vld_r <= 0;
		vld_r2 <= 0;
		vld_r3 <= 0;
	end
	else begin	// more energy efficient but more area
		if (data_vld) begin
			a_r <= a;
			b_r <= b;
			c_r <= c;
			d_r <= d;
		end
		vld_r <= data_vld;
		
		if (vld_r) begin
			tmp1 <= a_r - b_r;
			tmp2 <= 1 + 3 * c_r;
			d_r2 <= d_r;
		end
		vld_r2 <= vld_r;
		
		if (vld_r2) begin
			tmp3 <= tmp1 * tmp2;
			d_r3 <= d_r2;
		end
		vld_r3 <= vld_r2;
		
		if (vld_r3) begin
			tmp4 <= tmp3 - (4 * d_r3);
		end
		vld_r4 <= vld_r3;
		
		if (vld_r4) begin
			Q <= tmp4 >>> 1;
			Q_vld <= 1;
		end else begin
			Q_vld <= 0;
		end

	end
end

/*
always_ff @(posedge clk or posedge rst) begin	// less area and less energy efficient
	if (rst) begin
		tmp1 <= 0;
		tmp2 <= 0;
		tmp3 <= 0;
		tmp4 <= 0;
		Q <= 0;
		Q_vld <= 0;
		
		a_r <= 0;
		b_r <= 0;
		c_r <= 0;
		d_r <= 0;
		d_r2 <= 0;
		
		vld_r <= 0;
		vld_r2 <= 0;
		vld_r3 <= 0;
	end
	else begin
		a_r <= a;
		b_r <= b;
		c_r <= c;
		d_r <= d;
		vld_r <= data_vld;
		
		tmp1 <= a_r - b_r;
		tmp2 <= 1 + 3 * c_r;
		d_r2 <= d_r;
		vld_r2 <= vld_r;
		
		tmp3 <= tmp1 * tmp2;
		d_r3 <= d_r2;
		vld_r3 <= vld_r2;
		
		tmp4 <= tmp3 - (4 * d_r3);
		vld_r4 <= vld_r3;
		
		Q <= tmp4 >>> 1;
		Q_vld <= vld_r4;
	end
end
*/

endmodule
