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
    parameter REGISTER_VAL
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