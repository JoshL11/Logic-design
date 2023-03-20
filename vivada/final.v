`timescale 1ns/1ps


module takeoff(in,out,clk,sw);
input in, sw, clk;
reg [23:0] cnt;
output reg out;
always@(posedge clk) begin
    cnt<=cnt+1;
end

always@*begin
    if(cnt[23]==1 && sw == 0) out=1;
    else if(sw == 1)out=in;
    else out = 0;
end

endmodule

