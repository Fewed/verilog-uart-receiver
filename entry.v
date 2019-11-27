/*
module entry(
				 input wire clk,
				 input wire data,
				 output reg out
			 );
 
localparam baudrate = 100_000,
					 f_clk = 50_000_000,
					 cnt_val = f_clk/(2*baudrate)-1;
 
reg isTransmit = 0;
reg data_pre = 1;
reg[13:0] cnt = cnt_val;
reg[9:0] sh_reg = 0;
 
reg[4:0] cnt2 = 0;
 
 
always @(posedge clk) begin
	if (data_negedge) begin
		data_pre <= data;
		if (~isTransmit) begin
			isTransmit <= 1;
			cnt <= 3*cnt_val;
		end
		else cnt <= cnt_val;
	end
	else if (data_posedge) begin
		data_pre <= data;
		cnt <= cnt_val;
	end
	else cnt <= cnt - 1;
end
 
always @(posedge clk) begin
	if (check) begin
		sh_reg <= sh_reg << 1;
		sh_reg[0] <= data;
	end
end
 
always @(posedge clk) begin
	if (cnt2 == 0) begin
		cnt2 <= 10 + 10*sh_reg;
		out <= out ^ 1;
	end
	else cnt2 <= cnt2 - 1;
end
 
 
assign data_posedge = data && ~data_pre;
assign data_negedge = ~data && data_pre;
assign check = isTransmit && (cnt == 0);
 
endmodule
*/


/*
module entry #(parameter width=8) (
				 input wire clk,
				 input wire data,
				 output reg[width-1:0] sh_reg
			 );
 
 
 
 
 
always @(posedge clk) begin
	sh_reg <= {sh_reg[width-2:0], data};
end
 
endmodule
*/

//`include "gen.v"

module entry #(parameter clk_mhz=50, freq_khz=400, duty=40) (
				 input wire clk,
				 input wire data,
				 output wire out
			 );

localparam cnt_max = 1000 * clk_mhz / freq_khz,
					 cnt_width = $clog2(cnt_max),
					 cnt_duty = duty * cnt_max / 100;

reg[cnt_width-1:0] cnt = 0;

always @(posedge clk) begin
	cnt <= cnt < cnt_max-1 ? cnt + 1 : 0;
end

assign out = cnt < cnt_duty;


endmodule
