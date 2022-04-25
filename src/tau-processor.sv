module tau_processor (
	//input wire clock_50mhz,
	//output reg [5:0] pixel_colour,
	input wire clock_50mhz, pll_rst_switch,
	output wire vga_hsync, vga_vsync,
	output wire [5:0] pixel_colour,
	output wire vga_h_led, vga_v_led,
	output wire pll_locked, debug_led
);

	wire [9:0] vga_x, vga_y;
	wire vga_in_active_area;
	wire [15:0] vram_data_out, vram_addr, vram_a_out;
	wire [3:0] pixel_info;
	
	wire clock_25mhz;

	clock_vga_25_175mhz uut_clk_vga (
		.refclk(clock_50mhz), .rst(1'b0), .outclk_0(clock_25mhz), .locked(pll_locked)
	);

	ram_dual_port_sync # (.MEMORY_DEPTH(19200), .INIT_FILE(".\\mem_init\\vram_init_gen2.mem")) 
	uut_vram (
		.clock_a(clock_25mhz), .enable_a(1'b0), .rw_a(1'b0), .address_a(16'b0), .data_in_a(16'b0), .data_out_a(vram_a_out),
		.clock_b(clock_25mhz), .enable_b(1'b1), .rw_b(1'b0), .address_b(vram_addr), .data_in_b(16'b0), .data_out_b(vram_data_out),
	);

	vga_driver uut_vga_driver (
		.clock_25mhz(clock_25mhz), .x(vga_x), .y(vga_y),
		.hsync(vga_hsync), .vsync(vga_vsync), .in_active_area(vga_in_active_area)
	);

	vga_vram_interface uut_vga_vram_interface(
		.x(vga_x[9:1]), .y(vga_y[9:1]), .vram_in(vram_data_out), .in_active_area(vga_in_active_area),
		.vram_addr(vram_addr), .pixel_data(pixel_info), .clock(clock_25mhz)
	);

	ega_colour_palette_logic uut_ega_colour (
		.index(pixel_info), .colour(pixel_colour)
	);
	
	//assign pixel_colour = 6'b111111;
	
	//always @ (posedge clock_25mhz) begin
	//	pixel_colour <= 6'b111111;
	//end
	
	//always @ (negedge clock_25mhz) begin
	//	pixel_colour <= 6'b000000;
	//end

	assign vga_h_led = vga_hsync;
	assign vga_v_led = vga_vsync;

	wire [25:0] clock_wire;

	clock_divider uut_clock_div (
		.phys_clk(clock_50mhz), .clock_div(clock_wire)
	);

	assign debug_led = clock_wire[25];

endmodule
