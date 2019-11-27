// clk 50 Mhz

module gen #(parameter clk_mhz=50, freq_khz=100, duty=25) (
				 input wire clk,
				 output wire[50:0] out
			 );

localparam cnt_max = 500 * clk_mhz / freq_khz,
					 cnt_width = $clog2(cnt_max);

assign out = cnt_width;

/*
always @(posedge clk) begin
	if (int_clk_cnt) int_clk_cnt <= int_clk_cnt - 1;
	else begin
		int_clk_cnt <= num;
		int_clk <= ~int_clk;
	end
end
*/

endmodule
