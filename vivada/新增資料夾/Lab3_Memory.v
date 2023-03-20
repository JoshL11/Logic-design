`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output [7:0] dout;

reg [7:0] mem[127:0];
reg [7:0] dout;
wire [7:0] out;


always @(negedge clk) begin
    if(ren == 1'b1 ) 
    begin
        dout <= mem[addr];
    end
    
    else  if(wen == 1'b1 )begin
        mem[addr] = din;
        dout <= 8'b0;
     end
     else dout <= 8'b0;
end




endmodule
