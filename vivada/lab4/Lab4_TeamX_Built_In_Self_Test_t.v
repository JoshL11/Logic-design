`timescale 1ns/1ps

module BIST_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
wire scan_in;
reg scan_en = 1'b0;
wire scan_out;
// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Built_In_Self_Test  BIU(
    .clk (clk),
    .rst_n (rst_n),
    .scan_in (scan_in),
    .scan_out (scan_out),
    .scan_en (scan_en)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (posedge clk) 
    @ (negedge clk) begin
        scan_en = 1'b1;
        rst_n = 1'b1;
    end
    repeat(7)@(negedge clk) ;
    @(negedge clk)scan_en = 0;
    repeat(8)@(negedge clk) scan_en = 1;;
    //@(negedge clk)scan_en = 0;
    //@(negedge clk) scan_en = 1'b1;
  
    repeat(8)@(negedge clk) ;
    //@(negedge clk)scan_en = 0;
    //repeat(7)@(negedge clk) scan_en = 1;
    @(negedge clk)scan_en = 0;
    repeat(8)@(negedge clk) scan_en = 1;
    //@(negedge clk) scan_en = 0;
    repeat(8)@(negedge clk) scan_en = 1;
    @(negedge clk) 
    $finish;
end

endmodule
