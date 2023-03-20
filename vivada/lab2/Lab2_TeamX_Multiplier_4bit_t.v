`timescale 1ns/1ps

module Multiplier_4bit_t;
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;

wire [7:0] p;

Multiplier_4bit mul(
    .a(a),
    .b(b),
    .p(p)
);

initial begin
    a = 4'b0010;
    b = 4'b0010;
    repeat (2 ** 4) begin
        
        #1 b = b + 4'b0001;
        #1 a = a + 4'b0001;
    end
    #1 $finish;
end

endmodule