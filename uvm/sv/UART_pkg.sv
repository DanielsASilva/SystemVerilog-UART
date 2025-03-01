package UART_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	

	`include "UART_packet.sv"
	`include "UART_monitor.sv"
	`include "UART_sequencer.sv"
	`include "UART_seqs.sv"
	`include "UART_rx_driver.sv"
	`include "UART_agent.sv"
	`include "UART_env.sv"

	/*
	`include "UART_packet.sv"
	`include "UART_env.sv"
	`include "UART_agent.sv"
	`include "UART_rx_driver.sv"
	`include "UART_monitor.sv"
	`include "UART_sequencer.sv"
	`include "UART_seqs.sv"
	*/
endpackage : UART_pkg
