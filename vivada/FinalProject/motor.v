module motor(input clk, input rst, input [1:0] mode, output pwm);

    reg [9:0]next_left_motor;
    reg [9:0]left_motor;
    wire left_pwm;
    reg [30:0] counter;
    reg [30:0]next_counter;
    motor_pwm m0(clk, rst, left_motor, left_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            counter <= 31'b0;
        end else begin
            left_motor <= next_left_motor;
            counter <= next_counter;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    always@(*) begin
        if(mode == 2'b00)begin
            next_left_motor = 10'd0;
            next_counter = 0;
        end
        else if(mode == 2'b11) begin
            if(counter == 31'd50000000)begin
                next_left_motor = 10'd0;
                next_counter = counter;
            end
            else begin
                next_left_motor = 10'd1000;
                next_counter = counter + 1;
            end
        end
        else begin
            next_left_motor = 10'd0;
            next_counter = 0;
        end
    end

    assign pwm = left_pwm;
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

