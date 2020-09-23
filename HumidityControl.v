module HumidityControl(clk, rxDone, rxData, outControl);

input rxDone;
input [7:0] rxData;
input clk;

output reg outControl;
reg [25:0] counter;
reg state;
reg finish;

initial 
begin
	outControl <= 1'b0;
	counter <= 26'd0;
	state <= 1'b0;
	finish <= 1'b0;
end

always @ (posedge clk)
begin
	if(state == 1'b1)
	begin
	if(counter < 26'd50000000)
		begin
		counter <= counter + 1;
		finish <= 1'b0;
		end
	else
		begin
		counter <= 26'd0;
		finish <= 1'b1;
		end
	end
	else
	begin
		counter <= 26'd0;
		finish <= 1'b0;
	end
end

always @ (posedge rxDone or posedge finish)
begin
	if (finish)
	begin 
		state <= 1'b0;
		outControl <= 1'b0;
	end
	else if (rxData == 8'd54)
	begin
		state <= 1'b1;
		outControl <= 1'b1;
	end
	else
	begin 
		state <= 1'b0;
		outControl <= 1'b0;
	end
end


endmodule