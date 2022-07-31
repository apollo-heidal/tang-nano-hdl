`timescale 10us/1us

module rainbow_led_tb();
    reg clk = 0;
    reg b_a = 0;
    reg b_b = 0;

    wire [2:0] led = 3'b000;

    localparam DURATION = 1_000_000;

    // main clock
    always begin
        #41.667     // Delay: 1 / ((2 * 41.67) * 1ns) ~= 12Mhz
        clk = ~clk;
    end

    rainbow_led uut (
        .clk(clk),
        .button_a(b_a),
        .button_b(b_b),
        .led(led)
    );

    initial begin
        $dumpfile("rainbow_led_tb.vcd");
        $dumpvars(0, rainbow_led_tb);

        #(DURATION)

        $display("Finished");
        $finish;
    end

endmodule