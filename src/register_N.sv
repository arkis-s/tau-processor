module register_N # (
    parameter WORD_SIZE = 8
) (
    input wire clock,
    input wire [WORD_SIZE-1:0] input_value,
    output reg [WORD_SIZE-1:0] output_value
);

    always @(posedge clock) begin
        output_value <= input_value;
    end

endmodule