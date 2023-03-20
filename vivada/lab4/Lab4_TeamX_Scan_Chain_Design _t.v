`timescale 1ns/1ps

module Scan_Chain_Design_t;
reg clk = 1'b0;
reg rst_n, scan_in, scan_en;
wire scan_out;

Scan_Chain_Design SCD(clk, rst_n, scan_in, scan_en, scan_out);

parameter cyc = 10;
always #(cyc/2) clk = !clk;

initial begin
    rst_n = 1'b1;
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b1;
    scan_en = 1'b0;
    repeat (2 ** 3) begin
        @(negedge clk)
        scan_en = 1'b1;
    end
    // test overlapping 9*10 = 90
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    scan_in = 1;
    @(negedge clk)
    scan_in = 0;
    @(negedge clk)
    scan_in = 0;
    @(negedge clk)
    scan_in = 1;
    @(negedge clk)
    scan_in = 0;
    @(negedge clk)
    scan_in = 1;
    @(negedge clk)
    scan_in = 0;
    @(negedge clk)
    scan_in = 1;
    @(negedge clk)
    scan_en = 1'b0;
    repeat (2 ** 3) begin
        @(negedge clk)
        scan_en = 1'b1;
    end
    @(negedge clk)
    
    $finish;
end

endmodule