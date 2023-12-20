module find_rise(input clk, input in, output reg out);
    reg prev;

    always @(posedge clk)
    begin
        prev    <= in;
        out     <= !prev && in;
    end
endmodule
