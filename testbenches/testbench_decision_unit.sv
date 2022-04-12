`include ".\\src\\decision_unit.sv"

module testbench_decision_unit;

    localparam WORD_SIZE = 16;
    localparam PERIOD = 5;

    reg [WORD_SIZE-1:0] pc_addr, peek_addr;
    reg [7:0] flags = 0;
    wire [WORD_SIZE-1:0] new_addr;

    // TODO: replace enum with one from a package file
    typedef enum logic [15:0] {
        JMP =16'h14xx, JE = 16'h15xx, JNE = 16'h16xx, JC = 16'h17xx, JNC = 16'h18xx,
        JS = 16'h19xx, JNS = 16'h1Axx, JO = 16'h1Bxx, JNO = 16'h1Cxx,
        JA = 16'h1Dxx, JAE = 16'h1Exx, JB = 16'h1Fxx, JBE = 16'h20xx,
        JG = 16'h21xx, JGE = 16'h22xx, JL = 16'h23xx, JLE = 16'h24xx,
        OTHER = 16'hxxxx
    } jump_instruction_enum;

    typedef enum logic [3:0]  {
        ZERO = 7, SIGN = 6, CARRY = 5, OVERFLOW = 4
    } flag_name_enum;

    jump_instruction_enum instruction;

    decision_unit # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_decision_unit (
        .program_counter_address(pc_addr), .instruction(instruction),
        .peek_jump_address(peek_addr), .flags(flags),
        .new_address(new_addr)
    );  

    initial begin
        
        $monitor("(%g) instruction %s (%h)\npc addr %h, peek addr %h\nflags:\n\tzero: %b\n\tsign: %b\n\tcarry: %b\n\toverflow: %b\nnew addr %h\n",
            $time, instruction.name(), instruction, pc_addr, peek_addr, flags[ZERO], flags[SIGN], flags[CARRY], flags[OVERFLOW], new_addr);

        pc_addr = 16'h1a2b;
        peek_addr = 16'h7f7f;

        instruction = OTHER; #PERIOD;
        instruction = JMP; #PERIOD;

        // jump if equal / jump if not equal
        instruction = JE; #PERIOD; // new addr = pc addr
        instruction = JNE; #PERIOD; // new addr = peek addr
        flags[ZERO] = 1;
        instruction = JE; #PERIOD; // new addr = peek addr
        instruction = JNE; #PERIOD; // new addr = pc addr

        flags = 0;

        // jump if carry / jump if not carry
        instruction = JC; #PERIOD; // new addr = pc addr
        instruction = JNC; #PERIOD; // new addr = peek addr
        flags[CARRY] = 1;
        instruction = JC; #PERIOD; // new addr = peek addr
        instruction = JNC; #PERIOD; // new addr = pc addr

        flags = 0;

        // jump if signed / jump if not signed
        instruction = JS; #PERIOD;
        instruction = JNS; #PERIOD;
        flags[SIGN] = 1;
        instruction = JS; #PERIOD;
        instruction = JNS; #PERIOD;

        flags = 0;

        // jump if overflow / jump if not overflow
        instruction = JO; #PERIOD;
        instruction = JNO; #PERIOD;
        flags[OVERFLOW] = 1;
        instruction = JO; #PERIOD;
        instruction = JNO; #PERIOD;

        flags = 0;

        // jump if above
        instruction = JA; #PERIOD; // new addr = peek addr
        flags[ZERO] = 1; #PERIOD; // new addr = pc addr
        flags[ZERO] = 0; flags[CARRY] = 1; #PERIOD; // new addr = pc addr
        flags[ZERO] = 1; #PERIOD; // new addr = peek addr

        flags = 0;

        // jump if above or equal / jump if below
        instruction = JAE; #PERIOD; // new addr = peek addr
        instruction = JB; #PERIOD; // new addr = pc addr
        flags[CARRY] = 1;
        instruction = JAE; #PERIOD; // new addr = pc addr
        instruction = JB; #PERIOD; // new addr = peek addr

        flags = 0;
        // jump if below or equal
        instruction = JBE; #PERIOD;
        flags[ZERO] = 1; #PERIOD;
        flags[CARRY] = 1; flags[ZERO] = 0; #PERIOD;
        flags[ZERO] = 1; #PERIOD;

        // jump if greater than
        flags = 0; instruction = JG;
        for (int i = 0; i < 8; i++) begin
           {flags[SIGN], flags[OVERFLOW], flags[ZERO]} = i[2:0];
           #PERIOD; 
        end

        // jump if greater than or equal to 
        flags = 0; instruction = JGE;
        for (int i = 0; i < 4; i++) begin
            {flags[SIGN], flags[OVERFLOW]} = i[1:0];
            #PERIOD;
        end

        // jump if less than
        flags = 0; instruction = JL;
        for (int i = 0; i < 4; i++) begin
            {flags[SIGN], flags[OVERFLOW]} = i[1:0];
            #PERIOD;
        end

        flags = 0; instruction = JLE;
        for (int i = 0; i < 8; i++) begin
            {flags[SIGN], flags[OVERFLOW], flags[ZERO]} = i[2:0];
            #PERIOD;
        end

    end


endmodule