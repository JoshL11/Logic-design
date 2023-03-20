`timescale 1ns/1ps

module Multi_Bank_Memory_t;

reg clk = 1'b0;
reg ren, wen;
reg [10:0] waddr, raddr;
reg [7:0] din;
wire [7:0] dout;

parameter cyc = 10;
always #(cyc/2) clk = !clk;

Multi_Bank_Memory MBM(.clk(clk), 
                      .ren(ren), 
                      .wen(wen), 
                      .waddr(waddr), 
                      .raddr(raddr), 
                      .din(din), 
                      .dout(dout));

initial begin
    ren = 0;
    wen = 0;
    din = 0;
    waddr = 0;
    raddr = 0;
    @(negedge clk)
    ren = 1;
    raddr = 11'b01101100001;
    @(negedge clk)
    ren = 0;
    wen = 1;
    din = 5;
    waddr = 11'b00011011010;
    @(negedge clk)
    ren = 1;
    raddr = 11'b00011011010;
    din = 6;
    waddr = 11'b01011101100;
    @(negedge clk)
    wen = 0;
    din = 7;
    raddr = 11'b01011101100;
    @(negedge clk)
    // same address
    wen = 1;
    din = 8;
    waddr = 11'b01011101100;
    @(negedge clk)
    ren = 1;
    raddr = 11'b10000100100;
    wen = 0;
    din = 9;
    @(negedge clk)
    wen = 1;
    waddr = 11'b10000100100;
    @(negedge clk)
    waddr = 11'b01011010101;
    din = 87;
    @(negedge clk)
    raddr = 11'b01011010101;
    @(negedge clk)
    ren = 0;
    waddr = 11'b01011010101;
     din = 88;
     @(negedge clk)
     ren = 1;
      raddr = 11'b01011010101;
      @(negedge clk)
    
    $finish;
end

endmodule