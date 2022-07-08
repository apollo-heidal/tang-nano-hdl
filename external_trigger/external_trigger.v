module external_trigger #(
    parameter t_us_int  = 25_000,   // microseconds between trigger pulses
    parameter t_us_trig = 50        // microseconds trig pulse width
) (
    input bin_in,   // pull-up
    input trig_out, // pull-down; must be inactive (LOW) to trigger  

    output reg trig_in  // pull-up
);

localparam int_ticks    = t_us_int * 24; // 24cycles / 1microsecond sysclk
localparam trig_ticks   = t_us_trig * 24;

localparam [$clog2(int_ticks)-1:0]  int_counter  = 0;
localparam [$clog2(trig_ticks)-1:0] trig_counter = 0;

wire can_trig   = ~bin_in && ~trig_out; // bin is ready and detector is ready

always @(posedge clk) begin
    if (~trig_in) begin
        if (trig_counter == trig_ticks) begin
            trig_in <= 1;
            trig_counter <= 0;
        end else trig_counter <= trig_counter + 1;
    end else if (can_trigger && (int_counter == int_ticks)) begin

        trig_in <= 0;
    end else if ()
end
    
endmodule