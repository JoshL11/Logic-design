`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

reg [3:0] dout;
reg hit;

reg [7:0] CAM [15:0];
reg [15:0] CAM_eq_din;
wire [3:0] next_dout;
wire next_hit;

genvar lineidx;
generate
    for(lineidx = 0; lineidx < 16; lineidx = lineidx + 1) begin
        always @(*) begin
            if(CAM[lineidx] == din) CAM_eq_din[lineidx] = 1'b1;
            else CAM_eq_din[lineidx] = 1'b0;
        end
    end
endgenerate

Priority_Encoder module_pe(CAM_eq_din, next_dout, next_hit);

always @(posedge clk ) begin
    if(ren) begin // MUX of ren
        dout <= next_dout;
        hit <= next_hit;
    end else begin
        dout <= 4'b0;
        hit <= 1'b0;
        if(wen) begin // MUX of wen
            CAM[addr] <= din;
        end else begin
            CAM[addr] <= CAM[addr];
        end       
    end
end
endmodule

module Priority_Encoder (in, out, hit);
input [15:0]        in;
output reg [3:0]    out;
output reg          hit;

always @(*) begin
    casex (in)
        16'b1XXX_XXXX_XXXX_XXXX : out = 4'd15;
        16'bX1XX_XXXX_XXXX_XXXX : out = 4'd14;
        16'bXX1X_XXXX_XXXX_XXXX : out = 4'd13;
        16'bXXX1_XXXX_XXXX_XXXX : out = 4'd12;
        16'bXXXX_1XXX_XXXX_XXXX : out = 4'd11;
        16'bXXXX_X1XX_XXXX_XXXX : out = 4'd10;
        16'bXXXX_XX1X_XXXX_XXXX : out = 4'd09;
        16'bXXXX_XXX1_XXXX_XXXX : out = 4'd08;
        16'bXXXX_XXXX_1XXX_XXXX : out = 4'd07;
        16'bXXXX_XXXX_X1XX_XXXX : out = 4'd06;
        16'bXXXX_XXXX_XX1X_XXXX : out = 4'd05;
        16'bXXXX_XXXX_XXX1_XXXX : out = 4'd04;
        16'bXXXX_XXXX_XXXX_1XXX : out = 4'd03;
        16'bXXXX_XXXX_XXXX_X1XX : out = 4'd02;
        16'bXXXX_XXXX_XXXX_XX1X : out = 4'd01;
        16'bXXXX_XXXX_XXXX_XXX1 : out = 4'd00;
        default: out = 4'd0;
    endcase

    if(in == 16'b0) hit = 1'b0;
    else hit = 1'b1;
end
endmodule