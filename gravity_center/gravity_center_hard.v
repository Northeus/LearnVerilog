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

    assign sum_w = mem_w[0] + mem_w[1] + mem_w[2] + mem_w[3] + mem_w[4];
    assign sum_x = mem_x[0] * mem_w[0]
                 + mem_x[1] * mem_w[1]
                 + mem_x[2] * mem_w[2]
                 + mem_x[3] * mem_w[3]
                 + mem_x[4] * mem_w[4];
    assign sum_y = mem_y[0] * mem_w[0]
                 + mem_y[1] * mem_w[1]
                 + mem_y[2] * mem_w[2]
                 + mem_y[3] * mem_w[3]
                 + mem_y[4] * mem_w[4];

    wire [7:0] result_x;
    wire [7:0] result_y;

    assign result_x = (sum_x + sum_w / 2) / sum_w;
    assign result_y = (sum_y + sum_w / 2) / sum_w;

    wire [16:0] distances[4:0];
    wire [4:0] is_geq;
    wire [4:0] candidates;

    // Why do it simple, when we can overcomplicate it ^^
    genvar g;
    generate
        // Lol, compiler i use can't parse g += 1 on genvar
        for (g = 0; g < 5; g = g + 1)
        begin
            assign distances[g] = (mem_x[g] - result_x) * (mem_x[g] - result_x)
                                + (mem_y[g] - result_y) * (mem_y[g] - result_y);

            // This could also go through the loop but now it's complicated enough
            assign is_geq[g] =
                ((distances[0] < distances[g])
                 | (distances[0] == distances[g]
                   & {mem_x[g], mem_y[g], mem_w[g]} <= {mem_x[0], mem_y[0], mem_w[0]}))
              & ((distances[1] < distances[g])
                 | (distances[1] == distances[g]
                   & {mem_x[g], mem_y[g], mem_w[g]} <= {mem_x[1], mem_y[1], mem_w[1]}))
              & ((distances[2] < distances[g])
                 | (distances[2] == distances[g]
                   & {mem_x[g], mem_y[g], mem_w[g]} <= {mem_x[2], mem_y[2], mem_w[2]}))
              & ((distances[3] < distances[g])
                 | (distances[3] == distances[g]
                   & {mem_x[g], mem_y[g], mem_w[g]} <= {mem_x[3], mem_y[3], mem_w[3]}))
              & ((distances[4] < distances[g])
                 | (distances[4] == distances[g]
                   & {mem_x[g], mem_y[g], mem_w[g]} <= {mem_x[4], mem_y[4], mem_w[4]}));

            if (g == 0)
                assign candidates[0] = is_geq[0];
            else
                assign candidates[g] = !(|candidates[g-1:0]) & is_geq[g];
        end
    endgenerate

    wire [2:0] candidate_addr;

    assign candidate_addr[0] = candidates[1] | candidates[3];
    assign candidate_addr[1] = candidates[2] | candidates[3];
    assign candidate_addr[2] = candidates[4];

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
            if (counter < 5)
            begin
                mem_x[counter] <= X;
                mem_y[counter] <= Y;
                mem_w[counter] <= W;
            end
            else
            begin
                mem_x[candidate_addr] <= X;
                mem_y[candidate_addr] <= Y;
                mem_w[candidate_addr] <= W;
            end

            ready   <= next;
            next    <= 1;

            Xc <= |sum_w ? result_x : 0;
            Yc <= |sum_w ? result_y : 0;

            counter <= counter == 5 ? 5 : counter + 1;
        end
    end
endmodule
