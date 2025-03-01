class UART_agent extends uvm_agent;
	
	`uvm_component_utils_begin(UART_agent)
		`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
	`uvm_component_utils_end

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	UART_monitor      monitor;
	UART_rx_driver    rx_driver;
	UART_sequencer    sequencer;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor = UART_monitor::type_id::create("monitor", this);
		if(is_active == UVM_ACTIVE) begin
			sequencer = UART_sequencer::type_id::create("sequencer", this);
			rx_driver = UART_rx_driver::type_id::create("rx_driver", this);
		end
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		rx_driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction : connect_phase

endclass : UART_agent
