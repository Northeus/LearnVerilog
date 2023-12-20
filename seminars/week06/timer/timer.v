module timer #(parameter WIDTH = 32, parameter PERIOD = 1000)(
	input  clk,
	output out);

    reg [WIDTH - 1:0] counter;

    assign out = counter == PERIOD - 1;

    always @(posedge clk)
        counter <= out ? 0 : counter + 1;
endmodule
