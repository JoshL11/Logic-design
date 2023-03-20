`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg[1:0] state;
reg[1:0] next_state;
reg cur_in;
reg dec;
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
reg[3:0] memory;

always@(posedge clk)begin
    if(!rst_n)begin
        state<=S0;
        cur_in<=in;
    end else begin
        state<=next_state;
        cur_in<=in;
    end
    
end

always@*begin
    case(state)
    S0:begin
        next_state=S1;
    end
    S1:begin
        next_state=S2;
        memory[0]=cur_in;
    end
    S2:begin
        next_state=S3;
        memory[1]=cur_in;
    end
    S3:begin
        next_state=S0;
        memory[2]=cur_in;
        memory[3]=in;
    end
    endcase
end

always@*begin
    if(state!=S3) dec=0;
    else begin
        case(memory)
        4'b0111:dec=1;
        4'b1001:dec=1;
        4'b1110:dec=1;
        default:dec=0;
        endcase
    end
end

endmodule
