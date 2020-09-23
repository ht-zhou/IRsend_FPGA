module TOP(
    	Clk                     ,
    	Rst_n                   ,   
   	Rx                      , 
	   RxData		            ,
		IrSend           
	);


input           Clk             ; 
input           Rst_n           ; // Reset
input           Rx              ; // RS232 RX line.
output [7:0]    RxData          ; // Received data
output          IrSend;


wire          	RxDone          ; // Reception completed. Data is valid.
wire            tick		 ; // Baud rate clock
wire 		       RxEn		 ;
wire [3:0]      NBits    	;
wire [15:0]    	BaudRate        ; 
wire enable;
wire [2:0] conduct ; 
wire send;
wire wave;
//The width of the UART signal is 1/9600 (104us). The width of the main clock is 1/50Mhz(20ns) (104000ns/16)/ 20ns = 325 pulses

assign 		RxEn = 1'b1	;
assign 		BaudRate = 16'd325; 	
assign 		NBits = 4'b1000	;	//We send/receive 8 bits

UART_rs232_rx I_RS232RX(
    	.Clk(Clk)             	,
   	.Rst_n(Rst_n)         	,
    	.RxEn(RxEn)           	,
    	.RxData(RxData)       	,
    	.RxDone(RxDone)       	,
    	.Rx(Rx)               	,
    	.Tick(tick)           	,
    	.NBits(NBits)
    );


UART_BaudRate_generator I_BAUDGEN(
    	.Clk(Clk)               ,
    	.Rst_n(Rst_n)           ,
    	.Tick(tick)             ,
    	.BaudRate(BaudRate)
    );
	 
Translater(
	.clk(Clk),
	.rxDone(RxDone),
	.RxData(RxData),
	.Enable(enable),
	.Conduct(conduct)
);

IRtest(
	.clk(Clk),
	.enable(enable),
	.conduct(conduct),
	.ir_send(send)
	
);

tiaozhi(
	.clk(Clk),
	.wave_out(wave)
);

assign IrSend = (wave & send);


endmodule
