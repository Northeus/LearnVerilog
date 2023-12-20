module debouncer #(parameter WIDTH = 10, parameter PERIOD = 500)(
	input clk,
	input clken,
	input in,
	output reg out);

    reg [WIDTH - 1:0] counter;

    always @(posedge clk)
        if (clken)
            if (counter == PERIOD - 1)
            begin
                counter <= 0;
                out     <= in;
            end
            else
                counter <= counter + 1;
endmodule

