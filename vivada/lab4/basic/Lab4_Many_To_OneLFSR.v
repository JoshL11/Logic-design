`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
reg [7:0] DFF;
always @(posedge clk) begin
    if(rst_n == 0) out <= 8'b10111101;
    else out <= DFF;
end

always @(*) begin
    DFF[7] = out[6];
    DFF[6] = out[5];
    DFF[5] = out[4];
    DFF[4] = out[3];
    DFF[3] = out[2];
    DFF[2] = out[1];
    DFF[1] = out[0];
    DFF[0] = (out[1]^out[2]) ^ (out[3] ^ out[7]);
end

endmodule

