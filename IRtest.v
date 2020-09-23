module IRtest(clk,enable,conduct,ir_send);

	parameter SJQ = 4'b0001 ;  //S9000
	parameter SSQW = 4'b0010; //S4500
	parameter SQLY = 4'b0011; //S7001
	parameter SQLE = 4'b0100; //S7002
	parameter SLOW =  4'b0110; //SLOW
	parameter SLW = 4'b0111;   //S20000
	parameter Skong = 4'b0000; //Skong
	parameter SIDLE  = 4'b1000; //idle


	input clk ;
	input enable;
	input [2:0]conduct ;//000->idle;001->open;002->close;003->up;004->down//

	output reg ir_send;

	reg clk_r;
	reg [2:0]conductreg;//000->idle;001->open;002->close;003->up;004->down//
	reg [11:0] clk_r_cnt;
	reg [15:0] cnt_time;
	reg [7:0] cnt_num;
	reg [3:0]state;
	reg [3:0]uptemp;
	reg [3:0]downtemp;
	reg [66:0]senddata;
	reg idle;
	reg temp;

	reg [66:0]close;
	reg [66:0]open;
	reg [66:0]zero;
	reg [66:0]sixteen;//16
	reg [66:0]seventeen;//17
	reg [66:0]eighteen;//18.etc
	reg [66:0]nineteen;
	reg [66:0]twenty;
	reg [66:0]twentyone;
	reg [66:0]twentytwo;
	reg [66:0]twentythr;
	reg [66:0]twentyfor;
	reg [66:0]twentyfif;
	reg [66:0]twentysix;
	reg [66:0]twentysev;
	reg [66:0]twentyeig;
	reg [66:0]twentynin;
	reg [66:0]thirty;

	initial 
	begin
	close     =67'b1000_0010_0101_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0001;
	open      =67'b1001_0010_0101_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0000;
	senddata  =67'b0000_0010_0000_0000_0000_0000_0000_0000_000_0000_1000_0000_0000_0000_0000_0000_0000;
	zero      =67'b0000_0010_0000_0000_0000_0000_0000_0000_000_0000_1000_0000_0000_0000_0000_0000_0000;

	sixteen   =67'b1001_0010_0000_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0110;
	seventeen =67'b1001_0010_1000_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1110;
	eighteen  =67'b1001_0010_0100_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0001;
	nineteen  =67'b1001_0010_1100_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1001;
	twenty    =67'b1001_0010_0010_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0101;
	twentyone =67'b1001_0010_1010_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1101;
	twentytwo =67'b1001_0010_0110_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0011;
	twentythr =67'b1001_0010_1110_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1011;
	twentyfor =67'b1001_0010_0001_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0111;
	twentyfif =67'b1001_0010_1001_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1111;
	twentysix =67'b1001_0010_0101_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0000;
	twentysev =67'b1001_0010_1101_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1000;
	twentyeig =67'b1001_0010_0011_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0100;
	twentynin =67'b1001_0010_1011_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_1100;
	thirty    =67'b1001_0010_0111_0000_0000_0100_0000_1010_010_0000_1000_0000_0100_0000_0000_0000_0010;


	state=4'b0000;
	cnt_time=16'b0;
	cnt_num=8'b0;
	clk_r=0;
	clk_r_cnt=12'b0;
	idle = 1;
	ir_send=0;
	conductreg=0;
	uptemp=0;
	downtemp=0;
	temp =0;
	end
	
	always@(posedge clk )
	begin
		if(clk_r_cnt==660)
		begin
			clk_r <= ~clk_r;
			clk_r_cnt <= 12'b0;
		end
		else clk_r_cnt <= clk_r_cnt+1;
	end
	
	always@(posedge enable)
	begin
		if(conduct!=0)
		conductreg <= conduct;
	end
	
	always@(negedge enable)
	begin
		if(conductreg==3&&(uptemp<downtemp||uptemp-downtemp<4))uptemp<=uptemp+1;
		else if (conductreg==4&&(downtemp<uptemp||downtemp-uptemp<10))downtemp<=downtemp+1;
		else if (conductreg==2)
		begin
			downtemp<=0;
			uptemp<=0;
		end
	end
	
	always@(posedge clk_r)
	begin
		if(enable==1)temp<=1;
		if(conductreg==1&&temp!=0)senddata<=open;
		else if(conductreg==2&&temp!=0)
		begin
			senddata<=close;
		end
		else if(conductreg==3&&temp!=0)
		begin
			if(uptemp==downtemp)senddata<=twentysix;
			else if(uptemp>downtemp)
			begin
				case(uptemp-downtemp)
				4'b0001:senddata<=twentysev;
				4'b0010:senddata<=twentyeig;
				4'b0011:senddata<=twentynin;
				4'b0100:senddata<=thirty;
				default:senddata<=thirty;
				endcase
			end
			else if(downtemp>uptemp)
			begin
				case(downtemp-uptemp)
				4'b0001:senddata<=twentyfif;
				4'b0010:senddata<=twentyfor;
				4'b0011:senddata<=twentythr;
				4'b0100:senddata<=twentytwo;
				4'b0101:senddata<=twentyone;
				4'b0110:senddata<=twenty;
				4'b0111:senddata<=nineteen;
				4'b1000:senddata<=eighteen;
				4'b1001:senddata<=seventeen;
				4'b1010:senddata<=sixteen;
				default:senddata<=sixteen;
				endcase
			end
			
		end
		else if(conductreg==4&&temp!=0)
		begin
			if(uptemp==downtemp)senddata<=twentysix;
			else if(uptemp>downtemp)
			begin
				case(uptemp-downtemp)
				4'b0001:senddata<=twentysev;
				4'b0010:senddata<=twentyeig;
				4'b0011:senddata<=twentynin;
				4'b0100:senddata<=thirty;
				default:senddata<=thirty;
				endcase
			end
			else if(downtemp>uptemp)
			begin
				case(downtemp-uptemp)
				4'b0001:senddata<=twentyfif;
				4'b0010:senddata<=twentyfor;
				4'b0011:senddata<=twentythr;
				4'b0100:senddata<=twentytwo;
				4'b0101:senddata<=twentyone;
				4'b0110:senddata<=twenty;
				4'b0111:senddata<=nineteen;
				4'b1000:senddata<=eighteen;
				4'b1001:senddata<=seventeen;
				4'b1010:senddata<=sixteen;
				default:senddata<=sixteen;
				endcase
			end
			
		end

		if((conductreg!=0)&&(senddata!=zero))//start
		begin
			case(state)
				Skong:
				begin
					state <= SJQ;
					ir_send<=1;
					idle<=0;
				end

				SJQ:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==337)
					begin
						cnt_time<=0;
						ir_send<=0;
						state<=SSQW;
					end
				end

				SSQW:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==170)
					begin
						cnt_time<=0;
						ir_send<=1;
						state<=SQLY;
					end
				end

				SQLY:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==23)
					begin
						if(cnt_num==67)
						begin
							cnt_num<=0;
							cnt_time<=0;
							ir_send<=0;
							state<=SIDLE;
							idle<=1;
							senddata<=67'b0000_0000_0000_0000_0000_0000_0000_0000_000_0000_0000_0000_0000_0000_0000_0000_0000;
							temp <=0;
						end
						else
						begin
							cnt_time<=0;
							ir_send<=0;
							state<=SLOW;
							cnt_num<=cnt_num+1;
						end
					end
				end

				SLOW:
				begin
					if(senddata[67-cnt_num]==1)
					begin
						cnt_time<=cnt_time+1;
						if(cnt_time==62)
						begin
							cnt_time<=0;
							ir_send<=1;
							if(cnt_num == 35)
							state<=SQLE;
							else state<=SQLY;
						end
					end
					else if(senddata[67-cnt_num]==0)
					begin
						cnt_time<=cnt_time+1;
						if(cnt_time==20)
						begin
							cnt_time<=0;
							ir_send<=1;
							if(cnt_num == 35)
							state<=SQLE;
							else state<=SQLY;
						end
					end
				end

				SQLE:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==23)
					begin
						cnt_time<=0;
						ir_send<=0;
						state<=SLW;
					end
				end

				SLW:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==759)
					begin
						cnt_time<=0;
						ir_send<=1;
						state<=SQLY;
					end
				end
				
				SIDLE:
				begin
					cnt_time<=cnt_time+1;
					if(cnt_time==20000)
					begin
						cnt_time<=0;
						state<=Skong;
					end
				end

				default;
			endcase
		end
	end
endmodule
