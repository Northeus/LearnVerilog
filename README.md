# LearnVerilog
Some verilog samples with testbanches.
To run a testbench and generate wave file in `.vcd` format use:

```sh
iverilog [testbench file] [modules file] && ./a.out
```

Unfortunatelly it feels, that `iverilog` behaves a bit differently than previously
used software (so for quartus there might be needed some minor changes).

## Tips
 - In case module doesn't have reset, set it's internal state for testbench.
 - Might leave out wave files (`.vcd`) from git repo.
 - Reset would be much nicer for all modules we intend to test as it would
   remove all the dependance on internal structure of the module to test it.


## Coutner
Simple counter with basic testbench syntax;

## Seminars
Testbanches for tasks in seminars.
For quartus there might be need to do some minor changes,
as i use iverilog with possible different standard.

### Week06
This week contains following modules with test banches:
 - debouncer
 - find\_rise
 - pwm
 -

### Week07

## Gravity center
