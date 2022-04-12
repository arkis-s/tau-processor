module ram_single_port_sync  # (
    parameter ADDRESS_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter MEMORY_DEPTH = 64,
    parameter INIT_FILE = ""
) (
    input wire clock, enable, rw,
    input wire [ADDRESS_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

    reg [DATA_WIDTH-1:0] memory_block [0:MEMORY_DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, memory_block);
    end

    always @ (posedge clock) begin
        if (enable) begin
            // read = 0, write = 1
            if (rw == 0) begin
                data_out <= memory_block[address];
            end else if (rw == 1) begin
                memory_block[address] <= data_in;
            end
        end
    end

endmodule

module ram_dual_port_sync # (
    parameter ADDRESS_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter MEMORY_DEPTH = 64,
    parameter INIT_FILE = "";
) (
    input wire clock_a, clock_b, enable_a, enable_b, rw_a, rw_b,
    input wire [ADDRESS_WIDTH-1:0] address_a, address_b,
    input wire [DATA_WIDTH-1:0] data_in_a, data_in_b,
    output reg [DATA_WIDTH-1:0] data_out_a, data_out_b
);

    reg [DATA_WIDTH-1:0] memory_block_dual [0:MEMORY_DEPTH-1];

    always @ (posedge clock_a) begin
        if (enable_a) begin
            // read = 0, write = 1
            if (rw_a == 0) begin
                data_out_a <= memory_block_dual[address_a];
            end else if (rw_a == 1) begin
                memory_block_dual[address_a] <= data_in_a;
            end
        end
    end

    always @ (posedge clock_b) begin
        if (enable_b) begin
            // read = 0, write = 1
            if (rw_b == 0) begin
                data_out_b <= memory_block_dual[address_b];
            end else if (rw_b == 1) begin
                memory_block_dual[address_b] <= data_in_b;
            end
        end
    end

endmodule