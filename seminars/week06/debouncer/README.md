# Debouncer
Module for a button debouncing using slow sampling. Parameter `PERIOD`
gives a scale factor for clock, how much slower we want to sample and
`WIDTH` parameter sets the required size of counter register to hold
`PERIOD` value.

## Testbench
Testbench uses reading from file with data in a numerical binary format
and use these data to test the module functionality.

## Possible issues
Since the module doesn't have reset signal, we need to initialize its
register ourself (or we might add this initialization into the module).

Furthermore, the standard used by iverilog for loading data using
`readmemb` function requires left address to be lower than right to
order things in an intuitive way (1364-2005).

