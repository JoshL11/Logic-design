`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [3:0] in1, in2, in3, in4;
input [4:0] control;
output [3:0] out1, out2, out3, out4;

wire [3:0] na,nb,nc,nd,ne,nf,ng,nh;
wire [4:0] rev_cont;
not not10[4:0](rev_cont,control);

Crossbar_2x2_4bit C1(in1[0],in2[0],control[0],na[0],nb[0]);
Crossbar_2x2_4bit C2(in1[1],in2[1],control[0],na[1],nb[1]);
Crossbar_2x2_4bit C3(in1[2],in2[2],control[0],na[2],nb[2]);
Crossbar_2x2_4bit C4(in1[3],in2[3],control[0],na[3],nb[3]);

//Crossbar_2x2_4bit C21(in1[0],in2[0],rev_control[0],na[0],nb[0]);
//Crossbar_2x2_4bit C22(in1[1],in2[1],control[0],na[1],nb[1]);
//Crossbar_2x2_4bit C23(in1[2],in2[2],control[0],na[2],nb[2]);
//Crossbar_2x2_4bit C24(in1[3],in2[3],control[0],na[3],nb[3]);

Crossbar_2x2_4bit C5(in3[0],in4[0],control[1],nc[0],nd[0]);
Crossbar_2x2_4bit C6(in3[1],in4[1],control[1],nc[1],nd[1]);
Crossbar_2x2_4bit C7(in3[2],in4[2],control[1],nc[2],nd[2]);
Crossbar_2x2_4bit C8(in3[3],in4[3],control[1],nc[3],nd[3]);

Crossbar_2x2_4bit C9(nb[0],nc[0],control[2],ne[0],nf[0]);
Crossbar_2x2_4bit C10(nb[1],nc[1],control[2],ne[1],nf[1]);
Crossbar_2x2_4bit C11(nb[2],nc[2],control[2],ne[2],nf[2]);
Crossbar_2x2_4bit C12(nb[3],nc[3],control[2],ne[3],nf[3]);

Crossbar_2x2_4bit C13(na[0],ne[0],control[3],out1[0],out2[0]);
Crossbar_2x2_4bit C14(na[1],ne[1],control[3],out1[1],out2[1]);
Crossbar_2x2_4bit C15(na[2],ne[2],control[3],out1[2],out2[2]);
Crossbar_2x2_4bit C16(na[3],ne[3],control[3],out1[3],out2[3]);

Crossbar_2x2_4bit C17(nf[0],nd[0],control[4],out3[0],out4[0]);
Crossbar_2x2_4bit C18(nf[1],nd[1],control[4],out3[1],out4[1]);
Crossbar_2x2_4bit C19(nf[2],nd[2],control[4],out3[2],out4[2]);
Crossbar_2x2_4bit C20(nf[3],nd[3],control[4],out3[3],out4[3]);




endmodule


module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2;
wire[3:0] w1,w2,w3,w4;
wire control_bar;
not n1(control_bar,control);
demux d1(in1,control_bar,w1,w2);
demux d2(in2,control,w3,w4);
mux m1(w1,w3,control_bar,out1);
mux m2(w2,w4,control,out2);

endmodule

module mux(in1,in2,sel,out);
input [3:0] in1,in2;
input sel;
output [3:0] out;
wire sel_bar;
wire [3:0] w1,w2;
not n1(sel_bar,sel);

and a1(w1[0],sel_bar,in1[0]);
and a2(w1[1],sel_bar,in1[1]);
and a3(w1[2],sel_bar,in1[2]);
and a4(w1[3],sel_bar,in1[3]);

and a5(w2[0],sel,in2[0]);
and a6(w2[1],sel,in2[1]);
and a7(w2[2],sel,in2[2]);
and a8(w2[3],sel,in2[3]);
    
or o1[3:0](out,w1,w2);
    
endmodule

module demux(in,sel,out1,out2);
input[3:0] in;
input sel;
output[3:0] out1,out2;
wire sel_bar;
not n1(sel_bar,sel);

and a1(out1[0],sel_bar,in[0]);
and a2(out1[1],sel_bar,in[1]);
and a3(out1[2],sel_bar,in[2]);
and a4(out1[3],sel_bar,in[3]);

and a5(out2[0],sel,in[0]);
and a6(out2[1],sel,in[1]);
and a7(out2[2],sel,in[2]);
and a8(out2[3],sel,in[3]);

endmodule