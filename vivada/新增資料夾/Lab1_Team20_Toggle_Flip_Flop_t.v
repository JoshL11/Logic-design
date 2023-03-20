`timescale 1ns/1ps

module Toggle_Flip_Flop_t;

// input and output signals
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
wire q;

// generate clk
always#(1) clk = ~clk;

// test instance instantiation
Toggle_Flip_Flop TFF(
    .clk(clk),
    .t(t),
    .rst_n(rst_n),
    .q(q)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("DFF.fsdb");
//      $fsdbDumpvars;
// end

// brute force 
initial begin
    
    @(negedge clk) begin 
        t = 1'b1;
        rst_n = !rst_n;
    end
    @(negedge clk) begin 
        t = 1'b0;
        //rst_n = !rst_n;
    end
    @(negedge clk) begin 
        t = 1'b1;
        //rst_n = rst_n;
    end
    @(negedge clk) begin 
        t = 1'b0;
        //rst_n = !rst_n;
    end
    #10 t = 1'b1;
    #10 t = 1'b0;
    #10 rst_n = 1'b0;
    #10 t = 1'b1;
    #10 t = 1'b0;
    @(negedge clk) $finish;
end

endmodule