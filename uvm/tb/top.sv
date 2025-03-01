module top;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import UART_pkg::*;
	`include "UART_tb.sv"
	`include "UART_test_lib.sv"

	UART_packet uart_pkt;

	initial begin
		run_test();
	end

endmodule : top
