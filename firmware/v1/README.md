# Template circuits

## basic

Minimalistic circuit turning on LEDs according to the push-buttons and displaying a digit on the 7-segment display.

## basic\_selftest

This design separates the "core" circuit and a "self-test" circuit in distinct files. 

Pressing the center push button on power-up or reset enters the self-test mode.
In the self test mode, the LEDs and 7-displays show an animation and count. The push buttons allow to change the direction of the animation or count.
This allows to test the functionality of all the on-board peripherals (buttons, display, clock).

The "core" functionality in this example is another animation on the 7-segment display.

This circuit can be used as a starting point for more complex designs, with the self-test functionality useful as a basic check of the hardware.

## uart\_selftest

This design includes a UART in the "core" circuit. 
Data is sent over the UART (9600 bps), and the data received from the UART is shown on the 7-segment display.

Using the UART assumes that BlueMax is plugged onto BasePower, which includes a UART-USB transceiver. 
Alternatively, it can be used with BlueSense, if the firmware of BlueSense is modified to enable its UART interface on the appropriate pins.

