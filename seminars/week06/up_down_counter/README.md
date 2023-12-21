# Up down counter
Counter counting in a direction given by the given signals.

## Testbench
We just iterate over a few clock cycles and check whether the module
behaves as supposed to do using our task `check` that do all the work.

## Possible issue
There again missin the reset button so we have to either do it in testbench
or in the up\_down\_counter module.

