# Moore state machine
Moore state machine for guessing code based on keys. Code is `0231`.

## Testbench
Testbench uses data stored in `data.b` file generated by `gen.py` script.

## Possible issues
We have to consider multiple keys pressed at the same time.

Progress value might be more specified.

## Possible upgrades
It might be nicer to have "unit test" structure so there is more info
than test passed / failed at given time. For example we might have
multiple separated tests for different purposes (e.g.: reset, multiple
keys pressed at once, correct combination, wrong combination).