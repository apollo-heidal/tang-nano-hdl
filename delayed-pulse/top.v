module top (
    input   sys_clk,
    input   button_a,
    input   button_b,

    output reg pulse_out
);

wire init           = button_a;
wire pulse_disable  = !button_b;

delayed_pulse #(
    .t_us_delay(30_000),
    .t_us_pulse_width(800)
) uut (
    .sys_clk(sys_clk),
    .init(init),
    .pulse_disable(pulse_disable),
    .pulse_out(pulse_out)
);
endmodule
