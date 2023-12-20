`timescale 1ns/1ns

module debouncer_tb;
    parameter PERIOD     = 10;
    parameter TEST_COUNT = 20;

    integer i;

    reg clk;
    reg clken;
    reg in;
    reg error;

    // Standard 1364-2005:
    // start address for readmem is the left address of memory.
    // might be different in quartus
    reg [0:1] data[0:19];

    wire out;

    debouncer #(.WIDTH(2), .PERIOD(3)) db(.clk(clk), .clken(clken), .in(in), .out(out));

    initial begin
        clk         = 0;
        clken       = 1;
        in          = 0;
        error       = 0;

        db.counter  = 0;
        db.out      = 0;

        $readmemb("data.b", data);
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    initial begin
        for (i = 0; i < 20; i += 1)
        begin
            @(posedge clk)
            in = data[i][0];

            #1
            if (out != data[i][1])
            begin
                $display($time,, "Error: expected=%b, got=%b", data[i][1], out);
                error = 1;
            end
        end

        if (error)
            $display("Tests failed!");
        else
            $display("Tests passed!");

        $finish;
    end

    initial begin
        $dumpfile("debouncer.vcd");
        $dumpvars(0, debouncer_tb);
    end
endmodule
