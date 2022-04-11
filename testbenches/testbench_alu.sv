`include ".\\src\\alu.sv"

module testbench_alu;



    localparam WORD_SIZE = 8;
    localparam PERIOD = 4;
    localparam CLEAR = 1;

    reg [WORD_SIZE-1:0] a, b;
    reg [3:0] mode;
    wire [7:0] flags;
    wire [WORD_SIZE-1:0] c;

    typedef enum { 
    //   v    v    v     v      v       v
        NOP, MOV, CMP, TEST, SHFT_L, SHFT_R,
    //   v    v     v   v         v   v
        ADD, ADC, SUB, SBB, MUL, AND, OR,
    //   v    v        v
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

        // very rough testbench but there is at least one testcase for each instruction

        // alu nop
        a = 0; b = 0; opcode = NOP; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // add -- 10 + 30 = 40 with no flags set
        a = 10; b = 30; opcode = ADD; #PERIOD;
        // add -- 255 + 1 = 256 -> overflow so c = 0, zf = 1, cf = 1
        a = 255; b = 1; #PERIOD;
        // add with carry -- 1 + 0 + carry (1) = 2
        a = 1; b = 0; opcode = ADC; #PERIOD;

        // add -- 2 + (-1) = 1
        // 1 =  00000001 so -1 = 11111111
        a = 2; b = 8'b11111111; opcode = ADD; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // 127 + 1 = 128 --> signed overflow
        a = 127; b = 1; opcode = ADD; #PERIOD;

        // shift left -- 2 << 6 = 128, no flags
        a = 2; b = 6; opcode = SHFT_L; #PERIOD;

        // shift left -- 128 << 1 = 256 -> overflow so c = 0, zf = 1, cf = 1
        a = c; b = 1; #PERIOD;

        // clear flags
        opcode = CLEAR_FLAGS; #CLEAR;

        // and -- 0110 1011 AND 1101 1111 = 0100 1011
        a = 8'b01101011; b = 8'b11011111; opcode = AND; #PERIOD;

        // not -- 1111 0000 becomes 0000 1111
        a = 8'b11110000; opcode = NOT; #PERIOD;

        // or -- 0 or 0 = 0
        a = 0; b = 0; opcode = OR; #PERIOD;
        a = 8'b01110001; b = 8'b10001001; #PERIOD;

        // shift right -- 255 >> 2 = 63
        a = 255; b = 2; opcode = SHFT_R; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;
        // shift right -- 1 >> 1 = 0, cf = 1, zf = 1
        a = 1; b = 1; opcode = SHFT_R; #PERIOD;

        // move -- c = b
        a = 63; b = 105; opcode = MOV; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;
        a = 11; b = 77; opcode = MOV; #PERIOD;

        // sub -- 127-27 = 100, no sign change
        a = 127; b = 27; opcode=SUB; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // 1 - 1 = 0, zf = 1, cf = 0, sf = 0
        a = 1; b = 1; opcode=SUB; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // 5 - 6 = -1, zf = 0, cf = 0, sf = 1, of = 0
        a = 5; b = 6; opcode=SUB; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // 127 - (-1) = 128 but signed is -128 to 127 therefore cf = 1, sf = 1, of = 1
        a = 127; b = -1; opcode=SUB; #PERIOD;

        // a - (b + c) where c is carry (set with the instruction before)
        // so 3 - (1 + 1) = 1, sf=0, cf=0, of=0, zf=0
        a = 3; b = 1; opcode=SBB; #PERIOD;

        // a = c = 1, b = 1 so 1 - (1 + 0) = 0, sf = 0, zf = 1, cf = 0, of = 0
        a = c; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;

        // xor
        a = 8'b10001000; b = 8'b11111111; opcode = XOR; #PERIOD;
        a = c; b = 8'b01110110; #PERIOD; // = 1

        //test -- 10000011 AND 10001000 = 1000 0000 but only signs affected
        // sf = 1, zf = 0, cf = 0, of= 0
        a = 8'b10000011; b = 8'b10001000; opcode = TEST; #PERIOD; opcode = CLEAR_FLAGS; #CLEAR;
        a = 8'b10000011; b = 8'b10001000; opcode = AND; #PERIOD;

        // cmp -- 0 - 0 = 0 therefore equal , sf = 0, zf = 1, of = 0, cf= 0
        a = 0; b = 0; opcode = CMP; #PERIOD;
        // 50 - 40 = 10, sf = 0, zf = 0, of = 0, cf = 0
        a = 50; b = 40; #PERIOD;

        // 40 - 50 = -10, sf = 1, zf= 0, of = 0, cf =1
        a = 40; b = 50; #PERIOD;

        $stop;

    end
endmodule