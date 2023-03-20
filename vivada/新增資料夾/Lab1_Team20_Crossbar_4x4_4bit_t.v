`timescale 1ns/1ps

module Crossbar_4x4_4bit_t;
reg [3:0] in1 = 4'b0001;
reg [3:0] in2 = 4'b0010;
reg [3:0] in3 = 4'b0100;
reg [3:0] in4 = 4'b1000;
reg [4:0] control = 5'b00000;
wire [3:0] out1, out2, out3, out4;

Crossbar_4x4_4bit cis(
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .out1(out1),
    .out2(out2),
    .out3(out3),
    .out4(out4),
    .control(control)
    
);

initial begin
    in1 = 4'b0001;
    in2 = 4'b0010;
    in3 = 4'b0100;
    in4 = 4'b1000;
    repeat (2 ** 5) begin
        #1 control = control + 4'b0001;
        //in1 = in1 + 4'b0001;
        //in2 = in2 + 4'b0001;
        //in3 = in3 + 4'b0001;
        //in4 = in4 + 4'b0001;
    end
    #1 $finish;
end

endmodule