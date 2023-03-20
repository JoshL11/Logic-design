`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg[7:0]memory[7:0];
reg [7:0] dout;

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