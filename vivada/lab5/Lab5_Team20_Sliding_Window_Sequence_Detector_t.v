`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;

parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;
Sliding_Window_Sequence_Detector SWSD(
    .clk(clk),
    .rst_n(rst_n),
    .in(in),
    .dec(dec)
);

initial begin
    #1 rst_n = 1'b0;
    #1 rst_n = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1; //11001001
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1; //110010101001
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1; //110001001
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;//10101010
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1; //1011010101
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1; //1111001001
    @(negedge clk)
    $finish;
end
endmodule