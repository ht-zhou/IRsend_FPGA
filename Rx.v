module UART_rs232_rx (Clk,Rst_n,RxEn,RxData,RxDone,Rx,Tick,NBits);

input Clk, Rst_n, RxEn,Rx,Tick;		
input [3:0]NBits;			

output RxDone;				
output [7:0]RxData;			


parameter  IDLE = 1'b0, READ = 1'b1; 	
reg  State;
reg  Next;			
reg  read_enable = 1'b0;		
reg  start_bit = 1'b1;			//notify when the start bit was detected (first falling edge of RX)
reg  RxDone = 1'b0;			
reg [4:0] Bit = 5'b00000;		
reg [3:0] counter = 4'b0000;		
reg [7:0] Read_data= 8'b00000000;	
reg [7:0] RxData;			

always @ (posedge Clk or negedge Rst_n)			
begin
if (!Rst_n)	State <= IDLE;				
else 		State <= Next;				
end

always @ (State or Rx or RxEn or RxDone)
begin
    case(State)	
	IDLE:	if(!Rx & RxEn)		Next = READ;	 //If Rx is low (Start bit detected) we start the read process
		else			Next = IDLE;
	READ:	if(RxDone)		Next = IDLE; 	 //If RxDone is high we get back to IDLE and wait for Rx input to go low (start bit detect)
		else			Next = READ;
	default 			Next = IDLE;
    endcase
end

always @ (State or RxDone)
begin
    case (State)
	READ: begin
		read_enable <= 1'b1;			
	      end
	
	IDLE: begin
		read_enable <= 1'b0;		
	      end
    endcase
end


//Read the input data
always @ (posedge Tick)

	begin
	if (read_enable)
	begin
	RxDone <= 1'b0;							
	counter <= counter+1;						
	
	if ((counter == 4'b1000) & (start_bit))				//Counter is 8? Detect the start bit.  
	begin
	start_bit <= 1'b0;
	counter <= 4'b0000;
	end

	if ((counter == 4'b1111) & (!start_bit) & (Bit < NBits))	//We make 8 loops and we read all 8 bits
	begin
	Bit <= Bit+1;
	Read_data <= {Rx,Read_data[7:1]};
	counter <= 4'b0000;
	end
	
	if ((counter == 4'b1111) & (Bit == NBits)  & (Rx))		// detect the stop bit (Rx input must be high)
	begin
	Bit <= 4'b0000;
	RxDone <= 1'b1;
	counter <= 4'b0000;
	start_bit <= 1'b1;						
	end
	end
	
	

end


//Output assign
always @ (posedge Clk)
begin

if (NBits == 4'b1000)
begin
RxData[7:0] <= Read_data[7:0];	
end

if (NBits == 4'b0111)
begin
RxData[7:0] <= {1'b0,Read_data[7:1]};	
end

if (NBits == 4'b0110)
begin
RxData[7:0] <= {1'b0,1'b0,Read_data[7:2]};	
end
end




endmodule
