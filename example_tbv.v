`timescale 1us/10ns

module clock_divider_tb();
    reg clk = 0;
    wire clk_a;

    localparam DURATION = 1_000_000;

    // main clock
    always begin
        #0.5
        clk = ~clk;
    end

    clock_divider #(
        .divisor(5)
    ) uut (
        .clk_in(clk),
        .clk_out(clk_a)
    );

    initial begin
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);

        #(DURATION)

        $display("Finished");
        $finish;
    end
endmodule