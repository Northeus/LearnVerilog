module pwm(
	input 		clk,   // input clock
	input 		clken, // input clock enable
	input [7:0] duty,  // duty cycle
	output reg 	out	   // generated signal
	);

	reg [7:0] counter;

	always @(posedge clk)
        if (clken)
        begin
            counter <= counter + 1;
            out     <= &duty ? 1 : counter < duty;
        end
endmodule



