// synchronous up/down counter
module up_down_counter(
	input clk,				// clock, active in rising edge
	input up,				// counting enable up, higher priority then down counting
	input down,		   		// counting enable down
	output reg [7:0] data 	// output data
	);

    wire [7:0] value;

    assign value = up ? 1 : (down ? -1 : 0);

    always @(posedge clk)
        data <= data + value;

endmodule
