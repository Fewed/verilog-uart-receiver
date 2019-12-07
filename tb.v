`timescale 1ns/1ps
`include "entry.v"

module test_entry;

reg clk, data;
wire out, edges;
wire[1:0]	state_value;
wire[7:0] out3, info;

//localparam mask = 0b0001_0000;

integer i;

//устанавливаем экземпляр тестируемого модуля
//entry entry_inst(tclk, data, out, state_value);
entry entry_inst(
				.clk(clk),
				.uart_tx(data),
				.uart_clk(out),
				.tmr_rst(edges),
				.state_cnt_value(out3),
				.state_value(state_value),
				.info(info)
			);

//моделируем сигнал тактовой частоты
always #10 clk = ~clk;

//от начала времени...

initial begin
	clk = 0;
	data = 1;

	// 0_1010_1100_1
	#1000 data = 0;	// 1250

	#1000 data = 1;
	#1000 data = 0;
	#1000 data = 1;
	#1000 data = 0;

	#1000 data = 1;
	#1000 data = 1;
	#1000 data = 0;
	#1000 data = 0;

	#1000 data = 1;
end

//заканчиваем симуляцию в момент времени "400"
initial #50000 $finish;


//создаем файл VCD для последующего анализа сигналов
initial begin
	$dumpfile("out.vcd");
	$dumpvars(0,test_entry);
end

//наблюдаем на некоторыми сигналами системы
initial $monitor($stime,, clk,,, data,, out,, state_value,, out3,, edges,, info);

endmodule
