module LED(clk, rst, state, LED);
input [1:0] state;
input clk, rst;
output reg [5:0] LED;
reg [23:0] cnt;
reg[5:0] next_val;
reg [7:0] DFF;

always @(posedge clk) begin
    if (rst) begin
        DFF <= 8'b10111101;
    end else begin
        DFF[0] <= (DFF[1] ^ DFF[2]) ^ (DFF[3] ^ DFF[7]);
        DFF[7:1] <= DFF[6:0];
    end
end

//wait for path
always@(posedge clk) begin
        cnt <= cnt + 1'b1;
end
always@(*) begin
    if(state == 2'b00) begin
        LED = 6'b000000;
    end
    else if(state == 2'b01) begin   
        if(cnt[23] == 1) 
            LED = 6'b111111;
        else LED = 6'b000000;
    end
    else if(state == 2'b10) begin
        if (DFF[5:0] == 1'b0) begin
            case (DFF[7:0] % 4'd6)
                4'd0: begin
                    LED[5:0] = 6'b000001;
                end
                4'd1: begin
                    LED[5:0] = 6'b000010;
                end
                4'd2: begin
                    LED[5:0] = 6'b000100;
                end
                4'd3: begin
                    LED[5:0] = 6'b001000;
                end
                4'd4: begin
                    LED[5:0] = 6'b010000;
                end
                4'd5: begin
                    LED[5:0] = 6'b100000;
                end
                default: begin
                    LED[5:0] = 6'b000001;
                end
            endcase
        end else begin
            LED[5:0] = DFF[5:0];
        end
    end
    else if(state == 2'b11) begin
        LED = LED + 6'b0;
    end
    else begin
        LED = LED + 6'b0;
    end
end

endmodule