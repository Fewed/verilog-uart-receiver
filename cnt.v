module cnt(
				 input wire clk,
				 input wire rst,
				 output reg[7:0] out = 0
			 );

always @(posedge clk or posedge rst) begin
	if (rst) out <= 0;
	else if (clk) out <= out + 1;
end


endmodule
