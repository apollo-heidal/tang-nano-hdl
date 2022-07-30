module rainbow_led #() (
    input clk,
    input button_a,
    input button_b,

    output reg [2:0] led
);

wire rst = !button_a;

// base colors
localparam WHITE    = 3'b000;
localparam MAGENTA  = 3'b001;
localparam YELLOW   = 3'b010;
localparam RED      = 3'b011;
localparam CYAN     = 3'b100;
localparam BLUE     = 3'b101;
localparam GREEN    = 3'b110;
localparam OFF      = 3'b111;

localparam N_BASE_COLORS    = 6;    // 6 because WHITE/OFF are not part of this rainbow
localparam N_SHIFT_COLORS   = 32;   // 32 different colors between 6 base colors

localparam CYCLE_SECS   = 10;                        // 6 seconds per rainbow cycle
localparam CYCLE_TICKS  = 12_000_000 * CYCLE_SECS;  // clk ticks per rainbow cycle
localparam SHIFT_TICKS  = CYCLE_TICKS / (N_BASE_COLORS * N_SHIFT_COLORS); // number of clk ticks in each shift slot

reg [$clog2(SHIFT_TICKS):0]         shift_cnt           = 0;
wire                                shift_clk           = (shift_cnt == SHIFT_TICKS);

reg [$clog2(N_SHIFT_COLORS-1)-1:0]  shift_color_cnt     = 0;
wire                                color_shift         = (shift_color_cnt == N_SHIFT_COLORS-1);

reg [$clog2(N_SHIFT_COLORS-1)-1:0]  base_color_cnt      = 0;
wire                                base_color_shift    = (base_color_cnt == N_SHIFT_COLORS-1);



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
reg [2:0] p_color       = RED;
reg [2:0] f_color       = ~RED;
reg [4:0] prev_shift_p  = 5'b00000;
reg [4:0] prev_shift_f  = 5'b00000;
reg [4:0] this_shift_p  = 5'b00000;
reg [4:0] this_shift_f  = 5'b00000;

wire p_empty = (this_shift_p == 'b0);
wire f_empty = (this_shift_f == 'b0);
wire both_empty = p_empty && f_empty;

// pick color for next shift slot
always @(posedge shift_clk) begin
    if (!p_empty) begin
        this_shift_p <= this_shift_p - 1;
        led <= p_color;
    end else if (!f_empty) begin
        this_shift_f <= this_shift_f - 1;
        led <= f_color;
    end else if (shift_color_cnt == N_SHIFT_COLORS-1) begin
        this_shift_p <= prev_shift_p - 1;
        this_shift_f <= prev_shift_f + 1;

        prev_shift_p <= this_shift_p;
        prev_shift_f <= this_shift_f;
    end else begin
        led <= OFF;
    end
end

// drive shift clk
always @(posedge clk) begin
    if (shift_cnt == SHIFT_TICKS) begin
        shift_cnt <= 0;
    end else begin
        shift_cnt <= shift_cnt + 1;
    end
end

// drive minor color shift
always @(posedge shift_clk) begin
    if (shift_color_cnt == (N_SHIFT_COLORS - 1)) begin
        shift_color_cnt <= 0;
    end else begin
        shift_color_cnt <= shift_color_cnt + 1;
    end
end

// drive major color shift
always @(posedge color_shift) begin
    if (base_color_cnt == N_SHIFT_COLORS-1) begin
        base_color_cnt <= 0;
    end else begin
        base_color_cnt <= base_color_cnt + 1;
    end
end

// major color reassignment
always @(posedge base_color_shift) begin
    p_color <= ~p_color;
    f_color <= ~f_color;
end
    
endmodule