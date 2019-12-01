module pwm #(parameter
						 clk_mhz = 50,
						 freq_khz = 400,
						 duty = 40
						)
			 (
				 input wire clk,
				 input wire rst,
				 output wire out
			 );


function[31:0] div(input[31:0] A, input[31:0] B);
	begin
		div = A / B + (2*(A % B) >= B ? 1 : 0);
	end
endfunction

localparam clk_khz = 1000 * clk_mhz,
					 cnt_max = div(clk_khz, freq_khz),
					 cnt_width = $clog2(cnt_max),
					 cnt_duty = div(duty * cnt_max, 100);

reg[cnt_width-1:0] cnt = 0;

always @(posedge clk) begin
	cnt <= (~rst & (cnt < cnt_max-1)) ? cnt + 1 : 0;
end

assign out = cnt < cnt_duty;

endmodule
