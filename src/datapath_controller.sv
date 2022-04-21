module datapath_controller # (
    parameter WORD_SIZE = 16,
    parameter MODE_SELECT_SIZE = 3
) (
    input wire [WORD_SIZE-1:0] p_ram_data, v_ram_data,
    input wire [MODE_SELECT_SIZE-1:0] mode,
    output reg [WORD_SIZE-1:0] instruction, peek, load,
    output reg load_flag = 0
);

     always_comb begin

        case(mode)

            0: instruction <= p_ram_data; // default
            1: peek <= p_ram_data; // peek
            2: load <= p_ram_data; // load
            3: load <= v_ram_data; // loadv
            4: load_flag <= 1;
            5: load_flag <= 0;
            default: instruction <= p_ram_data;

        endcase

    end
endmodule