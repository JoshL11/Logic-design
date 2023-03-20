`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output reg [7:0] dout;
wire [6:0] addr[3:0];
wire [3:0] w,r;
wire [7:0] wout[3:0];

reg [10:0] r_addr;
assign w[0] = wen && ~waddr[10] && ~waddr[9]; 
assign w[1] = wen && ~waddr[10] && waddr[9];
assign w[2] = wen && waddr[10] && ~waddr[9]; 
assign w[3] = wen && waddr[10] && waddr[9];

assign r[0] = ren && ~raddr[10] && ~raddr[9]; 
assign r[1] = ren && ~raddr[10] && raddr[9];
assign r[2] = ren && raddr[10] && ~raddr[9]; 
assign r[3] = ren && raddr[10] && raddr[9];

Bank b1(clk, r[0], w[0], waddr, raddr, din, wout[0]);
Bank b2(clk, r[1], w[1], waddr, raddr, din, wout[1]);
Bank b3(clk, r[2], w[2], waddr, raddr, din, wout[2]);
Bank b4(clk, r[3], w[3], waddr, raddr, din, wout[3]);



always @(posedge clk) begin
    r_addr <= raddr;
end
always @(*) begin
    if(r_addr[10:9] == 0) dout = wout[0];
    else if(r_addr[10:9] == 1) dout = wout[1];
    else if(r_addr[10:9]== 2) dout = wout[2];
    else if(r_addr[10:9] == 3) dout = wout[3];
    else dout = 8'b00000000;
end

endmodule





module Bank(clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output reg [7:0] dout;
wire [7:0] wout[3:0];

wire [6:0] addr[3:0];
wire [3:0] w,r;

reg [10:0] r_addr;

assign w[0] = wen && ~waddr[8] && ~waddr[7]; 
assign w[1] = wen && ~waddr[8] && waddr[7];
assign w[2] = wen && waddr[8] && ~waddr[7]; 
assign w[3] = wen && waddr[8] && waddr[7];

assign r[0] = ren && ~raddr[8] && ~raddr[7]; 
assign r[1] = ren && ~raddr[8] && raddr[7];
assign r[2] = ren && raddr[8] && ~raddr[7]; 
assign r[3] = ren && raddr[8] && raddr[7];


assign addr[0] = (r[0]) ? raddr[6:0] : waddr[6:0];
assign addr[1] = (r[1]) ? raddr[6:0] : waddr[6:0];
assign addr[2] = (r[2]) ? raddr[6:0] : waddr[6:0];
assign addr[3] = (r[3]) ? raddr[6:0] : waddr[6:0]; 

Memory m1(clk, r[0], w[0], addr[0], din, wout[0]);
Memory m2(clk, r[1], w[1], addr[1], din, wout[1]);
Memory m3(clk, r[2], w[2], addr[2], din, wout[2]);
Memory m4(clk, r[3], w[3], addr[3], din, wout[3]);




always @(posedge clk) begin
    r_addr <= raddr;
end
always @(*) begin
    if(r_addr[8:7] == 0) dout = wout[0];
    else if(r_addr[8:7] == 1) dout = wout[1];
    else if(r_addr[8:7]== 2) dout = wout[2];
    else if(r_addr[8:7] == 3) dout = wout[3];
    else dout = 8'b00000000;
end


endmodule

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output [7:0] dout;

reg [7:0] mem[127:0];
reg [7:0] dout;


always @(posedge clk) begin
    if(ren == 1'b1 ) 
    begin
        dout <= mem[addr];
    end
    
    else  if(wen == 1'b1 )begin
        mem[addr] <= din;
        dout <= 8'b0;
     end
     else dout <= 0;
end




endmodule