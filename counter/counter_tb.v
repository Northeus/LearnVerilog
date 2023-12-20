`timescale 1ns/1ns

module counter_tb;
    parameter PERIOD = 10;

    integer i;

    reg         CLK;
    reg         Reset;

    wire [7:0]  counter_data;

    counter c(.CLK(CLK), .Reset(Reset), .data(counter_data));

    initial begin
        CLK = 0;

        forever #(PERIOD / 2.0)
            CLK = ~CLK;
    end

    initial begin
        Reset = 1;

        @(negedge CLK)
        Reset = 0;

        for (i = 0; i < 16; i = i + 1)
        begin
            @(posedge CLK)
            if (i != counter_data)
                $display($time,, "Error: expected=%d, got=%d", i, counter_data);
        end

        $finish;
    end

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
    end
endmodule
