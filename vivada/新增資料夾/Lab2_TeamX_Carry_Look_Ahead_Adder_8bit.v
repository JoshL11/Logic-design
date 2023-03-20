`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;
wire [7:0] p,g;
wire c1,c2,c3,c4,c5,c6,c7;
adder add0(a[0],b[0],c0,s[0],p[0],g[0]);
adder add1(a[1],b[1],c1,s[1],p[1],g[1]);
adder add2(a[2],b[2],c2,s[2],p[2],g[2]);
adder add3(a[3],b[3],c3,s[3],p[3],g[3]);
adder add4(a[4],b[4],c4,s[4],p[4],g[4]);
adder add5(a[5],b[5],c5,s[5],p[5],g[5]);
adder add6(a[6],b[6],c6,s[6],p[6],g[6]);
adder add7(a[7],b[7],c7,s[7],p[7],g[7]);
cla_gen4bit cla0(p[3:0],g[3:0],c0,c1,c2,c3);
cla_gen4bit cla1(p[7:4],g[7:4],c4,c5,c6,c7);
cla_gen2bit cla2(p[7:0],g[7:0],c0,c4,c8);
endmodule

module and2in(a,b,out);
input a,b;
output out;
wire o1;
nand n1(o1,a,b);
nand n2(out,o1,o1);
endmodule

module or2in(a,b,out);
input a,b;
output out;
wire o1,o2;
nand n1(o1,a,a);
nand n2(o2,b,b);
nand n3(out,o1,o2);
endmodule

module nor2in(a,b,out);
input a,b;
output out;
wire o1;
or2in or1(a,b,o1);
nand n1(out,o1,o1);
endmodule

module xor2in(a,b,out);
input a,b;
output out;
wire o1,o2,a_bar,b_bar;
nand n1(a_bar,a,a);
nand n2(b_bar,b,b);
nand n3(o1,a_bar,b);
nand n4(o2,a,b_bar);
nand n5(out,o1,o2);
endmodule

module and5in(a,b,c,d,e,out);
input a,b,c,d,e;
output out;
wire w1;
nand n1(w1,a,b,c,d,e);
nand n2(out,w1,w1);
endmodule

module and4in(a,b,c,d,out);
input a,b,c,d;
output out;
wire w1;
nand n1(w1,a,b,c,d);
nand n2(out,w1,w1);
endmodule

module and3in(a,b,c,out);
input a,b,c;
output out;
wire w1;
nand n1(w1,a,b,c);
nand n2(out,w1,w1);
endmodule

module or5in(a,b,c,d,e,out);
input a,b,c,d,e;
output out;
wire a1,b1,c1,d1,e1;
nand n1(a1,a,a);
nand n2(b1,b,b);
nand n3(c1,c,c);
nand n4(d1,d,d);
nand n5(e1,e,e);
nand n6(out,a1,b1,c1,d1,e1);
endmodule

module adder(a,b,cin,s,p,g);
input a,b,cin;
output s,p,g;
and2in a1(a,b,g);
xor2in x1(a,b,p);
xor2in x2(p,cin,s);
endmodule

module c_gen(p,g,cin,cout);
inout p,g,cin;
output cout;
wire w1;
and2in a1(cin,p,w1);
or2in o1(w1,g,cout);
endmodule

module cla_gen4bit(p,g,c0,c1,c2,c3);
input [3:0] p,g;
input c0;
output c1,c2,c3;
c_gen cg0(p[0],g[0],c0,c1);
c_gen cg1(p[1],g[1],c1,c2);
c_gen cg2(p[2],g[2],c2,c3);
c_gen cg3(p[3],g[3],c3,cout);
endmodule

module cla_gen2bit(p,g,c0,c4,c8);
input [7:0] p,g;
input c0;
output c4,c8;
wire[3:0] w1,w2;
and5in a0(p[3],p[2],p[1],p[0],c0,w1[0]);
and4in a1(p[3],p[2],p[1],g[0],w1[1]);
and3in a2(p[3],p[2],g[1],w1[2]);
and2in a3(p[3],g[2],w1[3]);
or5in o0(g[3],w1[3],w1[2],w1[1],w1[0],c4);
and5in a4(p[7],p[6],p[5],p[4],c4,w2[0]);
and4in a5(p[7],p[6],p[5],g[4],w2[1]);
and3in a6(p[7],p[6],g[5],w2[2]);
and2in a7(p[7],g[6],w2[3]);
or5in o1(g[7],w2[3],w2[2],w2[1],w2[0],c8);
endmodule