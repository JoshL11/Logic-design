`timescale 1ns/1ps

module Lab5_TeamX_Traffic_Light_Controller;
reg clk = 1'b0, rst_n = 1'b0;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0] lr_light;
parameter cyc = 2;
// generate clock.
always #(cyc/2) clk = ~clk;
Traffic_Light_Controller TFC(
    .clk(clk), 
    .rst_n(rst_n), 
    .lr_has_car(lr_has_car), 
    .hw_light(hw_light), 
    .lr_light(lr_light)
);

initial begin
    #10 rst_n = 1'b1;
    #200 lr_has_car = 1'b1;
    #300 lr_has_car = 1'b1;
    #1rst_n = 1'b0;
    #1  rst_n = 1'b1;
    #1 lr_has_car = 1'b1;
    #400 lr_has_car = 1'b0;
    #250;
    #1 lr_has_car = 1'b1;
    #1 lr_has_car = 1'b0;
    #500;
    $finish;
end

endmodule