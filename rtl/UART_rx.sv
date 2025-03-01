`timescale 1ns/1ps

module UART_rx #(parameter DATA_SIZE = 8, // Valid values: 5 to 9
				 parameter STOP_BITS = 2, // Valid values: 1 or 2
				 parameter SYS_CLK_FREQ = 50000000,
				 parameter BAUD_RATE = 9600, // Valid values: 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600, 1000000, 1500000
				 parameter CLKS_PER_BIT = SYS_CLK_FREQ / BAUD_RATE,
				 parameter MID_SAMPLE = (CLKS_PER_BIT *3) / 2)
			    (input clk,
			     input rst,
			     output logic [7:0] data_out,
			     input  logic data_rx,
			     output logic pkt_drop,
			     output logic rx_busy);

	typedef enum {IDLE, START, DATA, PARITY, STOP} UART_STATE;

	UART_STATE cur_state, next_state;

	reg [DATA_SIZE-1:0] data_receive;
	reg [3:0] bit_count;

	logic [15:0] oversample_counter;
	logic [1:0] stop_counter;

	logic [15:0] baud_counter;
	logic baud_tick;

	logic data_rx_meta, data_rx_sync;

	always_ff @(posedge clk or negedge rst) begin
		if(!rst) begin
			cur_state <= IDLE;
			data_receive <= 8'b0;
			bit_count <= 4'b0;
			oversample_counter <= 16'b0;
			baud_counter <= 16'b0;
			baud_tick <= 1'b0;
			data_out <= 1'b0;
			pkt_drop <=1'b0;
			rx_busy <= 1'b0;
			stop_counter <= 1'b0;
		end else begin
			cur_state <= next_state;
			if(baud_counter == CLKS_PER_BIT - 1) begin
				baud_counter <= 1'b0;
				baud_tick <= 1'b1;
			end else begin
				baud_counter <= baud_counter + 1;
				baud_tick <= 1'b0;
			end

			case(cur_state)
				IDLE: begin
					pkt_drop <= 1'b0;
					oversample_counter <= 16'b0;
					bit_count <= 4'b0;
					if(data_rx_sync == 1'b0) begin
						rx_busy <= 1'b1;
					end
				end
				START: begin
					if(oversample_counter == MID_SAMPLE) begin
						oversample_counter <= 1'b0;
					end else begin
						oversample_counter <= oversample_counter + 1;
					end
				end
				DATA: begin
					if(baud_tick) begin
						data_receive[bit_count] <= data_rx_sync;
						if(bit_count < DATA_SIZE - 1) begin
							bit_count <= bit_count + 1;
						end
					end
				end
				PARITY: begin
					if(baud_tick) begin
					 	if(^data_receive != data_rx_sync) begin
							pkt_drop <= 1'b1;
						end
					end

				end
				STOP: begin
					if(baud_tick) begin
						if(data_rx_sync != 1'b1) begin
							pkt_drop <= 1'b1;
						end
						stop_counter <= stop_counter + 1;
						
						if(stop_counter == STOP_BITS - 1) begin
							rx_busy <= 1'b0;
							if(!pkt_drop) begin
								data_out <= data_receive;
							end
							stop_counter <= 1'b0;
						end 
						
					end
				end
				default: ;
			endcase
		
		end

	end

	always_comb begin
		next_state = cur_state;
		//baud_tick = (baud_counter == CLKS_PER_BIT - 1);

		case(cur_state)
			IDLE: begin
				if(data_rx_sync == 1'b0)
					next_state = START;
			end
			START: begin
				if(oversample_counter == MID_SAMPLE) begin
					next_state = DATA;
				end
			end
			DATA: begin
				if(baud_tick)
					if(bit_count == DATA_SIZE - 1) begin
						next_state = PARITY;
					end else begin
						next_state = DATA;
					end
			end
			PARITY: begin
				if(baud_tick) begin
					next_state = STOP;
				end
			end
			STOP: begin
				if(baud_tick) begin
					if(stop_counter == STOP_BITS - 1) begin
						next_state = IDLE;
					end
				end

			end
		endcase
	end

	// synchronizes assynchronous signal data_rx
	always_ff @(posedge clk) begin
		data_rx_meta <= data_rx;
		data_rx_sync <= data_rx_meta;
	end

endmodule
