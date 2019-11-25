`include "entry.v"

module test_entry;

reg tclk, tdata;
wire tout;

//устанавливаем экземпляр тестируемого модуля
entry entry_inst(tclk, tdata, tout);

//моделируем сигнал тактовой частоты
always #10 tclk = ~tclk;

//от начала времени...

initial begin
	tclk = 0;
	tdata = 0;

	//через временной интервал "50" подаем сигнал сброса
	#55 tdata = 1;
	#50 tdata = 0;
	#50 tdata = 1;
	#50 tdata = 0;
end

//заканчиваем симуляцию в момент времени "400"
initial begin
	#400 $finish;
end

//создаем файл VCD для последующего анализа сигналов
initial begin
	$dumpfile("out.vcd");
	$dumpvars(0,test_entry);
end

//наблюдаем на некоторыми сигналами системы
initial $monitor($stime,, tclk,,, tdata,, tout);

endmodule
