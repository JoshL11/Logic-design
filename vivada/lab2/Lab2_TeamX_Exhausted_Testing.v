`timescale 1ns/1ns

module RCA_t;

reg error = 1'b0;
reg done = 1'b0;;
wire [3:0] sum;
wire cout;


// input signal to the test instance.
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;
reg cin = 1'b0;

// output from the test instance.

// instantiate the test instance.
Ripple_Carry_Adder R55C7A(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout(cout),
    .sum(sum)
    
);

initial begin
   repeat(2 ** 4) begin
        repeat(2 ** 4) begin
            b = b + 4'b0001;
            repeat(2) begin
                cin = cin + 1'b1;
                #1 if((a+b+cin) !== {cout,sum}) error = 1'b1;
                else error = 1'b0;
                #4 ;
            end
        end
        a = a + 4'b0001;
    end 
    #1 error = 1'b0;
    #4 done = 1'b1;
    #5 done =  1'b0;
end

endmodule