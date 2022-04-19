/*

inputs:
    instruction word
    imm8 flag from microcode

outputs:
    mode select

15 14 13 12 11 10 9 8 ~~ 7 6 5 4 3 2 1 0
-- -- -- -- --  x x x    0 y y y 0 z z z

x = reg encoding if imm8 = true
y = dest reg if imm8 = false
z = src reg if imm8 = false
*/


module muxer_select_decision_logic_a # (
    parameter WORD_SIZE = 16
) (
    input wire [WORD_SIZE-1:0] instruction,
    input wire imm_flag,
    output reg [2:0] mode_select
); 

    always_comb begin

        if (imm_flag) begin
            mode_select <= instruction[10:8];
        end else begin
            mode_select <= instruction[6:4];
        end

    end
endmodule

module muxer_select_decision_logic_b # (
    parameter WORD_SIZE = 16,
    parameter DEFAULT_IMM_SELECTOR_VALUE = 0
) (
    input wire [WORD_SIZE-1:0] instruction,
    input wire imm_flag,
    output reg [3:0] mode_select
);

    always_comb begin
        if (imm_flag) begin
            mode_select <= DEFAULT_IMM_SELECTOR_VALUE;
        end else begin
            mode_select <= {1'b0, instruction[2:0]};
        end
    end
endmodule