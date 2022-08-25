module register_N # (
    parameter WORD_SIZE = 8
) (
    input wire clock, reset,
    input wire [WORD_SIZE-1:0] input_value,
    output reg [WORD_SIZE-1:0] output_value
);

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            output_value <= 0;
        end else begin
            output_value <= input_value;
        end
    end

endmodule