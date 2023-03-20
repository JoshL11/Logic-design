`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output reg [7:0] dout;
output reg valid;
reg rst_now;
reg [1:0] count;
wire [7:0] RRA_dout[3:0];
wire [3:0] FIFO_error;
wire [3:0] r_ren;
FIFO_8 a1(clk, rst_n, wen[0], ren[0], a, RRA_dout[0], FIFO_error[0]);
FIFO_8 b1(clk, rst_n, wen[1], ren[1], b, RRA_dout[1], FIFO_error[1]);
FIFO_8 c1(clk, rst_n, wen[2], ren[2], c, RRA_dout[2], FIFO_error[2]);
FIFO_8 d1(clk, rst_n, wen[3], ren[3], d, RRA_dout[3], FIFO_error[3]);
reg [3:0] ren;
reg [3:0] wen_now;
reg [1:0] count_now;
reg [1:0] count_next;
always @(posedge clk) begin
    if(!rst_n) begin
        count <= 0;
    end
    else begin
        count_now <= count;
        count <= count_next;
        wen_now <= wen;
    end
    rst_now <= rst_n;
end

always @(*)begin
    if(~rst_now) begin
        valid = 0;
        ren = 0;
        dout = 0;
    end
    else begin
        if(count == 0 && ~wen[0]) ren = 4'b0001;
        else if(count == 1 && ~wen[1]) ren = 4'b0010;
        else if(count == 2 && ~wen[2]) ren = 4'b0100;
        else if(count == 3 && ~wen[3]) ren = 4'b1000;
        else ren = 4'b0000;
        
        if(count_now == 0 && ~wen_now[0] && ~FIFO_error[0]) begin
            dout = RRA_dout[0];
            valid = 1;
        end
        else if(count_now == 1 && ~wen_now[1] && ~FIFO_error[1]) begin
            dout = RRA_dout[1];
            valid = 1;
        end
        else if(count_now == 2 && ~wen_now[2] && ~FIFO_error[2]) begin
            dout = RRA_dout[2];
            valid = 1;
        end
        else if(count_now == 3 && ~wen_now[3] && ~FIFO_error[3]) begin
            dout = RRA_dout[3];
            valid = 1;
        end
        else begin
            valid = 0;
            dout = 0;
        end
        
   end
   count_next = count + 1;
end
    
endmodule

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg[7:0]memory[7:0];
reg [7:0] dout;
integer gate = 1'd8;

reg[2:0] ren_ptr, wen_ptr;
reg[3:0] counter; 
wire empty, full;

reg error;
    

always @(posedge clk)
    begin
        if (!rst_n) begin
            wen_ptr <= 1'd0;
            ren_ptr <= 1'd0;
            counter <= 1'd0;
            error <= 1'd0;
            dout <= 1'd0;
        end
        else begin
            case({ren, wen})
                2'b00: 
                begin
                    error <= 0;
                    dout <= 0;
                end
                2'b01:
                    begin
                        dout <= 0;
                        
                        if(full) begin
                            error <= 1;
                            counter <= 8;
                        end
                        else begin
                            wen_ptr <= wen_ptr + 1;
                            error <= 0;
                            counter <= counter + 1;
                            memory[wen_ptr] <= din;
                        end
                    end
                2'b10:
                    begin  
                        
                        if(empty) begin 
                            error <= 1;
                            dout <= 1'b0;
                        end
                        else begin
                            ren_ptr <= ren_ptr + 1;
                            error <= 0;
                            counter <= counter - 1;
                            dout <= memory[ren_ptr];
                        end
                    end
                2'b11:
                    begin  
                        
                        if(empty) begin 
                            error <= 1;
                            dout <= 1'b0;
                        end
                        else begin
                            ren_ptr <= ren_ptr + 1;
                            error <= 0;
                            counter <= counter - 1;
                            dout <= memory[ren_ptr];
                        end
                    end
                endcase
            end
        
    end 

assign full = (counter == 4'b1000);
assign empty = (counter == 1'b0);



endmodule

