module state(clk, rst, start, open, state);
input start;
input [5:0] open;
input clk, rst;
output reg [1:0] state;
reg [10:0] cnt;
reg [1:0] next_state;
//00 means have not started LED flash,motor stop
// LED stop motor spin for a while
//01 if 微�?��?��?? was triggered count the score

always @(posedge clk) begin
    if(rst) state <= 2'b00;
    else begin
        state <= next_state;
        cnt <= cnt + 1;
    end
end
always @(*) begin
    case(state)
    2'b00: begin
        if(start) next_state = 2'b01;
        else next_state = 2'b00; 
    end
    2'b01: begin        
        if(start) next_state = 2'b10;
        else next_state = 2'b01; 
    end
    2'b10: begin
        if(cnt[10] == 1) next_state = 2'b11;
        else next_state = state;
    end
    2'b11: begin
        if(open[0] || open[1] || open[2] || open[3] || open[4] || open[5]) next_state = 2'b01;
        else next_state = 2'b11;
    end
    default: next_state = state;
    endcase
end
endmodule