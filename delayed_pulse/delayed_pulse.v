module external_trigger #(
    parameter t_us_int  = 25_000,   // microseconds between trigger pulses
    parameter t_us_trig = 50        // microseconds trig pulse width
) (
    input sys_clk,
    input bin_in,   // pull-up
    input trig_out,  

    output reg trig_in  // pull-up
);

localparam INT_MAX    = t_us_int * 12; // 12cycles / 1microsecond sys_clk
localparam TRIG_MAX   = t_us_trig * 12;

reg [$clog2(INT_MAX)-1:0]  int_counter  = 0;
reg [$clog2(TRIG_MAX)-1:0] trig_counter = 0;

reg int_en;
reg trig_en;

// reg bin_in_test;
// wire bin_in;
// assign bin_in = bin_in_test;

wire can_trig   = !bin_in && !trig_out; // bin and detector are ready

always @(posedge sys_clk) begin
    if (can_trig && (int_counter == 0)) begin
        trig_in <= 'b0;
    end else if (!trig_in) begin    
        if (trig_counter == TRIG_MAX) begin
            trig_in <= 'b1;
            trig_counter <= 0;
        end else begin
            trig_counter <= trig_counter + 1;
        end
    // end else if (int_counter == INT_MAX) begin
    //     int_counter <= 0;
    end else begin
        int_counter <= int_counter + 1;
    end
end


// //test variables
// reg [23:0] bin_counter;

// always @(posedge clk) begin
//     if (bin_counter == 12_000_000) begin
//         bin_in <= 'b0;
//         bin_counter <= 0;
//     end else if (bin_counter == 12_000) begin
//         bin_in <= 'b1;
//         bin_counter <= bin_counter + 1;
//     end else begin
//         bin_counter <= bin_counter + 1;
//     end
// end
    
endmodule