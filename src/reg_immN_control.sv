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
    output reg [2:0] mode_select,
    input wire clock
); 

    // always_comb begin
    // // always @ (imm_flag or posedge instruction) begin
    // // always @ (negedge clock) begin
    // if (instruction[15:8] => 8'h28 & instruction[15:8] <= 8'h8f) begin
    //         if (imm_flag == 1) begin
    //             mode_select <= instruction[10:8];
    //         end else if (imm_flag == 0) begin
    //             mode_select <= instruction[6:4];
    //         end else begin
    //             mode_select <= 'x;
    //         end
    //     end else begin 
    //         mode_select <= mode_select;
    // end
    // end

    // always_comb begin
    // always @ (negedge clock) begin
    always @ (instruction) begin

        if (instruction[15:8] >= 8'h28 & instruction[15:8] <= 8'h8f) begin
            mode_select <= instruction[10:8];
            // if the instruction does not contain an immediate value but affects the registers
        end else if (instruction[15:8] >= 8'h06 & instruction[15:8] <= 8'h13) begin
            mode_select <= {1'b0, instruction[6:4]};
        end else begin
            mode_select <= 'z; //mode_select;
        end


        // if (instruction[15:8] >= 8'h28 & instruction[15:8] <= 8'h8f) begin

        //     if (imm_flag == 1) begin
        //         mode_select <= instruction[10:8];
        //     end else if (imm_flag == 0) begin
        //         mode_select <= instruction[6:4];
        //     end

        // end else begin
        //     mode_select <= mode_select;
        // end

    end


endmodule

module muxer_select_decision_logic_b # (
    parameter WORD_SIZE = 16,
    parameter DEFAULT_IMM_SELECTOR_VALUE = 0
) (
    input wire [WORD_SIZE-1:0] instruction,
    input wire imm_flag, clock,
    output reg [3:0] mode_select
);

    // always_comb begin
    // always @ (negedge clock) begin
    always @ (instruction) begin

        // if the instruction contains an immediate value
        if (instruction[15:8] >= 8'h28 & instruction[15:8] <= 8'h8f) begin
            mode_select <= DEFAULT_IMM_SELECTOR_VALUE;
            // if the instruction does not contain an immediate value but affects the registers
        end else if (instruction[15:8] >= 8'h06 & instruction[15:8] <= 8'h13) begin
            mode_select <= {1'b0, instruction[2:0]};
        end else begin
            mode_select <= 'z; //mode_select;
        end


        //if (instruction[15:8] >= 8'h28 & instruction[15:8] <= 8'h8f) begin
        //    if (imm_flag == 1) begin
        //        mode_select <= DEFAULT_IMM_SELECTOR_VALUE;
        //    end else if (imm_flag == 0) begin
        //        mode_select <= {1'b0, instruction[2:0]};
        //    end
        //end else begin
        //    mode_select <= mode_select;
        //end
    end
endmodule