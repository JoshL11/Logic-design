`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;

wire [3:0] na, nb, nc, nd;
and2in a1(a[0],b[0],p[0]);
and2in a2(a[1],b[0],na[0]);
and2in a3(a[2],b[0],na[1]);
and2in a4(a[3],b[0],na[2]);


and2in a5(a[0],b[1],nb[0]);
and2in a6(a[1],b[1],nb[1]);
and2in a7(a[2],b[1],nb[2]);
and2in a8(a[3],b[1],nb[3]);

and2in a11(a[0],b[2],nc[0]);
and2in a12(a[1],b[2],nc[1]);
and2in a13(a[2],b[2],nc[2]);
and2in a14(a[3],b[2],nc[3]);

and2in a15(a[0],b[3],nd[0]);
and2in a16(a[1],b[3],nd[1]);
and2in a17(a[2],b[3],nd[2]);
and2in a18(a[3],b[3],nd[3]);

wire [3:0] sum0, sum1, sum2, sum3;
wire c1,c2,c3;

bit_adder ad1(nb[0],nb[1],nb[2],nb[3],na[0],na[1],na[2],0,p[1],sum0[1],sum0[2],sum0[3],c1);
bit_adder ad2(sum0[1],sum0[2],sum0[3],c1,nc[0],nc[1],nc[2],nc[3],p[2],sum1[1],sum1[2],sum1[3],c2);
bit_adder ad3(sum1[1],sum1[2],sum1[3],c2,nd[0],nd[1],nd[2],nd[3],p[3],p[4],p[5],p[6],p[7]);




endmodule



module bit_adder(a0,a1,a2,a3,b0,b1,b2,b3,s0,s1,s2,s3,cout);
input a0,a1,a2,a3,b0,b1,b2,b3;
output s0,s1,s2,s3,cout;
wire c0,c1,c2;

Full_Adder f1(a0,b0,0,c0,s0);
Full_Adder f2(a1,b1,c0,c1,s1);
Full_Adder f3(a2,b2,c1,c2,s2);
Full_Adder f4(a3,b3,c2,cout,s3);

endmodule

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;
wire na,nb,nc;
xor2in a1(a,b,sum);
and2in a2(a,b,cout);
endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire na,nb,nc;
Majority m1(a,b,cin,cout);
xor2in x1(a,b,na);
xor2in x2(na,cin,sum);
endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire qa,qb,qc,qd,qe,qf;
and2in a1(a,b,qa);
and2in a2(a,c,qb);
and2in a3(b,c,qc);
or2in a4(qa,qb,qd);
or2in a5(qd,qc,out);

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

module xnor2in(a,b,out);
input a,b;
output out;
wire o1,o2;
nand n1(o1,a,b);
or2in or1(a,b,o2);
nand n2(out,o1,o2);
endmodule
