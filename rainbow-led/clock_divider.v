module clock_divider #(
    parameter divisor = 2
) (
    input clk_in,
    output reg clk_out
);

initial begin
    clk_out = 0;
end

reg                     init        = 1;
reg [$clog2(divisor):0] div_cnt     = 0;
wire                    toggle_clk  = (div_cnt == divisor-1);

always @(posedge toggle_clk) begin
    if (init) begin
        if (clk_in) begin
            clk_out <= ~clk_out;
            init <= 0;
            div_cnt <= 0;
        end
    end else begin
        clk_out <= ~clk_out;
        div_cnt <= 0;
    end
end

always @(posedge clk_in) begin
    div_cnt <= div_cnt + 1;
end
endmodule