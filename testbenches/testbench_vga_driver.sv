`include ".\\src\\vga_driver.sv"

module testbench_vga_driver;


    reg clock = 1'b0;
    always #1 clock = ~clock;

    wire [9:0] x, y;
    reg [8:0] addr_x, addr_y;
    wire hsync, vsync, in_active_area;

    assign addr_x = x[9:1];
    assign addr_y = y[9:1];

    vga_driver uut_vga_driver (
        .clock_25mhz(clock), .x(x), .y(y),
        .hsync(hsync), .vsync(vsync),
        .in_active_area(in_active_area)
    );


    initial begin
        #10000;
        $stop;
    end



endmodule