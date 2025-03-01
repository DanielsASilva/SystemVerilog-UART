class UART_env extends uvm_env;
	`uvm_component_utils(UART_env)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	UART_agent agent;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = UART_agent::type_id::create("agent", this);
	endfunction : build_phase

endclass : UART_env
