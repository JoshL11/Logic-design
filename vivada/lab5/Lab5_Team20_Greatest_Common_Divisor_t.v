`timescale 1ns / 1ps

module Lab5_Team20_Greatest_Common_Divisor_t();
reg clk, rst_n;
reg start;
reg [15:0] a;
reg [15:0] b;
wire done;
wire [15:0] gcd;
always#(5) clk=~clk;
Greatest_Common_Divisor GCD(clk, rst_n, start, a, b, done, gcd);
initial begin
    clk=0;
    rst_n=0;
    start=0;
    a=0;
    b=0;
    @(negedge clk)begin
        rst_n=1;
        a=16'd100;
        b=16'd15;
    end
    @(negedge clk)begin
        start=1;
    end
    @(negedge clk)begin
        start=0;
    end
    @(negedge clk)begin
        a=16'd30;
        b=16'd20;
    end
    @(negedge done)begin
        a=16'd27;
        b=16'd174;
    end
    @(negedge clk)begin
        start=1;
    end
    @(negedge clk)begin
        start=0;
    end
    @(negedge done)begin
        a=16'd50;
        b=16'd25;
        start=1;
    end
    @(negedge done)
    #10 $finish;
end
endmodule
