`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 16:33:47
// Design Name: 
// Module Name: Lab4_Team20_Mealy_Sequence_Detector_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab4_Team20_Mealy_Sequence_Detector_t();
reg clk, rst_n;
reg in;
wire dec;
always#(5) clk=~clk;
Mealy_Sequence_Detector fuck(clk, rst_n, in, dec);
initial begin
    clk=1;
    rst_n=0;
    in=0;
    @(negedge clk) rst_n=1;
    #10 in=1;
    #30 in=0;
    #10 in=1;
    #20 in=0;
    #10 in=1;
    #10 in=0;
    #20 in=1;
    #10 in=1;
    #30 in=0;
    #25 $finish;
end
endmodule
