-64

-uvmhome $UVMHOME

// include directories
	-incdir uvm/sv
	-incdir uvm/tb
	-incdir rtl/

// compile files
	uvm/sv/UART_pkg.sv
	uvm/tb/top.sv

+UVM_TESTNAME=base_test
+SVSEED=random
