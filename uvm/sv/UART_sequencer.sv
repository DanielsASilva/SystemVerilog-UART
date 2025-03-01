class UART_sequencer extends uvm_sequencer #(UART_packet);
	`uvm_component_utils(UART_sequencer)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : UART_sequencer
