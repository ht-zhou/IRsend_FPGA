module Translater(clk, rxDone, RxData, Enable, Conduct);

input clk;
input [7:0] RxData;
input rxDone;
output reg Enable;
output reg [2:0] Conduct;

reg [10:0] counter;
reg state;
reg finish;

initial 
begin
	Enable <= 1'b0;
	counter <= 11'd0;
	state <= 1'b0;
	finish <= 1'b0;
	Conduct <= 3'b000;
end

always @ (posedge clk)
begin
	if(state == 1'b1)
	begin
	if(counter < 11'd2000)
		begin
		counter <= counter + 1;
		finish <= 1'b0;
		end
	else
		begin
		counter <= 11'd0;
		finish <= 1'b1;
		end
	end
	else
	begin
		counter <= 11'd0;
		finish <= 1'b0;
	end
end

always @ (posedge rxDone or posedge finish)
begin
	if (finish)
	begin 
		state <= 1'b0;
		Enable <= 1'b0;
		Conduct <= 3'b000;
	end
	else if (RxData == 8'd55)
	begin
		state <= 1'b1;
		Enable <= 1'b1;
		Conduct <= 3'b001;
	end
	else if (RxData == 8'd56)
	begin
		state <= 1'b1;
		Enable <= 1'b1;
		Conduct <= 3'b010;
	end
	else if (RxData == 8'd99)
	begin
		state <= 1'b1;
		Enable <= 1'b1;
		Conduct <= 3'b011;
	end
	else if (RxData == 8'd100)
	begin
		state <= 1'b1;
		Enable <= 1'b1;
		Conduct <= 3'b100;
	end
	else
	begin 
		state <= 1'b0;
		Enable <= 1'b0;
		Conduct <= 3'b000;
	end
end


endmodule