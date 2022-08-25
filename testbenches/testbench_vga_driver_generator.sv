`include ".\\src\\vga_driver.sv"
`include ".\\src\\vga_screen_gen.sv"
`include ".\\src\\ram.sv"

module testbench_vga_driver_generator;

    reg clock = 1'b1;
    always #1 clock = ~clock;

    wire [9:0]x, y;
    wire hsync, vsync, in_active_area;
    wire [15:0] vram_addr, vram_data;
    wire [3:0] pixel;
    reg [8:0] addr_x, addr_y;

    assign addr_x = x[9:1];
    assign addr_y = y[9:1];

    //reg [15:0] dummy_mem [0:76800] // 76800 == 320 * 240

    ram_dual_port_sync # (.ADDRESS_WIDTH(16), .DATA_WIDTH(16), 
        .MEMORY_DEPTH(19200), .INIT_FILE(".\\mem_init\\vram_init_gen.mem")
    ) uut_vram (
        .clock_b(clock), .enable_b(1'b1), .rw_b(1'b0), 
        .address_b(vram_addr), .data_out_b(vram_data)
    );

    vga_driver uut_vga_driver (
        .clock_25mhz(clock), .x(x), .y(y),
        .hsync(hsync), .vsync(vsync),
        .in_active_area(in_active_area)
    );

    vga_vram_interface uut_vram_interface (
        .x(x[9:1]), .y(y[9:1]), .in_active_area(in_active_area),
        .vram_in(vram_data), .vram_addr(vram_addr), .pixel_data(pixel)
    );

    initial begin

        //#1700000;
        //#50000;
        #500;
        $stop;

    end
endmodule