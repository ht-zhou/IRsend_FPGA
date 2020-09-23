module freq(clk,clk_out);
input clk;
output reg clk_out;

reg [10:0]cnt ;
initial
begin
	cnt<=0;
	clk_out<=0;
end

always@(posedge clk)
begin
	cnt<=cnt+1;
	if(cnt==660)
	begin
		cnt<=0;
		clk_out<=~clk_out;
	end
end
endmodule
