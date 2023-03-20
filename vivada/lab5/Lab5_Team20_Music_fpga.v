`timescale 1ns / 1ps

module Lab5_Team20_Music_fpga(
    input clk,
	output pmod_1,
	output pmod_2,
	output pmod_4,
	inout wire PS2_DATA,
	inout wire PS2_CLK
    );
    
parameter slow_freq = 32'd1;
parameter fast_freq = 32'd2;
parameter DUTY_BEST = 10'd512;
    
wire [31:0] freq;
wire [7:0] ibeatNum;
wire fastbeatFreq,slowbeatFreq;
wire enter;
wire dir,speed;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on
   
SampleDisplay SD(
	.speed(speed),
	.dir(dir),
	.enter(enter),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(0),
	.clk(clk)
	);

PWM_gen toneGen ( .clk(clk), 
				  .reset(enter), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);
PWM_gen fastGen ( .clk(clk), 
					 .reset(enter),
					 .freq(fast_freq),
					 .duty(DUTY_BEST), 
					 .PWM(fastbeatFreq)
);
PWM_gen slowGen ( .clk(clk), 
					 .reset(enter),
					 .freq(slow_freq),
					 .duty(DUTY_BEST), 
					 .PWM(slowbeatFreq)
);
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

PlayerCtrl playerCtrl_00 ( .clk((speed)?fastbeatFreq:slowbeatFreq),
						   .reset(enter),
						   .dir(dir),
						   .ibeat(ibeatNum)
);	
    
endmodule

module SampleDisplay(
	output reg speed,
	output reg dir,
	output reg enter,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	
	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:3] = {
		9'b0_0001_1101,	// W => 1D
		9'b0_0001_1011,	// S => 1B
		9'b0_0010_1101,  // R => 2D
		9'b0_0101_1010  // Enter => 5A
	};
	
	reg [2:0] key_num;
	reg [9:0] last_key;
	
	wire shift_down;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk) begin
	   if(enter) enter<=0;
	   else enter<=enter;
	   if (been_ready && key_down[last_change] == 1'b1) begin
			     if(key_num==3'b000)begin
			         dir<=1;
			         speed<=speed;
			         enter<=0;
			     end
			     else if(key_num==3'b001)begin
			         dir<=0;
			         speed<=speed;
			         enter<=0;
			     end
			     else if(key_num==3'b010)begin
			         dir<=dir;
			         speed<=~speed;
			         enter<=0;
			     end
			     else if(key_num==3'b011)begin
			         dir<=1;
			         speed<=0;
			         enter<=1;
			     end
			     else begin
			         dir<=dir;
			         speed<=speed;
			         enter<=0;
			     end
		end
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 3'b000;
			KEY_CODES[01] : key_num = 3'b001;
			KEY_CODES[02] : key_num = 3'b010;
			KEY_CODES[03] : key_num = 3'b011;
			default		  : key_num = 3'b111;
		endcase
	end
	
endmodule


module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

//
//
//
//

`define NM1 32'd466 //bB_freq
`define NM2 32'd523 //C_freq
`define NM3 32'd587 //D_freq
`define NM4 32'd622 //bE_freq
`define NM5 32'd698 //F_freq
`define NM6 32'd784 //G_freq
`define NM7 32'd880 //A_freq
`define NM0 32'd20000 //slience (over freq.)

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1/4 beat
		8'd0 : tone = `NM0;	//3
		8'd1 : tone = `NM2>>1;
		8'd2 : tone = `NM3>>1;
		8'd3 : tone = `NM4>>1;
		8'd4 : tone = `NM5>>1;	//1
		8'd5 : tone = `NM6>>1;
		8'd6 : tone = `NM7>>1;
		8'd7 : tone = `NM1;
		8'd8 : tone = `NM2;	//2
		8'd9 : tone = `NM3;
		8'd10 : tone = `NM4;
		8'd11 : tone = `NM5;
		8'd12 : tone = `NM6;	//6-
		8'd13 : tone = `NM7;
		8'd14 : tone = `NM1 << 1;
		8'd15 : tone = `NM2 << 1;
		8'd16 : tone = `NM3 << 1;
		8'd17 : tone = `NM4 << 1;
		8'd18 : tone = `NM5 << 1;
		8'd19 : tone = `NM6 << 1;
		8'd20 : tone = `NM7 << 1;
		8'd21 : tone = `NM1 << 2;
		8'd22 : tone = `NM2 << 2;
		8'd23 : tone = `NM3 << 2;
		8'd24 : tone = `NM4 << 2;
		8'd25 : tone = `NM5 << 2;
		8'd26 : tone = `NM6 << 2;
		8'd27 : tone = `NM7 << 2;
		8'd28 : tone = `NM1 << 3;
		8'd29 : tone = `NM2 << 3;
		8'd30 : tone = `NM0;
		default : tone = `NM0;
	endcase
end

endmodule

//
//
//
//

module PlayerCtrl (
	input clk,
	input reset,
	input dir,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 29;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 1;
	else if (ibeat > 1 && ibeat < BEATLEAGTH) begin
		if(dir) ibeat <= ibeat + 1;
		else ibeat<=ibeat-1;
	end else begin
	    if(ibeat==1 && dir==1) ibeat<=ibeat+1;
	    else if(ibeat==BEATLEAGTH && dir==0) ibeat<=ibeat-1;
	    else ibeat<=ibeat;
	end
end

endmodule


