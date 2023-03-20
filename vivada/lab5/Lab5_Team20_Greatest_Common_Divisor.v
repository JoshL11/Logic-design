`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
reg done;
reg flag;
reg[15:0] gcd;
reg cnt;
reg[1:0] state;
reg[1:0] next_state;
reg[15:0] buffer_a,buffer_b,next_buffer_a,next_buffer_b;
reg[15:0] t;


always@(posedge clk)begin
    if(!rst_n) state<=WAIT;
    else state<=next_state;
end

always@(posedge clk)begin
    if(!rst_n)begin
        buffer_a<=0;
        buffer_b<=0;
    end
    else begin
        buffer_a<=next_buffer_a;
        buffer_b<=next_buffer_b;
    end
end

always@(posedge clk)begin
    if(state!=FINISH) cnt<=0;
    else cnt<=cnt+1;
end

always@(*)begin
    case(state)
    WAIT:begin
        done=0;
        gcd=0;
        if(start) begin
            next_buffer_a=(a>b)?a:b;
            next_buffer_b=(a>b)?b:a;
            next_state=CAL;
        end else begin
            next_state=WAIT;
        end   
    end
    CAL:begin
        done=0;
        gcd=0;
        if(buffer_a != buffer_b)begin
            t=buffer_a - buffer_b;
            next_buffer_a=(t>buffer_b)?t:buffer_b; 
            next_buffer_b=(t>buffer_b)?buffer_b:t;
        end else begin
            t=t+0;
            next_buffer_a=next_buffer_a+0;
            next_buffer_b=next_buffer_b+0;
        end
        if(buffer_a != buffer_b) next_state=CAL;
        else next_state=FINISH;
    end
    FINISH:begin
        gcd=buffer_a;
        done=1;
        if(cnt==1) next_state=WAIT;
        else next_state=FINISH;
    end
    default:begin end
    endcase
end

endmodule
