# Gravity center
Modules computing gravity center from a set of given points.

## Description
The interface is as follows:

```verilog
module gravity_center(
    input           clk,        // Clock signal
    input           rst,        // Reset signal
    input [7:0]     X,          // X value
    input [7:0]     Y,          // Y value
    input [3:0]     W,          // Weight
    output          ready,      // Data ready
    output [7:0]    center);    // Computed center
```

On each clk cycle, there is given a point `P` via its coordinates `(X, Y)`
and weight `W`. Our module should store up to 5 points and compute the
center of gravity $\( X_{gc}, Y_{gc} $\) as follows:

$$\left( X_{gc}, Y_{gc} \right) =
    \left(
        \frac{ \sum\limits_{i=1}^5 X_i W_i }{ \sum\limits_{i=1}^5 W_i } \,
        \frac{ \sum\limits_{i=1}^5 Y_i W_i }{ \sum\limits_{i=1}^5 W_i }
    \right)$$

I.e. the center of gravity is the weighted mean of last 5 points.

## Difficulties




