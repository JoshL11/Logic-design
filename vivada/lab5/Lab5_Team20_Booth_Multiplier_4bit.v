`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output signed [7:0] p;
parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
reg signed[7:0] p;
reg[1:0] state,next_state;
reg[3:0]cur_a,cur_b;
reg[3:0]Q;
reg[1:0]cnt;
reg Q_last,flag;
reg [8:0] ans;
wire signed [7:0] out;
assign out=ans[8:1];
always@(posedge clk)begin
    flag<=0;
    if(!rst_n) state<=WAIT;
    else state<=next_state;
end

always@(posedge clk)begin
    if(state!=CAL) cnt=2'b00;
    else cnt<=cnt+2'b01;
end

always@*begin
    case(state)
    WAIT: p=0;
    CAL: p=0;
    FINISH:begin
        if(cur_a==-4'd8) p=-out;
        else p=out;
    end
    default:begin end
    endcase
end

always@*begin
    case(state)
    WAIT:begin
        if(start)begin
            cur_a=a;
            cur_b=b;
            ans={4'b0000,cur_b,1'b0};
            next_state=CAL;
        end
        else next_state=WAIT;
    end
    CAL:begin
        if(cnt==2'b11) next_state=FINISH;
        else next_state=CAL;
            if(!flag)begin
                flag=1;
                case(ans[1:0])
                2'b00:begin
                    ans={ans[8],ans[8:1]};
                end
                2'b01:begin
                    ans[8:5]=ans[8:5]+cur_a;
                    ans={ans[8],ans[8:1]};
                end
                2'b10:begin
                    ans[8:5]=ans[8:5]-cur_a;
                    ans={ans[8],ans[8:1]};
                end
                2'b11: ans={ans[8],ans[8:1]};
                default:begin end
                endcase
            end
    end
    FINISH: next_state=WAIT;
    default:begin end
    endcase
end
endmodule
