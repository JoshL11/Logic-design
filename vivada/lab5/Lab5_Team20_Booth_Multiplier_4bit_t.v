`timescale 1ns / 1ps
module Lab5_Team20_Booth_Multiplier_4bit_t();
reg clk;
reg rst_n; 
reg start;
reg signed [3:0] a, b;
wire signed [7:0] p;
always#(5) clk=~clk;
Booth_Multiplier_4bit test0(clk, rst_n, start, a, b, p);
initial begin
    clk=0;
    rst_n=0;
    start=0;
    a=-4'd8;b=-4'd8;
    @(negedge clk) rst_n=1;
    repeat(3)begin
        @(negedge clk)begin
            start=1;
        end
        @(negedge clk)begin
            start=0;
        end
        repeat(5)begin
            @(negedge clk);
        end
        b=b+4'd3;
    end
    b=4'd4;
    repeat(4)begin
        @(negedge clk)begin
            start=1;
        end
        @(negedge clk)begin
            start=0;
        end
        repeat(5)begin
            @(negedge clk);
        end
        a=a+4'd2;
    end
    $finish;
end
endmodule
