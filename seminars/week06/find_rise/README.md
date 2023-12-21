# Find rise
Module that create an impulse on a rising edge.

## Testbench
Simple testbench that just set and check values.

## Possible issue
There again missin the reset button so we have to either do it in testbench
or in the find\_rise module.

## Possible upgrades
There is some code duplication that could be taken out.
For example create some task to check results:

```verilog
// Check value on the next cycle
task check_outcome(input true_value);
begin
    @(posedge clk) #1
    err = err || (out != true_value);
end
endtask

// Set input on next negative edge (before next cycle)
task set_input(input value);
begin
        @(negedge clk)
        in = value;
end
endtask
```

Or we might just simply use `readmemb` to load test data.
