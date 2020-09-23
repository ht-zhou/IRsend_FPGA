module tiaozhi(clk,wave_out);
input clk;
output reg wave_out;

reg state;
reg [10:0]cnt ;
initial
begin
	cnt<=0;
	wave_out<=0;
	state <=1;
end

always@(posedge clk)
begin
	cnt<=cnt+1;
	if(state==1&&cnt==120)
	begin
		cnt<=0;
		wave_out<=~wave_out;
		state<=0;
	end
	else if(state==0&&cnt==1200)
	begin
		cnt<=0;
		wave_out<=~wave_out;
		state<=1;
	end
end
endmodule
