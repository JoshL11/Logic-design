`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, AN, seg5);
input [3:0] rs, rt;
input [2:0] sel;

output [3:0] AN;
output [6:0] seg5;
wire [3:0] sel_bar;
wire [7:0] after_sel;
wire [3:0] out0,out1,out2,out3,out4,out5;
wire [3:0] f0,f1,f2,f3,f4,f5,f6,f7;
wire [3:0] rd;
wire out6,out7;
wire [15:0] out;
wire [6:0] seg;
new_not n1(sel[0],sel_bar[0]);
new_not n2(sel[1],sel_bar[1]);
new_not n3(sel[2],sel_bar[2]);
new_and3in a0(sel_bar[2],sel_bar[1],sel_bar[0],after_sel[0]);
new_and3in a1(sel_bar[2],sel_bar[1],sel[0],after_sel[1]);
new_and3in a2(sel_bar[2],sel[1],sel_bar[0],after_sel[2]);
new_and3in a3(sel_bar[2],sel[1],sel[0],after_sel[3]);
new_and3in a4(sel[2],sel_bar[1],sel_bar[0],after_sel[4]);
new_and3in a5(sel[2],sel_bar[1],sel[0],after_sel[5]);
new_and3in a6(sel[2],sel[1],sel_bar[0],after_sel[6]);
new_and3in a7(sel[2],sel[1],sel[0],after_sel[7]);

adder4bit sel_0(rs,rt,0,out0);
adder4bit sel_1(rs,rt,1,out1);
and4bit sel_2(rs,rt,out2);
or4bit sel_3(rs,rt,out3);
leftshift sel_4(rs,rt,out4);
rightshift sel_5(rs,rt,out5);
equal_comparator sel_6(rs,rt,out6);
bigger_comparator sel_7(rs,rt,out7);

select s0(after_sel[0],out0[0],out0[1],out0[2],out0[3],f0);
select s1(after_sel[1],out1[0],out1[1],out1[2],out1[3],f1);
select s2(after_sel[2],out2[0],out2[1],out2[2],out2[3],f2);
select s3(after_sel[3],out3[0],out3[1],out3[2],out3[3],f3);
select s4(after_sel[4],out4[0],out4[1],out4[2],out4[3],f4);
select s5(after_sel[5],out5[0],out5[1],out5[2],out5[3],f5);
select s6(after_sel[6],out6,1,1,1,f6);
select s7(after_sel[7],out7,1,0,1,f7);

or8in o0(f0[0],f1[0],f2[0],f3[0],f4[0],f5[0],f6[0],f7[0],rd[0]);
or8in o1(f0[1],f1[1],f2[1],f3[1],f4[1],f5[1],f6[1],f7[1],rd[1]);
or8in o2(f0[2],f1[2],f2[2],f3[2],f4[2],f5[2],f6[2],f7[2],rd[2]);
or8in o3(f0[3],f1[3],f2[3],f3[3],f4[3],f5[3],f6[3],f7[3],rd[3]);

new_and(1,1,AN[3]);
new_and(1,1,AN[2]);
new_and(1,1,AN[1]);
new_and(0,0,AN[0]);

decorder_4x16 d1(rd,out);


wire t1,t2,t3,t4;
or8in o4(out[0],out[2],out[3],out[5],out[6],out[7],out[8],out[9],t1);
new_or4in o5(t1,out[10],out[12],out[14],t2);
new_or o6(t2,out[15],seg[0]);

or8in o7(out[0],out[1],out[2],out[3],out[4],out[7],out[8],out[9],t3);
new_or o8(t3,out[10],t4);
new_or o66(t4,out[13],seg[1]);
wire t5,t6,t7,t8,t9,t10;
or8in o44(out[0],out[1],out[3],out[5],out[6],out[7],out[8],out[9],t6);
new_or4in o55(t6,out[10],out[11],out[4],t10);
new_or o67(t10,out[13],seg[2]);

or8in o77(out[0],out[5],out[2],out[3],out[6],out[11],out[8],out[9],t7);
new_or o88(t7,out[12],t8);
new_or o68(t8,out[13],t9);
new_or o69(t9,out[14],seg[3]);
wire e1,e2,e3,e4,e5,e6,e7,e8;

or8in o79(out[0],out[6],out[2],out[10],out[11],out[12],out[8],out[13],e1);
new_or o84(e1,out[14],e2);
new_or o36(e2,out[15],seg[4]);


or8in o47(out[0],out[5],out[10],out[4],out[6],out[11],out[8],out[9],e3);
new_or o48(e3,out[15],e4);
new_or o56(e4,out[12],e5);
new_or o96(e5,out[14],seg[5]);

wire r1,r2,r3;
or8in o41(out[4],out[2],out[3],out[5],out[6],out[11],out[8],out[9],r1);
new_or4in o59(r1,out[10],out[13],out[14],r2);
new_or o16(r2,out[15],seg[6]);



new_not n146[6:0](seg,seg5);


endmodule

module decorder_4x16(rd,out);
input [3:0] rd;
output [15:0] out;
wire rd_bar0,rd_bar1,rd_bar2,rd_bar3;
new_not y1(rd[0],rd_bar0);
new_not y2(rd[1],rd_bar1);
new_not y3(rd[2],rd_bar2);
new_not y4(rd[3],rd_bar3);
new_and4in a751(rd_bar0,rd_bar1,rd_bar2,rd_bar3,out[0]);
new_and4in a11(rd[0],rd_bar1,rd_bar2,rd_bar3,out[1]);
new_and4in a12(rd_bar0,rd[1],rd_bar2,rd_bar3,out[2]);
new_and4in a13(rd[0],rd[1],rd_bar2,rd_bar3,out[3]);
new_and4in a14(rd_bar0,rd_bar1,rd[2],rd_bar3,out[4]);
new_and4in a15(rd[0],rd_bar1,rd[2],rd_bar3,out[5]);
new_and4in a16(rd_bar0,rd[1],rd[2],rd_bar3,out[6]);
new_and4in a17(rd[0],rd[1],rd[2],rd_bar3,out[7]);
new_and4in a18(rd_bar0,rd_bar1,rd_bar2,rd[3],out[8]);
new_and4in a19(rd[0],rd_bar1,rd_bar2,rd[3],out[9]);
new_and4in a21(rd_bar0,rd[1],rd_bar2,rd[3],out[10]);
new_and4in a31(rd[0],rd[1],rd_bar2,rd[3],out[11]);
new_and4in a41(rd_bar0,rd_bar1,rd[2],rd[3],out[12]);
new_and4in a51(rd[0],rd_bar1,rd[2],rd[3],out[13]);
new_and4in a61(rd_bar0,rd[1],rd[2],rd[3],out[14]);
new_and4in a71(rd[0],rd[1],rd[2],rd[3],out[15]);
endmodule


module select(sel,a,b,c,d,out);
input sel,a,b,c,d;
output [3:0] out;
new_and a1(sel,a,out[0]);
new_and a2(sel,b,out[1]);
new_and a3(sel,c,out[2]);
new_and a4(sel,d,out[3]);
endmodule

module uni_gate(a,b,out);
input a,b;
output out;
wire b_bar;
not n1(b_bar,b);
and a1(out,a,b_bar);
endmodule

module new_not(a,out);
input a;
output out;
uni_gate u1(1'b1,a,out);
endmodule

module new_and(a,b,out);
input a,b;
output out;
wire b_bar;
new_not n1(b,b_bar);
uni_gate u1(a,b_bar,out);
endmodule

module and4bit(a,b,out);
input [3:0] a,b;
output [3:0] out;
new_and a0(a[0],b[0],out[0]);
new_and a1(a[1],b[1],out[1]);
new_and a2(a[2],b[2],out[2]);
new_and a3(a[3],b[3],out[3]);
endmodule

module new_and4in(a,b,c,d,out);
input a,b,c,d;
output out;
wire o1,o2;
new_and a0(a,b,o1);
new_and a1(o1,c,o2);
new_and a2(o2,d,out);
endmodule

module new_and3in(a,b,c,out);
input a,b,c;
output out;
wire o1;
new_and a0(a,b,o1);
new_and a1(o1,c,out);
endmodule

module new_or(a,b,out);
inout a,b;
output out;
wire a_bar,o1;
new_not n1(a,a_bar);
uni_gate u1(a_bar,b,o1);
new_not n2(o1,out);
endmodule

module new_or4in(a,b,c,d,out);
input a,b,c,d;
output out;
wire o1,o2;
new_or a0(a,b,o1);
new_or a1(o1,c,o2);
new_or a2(o2,d,out);
endmodule

module or4bit(a,b,out);
input [3:0] a,b;
output [3:0] out;
new_or o0(a[0],b[0],out[0]);
new_or o1(a[1],b[1],out[1]);
new_or o2(a[2],b[2],out[2]);
new_or o3(a[3],b[3],out[3]);
endmodule

module or8in(a,b,c,d,e,f,g,h,out);
input a,b,c,d,e,f,g,h;
output out;
wire w0,w1,w2,w3,w4,w5;
new_or o0(a,b,w0);
new_or o1(c,d,w1);
new_or o2(e,f,w2);
new_or o3(g,h,w3);
new_or o4(w0,w1,w4);
new_or o5(w2,w3,w5);
new_or o6(w4,w5,out);
endmodule

module new_nand(a,b,out);
input a,b;
output out;
wire o1;
new_and na1(a,b,o1);
new_not n1(o1,out);
endmodule

module new_nor(a,b,out);
input a,b;
output out;
wire o1;
new_or no1(a,b,o1);
new_not n1(o1,out);
endmodule

module new_xor(a,b,out);
input a,b;
output out;
wire o1,o2,a_bar,b_bar;
new_not n1(a,a_bar);
new_not n2(b,b_bar);
new_and a1(a,b_bar,o1);
new_and a2(a_bar,b,o2);
new_or or1(o1,o2,out);
endmodule

module full_adder(a,b,cin,cout,sum);
input a,b,cin;
output cout,sum;
wire o1,o2,o3;
new_xor x1(a,b,o1);
new_xor x2(o1,cin,sum);
new_and a1(o1,cin,o2);
new_and a2(a,b,o3);
new_or or1(o2,o3,cout);
endmodule

module adder4bit(a,b,cin,sum);
input [3:0] a,b;
input cin;
output [3:0] sum;
wire [3:0] xor_b;
wire [3:0] c;
new_xor x0(cin,b[0],xor_b[0]);
new_xor x1(cin,b[1],xor_b[1]);
new_xor x2(cin,b[2],xor_b[2]);
new_xor x3(cin,b[3],xor_b[3]);
full_adder add0(a[0],xor_b[0],cin,c[0],sum[0]);
full_adder add1(a[1],xor_b[1],c[0],c[1],sum[1]);
full_adder add2(a[2],xor_b[2],c[1],c[2],sum[2]);
full_adder add3(a[3],xor_b[3],c[2],c[3],sum[3]);
endmodule

module leftshift(a,b,out);
input [3:0] a,b;
output [3:0] out;
new_and a1(a[2],1'b1,out[3]);
new_and a2(a[1],1'b1,out[2]);
new_and a3(a[0],1'b1,out[1]);
new_and a4(a[3],1'b1,out[0]);
endmodule

module rightshift(a,b,out);
input [3:0] a,b;
output [3:0] out;
new_and a1(b[3],1'b1,out[3]);
new_and a2(b[3],1'b1,out[2]);
new_and a3(b[2],1'b1,out[1]);
new_and a4(b[1],1'b1,out[0]);
endmodule

module equal_comparator(a,b,out);
input [3:0] a,b;
output out;
wire [7:0] o;
wire [3:0] equal;
wire [3:0] a_and_b, not_a_and_not_b, not_a, not_b, xi;
wire s1, s2;

new_not not1[3:0](a, not_a);
new_not not2[3:0](b, not_b);
new_and and1[3:0](a, b, a_and_b);
new_and and2[3:0](not_a, not_b, not_a_and_not_b);
new_or or1[3:0](a_and_b, not_a_and_not_b, xi);
new_and and3(xi[0], xi[1], s1);
new_and and4(xi[2], xi[3], s2);
new_and and5(s1, s2, out);


endmodule

module bigger_comparator(a,b,out);
input [3:0] a,b;
output out;
wire [7:0] o;
wire [3:0] w,w_bar;
wire w0,w1,w2,w3,w4,w5,out_bar;

uni_gate u0(b[3],a[3],o[0]);
uni_gate u1(a[3],b[3],o[1]);
uni_gate u2(b[2],a[2],o[2]);
uni_gate u3(a[2],b[2],o[3]);
uni_gate u4(b[1],a[1],o[4]);
uni_gate u5(a[1],b[1],o[5]);
uni_gate u6(b[0],a[0],o[6]);
uni_gate u7(a[0],b[0],o[7]);
new_or x0(o[0],o[1],w[0]);
new_or x1(o[2],o[3],w[1]);
new_or x2(o[4],o[5],w[2]);
new_or x3(o[6],o[7],w[3]);
new_not n0(w[0],w_bar[0]);
new_not n1(w[1],w_bar[1]);
new_not n2(w[2],w_bar[2]);
new_not n3(w[3],w_bar[3]);
new_and a0(w_bar[0],o[3],w0);
new_and3in a1(w_bar[0],w_bar[1],o[5],w1);
new_and3in a2(w_bar[0],w_bar[1],w_bar[2],w2);
new_and a3(w2,o[7],w3);
new_or or0(w0,w1,w4);
new_or or1(w3,o[1],w5);
new_or or2(w4,w5,out);
endmodule