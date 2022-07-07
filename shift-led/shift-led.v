// Shift Tang Nano RGB LED through all possible states 

module shift_led 
#(
    parameter  SHIFT_HZ     = 2,
    parameter  TANG_NANO_HZ = 24_000_000
    ) 
    (
    input               sys_clk,
    input               sys_rst_n,

    output reg [2:0]    led
);
    localparam  COUNT_MAX   = TANG_NANO_HZ / SHIFT_HZ;
    localparam  COUNT_SIZE  = $clog2(COUNT_MAX);

    // divided clock counter
    reg [23:0] count; 

    wire    rst     = !sys_rst_n;
    wire    shift   = (count == COUNT_MAX);

    always @ (posedge rst or posedge sys_clk) begin
        if (rst) begin// non-zero evaluates as true 
            count   <= 24'd0;
            led     <= 'b0;
        end else if (shift) begin
            if (led == 3'b110) begin
                led <= 3'b0;
            end else begin
                led <= led + 3'b1;
            end
            count <= 24'd0;
        end else begin
            count <= count + 1;
        end
    end
endmodule
