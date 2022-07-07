module led (
    input sys_clk, // clk input
    input sys_rst_n, // reset input
    output reg [2:0] led // 110 G, 101 R, 011 B
);

localparam COUNT_MAX = 24'd12_000_000;

reg [23:0] counter;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        counter <= 24'd0;
    else if (counter < COUNT_MAX) // 0.5s delay
        counter <= counter + 1;
    else
        counter <= 24'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        led <= 3'b000;
    end else if ((led == 3'b111) && (counter == COUNT_MAX)) begin
        led <= 3'b001;
    end else if (counter == COUNT_MAX) begin
        led <= led + 3'b001;
    end
end

endmodule
