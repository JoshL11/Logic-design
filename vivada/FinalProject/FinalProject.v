`timescale 1ns/1ps

module TakeOff(clk, start, rst, LED, AN, SEG, left, open, left_motor);
input start;
input clk,rst;
input [5:0] open;
output [5:0] LED;
output reg [3:0] AN;
output reg [6:0] SEG;
wire [6:0] SEG1, SEG2, SEG3, SEG0;
output reg [1:0]left;
output left_motor;
wire [20:0] score;
reg [1:0] cnt;
wire clk_display;
wire Rst_n, rst_pb, stop;
wire i,o;
wire [5:0] open_de, open_one;

debounce d6[5:0](open_de, open, clk);
onepulse d7[5:0](open_de, clk, open_one);
debounce d4(i, start, clk);
onepulse d5(i, clk, o);
debounce d0(rst_pb, rst, clk);
onepulse d1(rst_pb, clk, Rst_n);

wire [1:0] state;
clock_div_display Bitch(clk,clk_display);

motor A(.clk(clk),.rst(Rst_n),.mode(state),.pwm(left_motor));

/*sonic_top B(.clk(clk), .rst(Rst_n), .Echo(echo), .Trig(trig),.stop(stop));*/

state C(.clk(clk), .rst(Rst_n), .start(o), .open(open_one), .state(state));

LED D(.clk(clk), .rst(Rst_n), .state(state), .LED(LED));

SMopen E(.clk(clk), .rst(Rst_n), .open(open_one), .LED(LED), .score(score));

always @(*) begin
    if(state == 2'b11)
        left = 2'b10;
    else left = 2'b00;
    
end


insertmoney T(SEG0,SEG1,SEG2,SEG3,score);


always@(posedge clk)begin
    if(clk_display==1)begin
    cnt<=cnt+1;
    if(cnt==0)begin
        AN<=4'b1110;
        SEG<=SEG0;
    end
    else if(cnt==1)begin
        AN<=4'b1101;
        SEG<=SEG1;
    end
    else if(cnt==2)begin
        AN<=4'b1011;
        SEG<=SEG2;
    end
    else begin
        AN<=4'b0111;
        SEG<=SEG3;
    end
    end
end




endmodule
module clock_div_display(clk_in,clk_out);
input clk_in;
output reg clk_out;
reg [17:0] cnt;
always@(posedge clk_in)begin
     cnt<=cnt+1;
end
always@* begin
    if(cnt==0) clk_out=1;
    else clk_out=0;
end
endmodule


module insertmoney(seg0, seg1, seg2, seg3, money);
input [20:0] money;
output reg [6:0] seg0, seg1, seg2, seg3;

always @(*) begin
    if(money >= 21'd100) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000001;
        seg2 = 7'b1001111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd95) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd90) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd85) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd80) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd75) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0001101;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd70) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0001101;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd65) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0100000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd60) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0100000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd55) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0100100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd50) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0100100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd45) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1001100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd40) begin
        seg0 = 7'b0000001;
        seg1 = 7'b1001100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd35) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000110;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd30) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000110;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd25) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0010010;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd20) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0010010;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd15) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1001111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd10) begin
        seg0 = 7'b0000001;
        seg1 = 7'b1001111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd5) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1111111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 21'd0) begin
        seg0 = 7'b0000001;
        seg1 = 7'b1111111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else begin
        seg0 = 7'b1111110;
        seg1 = 7'b1111111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
end





endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [9:0] DFF;
    
    always @(posedge clk) begin
        DFF[9:1] <= DFF[8:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule