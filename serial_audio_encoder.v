`default_nettype none

module serial_audio_encoder #(parameter data_width = 32)(
    input wire reset,
    input wire sclk,
    input wire is_i2s,
    input wire lrclk_polarity,
    input wire i_valid,
    output wire i_ready,
    input wire i_is_left,
    input wire [data_width-1:0] i_data,
    output reg is_underrun,
    output wire osclk,
    output wire olrclk,
    output wire osdat);

    reg reg_lrclk;
    reg [1:0] reg_sdata;
    reg is_next_left;

    reg is_valid_shift;
    reg [data_width-2:0] shift;
    reg [$clog2(data_width-1)-1:0] shift_count;

    assign olrclk = reg_lrclk ^ lrclk_polarity;
    assign osclk = ~sclk;
    assign osdat = reg_sdata[is_i2s];

    assign i_ready = !is_valid_shift;

    always @(posedge sclk or posedge reset) begin
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
                reg_sdata <= { reg_sdata[0], shift[data_width-2] };
                is_underrun <= 1'b0;
            end else begin
                if (i_valid && i_is_left == is_next_left) begin
                    is_next_left <= !is_next_left;
                    is_valid_shift <= 1'b1;
                    shift <= i_data[data_width-2:0];
                    shift_count <= data_width - 2;
                    reg_lrclk <= !reg_lrclk;
                    reg_sdata <= { reg_sdata[0], i_data[data_width-2] };
                    is_underrun <= 1'b0;
                end else begin
                    if (!is_underrun)
                        reg_lrclk <= !reg_lrclk;
                    is_valid_shift <= 1'b0;
                    reg_sdata <= 2'b00;
                    is_underrun <= 1'b1;
                end
            end
        end
    end


endmodule

