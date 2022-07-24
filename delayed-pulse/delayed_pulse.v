module delayed_pulse #(
    parameter t_us_delay  = 25_000, // microseconds between pulses
    parameter t_us_pulse_width = 50 // microseconds pulse width
) (
    input       sys_clk,
    input       init,   // pull-up
    input       pulse_disable,

    output reg  pulse_out  // pull-up
);

localparam PULSE_TICKS  = 24 * t_us_pulse_width;    // 24Mhz system clock
localparam DELAY_TICKS  = 24 * t_us_delay;

reg [$clog2(PULSE_TICKS)-1:0]   pulse_cnt = 0;
reg [$clog2(DELAY_TICKS)-1:0]   delay_cnt = 0;

wire pulse_start    = !init && !pulse_disable && (delay_cnt == 0);
wire pulse_end      = (pulse_cnt == PULSE_TICKS);
wire delay_end      = (delay_cnt == DELAY_TICKS);

always @(posedge sys_clk) begin
    if (pulse_start) begin
        pulse_out <= 'b0;
    end else if (pulse_end) begin
        pulse_out <= 'b1;
        pulse_cnt <= 0;
    end else if (delay_end) begin
        delay_cnt <= 0;
    end
    pulse_cnt <= pulse_cnt + 1;
    delay_cnt <= delay_cnt + 1;
end
endmodule
