module test_my_board (input clk_50M,
	input uart_rx_pin,
	output reg uart_tx_pin,
	output reg led110,
	output reg led111,
	output reg led114,
	output reg led115);

localparam UART_CLKS_PER_BIT = 434;//115200 bps
reg [25:0] count;
logic [3:0] leds;

reg use_leds_from_uart;
initial use_leds_from_uart = 0;

logic uart_rx_received;
wire [7:0] uart_rx_byte;

reg uart_tx_send_byte = 0;
reg uart_tx_active;
reg [7:0] uart_tx_byte;


//Первоначально посылаем message_id==0 'Device online\n'
//Это конечно не совсем честно, по хорошему надо паузу выдержать.
reg signal_send_message = 1;
reg [2:0] message_id = 0;


always @ (*)
begin
	led110 = leds[0];
	led111 = leds[1];
	led114 = leds[2];
	led115 = leds[3];
end

always @ ( posedge clk_50M)
begin
	count <= count+1'd1;
	if(uart_rx_received)
	begin
		//set bit 7 to use counter to leds
		casez (uart_rx_byte)
			8'b0000zzzz:
			begin
				leds <= uart_rx_byte[3:0];
				use_leds_from_uart <= 1;
				
				message_id <= 3'h2;//'Led data received\n'
				signal_send_message <= 1;
			end
			8'b00010000:
			begin
				use_leds_from_uart <= 0;
				
				message_id <= 3'h3;//'Use counter to led\n'
				signal_send_message <= 1;
			end
		endcase
	end
	
	if(signal_send_message)
	begin
		signal_send_message <= 0;
	end
	
	if(!use_leds_from_uart)
	begin
		case (count[25:23])
		0: begin leds <= 4'b1000; end
		1: begin leds <= 4'b0100; end
		2: begin leds <= 4'b0010; end
		3: begin leds <= 4'b0001; end
		4: begin leds <= 4'b0001; end
		5: begin leds <= 4'b0010; end
		6: begin leds <= 4'b0100; end
		7: begin leds <= 4'b1000; end
		endcase
	end
end

uart_rx 
  #(.CLKS_PER_BIT(UART_CLKS_PER_BIT))
	uart_rx0
  (
   .i_Clock(clk_50M),
   .i_Rx_Serial(uart_rx_pin),
   .o_Rx_DV(uart_rx_received),
   .o_Rx_Byte(uart_rx_byte)
   );
	
uart_tx 
  #(.CLKS_PER_BIT(UART_CLKS_PER_BIT))
   uart_tx0
  (
   .i_Clock(clk_50M),
   .i_Tx_DV(uart_tx_send_byte),
   .i_Tx_Byte(uart_tx_byte), 
   .o_Tx_Active(uart_tx_active),
   .o_Tx_Serial(uart_tx_pin),
	.o_Tx_Done()
   );
	
uart_send_message uart_send_message0(
	.clock(clk_50M),
	.signal_send_message(signal_send_message),
	.message_id(message_id),
	.uart_tx_active(uart_tx_active),
	.uart_tx_send_byte(uart_tx_send_byte),
	.uart_tx_byte(uart_tx_byte));

endmodule
