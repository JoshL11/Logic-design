`timescale 1ns/1ps

module Vending_machine_fpga(clk, Left, Right, Top, Down, Center, AN, seg, LED, PS2_DATA, PS2_CLK);
input Left, Right, Top, Down, Center;
inout wire PS2_DATA;
inout wire PS2_CLK;
input clk;
output reg [3:0] AN;
output reg [6:0] seg;
output [3:0] LED;
wire [2:0] drink;
wire [6:0] seg0;
wire [6:0] seg1;
wire [6:0] seg2;
wire [6:0] seg3;
reg [1:0] cnt;
reg [31:0] cancnt;
reg [31:0] cancnt_next;
wire clk_display;
wire five, ten, fifty, rst_n, cancel;
wire db0,db1,db2,db3,db4;
parameter insert_state = 2'b00;
parameter cancel_state = 2'b01;
reg [1:0] state;
reg [1:0] next_state;

reg [7:0] money;
reg [7:0] next_money;

clock_div_display cd0(clk,clk_display);
debounce d0(deb0, Top, clk);
onepulse o0(deb0, clk, rst_n);//top

debounce d1(deb1, Down, clk);
onepulse o1(deb1, clk, cancel);//down

debounce d2(deb2, Left, clk);
onepulse o2(deb2, clk, five);//Left

debounce d3(deb3, Right, clk);
onepulse o3(deb3, clk, fifty);//right

debounce d4(deb4, Center, clk);
onepulse o4(deb4, clk, ten);//center

always@(posedge clk) begin
    if(rst_n) begin
        money <= 7'd0;
        state <= insert_state;
        cancnt <= 32'd0;
    end
    else begin
        state <= next_state;
        money <= next_money;
        cancnt <= cancnt_next;
    end
end
always @(*) begin
    case(state) 
       2'b00: begin
            if(drink == 3'b000) begin
                if(ten) begin
                    if(money + 7'd10 >= 7'd100) next_money = 7'd100;
                    else next_money = money + 7'd10;
                end
                else if(five) begin
                    if(money + 7'd5 >= 7'd100) next_money = 7'd100;
                    else next_money = money + 7'd5;
                end
                else if(fifty) begin
                    if(money + 7'd50 >= 7'd100) next_money = 7'd100;
                    else next_money = money + 7'd50;
                end
                else if(cancel) next_state = cancel_state;
                else begin
                    next_money = money;
                    next_state = state;
                end
            end
            else if(drink == 3'b001) begin
                if(money >= 7'd75) begin
                    next_money = money - 7'd75;
                    next_state = cancel_state;
                end
                else begin
                    next_money = money;
                    next_state = state;
                end
            end
            else if(drink == 3'b010) begin
                if(money >= 7'd50) begin
                    next_money = money - 7'd50;
                    next_state = cancel_state;
                end
                else begin
                    next_money = money;
                    next_state = state;
                end
            end
            else if(drink == 3'b011) begin
                if(money >= 7'd30) begin
                    next_money = money - 7'd30;
                    next_state = cancel_state;
                end
                else begin
                    next_money = money;
                    next_state = state;
                end
            end
            else if(drink == 3'b100) begin
                if(money >= 7'd20) begin
                    next_money = money - 7'd20;
                    next_state = cancel_state;
                end
                else begin
                    next_money = money;
                    next_state = state;
                end
            end
            else begin
                next_money = money;
                next_state = state;
            end

       end 
       2'b01: begin
            
            if(cancnt == 32'd100000000) begin
               
                if(money == 7'd0) begin
                    //drink = 3'b000;
                    next_state = insert_state;
                    next_money = money;
                end
                else begin
                    next_state = state;
                    next_money = money - 7'd5;
                end
                 cancnt_next = 32'd0;
            end
            else begin
                cancnt_next = cancnt + 32'd1;
                next_money = money;
                next_state = state;
            end
       end
       default: begin
            next_money = 7'd0;
            next_state = insert_state;
       end
    endcase
end

always@(posedge clk)begin
    if(clk_display==1)begin
    cnt<=cnt+1;
    if(cnt==0)begin
        AN<=4'b1110;
        seg<=seg0;
    end
    else if(cnt==1)begin
        AN<=4'b1101;
        seg<=seg1;
    end
    else if(cnt==2)begin
        AN<=4'b1011;
        seg<=seg2;
    end
    else begin
        AN<=4'b0111;
        seg<=seg3;
    end
    end
end

insertmoney i1(seg0, seg1, seg2, seg3, money);
SampleDisplay s1(drink, PS2_DATA, PS2_CLK, rst_n, clk);


assign LED[3] = (state == 2'b00 && money >= 8'd75) ? 1 : 0;
assign LED[2] = (state == 2'b00 && money >= 8'd50) ? 1 : 0;
assign LED[1] = (state == 2'b00 && money >= 8'd30) ? 1 : 0;
assign LED[0] = (state == 2'b00 && money >= 8'd25) ? 1 : 0;

endmodule

module insertmoney(seg0, seg1, seg2, seg3, money);
input [6:0] money;
output reg [6:0] seg0, seg1, seg2, seg3;

always @(*) begin
    if(money >= 7'd100) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000001;
        seg2 = 7'b1001111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd95) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd90) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd85) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd80) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd75) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0001101;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd70) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0001101;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd65) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0100000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd60) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0100000;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd55) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0100100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd50) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0100100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd45) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1001100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd40) begin
        seg0 = 7'b0000001;
        seg1 = 7'b1001100;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd35) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0000110;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd30) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0000110;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd25) begin
        seg0 = 7'b0100100;
        seg1 = 7'b0010010;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd20) begin
        seg0 = 7'b0000001;
        seg1 = 7'b0010010;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd15) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1001111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd10) begin
        seg0 = 7'b0000001;
        seg1 = 7'b1001111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd5) begin
        seg0 = 7'b0100100;
        seg1 = 7'b1111111;
        seg2 = 7'b1111111;
        seg3 = 7'b1111111;
    end
    else if(money == 7'd0) begin
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

module debounce(pb_debounced,pb,clk);
output pb_debounced;
input pb;
input clk;
reg[3:0] dff;
always@(posedge clk)begin
        dff[3:1] <= dff[2:0];
        dff[0] <= pb;
end
assign pb_debounced=((dff == 4'b1111)?1'b1:1'b0);
endmodule

module onepulse(pb_debounced,clk,pb_onepulse);
input pb_debounced;
input clk;
output reg pb_onepulse;
reg pb_debounced_delay;
always@(posedge clk)begin
        pb_onepulse<=pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay<=pb_debounced;
end
endmodule



module SampleDisplay(
	output reg [2:0] drink,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	
parameter [8:0] KEY_CODES [0:3] = {
    9'b0_0001_1100,	// a => 1C
    9'b0_0001_1011,	// s => 1B
    9'b0_0010_0011,	// d => 23
    9'b0_0010_1011// f => 2B
    };
	
	
	reg [3:0] key_num;

	
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk, posedge rst) begin   
		if (rst) begin
			drink <= 3'b000;
		end else begin
			drink <= 3'b000;
			if (been_ready && key_down[last_change] == 1'b1) begin
				if (key_num != 3'b000)begin
					drink <= key_num;
				end
			end
		end
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 3'b001;
			KEY_CODES[01] : key_num = 3'b010;
			KEY_CODES[02] : key_num = 3'b011;
			KEY_CODES[03] : key_num = 3'b100;
			default		  : key_num = 3'b000;
		endcase
	end
	
endmodule


module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule

module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule
