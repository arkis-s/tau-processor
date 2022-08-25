module decision_unit # (
    parameter WORD_SIZE = 16
) (
    input wire [WORD_SIZE-1:0] program_counter_address,
    input wire [WORD_SIZE-1:0] instruction,
    input wire [WORD_SIZE-1:0] peek_jump_address,
    input wire [7:0] flags,
    output reg [WORD_SIZE-1:0] new_address
    //output reg jump
);

    // move both enums into package(?)
    typedef enum logic [7:0] {
        JMP = 8'h14, JE = 8'h15, JNE = 8'h16, JC = 8'h17, JNC = 8'h18,
        JS = 8'h19, JNS = 8'h1A, JO = 8'h1B, JNO = 8'h1C,
        JA = 8'h1D, JAE = 8'h1E, JB = 8'h1F, JBE = 8'h20,
        JG = 8'h21, JGE = 8'h22, JL = 8'h23, JLE = 8'h24
    } jump_instruction_enum;

    //typedef enum logic [3:0]  {
    //    ZERO = 7, SIGN = 6, CARRY = 5, OVERFLOW = 4
    //} flag_name_enum;

    typedef enum logic [3:0] {
        ZERO = 4'b0111, SIGN = 4'b0110, CARRY = 4'b0101, OVERFLOW = 4'b0100
    } flag_name_enum;


    // todo: make this look better somehow
    // always_comb begin
    always @ (instruction or peek_jump_address or flags) begin
        case (instruction[15:8])

            JMP: new_address = peek_jump_address;

            JE: new_address = (flags[ZERO] == 1) ? peek_jump_address : program_counter_address+2;
            JNE: new_address = (flags[ZERO] == 0) ? peek_jump_address : program_counter_address+2;

            JC: new_address = (flags[CARRY] == 1) ? peek_jump_address : program_counter_address+2;
            JNC: new_address = (flags[CARRY] == 0) ? peek_jump_address : program_counter_address+2;

            JS: new_address = (flags[SIGN] == 1) ? peek_jump_address : program_counter_address+2;
            JNS: new_address = (flags[SIGN] == 0) ? peek_jump_address : program_counter_address+2;

            JO: new_address = (flags[OVERFLOW] == 1) ? peek_jump_address : program_counter_address+2;
            JNO: new_address = (flags[OVERFLOW] == 0) ? peek_jump_address : program_counter_address+2;

            JA: new_address = ((flags[CARRY] ^ flags[ZERO]) == 0) ? peek_jump_address : program_counter_address+2;
            JAE: new_address = (flags[CARRY] == 0) ? peek_jump_address : program_counter_address+2;
            JB: new_address = (flags[CARRY] == 1) ? peek_jump_address : program_counter_address+2;
            JBE: new_address = ((flags[CARRY] | flags[ZERO]) == 1) ? peek_jump_address : program_counter_address+2;

            JG: new_address = (((flags[SIGN] ^ flags[OVERFLOW]) | flags[ZERO]) == 0) ? peek_jump_address : program_counter_address+2;
            JGE: new_address = ((flags[SIGN] ^ flags[OVERFLOW]) == 0) ? peek_jump_address : program_counter_address+2;
            JL: new_address = ((flags[SIGN] ^ flags[OVERFLOW]) == 1) ? peek_jump_address : program_counter_address+2;
            JLE: new_address = (((flags[SIGN] ^ flags[OVERFLOW]) | flags[ZERO]) == 1) ? peek_jump_address : program_counter_address+2;

            default: new_address = program_counter_address+2;

        endcase
    end

endmodule