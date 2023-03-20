module SMopen(clk, rst, open , LED, score, state);
input clk ,rst;
input [1:0] state;
input [5:0] LED, open;
output  reg [20:0] score;
reg [20:0] next_score;
always @(posedge clk) begin
    if(rst) begin
        score <= 21'd0;
    end
    else score <= next_score;
end
always @(*) begin
        if(LED[0] && open[0]) begin
            next_score = score + 21'd5;
        end
        else if(LED[1] && open[1])begin
            next_score = score + 21'd5;
        end
        else if(LED[2] && open[2])begin
            next_score = score + 21'd5;
        end
        else if(LED[3] && open[3])begin
            next_score = score + 21'd5;
        end 
        else if(LED[4] && open[4])begin
            next_score = score + 21'd5;
        end
        else if(LED[5] && open[5])begin
            next_score = score + 21'd5;
        end
        else begin
            next_score = score;
        end
        /*if(stop) score = score + 1;
        else score = score + 0;*/
    end

endmodule