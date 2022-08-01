iverilog \
-o rainbow_led_tb.out \
-D VCD_OUTPUT=rainbow_led_tb \
rainbow_led_tbv.v \
rainbow_led.v \
clock_divider.v;

vvp rainbow_led_tb.out;

gtkwave rainbow_led_tb.vcd;
