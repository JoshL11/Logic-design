`timescale 1ns/1ps

module Fanout_4(in, out);
    input in;
    output [3:0] out;
    wire revin;
    not n1(revin,in);
    
    not not1(out[3],revin);
    not not2(out[2],revin);
    not not3(out[1],revin);
    not not4(out[0],revin);

endmodule
