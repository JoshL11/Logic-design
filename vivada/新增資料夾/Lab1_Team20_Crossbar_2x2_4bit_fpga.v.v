`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2, out3, out4);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2, out3, out4;
wire[3:0] w1,w2,w3,w4;
wire[3:0] r1,r2,r3,r4;
wire control_bar;
not n1(control_bar,control);
demux d1(in1,control_bar,w1,w2);
demux d2(in2,control,w3,w4);
mux m1(w1,w3,control_bar,out1);
mux m2(w2,w4,control,out2);
not not1[3:0](r1,out1);
not not2[3:0](r2,out2);
not not3[3:0](out3,r1);
not not4[3:0](out4,r2);

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



