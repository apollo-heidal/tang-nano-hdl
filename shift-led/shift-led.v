// Shift Tang Nano RGB LED through all possible states 

module shift_led #(
    parameter   SHIFT_HZ        = 1,
                TANG_NANO_HZ    = 24_000_000 // 24Mhz
) (
    input               clk,
                        rst_button,

    output reg [2:0]    led
);

    localparam  COUNT_MAX   = (TANG_NANO_HZ / SHIFT_HZ) - 1,
                COUNT_SIZE  = $clog2(COUNT_MAX);

    wire rst, shift;

    // divided clock counter
    reg     [COUNT_SIZE:0]  count       = 0;
    wire    [COUNT_SIZE:0]  count_inc   = count + 1;
    always @ (posedge clk) begin
        if (count == COUNT_MAX) begin
            count <= 0;
            shift <= 1;
        end else begin
            count <= count_inc;
        end
    end

    // RGB LED
    wire [2:0] led_ctrl;
    always @(posedge rst or posedge shift) begin
        if (rst) begin
            led <= 0;
            count <= 0;
        end else if (led == 3'b111) begin
            led <= 0;
        end else begin
            led <= led + 1;            
        end
    end

    // logic
    assign led = led_ctrl;
    assign rst = !rst_button;


endmodule
