module ROM_sync # (
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter MEMORY_DEPTH = 64,
    //parameter MEMORY_WIDTH = 8,
    //parameter MEMORY_DEPTH = 8,
    parameter INIT_FILE = ""
) (
    input wire clock, read_enable, reset,
    input wire [ADDRESS_WIDTH-1:0] address,
    output reg [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] memory_block [0:MEMORY_DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, memory_block);
    end

    always @ (posedge clock or posedge reset) begin

        if (reset) begin
            data <= memory_block[address];
        end else if (read_enable) begin
            data <= memory_block[address];
        end
    end
endmodule

module ROM_async # (
    parameter ADDRESS_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter MEMORY_DEPTH = 8,
    parameter INIT_FILE = ""
) (
    input wire read_enable, reset,
    input wire [ADDRESS_WIDTH-1:0] address,
    // output reg [MEMORY_WIDTH-1:0] data
    output reg [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] memory_block [0:MEMORY_DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, memory_block);
    end

    always_comb begin
    //always @ (*) begin
        if (reset) begin
            data <= memory_block[address];
        end else if (read_enable) begin
            data = memory_block[address];
        end
    end

endmodule