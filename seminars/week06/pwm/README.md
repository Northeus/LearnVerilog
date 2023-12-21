# PWM
Pulse width modulation module that based on a given input
produces signal. It's quite easy, yet we need to be careful
to also address full and empty duty cycles.

## Testbench
Testbench tests following cases:
 - We get precisely the duty cycle we set (in our case 42)
 - Zero duty cycle won't generate any pulses
 - Full duty cycle will keep wire in high constantly
 - Clock gate won't allow to update the pwm if it's disabled

## Possible issue
There again missin the reset button so we have to either do it in testbench
or in the pwm module.
