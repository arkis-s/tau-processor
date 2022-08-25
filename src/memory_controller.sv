module memory_controller # (
    parameter INPUT_ADDRESS_WIDTH = 16,
    parameter INPUT_DATA_WIDTH = 16
) (
    //                                                               v this is reg {E, F}
    input wire [INPUT_ADDRESS_WIDTH-1:0] program_counter_address, input_address,
    //                                 v this is reg {G, H}
    input wire [INPUT_DATA_WIDTH-1:0] input_data,
    input wire [2:0] microcode_control,
    output reg p_ram_rw, v_ram_rw,
    output reg [INPUT_DATA_WIDTH-1:0] p_ram_address, v_ram_address, p_ram_data, v_ram_data
);

    //typedef enum logic [2:0] {
    //    // load = load from memory into reg
    //    // store = store from reg into memory
    //    LOAD = 1, STORE = 2,
    //    LOADV = 3, STOREV = 4,
    //    PEEK = 5
    //} load_store_op_set;

    typedef enum logic [2:0] {
        LOAD = 3'b001, STORE = 3'b010,
        LOADV = 3'b011, STOREV = 3'b100,
        PEEK = 3'b101
    } load_store_op_set;


    always_comb begin
    //always @ (*) begin
        
        case (microcode_control)

            // fetch value at address {E, F}
            LOAD: begin
                p_ram_rw <= 0;
                p_ram_address <= input_address;
            end

            STORE: begin
                p_ram_rw <= 1;
                p_ram_address <= input_address;
                p_ram_data <= input_data;
            end

            LOADV: begin
                v_ram_rw <= 0;
                v_ram_address <= input_address;
            end

            STOREV: begin
                v_ram_rw <= 1;
                v_ram_address <= input_address;
                v_ram_data <= input_data;
            end

            PEEK: begin
                p_ram_rw <= 0;
                p_ram_address <= program_counter_address + 1;
            end

            default: begin
                p_ram_rw <= 0;
                v_ram_rw <= 0;

                // when the module gets an opcode it doesn't understand,
                // we dont want to hamper the execution of the program, 
                // so pass the value through
                p_ram_address <= program_counter_address;
                v_ram_address <= v_ram_address;

                // only reading should occur, so it shouldn't matter
                // what values these are set to
                p_ram_data <= 0;
                v_ram_data <= 0;
            end

        endcase

    end

endmodule