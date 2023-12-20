`timescale 1ns/1ns

module timer_tb;
    parameter PERIOD        = 10;
    parameter TIMER_PERIOD  = 3;
    parameter TIMER_WIDTH   = 2;

    integer i;

    reg                     clk;
    reg                     error;
    reg [TIMER_WIDTH - 1:0] counter;

    wire out;

    timer #(.WIDTH(TIMER_WIDTH), .PERIOD(TIMER_PERIOD)) t(.clk(clk), .out(out));

    initial begin
        clk     = 0;
        error   = 0;
        counter = 0;

        // There might be a problem in case of different solutions
        t.counter = 0;
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    initial begin
        @(posedge out);

        for (i = 0; i < TIMER_PERIOD * 3; i += 1)
        begin
            @(posedge clk) #1
            counter += 1;

            if ((out && counter < TIMER_PERIOD) || (!out && counter >= TIMER_PERIOD))
            begin
                error = 1;
                $display($time,, "Error: expected=%b, got=%b", 1, out);
            end

            if (out)
                counter = 0;
        end

        if (error)
            $display("Tests failed!");
        else
            $display("Tests passed!");

        $finish;
    end

    initial begin
        $dumpfile("timer.vcd");
        $dumpvars(0, timer_tb);
    end
endmodule
