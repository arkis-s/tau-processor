`include ".\\src\\rom.sv"

module testbench_rom_sync;

    localparam CLOCK = 10;
    reg clock = 0;
    always #CLOCK clock = ~clock;

    localparam MEM_WIDTH = 16;
    localparam MEM_DEPTH = 64;
    localparam INIT_FILE = ".\\mem_init\\memory_test.mem";


    reg read_enable = 0;
    reg [MEM_WIDTH-1:0] address = 0;
    wire [MEM_WIDTH-1:0] data;

    
    reg [MEM_WIDTH-1:0] testmem [0:MEM_DEPTH];
    

    ROM_sync # (.MEMORY_WIDTH(MEM_WIDTH), .MEMORY_DEPTH(MEM_DEPTH), .INIT_FILE(INIT_FILE)
    ) uut_ROM_sync (
        .clock(clock), .read_enable(read_enable), .address(address), .data(data)
    );

    // at time = 0, set read_enable high to get output
    initial begin
        read_enable = 1;
        $readmemh(INIT_FILE, testmem);
    end

    always @(posedge clock) begin
        // address-1 because the we're accessing an array directly without the need of a clock delay
        // so this stops us from getting ahead by one value
        $monitor("(%g) R_EN = %b, ADDRESS = %h, DATA = %h, expected = %h", $time, read_enable, address, data, testmem[address-1]);

        // test if we are getting the expected input value
        assert(data == testmem[address-1]) else $warning("entry failed to verify");

        if (address == MEM_DEPTH) begin
            $stop;
        end

        address++;
    
    end
endmodule

module testbench_rom_async;

    // NON-FUNCTIONAL TESTBENCH
    // ... but the memory loads just file according to the memory list in modelsim so this will stay broken


    localparam MEM_WIDTH = 16;
    localparam MEM_DEPTH = 64;
    localparam INIT_FILE = ".\\mem_init\\memory_test.mem";

    reg read_enable = 0;
    reg [MEM_WIDTH-1:0] address = 0;
    wire [MEM_WIDTH-1:0] data;

    
    reg [MEM_WIDTH-1:0] testmem [0:MEM_DEPTH];
    
    ROM_async # (.MEMORY_WIDTH(MEM_WIDTH), .MEMORY_DEPTH(MEM_DEPTH), .INIT_FILE(INIT_FILE)
    ) uut_ROM_async (
        .read_enable(read_enable), .address(address), .data(data)
    );

    // at time = 0, set read_enable high to get output
    initial begin
        read_enable = 1;
        $readmemh(INIT_FILE, testmem);
    end

    initial begin

        for (int i = 0; i < MEM_DEPTH; i++) begin
            address <= i;
            assert(data == testmem[i]) else $warning("entry failed to verify e: %h g: %h", testmem[i], data);
            #5;
        end

        $stop;

    end
endmodule