`timescale 1ns/1ns

module find_rise_tb;
    parameter PERIOD = 10;

    reg clk;
    reg in;
    reg err;

    wire out;

    find_rise fr(.clk(clk), .in(in), .out(out));

    initial begin
        clk = 0;
        in  = 0;
        err = 0;

        fr.prev = 0;
    end

    initial begin
        forever #(PERIOD / 2.0)
            clk = ~clk;
    end

    initial begin
        @(posedge clk) #1
        err = err || (out != 0);

        @(posedge clk) #1
        err = err || (out != 0);

        @(negedge clk)
        in = 1;

        @(posedge clk) #1
        err = err || (out != 1);

        @(posedge clk) #1
        err = err || (out != 0);

        @(negedge clk)
        in = 0;

        @(posedge clk) #1
        err = err || (out != 0);

        @(negedge clk)
        in = 1;

        @(posedge clk) #1
        err = err || (out != 1);

        @(posedge clk) #1
        err = err || (out != 0);

        @(posedge clk) #1
        err = err || (out != 0);

        if (err)
            $display("Tests failed!");
        else
            $display("Tests passed!");

        $finish;
    end

    initial begin
        $dumpfile("find_rise.vcd");
        $dumpvars(0, find_rise_tb);
    end

endmodule
