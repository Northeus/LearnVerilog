`timescale 1ns/1ns

module moore_state_machine_tb;
    parameter PERIOD     = 10;
    parameter TEST_COUNT = 200;

    integer i;

    reg         clk;
    reg         reset;
    reg [3:0]   keys;
    reg         expected_unlock;
    reg [3:0]   expected_progress;
    reg         error;

    wire        unlock;
    wire [3:0]  progress;

    // Standard 1364-2005:
    // start address for readmem is the left address of memory.
    // might be different in quartus
    reg [0:9] data[0:TEST_COUNT - 1];

    moore_state_machine msm(
        .clk(clk), .reset(reset), .keys(keys), .unlock(unlock), .progress(progress));

    initial begin
        clk         = 0;
        reset       = 0;
        keys        = 0;
        error       = 0;

        $readmemb("data.b", data);
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    initial begin
        #1 reset = 1;
        #1 reset = 0;

        for (i = 0; i < TEST_COUNT; i += 1)
        begin
            @(posedge clk)
            keys                = data[i][0:3];
            expected_unlock     = data[i][4];
            expected_progress   = data[i][5:8];
            reset               = data[i][9];

            #1
            if ({unlock, progress} != {expected_unlock, expected_progress})
            begin
                $display($time,,
                    "Error: expected=[unlock=%b, progress=%b], got=[unlock=%b, progress=%b]",
                    expected_unlock, expected_progress, unlock, progress);
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
        $dumpfile("moore_state_machine.vcd");
        $dumpvars(0, moore_state_machine_tb);
    end
endmodule
