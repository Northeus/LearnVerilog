module moore_state_machine
(
	input	         clk,
    input            reset,    // input clock and asynchronous reset
	input      [3:0] keys,     // input keys, log 1 is after pressing of key for one cycle of clk
	output reg       unlock,   // 1 after right sequence of keys, 0 in other states
	output reg [3:0] progress  // progress of keys pressing
);

...

   // **************************************************
	// TASK :  build the Moore state machine
	//  
	//   states: RESET                    - initial state 
	//           KEY1, KEY2,  KEY3, KEY4  - waiting for keys
   //				 UNLOCK                   - the lock is unlocked
	//  
	//   sequence for unlocking: keys = 0001,0100,1000,0010
	//   
	//   wrong sequence of keys resets state machiine
	// 
	// **************************************************


endmodule
