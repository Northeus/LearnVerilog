module gravity_center(
    input               clk,        // Clock signal
    input               rst,        // Reset signal
    input [7:0]         X,          // X value
    input [7:0]         Y,          // Y value
    input [3:0]         W,          // Weight
    output reg          ready,      // Data ready
    output reg [7:0]    Xc,         // Computed center (x coordinate)
    output reg [7:0]    Yc);        // Computed center (y coordinate)

    integer i;

    reg [7:0] mem_x[0:4];
    reg [7:0] mem_y[0:4];
    reg [3:0] mem_w[0:4];
    reg [2:0] counter;

    // Ensures that ready is set when data are computed.
    reg next;

    wire [6:0]  sum_w;
    wire [15:0] sum_x;
    wire [15:0] sum_y;

    wire [7:0] result_x;
    wire [7:0] result_y;

    assign sum_w = mem_w[0] + mem_w[1] + mem_w[2] + mem_w[3] + mem_w[4];
    assign sum_x = mem_x[0] * mem_w[0]
                 + mem_x[1] * mem_w[1]
                 + mem_x[2] * mem_w[2]
                 + mem_x[3] * mem_w[3]
                 + mem_x[4] * mem_w[4];
    assign sum_y = mem_x[0] * mem_w[0]
                 + mem_x[1] * mem_w[1]
                 + mem_x[2] * mem_w[2]
                 + mem_x[3] * mem_w[3]
                 + mem_x[4] * mem_w[4];

    assign result_x = (sum_x + sum_w / 2) / sum_w;
    assign result_y = (sum_y + sum_w / 2) / sum_w;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            counter <= 0;
            ready   <= 0;
            next    <= 0;

            for (i = 0; i < 5; i += 1)
            begin
                mem_w[i] <= 0;

                // For test (in reality might not be needed)
                mem_x[i] <= 0;
                mem_y[i] <= 0;
            end
        end
        else
        begin
            mem_x[counter] <= X;
            mem_y[counter] <= Y;
            mem_w[counter] <= W;

            ready   <= next;
            next    <= 1;

            Xc <= |sum_w ? result_x : 0;
            Yc <= |sum_w ? result_y : 0;

            // Ternary might be faster than mod
            counter <= (counter + 1) % 5;
        end
    end
endmodule
