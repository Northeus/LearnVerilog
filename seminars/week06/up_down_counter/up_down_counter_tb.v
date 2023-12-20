`timescale 1ns/1ns

module up_down_counter_tb;
    parameter PERIOD = 10;

    integer i;

    reg         clk;
    reg         up;
    reg         down;
    reg         error;
    reg [7:0]   state;

    wire [7:0] out;

    up_down_counter t(.clk(clk), .up(up), .down(down), .data(out));

    initial begin
        clk     = 0;
        up      = 0;
        down    = 0;
        error   = 0;

        // There might be a problem in case of different solutions
        t.data = 0;
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    task check;
    input [7:0] dir;
    begin
        state = out;

        for (i = 0; i < 10; i += 1)
        begin
            @(posedge clk) #1
            state += dir;

            if (state != out)
            begin
                error = 1;
                $display($time,, "Error: dir=%d, expected=%d, got=%d", dir, state, out);
            end
        end
    end
    endtask

    initial begin
        check(0);

        down = 1;
        check(-1);

        up   = 1;
        check(1);

        up   = 0;
        down = 0;
        check(0);

        up   = 1;
        check(1);

        if (error)
            $display("Tests failed!");
        else
            $display("Tests passed!");

        $finish;
    end

    initial begin
        $dumpfile("up_down_counter.vcd");
        $dumpvars(0, up_down_counter_tb);
    end
endmodule
