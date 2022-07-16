'`timescale 1ns/10ps

module ex_trig_tb ();


    localparam DURATION = 50_000;

    external_trigger #() ex_trig (
        .sys_clk(sys_clk),
        
    );

    always @(posedge clk) begin
        if (counter == 12_000_000) begin

        end
    end
endmodule