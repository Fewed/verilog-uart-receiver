module edge_det #(parameter
									type=0
								 )
			 (
				 input wire clk,
				 input wire sgn,
				 output wire out
			 );

reg sgn_pre = 0;

always @(posedge clk) begin
	if (sgn_changed) sgn_pre <= sgn;
end

assign sgn_changed = sgn ^ sgn_pre,
			 pos_edge = (type == 0) & (sgn & sgn_changed),
			 neg_edge = (type == 1) & (~sgn & sgn_changed),
			 both_edges = (type == 2) & sgn_changed,
			 out = pos_edge | neg_edge | both_edges;

endmodule
