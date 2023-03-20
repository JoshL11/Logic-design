`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;
Many_To_One_LFSR M1(clk, rst_n, scan_in);

Scan_Chain_Design Sc(clk, rst_n, scan_in, scan_en, scan_out);

endmodule




module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output  scan_out;
reg [7:0] dff;
reg scan_out;

wire [7:0] p;
wire [3:0] a,b;

always@(posedge clk) begin
    if(!rst_n) begin
        dff[7:0] <= 8'd00000000;
        
    end
    else begin
        if(scan_en) begin
            dff[7] <= scan_in;
            dff[0] <= dff[1];   
            dff[1] <= dff[2];
            dff[2] <= dff[3];
            dff[3] <= dff[4];
            dff[4] <= dff[5];
            dff[5] <= dff[6];
            dff[6] <= dff[7];
            scan_out <= dff[1];
        end
        else begin
            scan_out <= p[0];
            dff[7:0] <= p[7:0];
        end
    end
end

assign b = dff[3:0];
assign a = dff[7:4];
assign p = a*b;


endmodule


module Many_To_One_LFSR(clk, rst_n, temp);
input clk;
input rst_n;
reg [7:0] out;
output temp;
reg [7:0] DFF;



always @(posedge clk) begin
    if(rst_n == 0) begin
        out <= 8'b10111101;
        //DFF <= 8'b10111101;
    end
    else begin
        out <= DFF;
    end
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
assign temp = out[7];
endmodule
