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

`include "pwm.v"
`include "edge_det.v"
`include "cnt.v"

module entry (
				 input wire clk,
				 input wire uart_tx,
				 output wire uart_clk,
				 output wire tmr_rst,
				 output wire[7:0] state_cnt_value,
				 output reg[1:0] state_value = 0,
				 output reg[7:0] info = 0
			 );

wire neg_egde_det_out;



reg zero = 0;


pwm #(.freq_khz(2000), .duty(50)) pwm_ins(.clk(clk), .rst(zero), .out(uart_clk));
//edge_det #(.type(0)) resett(.clk(clk), .sgn(uart_tx), .out(get_data));
edge_det #(.type(1)) neg_edge_det(.clk(clk), .sgn(uart_tx), .out(neg_egde_det_out));
cnt state_cnt(.clk(uart_clk), .rst(tmr_rst), .out(state_cnt_value));

always @(posedge clk) begin
	if (tmr_rst) state_value <= 1;
	else if (e2) state_value <= 2;
	else if (e3) state_value <= 0;
end

always @(posedge middle) begin
	if (state_value) info <= {uart_tx, info[7:1]};
end

assign tmr_rst = (state_value == 0) & neg_egde_det_out,
			 e2 = (state_value == 1) & (state_cnt_value == 3),
			 e3 = (state_value == 2) & (state_cnt_value == 2*7+3),
			 middle = (state_cnt_value-1)%2 == 0;


endmodule
