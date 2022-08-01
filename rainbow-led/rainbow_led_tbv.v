`timescale 10ns/100ps

module rainbow_led_tb();
    // main clock
    reg clk = 0;
    always begin
        #4.16666
        clk = ~clk;
    end

    wire [2:0] led;
    rainbow_led uut (
        .clk(clk),
        .led(led)
    );

    initial begin
        $dumpfile("rainbow_led_tb.vcd");
        $dumpvars(0, rainbow_led_tb);

        #(100_000_000) // duration

        $display("Finished");
        $finish;
    end
endmodule