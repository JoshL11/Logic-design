`timescale 1ns/1ps

module FIFO_8_t;

reg clk = 1'b1;
reg rst_n = 1'b1;
reg wen = 1'b0, ren = 1'b0;
reg [7:0] din;
wire [7:0] dout;
wire error;

FIFO_8 fifo(.clk(clk), 
            .rst_n(rst_n),    
            .wen(wen), 
            .ren(ren), 
            .din(din), 
            .dout(dout), 
            .error(error));

parameter cyc = 10;
always#(cyc/2) clk = ~clk;

initial begin
    @(negedge clk)
    rst_n = 0;
    @(negedge clk)
    rst_n = 1;
    @(negedge clk)
    wen = 1;
    din = 10;
    @(negedge clk)
    din = 20;
    @(negedge clk)
    wen = 0;
    ren = 1;
    din = 30;
    // ren = 1 and wen = 1
    @(negedge clk)
    wen = 1;
    ren = 1;
    din = 35;
    // ren = 0 and wen = 0
    @(negedge clk)
    wen = 0;
    ren = 0;
    din = 45;
    @(negedge clk)
    wen = 0;
    ren = 1;
    @(negedge clk)
    
    // reset
    @(negedge clk)
    ren = 0;
    wen = 0;
    rst_n = 0;
    @(negedge clk)
    rst_n = 1;
    //empty queue
    @(negedge clk)
    ren = 1;
    @(negedge clk)
    ren = 0;
    // full queue
    din = 8'b11100010;
    repeat(2 ** 3 + 3) begin
        @(negedge clk)
        wen = 1;
        din = din + 3'b100;
    end
    @(negedge clk)
    wen = 0;

    // reset to test whether the queue is circular and the last one signal should be an error
    @(negedge clk)
    ren = 0;
    wen = 0;
    rst_n = 0;
    @(negedge clk)
    rst_n = 1;
    din = 1;
    repeat (7) begin
        @(negedge clk)
        wen = 1;
        din = din + 1;
    end
    repeat (6) begin
        @(negedge clk)
        ren = 1;
        din = din + 1;
    end
    
    @(negedge clk)
    ren = 0;
    din = din + 1;
    @(negedge clk)
    din = din + 1;
    repeat (8) begin
        @(negedge clk)
        wen = 1;
        din = din + 1;
    end
    repeat (15) begin
        @(negedge clk)
        ren = 1;
        din = din + 1;
    end
    
    @(negedge clk)
    @(posedge clk)
    $finish;
end

endmodule