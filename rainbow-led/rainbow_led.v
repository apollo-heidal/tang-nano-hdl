module rainbow_led (
    input clk,
    input button_a,
    input button_b,

    output reg [2:0] led
);

wire rst = !button_a;

// base colors
localparam N_COLORS     = 3'b110; // 6 because WHITE/OFF are not part of this rainbow
localparam WHITE        = 3'b000;
localparam MAGENTA      = 3'b001;
localparam YELLOW       = 3'b010;
localparam RED          = 3'b011;
localparam CYAN         = 3'b100;
localparam BLUE         = 3'b101;
localparam GREEN        = 3'b110;
localparam OFF          = 3'b111;

localparam CYCLE_S      = 3'b110;               // 6 seconds per rainbow cycle
localparam CYCLE_TICKS  = 24_000_000 * CYCLE_S; // clk ticks per rainbow cycle

localparam SHIFT_COLORS = 6'b100000;            // 32 different colors between 6 base colors
localparam SHIFT_TICKS  = CYCLE_TICKS / (N_COLORS * SHIFT_COLORS); // clk ticks fo reach shift period

reg [4:0] shift_cnt     = 5'b00000;
reg [4:0] prev_shift_a  = 5'b00000;
reg [4:0] prev_shift_b  = 5'b00000;
reg [4:0] this_shift_a  = 5'b00000;
reg [4:0] this_shift_b  = 5'b00000;

wire shift_color = 

always @(posedge clk) begin
    led <= MAGENTA;
end

always @(posedge rst) begin
    
end
    
endmodule