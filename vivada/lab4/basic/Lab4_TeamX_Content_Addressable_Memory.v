


module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out,dff);
input clk;
input rst_n;
input scan_in;
input scan_en;
output reg scan_out;
output reg [7:0] dff;

reg [7:0] p;
reg [3:0] a,b;

always@(posedge clk) begin
    if(!rst_n) begin
        dff[7:0] <= 8'd00000000;
        a[3:0] <= 4'b0000;
        b[3:0] <= 4'b0000;
        p[7:0] <= 8'b00000000;
    end
    else begin
        if(scan_en) begin
            dff[0] <= scan_in;
            dff[1] <= dff[0];
            dff[2] <= dff[1];
            dff[3] <= dff[2];
            dff[4] <= dff[3];
            dff[5] <= dff[4];
            dff[6] <= dff[5];
            dff[7] <= dff[6];   
            scan_out <= dff[7];
        end
        else begin
            dff[7] <= p[0];
            dff[6] <= p[1];
            dff[5] <= p[2];
            dff[4] <= p[3];
            dff[3] <= p[4];
            dff[2] <= p[5];
            dff[1] <= p[6];
            dff[0] <= p[7];
        end
    end
end
always@(*) begin
    if(scan_en == 0) begin
        p = a * b;
    end
    else begin
        a[3] = dff[0];
        a[2] = dff[1];
        a[1] = dff[2];
        a[0] = dff[3];
        b[3] = dff[4];
        b[2] = dff[5];
        b[1] = dff[6];
        b[0] = dff[7];
    end
end
endmodule

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