`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;
wire w,e,r,y,nw,nt,nq,f;

and and1(w,q,t);
not not1(nt,t);
not not2(nq,q);
and and2(e,nt,nq);
or or1(r,w,e);
not not3(y,r);

and and3(f,y,rst_n);
D_Flip_Flop d1(clk,f,q);


endmodule


module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;
wire revclk,temp;

not not1(revclk,clk);

D_Latch d1(revclk,d,temp);

D_Latch d2(clk,temp,q);
endmodule

module D_Latch (e, d, q);
input e;
input d;
output q;

wire nd,top,down,nq;
not not1(nd,d);
nand nand1(top,e,d);
nand nand2(down,e,nd);
nand nand3(q,nq,top);
nand nand4(nq,q,down);

endmodule