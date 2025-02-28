`timescale 1ns/1ps

module UART_tx #(parameter DATA_SIZE = 8, // Valid values: 5 to 9
				 parameter SYS_CLK_FREQ = 50000000,
				 parameter BAUD_RATE = 9600, // Valid values: 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600, 1000000, 1500000
				 parameter CLKS_PER_BIT = SYS_CLK_FREQ / BAUD_RATE)
			    (input clk,
			     input rst,
			     input wr_en,
			     input  logic [7:0] data_in,
			     output logic data_tx,
			     output logic tx_busy);

	typedef enum {IDLE, START, DATA, PARITY, STOP} UART_STATE;

	UART_STATE cur_state, next_state;

	logic [DATA_SIZE-1:0] data_send;
	logic [3:0] bit_count;

	logic [15:0] baud_counter;
	logic baud_tick; 

	always_ff @(posedge clk or negedge rst) begin
		if(!rst) begin
			cur_state <= IDLE;
			data_send <= 8'b0;
			bit_count <= 4'b0;
			baud_counter <= 16'b0;
			baud_tick <= 1'b0;
		end else begin
			cur_state <= next_state;
			if(baud_counter == CLKS_PER_BIT - 1) begin
				baud_counter <= 16'b0;
				baud_tick <= 1'b1;
			end else begin
				baud_counter <= baud_counter + 1;
				baud_tick <= 1'b0;
			end
	
		case(cur_state)
			IDLE: begin
				if(wr_en) begin
					data_send <= data_in;
					bit_count <= 4'b0;
				end
			end
			DATA: begin
				if(baud_tick && (bit_count <= DATA_SIZE - 1))
					bit_count <= bit_count + 1;
			end
			default: ;
		endcase
		end
	end

	always_comb begin
		next_state = cur_state;
		//baud_tick = (baud_counter == CLKS_PER_BIT - 1);
		tx_busy = (cur_state != IDLE);

		case(cur_state)
			IDLE: begin
				data_tx = 1'b1;
				if(wr_en) begin
					next_state = START;
				end
			end
			START: begin
				data_tx = 1'b0; // send start signal
				if(baud_tick)
					next_state = DATA;
			end
			DATA: begin
				data_tx = data_send[bit_count];
				if(baud_tick) begin
					if(bit_count == DATA_SIZE - 1) begin
						next_state = PARITY;
					end else begin
						next_state = DATA;
					end
				end
			end
			PARITY: begin
				data_tx = ^data_send;	
				if(baud_tick)
					next_state = STOP;
			end
			STOP: begin
				data_tx = 1'b1; // stop signal
				if(baud_tick)
					next_state = IDLE;
			end
		endcase
	end

endmodule
