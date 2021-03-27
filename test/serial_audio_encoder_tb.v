`timescale 1ns/1ps

module serial_audio_encoder_tb();

    localparam CLK_SCLK = 1000000000 / (44100 * 32); // 44.1KHz * 32
    localparam lrclk_polarity = 1'b0;
    localparam is_i2s = 1'b0;
    localparam data_width = 16;

    initial begin
        $dumpfile("serial_audio_encoder_tb.vcd");
        $dumpvars;
    end

    reg Clock;
    initial begin
        Clock = 1'b0;
        forever begin
            #(CLK_SCLK / 2) Clock = ~Clock;
        end
    end

    reg reset;
    reg i_valid;
    wire i_ready;
    reg i_is_left;
    reg [data_width-1:0] i_data;

    serial_audio_encoder #(.data_width(data_width)) audio_encoder_ (
        .reset(reset),
        .sclk(Clock),
        .is_i2s(is_i2s),
        .lrclk_polarity(lrclk_polarity),
        .i_valid(i_valid),
        .i_ready(i_ready),
        .i_is_left(i_is_left),
        .i_data(i_data),
        .is_underrun(),
        .osclk(),
        .olrclk(),
        .osdat()
    );

    task set_data(input is_left, input [31:0] data);
        begin
            i_valid <= 1'b1;
            i_is_left <= is_left;
            i_data <= data;
            wait (i_ready) @(posedge Clock);
            i_valid <= 1'b0;
            @(posedge Clock);
        end
    endtask

    initial begin
        i_valid = 1'b0;
        i_data = 1'b0;
        i_is_left = 1'b0;
        reset = 1'b1;
        repeat (2) @(posedge Clock) reset = 1'b1;
        repeat (2) @(posedge Clock) reset = 1'b0;

        set_data(1'b1, 32'hAAAAAAAB);
        set_data(1'b0, 32'hAAAAAAAA);
        set_data(1'b1, 32'hAAAAAAAB);
        set_data(1'b0, 32'hAAAAAAAA);

        repeat (128) @(posedge Clock);

        set_data(1'b1, 32'hAAAAAAAA);

        repeat (128) @(posedge Clock);

        $finish;
    end


endmodule
