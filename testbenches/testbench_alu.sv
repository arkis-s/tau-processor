`include ".\\src\\alu.sv"

module testbench_alu;



    localparam WORD_SIZE = 8;
    localparam PERIOD = 4;
    localparam CLEAR = 1;

    reg [WORD_SIZE-1:0] a, b;
    reg [3:0] mode;
    wire [7:0] flags;
    wire [WORD_SIZE-1:0] c;



    // easier debug with enums? 
    // https://github.com/arkis-s/tau-processor
    typedef enum { 
        NOP, MOV, CMP, TEST, SHFT_L, SHFT_R,
        ADD, ADC, SUB, SBB, MUL, AND, OR,
        XOR, NOT, CLEAR_FLAGS
    } alu_op_set;

    alu_op_set opcode;

    alu # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_alu (
        .input_A(a), .input_B(b), .mode_select(opcode), .flags(flags), .output_C(c)
    );

    initial begin

        $monitor("(%g) mode = %s\nin_A = %d, in_B = %d, out_C = %d\nFLAGS:\n\tZERO: %b\n\tSIGN: %b\n\tCARRY: %b\n\tOVERFLOW: %b\n",
                $time, opcode.name(), a, b, c, flags[7], flags[6], flags[5], flags[4]);

        
        // done instructions:
        // nop, clear_flags, add, adc, shft_l, 


        // alu nop
        a = 0; b = 0; opcode = NOP; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // add -- 10 + 30 = 40 with no flags set
        a = 10; b = 30; opcode = ADD; #PERIOD;
        // add -- 255 + 1 = 256 -> overflow so c = 0, zf = 1, cf = 1
        a = 255; b = 1; #PERIOD;
        // add with carry -- 1 + 0 + carry (1) = 2
        a = 1; b = 0; opcode = ADC; #PERIOD;

        // add -- 2 + (-1) = 1
        // 1 =  00000001
        // -1 = 11111111
        a = 2; b = 8'b11111111; opcode = ADD; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        a = 127; b = 1; opcode = ADD; #PERIOD;

        // shift left -- 2 << 6 = 128, no flags
        a = 2; b = 6; opcode = SHFT_L; #PERIOD;

        // shift left -- 128 << 1 = 256 -> overflow so c = 0, zf = 1, cf = 1
        a = c; b = 1; #PERIOD;

        // clear flags
        opcode = CLEAR_FLAGS; #CLEAR;

        // and -- 0110 1011 AND 1101 1111 = 0100 1011
        a = 8'b01101011; b = 8'b11011111; opcode = AND; #PERIOD;




        // // testing compare instruction which is a - b
        // // so 3 - 4 = -1 should generate a sign and carry flag
        // a = 3; b = 4; opcode = CMP; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // // 4 - 3 = 1, shouldn't generate any flag
        // a = 4; b = 3; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // // test instruction
        // a = 255; b = 255; opcode = TEST; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;
        
        // // shift left
        // a = 1; b = 3; opcode = SHFT_L; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // a = 1; b = 7; opcode = SHFT_L; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;


        // // shift right
        // b = 4; opcode = SHFT_R; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;



        $stop;

    end
endmodule