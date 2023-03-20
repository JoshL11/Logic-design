`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;
reg dclk;
div_3 d0(clk,rst_n,clk1_3);
div_2 d1(clk,rst_n,clk1_2);
div_4 d2(clk,rst_n,clk1_4);
div_8 d3(clk,rst_n,clk1_8);
always@(posedge clk) begin
    if(sel==2'b00) assign dclk = clk1_3;
    else if(sel==2'b01) assign dclk = clk1_2;
    else if(sel==2'b10) assign dclk = clk1_4;
    else assign dclk = clk1_8;
end


endmodule

module div_2(clk,rst_n,o_clk);
input clk, rst_n;
output reg o_clk;
reg cnt;

always@(posedge clk) begin
   if (!rst_n)
     cnt <= 1'b0;
   else if (cnt == 1'b1) // 0 ~ 1
     cnt <= 1'b0;
   else
     cnt <= cnt + 1'b1;
 end
  
 always@(posedge clk) begin
   if (!rst_n)
     o_clk <= 0;
   else if (cnt == 1'b0) // 0
     o_clk <= 1;
   else              // 1
     o_clk <= 0;
end
endmodule

module div_4(clk,rst_n,o_clk);
input clk,rst_n;
output reg o_clk;
reg [1:0] cnt;

always@(posedge clk) begin
    if(!rst_n) cnt<=2'b00;
    else if(cnt==2'b11) cnt<=2'b00;
    else cnt<=cnt+2'b01;
end
always@(posedge clk) begin
  if (!rst_n)
   o_clk <= 0;
  else if (cnt==2'b0)          // 2 ~ 3
   o_clk <= 1;   
  else
   o_clk<=0;
end
endmodule

module div_8(clk,rst_n,o_clk);
input clk,rst_n;
output reg o_clk;
reg [2:0] cnt;

always@(posedge clk) begin
    if(!rst_n) cnt<=3'b000;
    else if(cnt==3'b111) cnt<=3'b000;
    else cnt<=cnt+3'b001;
end
always@(posedge clk) begin
  if (!rst_n)
   o_clk <= 0;
  else if (cnt ==3'b000) // 0 ~ 1
   o_clk <= 1; 
  else
   o_clk<=0;
end
endmodule

module div_3(clk,rst_n,o_clk);
input clk,rst_n;
output reg o_clk;
reg [1:0] cnt=2'b00;

always@(posedge clk) begin
    if(!rst_n) cnt<=2'b00;
    else if(cnt==2'b10) cnt<=2'b00;
    else cnt<=cnt+2'b01;
end
always@(posedge clk) begin
  if (!rst_n)
   o_clk <= 0;
  else if (cnt==2'b00)          // 2 ~ 3
   o_clk <= 1;   
  else
   o_clk<=0;
end
endmodule