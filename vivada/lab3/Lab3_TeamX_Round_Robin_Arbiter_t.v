`timescale 1ns/1ps

module Round_Robin_Arbiter_t;

reg clk = 0;
reg rst_n;
reg [3:0] wen;
reg [7:0] a, b, c, d;
wire [7:0] dout;
wire valid;

parameter cyc = 10;
always #(cyc/2) clk = !clk;

Round_Robin_Arbiter RRA(.clk(clk), 
                        .rst_n(rst_n), 
                        .wen(wen), 
                        .a(a), 
                        .b(b), 
                        .c(c), 
                        .d(d), 
                        .dout(dout), 
                        .valid(valid));

initial begin

    // test normal cases
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    wen = 4'b1111;
    a = 8'd1;
    b = 8'd2;
    c = 8'd3;
    d = 8'd4;
    @(negedge clk)
    wen = 4'b0100;
    c = 8'd50;
    @(negedge clk)
    wen = 4'b0000;
    @(negedge clk)
    @(negedge clk)

    // test read and write at same queue
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    wen = 4'b1111;
    a = 8'd1;
    b = 8'd2;
    c = 8'd3;
    d = 8'd4;
    @(negedge clk) // error
    wen = 4'b0010;
    b = 8'd5;
    @(negedge clk)
    wen = 4'b0000;
    @(negedge clk)
    // empty
    @(negedge clk)

    // all full
    rst_n = 1'b0;
    @(negedge clk)
    a = 8'd10;
    b = 8'd20;
    c = 8'd30;
    d = 8'd40;
    rst_n = 1'b1;
    wen = 4'b1111;
    repeat(2 ** 3) begin
        @(negedge clk)
        a = a + 1;
        b = b + 1;
        c = c + 1;
        d = d + 1;
    end
    // full for read
    repeat(2 ** 5) begin// 
        @(negedge clk)
        wen = 4'b0000;
    end
    //empty
    repeat(2) begin
        @(negedge clk)
        wen = 4'b0000;
    end
    @(negedge clk)
    $finish;
end

endmodule