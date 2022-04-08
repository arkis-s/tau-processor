module ROM_sync # (
    parameter MEMORY_WIDTH = 8,
    parameter MEMORY_DEPTH = 8,
    parameter INIT_FILE = ""
) (
    input wire clock, read_enable,
    input wire [MEMORY_WIDTH-1:0] address,
    output reg [MEMORY_WIDTH-1:0] data
);

    reg [MEMORY_WIDTH-1:0] memory_block [0:MEMORY_DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, memory_block);
    end

    always @ (posedge clock) begin
        if (read_enable) begin
            data <= memory_block[address];
        end
    end
endmodule

module ROM_async # (
    parameter MEMORY_WIDTH = 8,
    parameter MEMORY_DEPTH = 8,
    parameter INIT_FILE = ""
) (
    input wire read_enable,
    input wire [MEMORY_WIDTH-1:0] address,
    output reg [MEMORY_WIDTH-1:0] data
);

    reg [MEMORY_WIDTH-1:0] memory_block [0:MEMORY_DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, memory_block);
    end

    always @ (address) begin
        if (read_enable) begin
            data <= memory_block[address];
        end
    end

endmodule