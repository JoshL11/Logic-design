`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/04 22:04:35
// Design Name: 
// Module Name: Lab4_Team20_Content_Addressable_Memory_t
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


module Lab4_Team20_Content_Addressable_Memory_t();
reg clk;
reg wen, ren;
reg [7:0] din;
reg [3:0] addr;
wire [3:0] dout;
wire hit;
always#(5) clk=~clk;
Content_Addressable_Memory CAM(clk, wen, ren, din, addr, dout, hit);
initial begin
    clk=0;
    wen=0;
    ren=0;
    din=0;
    addr=0;
    @(negedge clk)begin
        wen=1;
        din=8'b11111111;
    end
    @(negedge clk)begin
        addr=4'b0001;
    end
    @(negedge clk)begin
        addr=4'b0010;
        din=8'b00000001;
    end
    @(negedge clk)begin
        ren=1;
        din=8'b11111111;
    end
    @(negedge clk)begin
        din=8'b00000001;
    end
    @(negedge clk)begin
        din=8'b11110000;
    end 
    @(negedge clk)begin
        ren=0;
        wen=0;
    end
    @(negedge clk)begin
        $finish;
    end
end
endmodule
