# Timer
Timer module working as prescaler. Parameter `PERIOD` gives a scale factor
for the clock signal and the `WIDTH` parameter sets the required size of the
counter register to hold the `PERIOD` value.

## Testbench
Testbench simply loop over 3 timer cycles and check if the outcome is correct.

## Possible issue
There again missin the reset button so we have to either do it in testbench
or in the timer module.
