// **************************************************
// TASK :  build the Moore state machine
//
//  - states: RESET                    - initial state
//            KEY1, KEY2,  KEY3, KEY4  - waiting for keys
//			  UNLOCK                   - the lock is unlocked
//
//   sequence for unlocking: keys = 0001,0100,1000,0010
//
//   wrong sequence of keys resets state machiine
//
// **************************************************
module moore_state_machine
(
	input        clk,
    input        reset,    // input clock and asynchronous reset
	input  [3:0] keys,     // input keys, log 1 is after pressing of key for one cycle of clk
	output       unlock,   // 1 after right sequence of keys, 0 in other states
	output [3:0] progress  // progress of keys pressing
);

    parameter
        RESET  = 0,
        KEY1   = 1,
        KEY2   = 2,
        KEY3   = 3,
        KEY4   = 4,
        UNLOCK = 5;

    reg [2:0] state;

    assign unlock = state == UNLOCK;

    assign progress[0] = state == KEY2;
    assign progress[1] = state == KEY3;
    assign progress[2] = state == KEY4;
    assign progress[3] = state == UNLOCK;

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            state <= RESET;
        else
            case (state)
                RESET:                  state <= KEY1;
                KEY1:       if (|keys)  state <= |(keys & ~4'b0001) ? RESET : KEY2;
                KEY2:       if (|keys)  state <= |(keys & ~4'b0100) ? RESET : KEY3;
                KEY3:       if (|keys)  state <= |(keys & ~4'b1000) ? RESET : KEY4;
                KEY4:       if (|keys)  state <= |(keys & ~4'b0010) ? RESET : UNLOCK;
                UNLOCK:                 state <= UNLOCK;
                default:    state <= RESET;
            endcase
    end
endmodule
