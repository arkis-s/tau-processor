`include ".\\src\\alu.sv"

module testbench_alu;



    localparam WORD_SIZE = 8;
    localparam PERIOD = 5;
    localparam CLEAR = 1;

    reg [WORD_SIZE-1:0] a, b;
    reg [3:0] mode;
    wire [7:0] flags;
    wire [WORD_SIZE-1:0] c;



    // easier debug with enums? 
    // https://github.com/arkis-s/tau-processor
    typedef enum { 
        NOP,
        MOV,
        CMP,
        TEST,
        SHFT_L,
        SHFT_R,
        ADD,
        ADC,
        SUB,
        SBB,
        MUL,
        AND,
        OR,
        XOR,
        NOT,
        CLEAR_FLAGS
    } alu_op_set;

    alu_op_set opcode;

    alu # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_alu (
        .input_A(a), .input_B(b), .mode_select(opcode), .flags(flags), .output_C(c)
    );

    initial begin

        $monitor("(%g) in_A = %d, in_B = %d, out_C = %d\nmode = %s\nFLAGS:\n\tZERO: %b\n\tSIGN: %b\n\tCARRY: %b\n\tOVERFLOW: %b\n",
                $time, a, b, c, opcode.name(), flags[7], flags[6], flags[5], flags[4]);

        a = 0; b = 0; opcode = NOP; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // testing compare instruction which is a - b
        // so 3 - 4 = -1 should generate a sign and carry flag
        a = 3; b = 4; opcode = CMP; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // 4 - 3 = 1, shouldn't generate any flag
        a = 4; b = 3; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // test instruction
        a = 255; b = 255; opcode = TEST; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;
        
        // shift left
        a = 1; b = 3; opcode = SHFT_L; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        a = 1; b = 7; opcode = SHFT_L; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;


        // shift right
        b = 4; opcode = SHFT_R; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;



        $stop;

    end
endmodule