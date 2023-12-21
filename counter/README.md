# Counter
Simple module that increment output variable on each positive edge
clock signal with asynchronous reset that sets the output variable
to zero. There is induced bug that counter stop incrementing the data
register after reaching value 10 to show failerd tests in the testbench.

## Testbench
Simple testbench, which generates clock cycle and check the output value
for 16 clock cycles.
