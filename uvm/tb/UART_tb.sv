class UART_tb extends uvm_env;
    `uvm_component_utils(UART_tb)

    UART_env env;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = UART_env::type_id::create("env", this);
    endfunction : build_phase

endclass : UART_tb
