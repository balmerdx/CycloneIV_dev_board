module test_my_board (input clk_50M,
	input uart_rx_pin,
	output reg led110,
	output reg led111,
	output reg led114,
	output reg led115);

reg [25:0] count;
logic [3:0] leds;

reg use_leds_from_uart;
initial use_leds_from_uart = 0;

logic uart_rx_received;
wire [7:0] uart_rx_byte;


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
		use_leds_from_uart <= ~uart_rx_byte[7];
	end
	
	if(use_leds_from_uart)
	begin
		leds <= uart_rx_byte[3:0];
	end
	else
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
  #(.CLKS_PER_BIT(434)) //115200 bps
	uart_rx0
  (
   .i_Clock(clk_50M),
   .i_Rx_Serial(uart_rx_pin),
   .o_Rx_DV(uart_rx_received),
   .o_Rx_Byte(uart_rx_byte)
   );

endmodule
