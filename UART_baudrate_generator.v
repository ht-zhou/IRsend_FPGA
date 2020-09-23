
module UART_BaudRate_generator(
    Clk                   ,
    Rst_n                 ,
    Tick                  ,
    BaudRate
    );

input           Clk                 ; 
input           Rst_n               ;
input [15:0]    BaudRate            ; 
output          Tick                ; // Each "BaudRate" pulses we create a tick pulse
reg [15:0]      baudRateReg         ; 


always @(posedge Clk or negedge Rst_n)
begin
    if (!Rst_n) baudRateReg <= 16'b1;
    else if (Tick) baudRateReg <= 16'b1;
         else baudRateReg <= baudRateReg + 1'b1;
end
			
assign Tick = (baudRateReg == BaudRate);

endmodule

