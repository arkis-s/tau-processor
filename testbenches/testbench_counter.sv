`include "..\\src\\counter.sv"

module testbench_counter_w_load;

    localparam CLOCK = 10;
    localparam CYCLE = CLOCK * 2;
    reg clock = 0;
    always #CLOCK clock = ~clock;

    localparam ADDR_WIDTH = 16;
    localparam DATA_WIDTH = 16;

    reg load = 0;
    reg enable = 0;
    reg [ADDR_WIDTH-1:0] address = 0;
    wire [DATA_WIDTH-1:0] data;

    counter_w_load # (
        .ADDRESS_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)
    ) uut_counter (
        .clock(clock), .load(load), .enable(enable),
        .address(address), .data(data)
    );

    initial begin

        load = 1;
        #CYCLE;
        enable = 1;

        #60;
        address = 55;
        load = 0;

        #CLOCK;
        load = 1;
        assert(data == 55) $display("(%g) value %d loaded correctly", $time, address);

        #60;
        enable = 0;

        #20;
        $stop;

    end
endmodule