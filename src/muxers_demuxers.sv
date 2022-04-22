module mux_2to1 # (
    parameter WORD_SIZE = 8
) (
    //                         0  1 
    input wire [WORD_SIZE-1:0] A, B,
    input wire enable,
    input wire selector,
    output reg [WORD_SIZE-1:0] out // = 0
);

    always_comb begin
        if (enable) begin
            case (selector)
                0: out <= A;
                1: out <= B;
            endcase
        end
    end

endmodule


// ALU side A input
module mux_8to1 # (
    parameter WORD_SIZE = 8
) (
    //                         0  1  2  3  4  5  6  7 
    input wire [WORD_SIZE-1:0] A, B, C, D, E, F, G, H,
    input wire enable,
    input wire [2:0] selector,
    output reg [WORD_SIZE-1:0] out // = 0

);

    always_comb begin
        if (enable) begin
            case (selector)
                0: out <= A;
                1: out <= B;
                2: out <= C;
                3: out <= D;
                4: out <= E;
                5: out <= F;
                6: out <= G;
                7: out <= H;
            endcase
        end
    end

endmodule

// ALU side B input
module mux_9to1 # (
    parameter WORD_SIZE = 8
) (
    //                         0  1  2  3  4  5  6  7    8  default
    input wire [WORD_SIZE-1:0] A, B, C, D, E, F, G, H, IMM8, NC,
    input wire enable,
    input wire [3:0] selector,
    output reg [WORD_SIZE-1:0] out // = 0
);

    always_comb begin
        if (enable) begin
            case (selector)
                0: out <= A;
                1: out <= B;
                2: out <= C;
                3: out <= D;
                4: out <= E;
                5: out <= F;
                6: out <= G;
                7: out <= H;
                8: out <= IMM8;
                default: out <= NC;
            endcase
        end
    end

endmodule

module demux_1to3 # (
    parameter WORD_SIZE = 8
) (
    input wire[WORD_SIZE-1:0] input_value = 0,
    input wire enable,
    input wire [1:0] selector,
    //                          0  1  2
    output reg [WORD_SIZE-1:0] A, B, C, NC
);

    always_comb begin
        if (enable) begin
            case (selector)
                0: A <= input_value;
                1: B <= input_value; 
                2: C <= input_value;
                default: NC <= input_value;
            endcase
        end
    end
endmodule


// ALU output
module demux_1to8 # (
    parameter WORD_SIZE = 8
) (
    input wire[WORD_SIZE-1:0] input_value = 0,
    input wire enable,
    input wire [2:0] selector,
    //                          0  1  2  3  4  5  6  7, ///8-...
    output reg [WORD_SIZE-1:0] A, B, C, D, E, F, G, H //, NC
);


    always_comb begin
        if (enable) begin
            case (selector)

                0: A <= input_value;
                1: B <= input_value; 
                2: C <= input_value;
                3: D <= input_value;
                4: E <= input_value;
                5: F <= input_value;
                6: G <= input_value;
                7: H <= input_value;
                // default: NC = input_value;
            endcase
        end
    end
endmodule


