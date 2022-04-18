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