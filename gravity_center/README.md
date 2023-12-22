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
    output [7:0]    Xc,         // Computed center (x coordinate)
    output [7:0]    Yc);        // Computed center (y coordinate)
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

Whenever our data are ready, we simply set ready signal to high and on each
clock cycle send out corresponding data. After the reset all weights should
be zero, thus we should compute the center only from the received points.

Furthermore, due to the fact, that we are using whole numbers and we want the
most precise outcome, we have to round it to the closest integer.

Resultin point in case all the weights are zero should be $\left( 0, 0 \right)$.

## Difficulties
There are two optional difficulties to chose from when solving this problem.
Both are based on which point from the 5 loaded points should be swaped with
the new incoming point.

### Easy
We compute gravity center only from the latest 5 points. That means we always
replace the oldes point with a new one.

### Hard
We always replace the point that is furthest from the current gravity center.
In case of two points within the same distance, we pick the one with lower
X coordinate. If the X coordinates are same, we pick the point with lower Y
coordinate. If the Y coordinates are same, we pick the point with the lower W.

## Possible issues
Rounding on floats can be tricky in tests.

```py
    # doesn't work
    return (round(sum_x / sum_w), round(sum_y / sum_w))

    # work
    return (sum_x + sum_w // 2) // sum_w, (sum_y + sum_w // 2) // sum_w
```

## Possible upgrades
Generators in verilog might be used to deduplicate some code.
