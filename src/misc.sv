module halt_check # (
    parameter OPCODE_SIZE = 8
) (
    input wire [OPCODE_SIZE-1:0] opcode,
    output reg result
);

    // if instruction == halt then
    //      disable execution driver
    // else
    //      enable execution driver

    always_comb begin
        
        if (opcode == 8'h01) begin
            result = 0;
        end else begin
            result = 1;
        end

    end


endmodule

module load_register_glue_logic # (
    parameter REGISTER_VAL = 7
) ( 
    input wire [2:0] mux_register_select,
    input wire load_flag, alu_output_flag,
    output reg load_mux_select
);

    always_comb begin

        if(load_flag == 1) begin
            load_mux_select <= 1;
        end else if (load_flag == 0 & mux_register_select == REGISTER_VAL & alu_output_flag == 1) begin
            load_mux_select <= 0;
        end else begin
            load_mux_select <= load_mux_select;
        end

    end

endmodule

module ega_colour_palette_logic (
    input wire [3:0] index,
    output reg [5:0] colour
);

    always_comb begin

        case (index)
            // https://en.wikipedia.org/wiki/Enhanced_Graphics_Adapter#Color_palette
            
            // formatting is rgbRGB where lowercase = low intensity, uppercase = high intensity

            0: colour <= 6'b000000; // black
            1: colour <= 6'b000001; // blue
            2: colour <= 6'b000010; // green
            3: colour <= 6'b000011; // cyan
            4: colour <= 6'b000100; // red
            5: colour <= 6'b000101; // magenta
            6: colour <= 6'b010100; // brown
            7: colour <= 6'b000111; // white/light grey
            8: colour <= 6'b111000; // dark grey / bright black
            9: colour <= 6'b111001; // bright blue
            10: colour <= 6'b111010; // bright green
            11: colour <= 6'b111011; // bright cyan
            12: colour <= 6'b111100; // bright red
            13: colour <= 6'b111101; // bright magenta
            14: colour <= 6'b111110; // bright yellow
            15: colour <= 6'b111111; // bright white
            default: colour <= 0;

        endcase

    end


endmodule