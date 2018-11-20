module uart_send_message(
	input clock,
	input signal_send_message,
	input logic [2:0] message_id,
	input uart_tx_active,
	output logic uart_tx_send_byte,
	output logic [7:0] uart_tx_byte);
	
	logic [7:0]  address;
	reg [7:0]  mem_byte;
	reg send_byte = 0;
	reg [1:0] wait_one_clock = 0;
	
	always @ ( posedge clock)
	begin
		if(uart_tx_send_byte)
		begin
			uart_tx_send_byte <= 0;
		end
		else
		if(!uart_tx_active)
		begin
			if(signal_send_message)
			begin
				address[7:5] <= message_id;
				address[4:0] <= 0;
				send_byte <= 1;
				wait_one_clock <= 2;
			end
			
			if(wait_one_clock!=0)
			begin
				//У нас медленный вариант памяти, с триггерами в начале и в конце
				//Поэтому ждем дополнительные два clock, пока данные до нас доберутся.
				wait_one_clock <= wait_one_clock-1'b1;
			end
			else
			if(send_byte)
			begin
				if(mem_byte==8'h00)
				begin
					send_byte <= 0;
				end
				else
				begin
					uart_tx_send_byte <= 1;
					uart_tx_byte <= mem_byte;
					address <= address+1'b1;
				end
			end
		end
		
	end
	
	uart_messages uart_messages0(
	.address(address),
	.clock(clock),
	.q(mem_byte));

endmodule
