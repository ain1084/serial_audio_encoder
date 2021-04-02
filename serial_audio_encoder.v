`default_nettype none

module serial_audio_encoder #(parameter audio_width = 16)(
    input wire reset,
    input wire clk,
    input wire is_i2s,
    input wire lrclk_polarity,
    input wire i_valid,
    output wire i_ready,
    input wire i_is_left,
    input wire [audio_width-1:0] i_audio,
    output reg is_underrun,
    output wire sclk,
    output wire lrclk,
    output wire sdo);

    reg reg_lrclk;
    reg [1:0] reg_sdata;
    reg is_next_left;

    reg is_valid_shift;
    reg [audio_width-2:0] shift;
    reg [$clog2(audio_width-1)-1:0] shift_count;

    assign lrclk = reg_lrclk ^ lrclk_polarity;
    assign sclk = ~clk;
    assign sdo = reg_sdata[is_i2s];

    assign i_ready = !is_valid_shift;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_lrclk <= 1'b1;  // Right channel at start
            is_next_left <= 1'b1;
            is_underrun <= 1'b1;
            reg_sdata <= 2'b00;
            is_valid_shift <= 1'b0;
            shift <= 0;
            shift_count <= 0;
        end else begin
            if (is_valid_shift) begin
                shift_count <= shift_count - 1'b1;
                is_valid_shift <= shift_count != 0;
                shift <= shift << 1;
                reg_sdata <= { reg_sdata[0], shift[audio_width-2] };
                is_underrun <= 1'b0;
            end else begin
                if (i_valid && i_is_left == is_next_left) begin
                    is_next_left <= !is_next_left;
                    is_valid_shift <= 1'b1;
                    shift <= i_audio[audio_width-2:0];
                    shift_count <= audio_width - 2;
                    reg_lrclk <= !reg_lrclk;
                    reg_sdata <= { reg_sdata[0], i_audio[audio_width-1] };
                    is_underrun <= 1'b0;
                end else begin
                    // Underrun
                    if (!is_underrun) begin
                        reg_lrclk <= !reg_lrclk;
                        is_next_left <= !is_next_left;
                    end
                    is_valid_shift <= 1'b0;
                    reg_sdata <= 2'b00;
                    is_underrun <= 1'b1;
                end
            end
        end
    end


endmodule

