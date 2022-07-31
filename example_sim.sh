iverilog \
-o clock_divider_tb.out \
-D VCD_OUTPUT=clock_divider_tb \
example_tbv.v clock_divider.v;

vvp clock_divider_tb.out;

gtkwave clock_divider_tb.vcd;
