`timescale 1ns/1ns

module segment7_tb;
    integer i;

    reg         enable;
    reg         error;
    reg [3:0]   data;
    reg [6:0]   expected;

    wire [6:0] out;

    segment7 s7(.enable(enable), .data(data), .seg(out));

    initial begin
        enable  = 1;
        error   = 0;

        for (i = 0; i < 16; i += 1)
        begin
            #1
            data = i;

            // Test combinations:
            #1
            // Possible to use case instead of another mem file
			case (data)
				4'h0   : expected = 7'b1000000;
				4'h1   : expected = 7'b1111001;
				4'h2   : expected = 7'b0100100;
				4'h3   : expected = 7'b0110000;
				4'h4   : expected = 7'b0011001;
				4'h5   : expected = 7'b0010010;
				4'h6   : expected = 7'b0000010;
				4'h7   : expected = 7'b1111000;
				4'h8   : expected = 7'b0000000;
				4'h9   : expected = 7'b0011000;
				4'hA   : expected = 7'b0001000;
				4'hb   : expected = 7'b0000011;
				4'hC   : expected = 7'b1000110;
				4'hd   : expected = 7'b0100001;
				4'hE   : expected = 7'b0000110;
				4'hF   : expected = 7'b0001110;
				default: expected = 7'b1111111;
			endcase

            if (out != expected)
            begin
                error = 1;
                $display("Error: input=%h, output=%b, expected=%b", data, out, expected);
            end
        end

        // Test enable:
        #1
        data    = 0;
        enable  = 0;

        #1
        if (!(&out))
            $display("Error: enable won't turn off segment!");

        if (error)
            $display("Test failed!");
        else
            $display("Test passed!");

        $finish;
    end

    initial begin
        $dumpfile("segment7.vcd");
        $dumpvars(0, segment7_tb);
    end
endmodule
