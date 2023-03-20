`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output reg [2:0] hw_light;
output reg [2:0] lr_light;
reg [2:0] hw_light_next, lr_light_next;
reg [2:0] state;
reg [2:0] state_next;
reg [6:0] counter;
reg [6:0] counter_next;
reg HW_eighty;
parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;
parameter s5 = 3'b101;

always @(posedge clk) begin
    if(!rst_n) begin
        hw_light <= 3'b100;
        lr_light <= 3'b001;
        state <= s0;
        HW_eighty <= 1'b0;
        counter <= 1;
    end
    else begin
        state <= state_next;
        counter <= counter_next;
        hw_light <= hw_light_next;
        lr_light <= lr_light_next;
    end
end

always @(*) begin
    case(state) 
        3'b000: begin
            if(counter >= 7'd80) begin
                HW_eighty = 1'b1;
            end
            else HW_eighty = HW_eighty + 1'b0;
            if(lr_has_car && HW_eighty) begin
                state_next = s1;
                counter_next = 1'b1;
                hw_light_next = 3'b010;
                lr_light_next = 3'b001;
            end
            else begin
                counter_next = counter + 1'b1;
                state_next = state;
                hw_light_next = 3'b100;
                lr_light_next = 3'b001;
            end
        end
        3'b001: begin
            HW_eighty = 1'b0;
            if(counter == 7'd20) begin
                state_next = s2;
                hw_light_next = 3'b001;
                lr_light_next = 3'b001;
                counter_next = 1'b1;
            end
            else begin
                state_next = state;
                hw_light_next = 3'b010;
                lr_light_next = 3'b001;
                counter_next = counter + 1'b1;
            end
        end
        3'b010: begin
            HW_eighty = 1'b0;
            if(counter == 7'd1) begin
                state_next = s3;
                hw_light_next = 3'b001;
                lr_light_next = 3'b100;
                counter_next =1'b1;
            end
            else begin
                state_next = state;
                hw_light_next = 3'b001;
                lr_light_next = 3'b001;
                counter_next = counter + 1'b1;
            end
        end
        3'b011: begin
            HW_eighty = 1'b0;
            if(counter == 7'd80) begin
                state_next = s4;
                hw_light_next = 3'b001;
                lr_light_next = 3'b010;
                counter_next = 1'b1;
            end
            else begin
                state_next = state;
                hw_light_next = 3'b001;
                lr_light_next = 3'b100;
                counter_next = counter + 1'b1;
            end
        end
        3'b100: begin
            HW_eighty = 1'b0;
            if(counter == 7'd20) begin
                state_next = s5;
                hw_light_next = 3'b001;
                lr_light_next = 3'b001;
                counter_next = 1'b1;
            end
            else begin
                state_next = state;
                hw_light_next = 3'b001;
                lr_light_next = 3'b010;
                counter_next = counter + 1'b1;
            end
        end
        3'b101: begin
            HW_eighty = 1'b0;
            if(counter == 7'd1) begin
                state_next = s0;
                hw_light_next = 3'b100;
                lr_light_next = 3'b001;
                counter_next = 1'b1;
            end
            else begin
                state_next = state;
                hw_light_next = 3'b001;
                lr_light_next = 3'b001;
                counter_next = counter;
            end
        end
        default: begin
            HW_eighty = 1'b0;
            state_next = state;
            hw_light_next = 3'b000;
            lr_light_next = 3'b000;
            counter_next = counter;
        end
    endcase

    //assign counter_next = counter + 1'b1;
end
endmodule
