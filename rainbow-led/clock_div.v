module clock_div #(
    parameter divisor,
) (
    input clk_in,
    output reg clk_out,
);

reg [$clog2(divisor)-1:0] div_cnt = 0; 
always @(posedge clk_in) begin
    if (div_cnt == divisor) begin
        clk_out <= ~clk_out;
        div_cnt <= 0;
    end else begin
        div_cnt <= div_cnt + 1;
    end
end
endmodule