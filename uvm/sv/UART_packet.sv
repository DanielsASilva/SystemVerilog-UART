typedef enum bit {GOOD_PARITY, BAD_PARITY} parity_type_e;
typedef enum bit {GOOD_STOP, BAD_STOP} stop_type_e;

class UART_packet extends uvm_sequence_item;

	rand bit [7:0] data;
	     bit parity;
	     bit [1:0] stop = 2;

	rand parity_type_e parity_type;
	rand stop_type_e stop_type;
	rand int packet_delay;

	`uvm_object_utils_begin(UART_packet)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(parity, UVM_ALL_ON)
		`uvm_field_int(stop, UVM_ALL_ON)
		`uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
		`uvm_field_enum(stop_type_e, stop_type, UVM_ALL_ON)
		`uvm_field_int(packet_delay, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint cparity_type  {parity_type dist {GOOD_PARITY:=5, BAD_PARITY:=1}; }
	// only correct stop bits for now
	// constraint cparity_type  {parity_type dist {GOOD_STOP:=5, BAD_STOP:=1}; }
	constraint cpacket_delay {1 <= packet_delay <= 20; }

	function void set_parity();
		parity = ^data;
		if(parity_type == BAD_PARITY)
			parity = !parity;
	endfunction : set_parity

	function void set_stop();
		if(stop_type == GOOD_STOP)
			stop = 2;
	endfunction : set_stop

	function void post_randomize();
		set_parity();
		//set_stop();
	endfunction : post_randomize

	function new(string name = "yapp_packet");
		super.new(name);
	endfunction : new

endclass : UART_packet
