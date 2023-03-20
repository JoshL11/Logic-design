`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;
reg [3:0] state;
reg [3:0] state_next;
parameter s0 = 4'b0000;
parameter s1 = 4'b0001;
parameter s2 = 4'b0010;
parameter s3 = 4'b0011;
parameter s4 = 4'b0100;
parameter s5 = 4'b0101;
parameter s6 = 4'b0110;
parameter s7 = 4'b0111;
parameter s8 = 4'b1000;
parameter s9 = 4'b1001;

always@(posedge clk) begin
    if(!rst_n) begin
        dec <= 1'b0;
        state <= s0;
    end
    else begin
        state <= state_next;
    end
end

always@(*) begin
    case(state) 
        4'b0000:begin
            if(in == 1'b1) begin
                state_next = s1;
                dec = 1'b0;
            end
            else begin
                state_next = s0;
                dec = 1'b0;
            end
        end
        4'b0001:begin
            if(in == 1'b1) begin
                state_next = s2;
                dec = 1'b0;
            end
            else begin
                state_next = s0;
                dec = 1'b0;
            end
        end
        4'b0010:begin
            if(in == 1'b0) begin
                state_next = s3;
                dec = 1'b0;
            end
            else begin
                state_next = s2;
                dec = 1'b0;
            end
        end
        4'b0011:begin
            if(in == 1'b0) begin
                state_next = s4;
                dec = 1'b0;
            end
            else begin
                state_next = s1;
                dec = 1'b0;
            end
        end
        4'b0100:begin
            if(in == 1'b1) begin
                state_next = s5;
            end
            else state_next = s0;
        end
        4'b0101:begin
            if(in == 1'b0) begin
                state_next = s6;
                dec = 1'b0;
            end
            else begin
                state_next = s2;
                dec = 1'b0;
            end
        end
        4'b0110:begin
            if(in == 1'b0) begin
                state_next = s7;
                dec = 1'b0;
            end
            else begin
                state_next = s5;
                dec = 1'b0;
            end
        end
        4'b0111:begin
            if(in == 1'b1) begin
                state_next = s1;
                dec = 1'b1;
            end
            else begin
                state_next = s0;
                dec = 1'b0;
            end
        end
        default: begin
            state_next = s0;
            dec = 1'd0;
        end

    endcase

end
endmodule 