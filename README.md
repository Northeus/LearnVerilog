# LearnVerilog
Some verilog samples with testbanches.
To run a testbench and generate wave file in `.vcd` format use:

```sh
iverilog [testbench file] [modules file] && ./a.out
```

Unfortunatelly it feels, that `iverilog` behaves a bit differently than previously
used software (so for quartus there might be needed some minor changes). Possible
issue might be order of data loaded to vector from `readmemb` functions in testbench.
(or i just don't remember how it worked, that's also an option ^^)

## Tips
 - In case module doesn't have reset, set it's internal state for testbench.
 - Might leave out wave files (`.vcd`) from git repo.
 - Reset would be much nicer for all modules we intend to test as it would
   remove all the dependance on internal structure of the module to test it.
 - Tasks are really nice for removing duplicity in tests

## Coutner
Simple counter with basic testbench syntax.

## Seminars
Testbanches for tasks in seminars.
For quartus there might be need to do some minor changes,
as i use iverilog with possible different standard.

### Week06
This week contains following modules with test banches:
 - debouncer
 - find\_rise
 - pwm
 - timer
 - up_down_counter

### Week07
This week contains just moore\_state\_machine module with testbanch.

## Gravity center
Module and testbench for gravity center computation algoritmh.
