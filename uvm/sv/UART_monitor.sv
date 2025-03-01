class UART_monitor extends uvm_monitor;
	`uvm_component_utils(UART_monitor)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : UART_monitor