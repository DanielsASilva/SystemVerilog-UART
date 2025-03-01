class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    UART_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "recording_detail", 1);
        tb = UART_tb::type_id::create("tb", this);
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase",
                                 "default_sequence",
                                 UART_5_packets::get_type());
    endfunction : build_phase

    virtual function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction : check_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : base_test
