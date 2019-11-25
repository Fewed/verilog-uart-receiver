`include "entry.v"

module test_entry;

reg tclk, tdata;
wire tout;

integer i;

//устанавливаем экземпляр тестируемого модуля
entry entry_inst(tclk, tdata, tout);

//моделируем сигнал тактовой частоты
always #10 tclk = ~tclk;

//от начала времени...

initial begin
	tclk = 0;
	tdata = 0;

	#55 tdata = ~tdata;
	for (i=0; i<8; i++) #50 tdata = ~tdata;
end

//заканчиваем симуляцию в момент времени "400"
initial #500 $finish;


//создаем файл VCD для последующего анализа сигналов
initial begin
	$dumpfile("out.vcd");
	$dumpvars(0,test_entry);
end

//наблюдаем на некоторыми сигналами системы
initial $monitor($stime,, tclk,,, tdata,, tout);

endmodule
