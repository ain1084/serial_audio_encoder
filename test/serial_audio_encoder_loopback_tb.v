`timescale 1ns/1ps

module serial_audio_encoder_loopback_tb();

    localparam CLK_SCLK = 1000000000 / (44100 * 32); // 44.1KHz * 64

    localparam lrclk_polarity = 1'b1;
    localparam is_i2s = 1'b1;
    localparam data_width = 32;

    initial begin
        $dumpfile("serial_audio_encoder_loopback_tb.vcd");
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

    wire sclk;
    wire lrclk;
    wire sdat;


    wire o_decoder_valid;
    wire o_decoder_is_left;
    wire [31:0] o_decoder_audio;
    serial_audio_decoder audio_decoder_ (
        .reset(reset),
        .sclk(sclk),
        .lrclk(lrclk),
        .sdin(sdat),
        .is_i2s(is_i2s),
        .lrclk_polarity(lrclk_polarity),
        .is_error(),
        .o_valid(o_decoder_valid),
        .o_ready(1'b1),
        .o_is_left(o_decoder_is_left),
        .o_audio(o_decoder_audio)
    );
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
        .osclk(sclk),
        .olrclk(lrclk),
        .osdat(sdat)
    );

    integer encoder_count = 0;
    integer decoder_count = 0;

    task set_data(input is_left, input [data_width-1:0] data);
        begin
            i_valid <= 1'b1;
            i_is_left <= is_left;
            i_data <= data;
            wait (i_ready) @(posedge Clock);
            //$write("encoder(%08h): is_left(%1b) data = %08h\n", encoder_count, i_is_left, i_data);
            encoder_count = encoder_count + 1;
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

        set_data(1'b1, 32'hAAA7AAA3);
        set_data(1'b0, 32'hAAA80AA4);
        set_data(1'b1, 32'hAAA9AAA5);
        set_data(1'b0, 32'hAAAA0AA6);

/* 
        set_data(1'b1, 16'h1234);
        set_data(1'b0, 16'h5556);
        set_data(1'b1, 16'h789A);
        set_data(1'b0, 16'hCDEF);

 */
         repeat (128 + 32) @(posedge Clock);

        $finish;
    end

    always @(posedge sclk or posedge reset) begin
        if (reset) begin
        end else if (o_decoder_valid) begin
            $write("deodoer(%08h): is_left(%1b) data = %08h\n", decoder_count, o_decoder_is_left, o_decoder_audio);
            decoder_count = decoder_count + 1;
        end
    end


endmodule
