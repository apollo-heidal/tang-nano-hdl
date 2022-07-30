module rainbow_led (
    input clk,
    input button_a,
    input button_b,

    output reg [2:0] led
);

wire rst = !button_a;

localparam WHITE    = 3'b000;
localparam MAGENTA  = 3'b001;
localparam YELLOW   = 3'b010;
localparam RED      = 3'b011;
localparam CYAN     = 3'b100;
localparam BLUE     = 3'b101;
localparam GREEN    = 3'b110;
localparam OFF      = 3'b111;

localparam N_COLORS     = 6'b100000;    // 32 different colors
localparam T_CYCLE      = 4'b1000;      // 8 seconds per rainbow cycle
localparam 

always @(posedge clk) begin
    led <= MAGENTA;
end

always @(posedge rst) begin
    
end
    
endmodule