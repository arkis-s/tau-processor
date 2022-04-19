module datapath_controller # (
    parameter WORD_SIZE = 16,
    parameter MODE_SELECT_SIZE = 3
) (
    input wire [WORD_SIZE-1:0] p_ram_data, v_ram_data,
    input wire [MODE_SELECT_SIZE-1:0] mode,
    output reg [WORD_SIZE-1:0] instruction, peek, load
);


    always_comb begin

        case(mode)

            0: instruction = p_ram_data;
            1: peek = p_ram_data;
            2: load = p_ram_data;
            3: load = v_ram_data;
            default: instruction = p_ram_data;

        endcase

    end
endmodule