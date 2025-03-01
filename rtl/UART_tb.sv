`timescale 1ns/1ns

module UART_tb;

    reg clk = 0;
    reg rst = 1;
    
    reg wr_en = 0;
    reg [7:0] data_in;
    wire tx_busy;
    
    wire [7:0] data_out;
    wire rx_busy;
    wire pkt_drop;
    
    wire uart_data;
    
    UART_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .data_in(data_in),
        .data_tx(uart_data),
        .tx_busy(tx_busy)
    );
    
    UART_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .data_rx(uart_data),
        .data_out(data_out),
        .pkt_drop(pkt_drop),
        .rx_busy(rx_busy)
    );
    
    always #10 clk = ~clk;
    
    reg [7:0] test_data[4:0] = '{8'h00, 8'h55, 8'hAA, 8'hFF, 8'h1E};
    reg [7:0] received_data[4:0];
    int error_count = 0;
    
    initial begin
        $dumpfile("UART_tb.vcd");
        $dumpvars(0, UART_tb);
        
        // Reset sequence
        #20 rst = 1;
        #40 rst = 0;
        #60 rst = 1;
        
        // Allow some time after reset
        #200;
        
        for(int i = 0; i < 5; i++) begin
            send_packet(test_data[i]);
            receive_packet(received_data[i]);
            
            if(test_data[i] !== received_data[i]) begin
                $display("Error: Sent 0x%h, Received 0x%h", 
                        test_data[i], received_data[i]);
                error_count++;
            end
            
            if(pkt_drop) begin
                $display("Packet drop detected for data 0x%h", test_data[i]);
                error_count++;
            end
            
            #1000; // Wait between packets
        end
        
        if(error_count == 0)
            $display("All 5 packets transmitted and received successfully!");
        else
            $display("Test completed with %d errors", error_count);
        
        $finish;
    end
    
    task send_packet(input [7:0] data);
        $display("Sending data: 0x%h", data);
        data_in = data;
        wr_en = 1;
        
        // Wait until TX starts processing
        @(posedge tx_busy);
        #20 wr_en = 0;
        
        // Wait until TX completes
        @(negedge tx_busy);
    endtask
    
    task receive_packet(output [7:0] data);
        // Wait until RX completes
        @(negedge rx_busy);
        @(posedge clk);

        data = data_out;
        $display("Received data: 0x%h", data);
    endtask
    
endmodule
