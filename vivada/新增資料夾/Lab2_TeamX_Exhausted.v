`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [3:0] a, b;
input cin;
output cout;
output [3:0] sum;
wire [2:0] carry;

Full_Adder fa1(a[0], b[0], cin, carry[0], sum[0]);
Full_Adder fa2(a[1], b[1], carry[0], carry[1], sum[1]);
Full_Adder fa3(a[2], b[2], carry[1], carry[2], sum[2]);
Full_Adder fa4(a[3], b[3], carry[2], cout, sum[3]);
    
endmodule

module Full_Adder(a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire a_xor_b;

Majority m(a, a, cin, cout);
new_xor xor1(a_xor_b, a, b);
new_xor xor2(sum, cin, a_xor_b);

endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire s0, s1, s2, s3;

new_and and1(s0, a, b);
new_and and2(s1, a, c);
new_and and3(s2, b, c);
new_or or1(s3, s0, s1);
new_or or2(out, s2, s3);

endmodule

module new_and (out, a, b);
// (a nand b) nand (a nand b)
input a, b;
output out;
wire a_nand_b;

nand nand1(a_nand_b, a, b);
nand nand2(out, a_nand_b, a_nand_b);

endmodule

module new_or (out, a, b);
// !a nand !b
input a, b;
output out;
wire not_a, not_b;

nand nand1(not_a, a, a);
nand nand2(not_b, b, b);
nand nand3(out, not_a, not_b);

endmodule

module new_xor (out, a, b);
// (a nand !b) nand (!a nand b);
input a, b;
output out;
wire not_a, not_b, a_nand_not_b, not_a_nand_b;

nand nand1(not_a, a, a);
nand nand2(not_b, b, b);
nand nand3(a_nand_not_b, a, not_b);
nand nand4(not_a_nand_b, not_a, b);
nand nand5(out, a_nand_not_b, not_a_nand_b);

endmodule