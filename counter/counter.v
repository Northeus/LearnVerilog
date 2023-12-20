module counter(input CLK, input Reset, output reg[7:0] data);
    always @(posedge CLK or posedge Reset)
    begin
        if (Reset)
            data <= 0;
        else
            data <= data == 10 ? 10 : data + 1; // Some bug
    end
endmodule
