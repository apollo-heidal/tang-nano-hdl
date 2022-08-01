`timescale 1us/10ns

module clock_divider_tb();
    reg clk = 0;
    reg rst = 1;
    reg calib = 0;
    wire clk_a;
    wire clk_b;

    localparam DURATION = 1_000_000;

    // main clock
    always begin
        #0.5
        clk = ~clk;
    end

    // CLKDIV clkdiv_inst (
    //     .HCLKIN(clk),
    //     .RESETN(rst),
    //     .CALIB(calib),
    //     .CLKOUT(clk_a)
    // );
    // defparam clkdiv_inst.DIV_MODE="3.5";
    // defparam clkdiv_inst.GSREN="false";

    clock_divider #(
        .divisor(3)
    ) uut (
        .clk_in(clk),
        .clk_out(clk_b)
    );

    initial begin
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);

        #(DURATION)

        $display("Finished");
        $finish;
    end
endmodule