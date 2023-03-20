`timescale 1ns/1ps

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
