/*

decision unit
 -- responsible for deciding which address to load when a jump instruction is 

inputs:
    program counter/address
    instruction
    peak word
    flags from alu

output:
    new address

pseudocode/steps:

instruction enum w opcode {
    JMP = 4'h1400
    JE = 4'h1500
    JNE = 4'h1600
    ...
}

case (instruction):

    JMP:
        new address = peak word
    JE:
        if flags[zero]:
            new address = peak word
    JNE:
        if !flags[zero]:
            new address = peak word
    ...

*/

module decision_unit # (
    parameter WORD_SIZE = 16
) (
    input wire [WORD_SIZE-1:0] program_counter_address,
    input wire [WORD_SIZE-1:0] instruction,
    input wire [WORD_SIZE-1:0] peek_jump_address,
    input wire [7:0] flags,
    output reg [WORD_SIZE-1:0] new_address
);

    typedef enum logic [7:0] {
        // v          v               v              v            v
        JMP = 8'h14, JE = 8'h15, JNE = 8'h16, JC = 8'h17, JNC = 8'h18,
        // v            v               v           v
        JS = 8'h19, JNS = 8'h1A, JO = 8'h1B, JNO = 8'h1C,
        // v           v                v            v 
        JA = 8'h1D, JAE = 8'h1E, JB = 8'h1F, JBE = 8'h20,
        // v           v              v             
        JG = 8'h21, JGE = 8'h22, JL = 8'h23, JLE = 8'h24
    } jump_instruction_enum;

    typedef enum logic [3:0]  {
        ZERO = 7, SIGN = 6, CARRY = 5, OVERFLOW = 4
    } flag_name_enum;


    always_comb begin
        case (instruction[15:8])

            JMP: new_address = peek_jump_address;


            JE: new_address = (flags[ZERO] == 1) ? peek_jump_address : program_counter_address;
            JNE: new_address = (flags[ZERO] == 0) ? peek_jump_address : program_counter_address;

            JC: new_address = (flags[CARRY] == 1) ? peek_jump_address : program_counter_address;
            JNC: new_address = (flags[CARRY] == 0) ? peek_jump_address : program_counter_address;

            JS: new_address = (flags[SIGN] == 1) ? peek_jump_address : program_counter_address;
            JNS: new_address = (flags[SIGN] == 0) ? peek_jump_address : program_counter_address;

            JO: new_address = (flags[OVERFLOW] == 1) ? peek_jump_address : program_counter_address;
            JNO: new_address = (flags[OVERFLOW] == 0) ? peek_jump_address : program_counter_address;

            JA: new_address = ((flags[CARRY] ^ flags[ZERO]) == 0) ? peek_jump_address : program_counter_address;
            JAE: new_address = (flags[CARRY] == 0) ? peek_jump_address : program_counter_address;
            JB: new_address = (flags[CARRY] == 1) ? peek_jump_address : program_counter_address;
            JBE: new_address = ((flags[CARRY] | flags[ZERO]) == 1) ? peek_jump_address : program_counter_address;

            JG: new_address = (((flags[SIGN] ^ flags[OVERFLOW]) | flags[ZERO]) == 0) ? peek_jump_address : program_counter_address;
            JGE: new_address = ((flags[SIGN] ^ flags[OVERFLOW]) == 0) ? peek_jump_address : program_counter_address;
            JL: new_address = ((flags[SIGN] ^ flags[OVERFLOW]) == 1) ? peek_jump_address : program_counter_address;
            JLE: new_address = (((flags[SIGN] ^ flags[OVERFLOW]) | flags[ZERO]) == 1) ? peek_jump_address : program_counter_address;

            default: new_address = program_counter_address;

        endcase
    end

endmodule