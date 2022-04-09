`include ".\\src\\alu.sv"

module testbench_alu;



    localparam WORD_SIZE = 8;
    localparam PERIOD = 10;

    reg [WORD_SIZE-1:0] a, b;
    reg [3:0] mode;
    wire [7:0] flags;
    wire [WORD_SIZE-1:0] c;

    alu # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_alu (
        .input_A(a), .input_B(b), .mode_select(mode), .flags(flags), .output_C(c)
    );

    initial begin

        a = 0; b = 0; mode = 0; #PERIOD;

        // testing compare instruction which is a - b
        // so 3 - 4 = -1 should generate a sign and carry flag
        a = 3; b = 4; mode = 2; #PERIOD;

        // 4 - 3 = 1, shouldn't generate any flag
        a = 4; b = 3; #PERIOD;

        // test instruction
        a = 255; b = 255; mode = 3; #PERIOD;
        



        $stop;

    end
endmodule