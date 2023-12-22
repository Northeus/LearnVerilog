`timescale 1ns/1ns

module gravity_center_tb;
    parameter PERIOD     = 10;
    parameter TEST_COUNT = 100;

    integer i;
    integer j;

    reg         clk;
    reg         rst;
    reg [7:0]   X;
    reg [7:0]   Y;
    reg [3:0]   W;
    reg [7:0]   expected_X;
    reg [7:0]   expected_Y;
    reg         error;

    wire        ready;
    wire [7:0]  Xc;
    wire [7:0]  Yc;

    // Standard 1364-2005:
    // start address for readmem is the left address of memory.
    // might be different in quartus
    reg [0:35] data[0:TEST_COUNT - 1];

    // Gated helper
    wire clk_ready;

    assign clk_ready = ready & clk;

    gravity_center gc(
        .clk(clk), .rst(rst), .X(X), .Y(Y), .W(W), .ready(ready), .Xc(Xc), .Yc(Yc));

    initial begin
        clk     = 0;
        rst     = 0;
        error   = 0;

        $readmemh("data_easy.h", data);
    end

    initial
        forever #(PERIOD / 2.0)
            clk = ~clk;

    // Input
    initial begin
        #1 rst = 1;
        #1 rst = 0;

        for (i = 0; i < TEST_COUNT; i += 1)
        begin
            @(posedge clk)
            X = data[i][0:7];
            Y = data[i][8:15];
            W = data[i][16:19];
        end
    end

    // Tests
    initial begin
        for (j = 0; j < TEST_COUNT; j += 1)
        begin
            @(posedge clk_ready)
            #1

            if (ready)
            begin
                expected_X = data[j][20:27];
                expected_Y = data[j][28:35];

                if ({Xc, Yc} != {expected_X, expected_Y})
                begin
                    $display($time,,
                        "Error: expected=(%h, %h), got=(%h, %h), id=%0d",
                        expected_X, expected_Y, Xc, Yc, j);
                    error = 1;
                end
            end
        end

        if (error)
            $display("Tests failed!");
        else
            $display("Tests passed!");

        $finish;
    end

    initial begin
        $dumpfile("gravity_center_easy_tb.vcd");
        $dumpvars(0, gravity_center_tb);
    end
endmodule
