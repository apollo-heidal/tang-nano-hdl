// The following registers are "buckets" that hold the current color state.
// At the beginning of each "shift" cycle (of which there are 6 * SHIFT_COLORS),
// this_shift_p/f registers are assigned values that sum to 32. The distribution
// of those values depends on how much of a certain color is desired.
// "p" and "f" refer to past and future, so if RED is the past color and MAGENTA the future,
// and we desire a color that is more red than magenta, then the value assigned to this_shift_p
// will be larger than this_shift_f. The "prev_" variables simply keep track of the previous shift color
// so we can perform a smooth transition across the rainbow.
// On each shift_clk, one of this_shift_p/f is decremented if it is not empty.
// The result is a rapid toggle between two neighboring colors that the human eye
// averages to make a single color between the two. By increasing the amount of "future" color
// on each shift cycle, we circularly transition between colors.

module rainbow_led (
    input clk,
    output reg [2:0] led
);

// localparam N_BASE_COLORS        = 6;    // 6 because WHITE/OFF are non-colors, in this case
// localparam N_COLORS_PER_BASE    = 5;    // num colors between eash base color
localparam N_BLUR_COLORS        = 1000; // just for readability
localparam C_W                  = $clog2(N_BLUR_COLORS); // color register width
// localparam N_COLORS             = N_COLORS_PER_BASE * N_BASE_COLORS;  // total colors

localparam TICKS_PER_MS     = 12_000;   // system clk speed
localparam BLUR_WINDOW_MS   = 5;        // in milliseconds
localparam BLUR_TICKS       = TICKS_PER_MS * BLUR_WINDOW_MS; // number of clk ticks in each blur window

// tracks blur clock;
// blurring is achieve by each color being 
// made up of blur slots, which are simply
// a high speed display of the past and future base colors.
// the number of times a base color is shown
// determines the the resulting color
reg [$clog2(BLUR_TICKS)-1:0]    blur_clk_cnt = 0;
reg [$clog2(N_BLUR_COLORS):0]   color_clk_count = 0;

// localparam BLUR_DIV         = TICKS_PER_MS / BLUR_WINDOW_MS;

// localparam RAINBOW_SECS         = 10;                               // seconds per rainbow cycle
// localparam RAINBOW_TICKS        = TICKS_PER_SEC * RAINBOW_SECS;     // clk ticks per rainbow cycle

// localparam MINOR_COLOR_TICKS = RAINBOW_TICKS / N_MINOR_COLORS;   // ticks per minor color

// clock_divider #(
//     .divisor(BLUR_DIV)
// ) clk1 (
//     .clk_in(clk),
//     .clk_out(shift_blur)
// );

// past and future base colors
reg [2:0] p_color;
reg [2:0] f_color;

// if this reg is non-empty, the current color
// is bias toward the "past" base color
reg [C_W-1:0] p_color_bias;
reg [C_W-1:0] last_p_color_bias;

// reg [C_W-1:0]   p_color_w;
// reg [C_W-1:0]   f_color_w;


// wire p_color_w_empty    = (p_color_w == 0);
// wire f_color_w_empty    = (f_color_w == 0);
wire shift_blur     = (blur_clk_cnt == BLUR_TICKS);
wire shift_color    = (color_clk_count == N_BLUR_COLORS);
// wire rst                = (blur_bias == 0);

initial begin
    led         = 'b011; // red
    p_color     = 'b011;
    f_color     = 'b101; // blue
    // p_color_w   = N_BLUR_COLORS; // initialize blur bias fully toward one color
    // f_color_w   = 'b0;
    p_color_bias  = N_BLUR_COLORS;
    last_p_color_bias = N_BLUR_COLORS;
end

// switches between blur colors
// and manages color clk counter
always @(posedge shift_blur) begin
    // blur
    if (p_color_bias == 0)
        led <= f_color;
    else begin
        led <= p_color;
        p_color_bias <= p_color_bias - 1;
    end

    // color clk counter
    if (shift_color) begin
        color_clk_count <= 0;
        p_color_bias <= last_p_color_bias - 1;
        last_p_color_bias <= last_p_color_bias - 1;
    end else
        color_clk_count <= color_clk_count + 1;
end

// drive blur color shift
// wire shift_blur_color = (blur_clk_cnt == BLUR_TICKS);
always @(posedge clk) begin
    if (blur_clk_cnt == BLUR_TICKS) begin
        blur_clk_cnt <= 0;
    end else begin
        blur_clk_cnt <= blur_clk_cnt + 1;
    end
end


// always @(posedge shift_color) begin // DEBUG: never reached in sim
    // if (rst) blur_bias <= N_BLUR_COLORS;
    // f_color_w <= N_BLUR_COLORS - blur_bias;
    // blur_bias <= blur_bias - 1;
// end

// always @(negedge shift_color) begin
// end

// always @(posedge rst) begin
//     p_color <= f_color;
//     f_color <= p_color;
// end

// // drive minor color shift
// reg [$clog2(MINOR_COLOR_TICKS)-1:0] minor_clk_cnt = 0;
// wire shift_minor_color = (minor_clk_cnt == MINOR_COLOR_TICKS);
// always @(posedge clk) begin
//     if (shift_minor_color) begin
//         minor_clk_cnt <= 0;
//     end else begin
//         minor_clk_cnt <= minor_clk_cnt + 1;
//     end
// end

// // drive base color shift
// reg [$clog2(N_M_COLORS_PER_BASE)-1:0] base_clk_cnt = 0;
// wire shift_base_color = (base_clk_cnt == N_M_COLORS_PER_BASE);
// always @(posedge shift_minor_color) begin
//     if (shift_base_color) begin
//         base_clk_cnt <= 0;
//     end else begin
//         base_clk_cnt <= base_clk_cnt + 1;
//     end
// end

// // shift base color
// always @(posedge shift_base_color) begin
//     past_base_color     <= future_base_color;
//     future_base_color   <= past_base_color;
// end

// // reset to next minor color or pick current blur color
// reg [2:0] past_base_color    = RED;
// reg [2:0] future_base_color  = ~RED;

// localparam W = $clog2(N_M_COLORS_PER_BASE)-1;
// reg [W:0] last_past_blur_col = 0;
// reg [W:0] last_fut_blur_col  = 0;
// reg [W:0] this_past_blur_col = N_M_COLORS_PER_BASE;
// reg [W:0] this_fut_blur_col  = 0;

// always @(shift_minor_color) begin
//     this_past_blur_col  <= last_past_blur_col - 1;
//     this_fut_blur_col   <= last_fut_blur_col + 1;

//     last_past_blur_col  <= this_past_blur_col;
//     last_fut_blur_col   <= this_fut_blur_col;

//     this_past_blur_col  <= this_past_blur_col - 1;
//     this_fut_blur_col   <= this_fut_blur_col - 1;
// end

// wire p_empty = (this_past_blur_col  == 0);
// wire f_empty = (this_fut_blur_col   == 0);

// always @(posedge shift_blur_color) begin
//     if (!p_empty) begin
//         led <= past_base_color;
//     end else if (!f_empty) begin
//         led <= future_base_color;
//     end else begin
//         led <= GREEN;
//     end
// end
endmodule