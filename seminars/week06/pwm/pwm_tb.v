`timescale 1ns/1ns

module pwm_tb;
    parameter PERIOD     = 10;
    parameter TEST_COUNT = 20;

    integer i;
    integer j;

    reg         clk;
    reg         clken;
    reg [7:0]   duty;
    reg [7:0]   counter;
    reg         error;

    wire out;

    pwm p(.clk(clk), .clken(clken), .duty(duty), .out(out));

    initial begin
        clk     = 0;
        clken   = 1;
        error   = 0;

        p.counter = 255;
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    initial begin
        // Testing specific duty cycle
        duty        = 42;
        p.counter   = 255;

        for (j = 0; j < 2; j += 1)
        begin
            counter = 0;

            for (i = 0; i < 256; i += 1)
            begin
                @(posedge clk) #1
                counter += out;
            end

            error = error | (counter != duty);
        end

        if (error)
            $display("Error: Pwm wasn't set exactly for given pwm duty cycle!");

        // Testing zero duty cycle
        duty = 0;

        for (i = 0; i < 1024; i += 1)
        begin
            @(posedge clk) #1
            error = error | out;
        end

        if (error)
            $display("Error: there was a pulse durning zero duty cycle!");

        error = 0;

        // Testing full duty cycle
        duty = 255;

        for (i = 0; i < 1024; i += 1)
        begin
            @(posedge clk) #1
            error = error | !out;
        end

        if (error)
            $display("Error: out wasn't held up continuously durning full duty cycle!");

        // Testing clken
        clken   = 0;
        duty    = 0;

        @(posedge clk) #1
        if (!out)
            $display("Error: clken might not work properly!");

        $finish;
    end

    initial begin
        $dumpfile("pwm.vcd");
        $dumpvars(0, pwm_tb);
    end
endmodule
