class UART_rx_driver extends uvm_driver #(UART_packet);
	`uvm_component_utils(UART_rx_driver)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask : run_phase

	task send_to_dut(UART_packet packet);
		`uvm_info(get_type_name(), $sformatf("Packet is \n%s", packet.sprint()), UVM_LOW)
		#10ns;
	endtask : send_to_dut

endclass : UART_rx_driver
