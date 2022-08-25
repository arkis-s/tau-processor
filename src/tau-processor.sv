//`include ".\\src\\alu.sv"
//`include ".\\src\\counter.sv"
//`include ".\\src\\decision_unit.sv"
//`include ".\\src\\execution_driver.sv"
//`include ".\\src\\memory_controller.sv"
//`include ".\\src\\muxers_demuxers.sv"
//`include ".\\src\\ram.sv"
//`include ".\\src\\rom.sv"
//`include ".\\src\\reg_immN_control.sv"
//`include ".\\src\\misc.sv"
//`include ".\\src\\datapath_controller.sv"

module tau_processor (
	input wire clock_50mhz, pll_rst_switch, global_reset,
	output wire vga_hsync, vga_vsync,
	output wire [5:0] pixel_colour,
	output wire [7:0] seg_bus_hi, seg_bus_lo,
	//output wire vga_h_led, vga_v_led,
	output wire pll_locked //, debug_led
);


	wire [25:0] clock_bus;
	wire clk_25, clk;
	wire global_reset_inv;

	clock_divider uut_clock_div (
		.phys_clk(clock_50mhz), .clock_div(clock_bus)
	);

	assign clk = clock_bus[25];
	assign global_reset_inv = ~global_reset;

	// PLL for 25.175MHz clock
	clock_vga_25_175mhz u_clock_25mhz (
		.refclk(clock_50mhz), .rst(~pll_rst_switch), .outclk_0(clk_25), .locked(pll_locked)
	);


    localparam WORD_SIZE = 16, MICROCODE_WIDTH = 16, BYTE = 8;

    wire [MICROCODE_WIDTH-1:0] control_lines;

	// 16 bit wide wires
    wire [WORD_SIZE-1:0] PC_value, PC_new_address,
                        DATAPATH_instruction, DATAPATH_peek, DATAPATH_load,
                        MC_PRAM_addr, MC_PRAM_data, MC_VRAM_addr_a, MC_VRAM_data_in_a,
                        PRAM_data_out, VRAM_data_out_a,
                        OPCODE_TRANSLATOR_index, MICROSEQUENCER_address, VRAM_data_out_b, VGA_VRAM_addr_b;
    
	// 1 bit wide wires
    wire HJ_ED_enable, 
        ED_MCS_load_n, ED_MCS_en, ED_MCR_en, ED_PC_en, ED_PC_load_n,
        MC_PRAM_rw, MC_VRAM_a_rw,
        DATAPATH_load_flag, //LOADMUX_gh_enable, LOADMUX_gh_select,
        LOADMUX_glue_g_select, LOADMUX_glue_h_select, vga_in_active_area;

	// special
    wire [2:0] MUX_LOGIC_SIDE_A_select;
    wire [3:0] MUX_LOGIC_SIDE_B_select;
	wire [9:0] vga_x, vga_y;
	wire [3:0] pixel_info;


	// 8 bit wide wires
    wire [7:0] MUX_ALU_input_a, MUX_ALU_input_b, ALU_value_out, ALU_flags,
                ALU_DEMUX_a, ALU_DEMUX_b, ALU_DEMUX_c, ALU_DEMUX_d, ALU_DEMUX_e, ALU_DEMUX_f, ALU_DEMUX_g, ALU_DEMUX_h,
                REG_a_val, REG_b_val, REG_c_val, REG_d_val, REG_e_val, REG_f_val, REG_g_val, REG_h_val,
                LOADMUX_REG_g_value, LOADMUX_REG_h_value;


	halt_check uut_halt_check (.opcode(DATAPATH_instruction[15:8]), .result(HJ_ED_enable));

	execution_driver uut_execution_driver (
        .clock(clk), .enable(HJ_ED_enable), .instruction_finish_control_line(control_lines[11]),
        .halt(~HJ_ED_enable), .jump_flag(control_lines[15]),
        .microcode_sequencer_load_n(ED_MCS_load_n), .microcode_sequencer_enable(ED_MCS_en), 
        .microcode_rom_read_enable(ED_MCR_en), 
        .program_counter_enable(ED_PC_en), .program_counter_load_n(ED_PC_load_n), .reset(global_reset_inv)
    );

    counter_w_load # (.ADDRESS_WIDTH(16), .DATA_WIDTH(16)) uut_program_counter (
        .clock(clk), .load(ED_PC_load_n), .enable(ED_PC_en),
        .address(PC_new_address), .data(PC_value), .reset(global_reset_inv)
    );

    memory_controller uut_memory_controller (
        .program_counter_address(PC_value), .input_address({REG_e_val, REG_f_val}), .input_data({REG_g_val, REG_h_val}),
        .microcode_control(control_lines[14:12]),
        .p_ram_rw(MC_PRAM_rw), .p_ram_address(MC_PRAM_addr), .p_ram_data(MC_PRAM_data),
        .v_ram_rw(MC_VRAM_a_rw), .v_ram_address(MC_VRAM_addr_a), .v_ram_data(MC_VRAM_data_in_a)
    );	

	// system memory
    ram_single_port_sync # (.INIT_FILE(".\\mem_init\\test_program.mem"), .MEMORY_DEPTH(128)) uut_program_ram (
        .clock(clk), .enable(1'b1), .rw(MC_PRAM_rw), 
        .address(MC_PRAM_addr), .data_in(MC_PRAM_data), .data_out(PRAM_data_out)
    );

	// vram
    ram_dual_port_sync # (.INIT_FILE(".\\mem_init\\vram_init.mem"), .MEMORY_DEPTH(128)) uut_video_ram (
        .clock_a(clk), .enable_a(1'b1), .rw_a(MC_VRAM_a_rw), 
        .address_a(MC_VRAM_addr_a), .data_in_a(MC_VRAM_data_in_a), .data_out_a(VRAM_data_out_a),

        .clock_b(clk_25), .enable_b(1'b0), .rw_b(1'b0),
        .address_b(VGA_VRAM_addr_b), .data_in_b(16'b0), .data_out_b(VRAM_data_out_b)
    );

    datapath_controller uut_datapath_controller (
        .p_ram_data(PRAM_data_out), .v_ram_data(VRAM_data_out_a),
        .mode(control_lines[10:8]),
        .instruction(DATAPATH_instruction),
        .peek(DATAPATH_peek), .load(DATAPATH_load),
        .load_flag(DATAPATH_load_flag)
        //.clock(clk)
    );

    ROM_async # (.ADDRESS_WIDTH(8), .MEMORY_DEPTH(256), 
                 .DATA_WIDTH(16), 
                 .INIT_FILE(".\\mem_init\\opcode_microcode_translate.mem")
    ) uut_opcode_translator_rom (
        .read_enable(1'b1), .address(DATAPATH_instruction[15:8]),
        .data(OPCODE_TRANSLATOR_index), .reset(global_reset_inv)
    );

    counter_w_load # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16)
    ) uut_microcode_sequencer (
        .clock(clk), .load(ED_MCS_load_n), .enable(ED_MCS_en),
        .address(OPCODE_TRANSLATOR_index), .data(MICROSEQUENCER_address), .reset(global_reset_inv)
    );

     ROM_sync # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(MICROCODE_WIDTH), 
        .MEMORY_DEPTH(512), .INIT_FILE(".\\mem_init\\microcode.mem")
    ) uut_microcode_rom (
        .read_enable(ED_MCR_en), .clock(clk),
        .address(MICROSEQUENCER_address), .data(control_lines), .reset(global_reset_inv)
    );

   decision_unit uut_decision_unit (
        .program_counter_address(PC_value), .instruction(DATAPATH_instruction),
        .peek_jump_address(DATAPATH_peek), .flags(ALU_flags), .new_address(PC_new_address)
        //.clock(clk)
    );

    muxer_select_decision_logic_a # (.WORD_SIZE(WORD_SIZE)
    ) uut_muxer_decision_logic_A (
        .instruction(DATAPATH_instruction), .imm_flag(control_lines[0]),
        .mode_select(MUX_LOGIC_SIDE_A_select), .clock(clk)
    );

    muxer_select_decision_logic_b # (.WORD_SIZE(WORD_SIZE), .DEFAULT_IMM_SELECTOR_VALUE(8)
    ) uut_muxer_decision_logic_b (
        .instruction(DATAPATH_instruction), .imm_flag(control_lines[0]),
        .mode_select(MUX_LOGIC_SIDE_B_select), .clock(clk)
    );

    register_N # (.WORD_SIZE(BYTE)) uut_reg_a (.clock(clk), .input_value(ALU_DEMUX_a), .output_value(REG_a_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_b (.clock(clk), .input_value(ALU_DEMUX_b), .output_value(REG_b_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_c (.clock(clk), .input_value(ALU_DEMUX_c), .output_value(REG_c_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_d (.clock(clk), .input_value(ALU_DEMUX_d), .output_value(REG_d_val), .reset(global_reset_inv));

    register_N # (.WORD_SIZE(BYTE)) uut_reg_e (.clock(clk), .input_value(ALU_DEMUX_e), .output_value(REG_e_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_f (.clock(clk), .input_value(ALU_DEMUX_f), .output_value(REG_f_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_g (.clock(clk), .input_value(LOADMUX_REG_g_value), .output_value(REG_g_val), .reset(global_reset_inv));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_h (.clock(clk), .input_value(LOADMUX_REG_h_value), .output_value(REG_h_val), .reset(global_reset_inv));

    mux_8to1 # (.WORD_SIZE(BYTE)
    ) uut_muxer_alu_input_a (
        .A(REG_a_val), .B(REG_b_val), .C(REG_c_val), .D(REG_d_val), .E(REG_e_val), .F(REG_f_val), .G(REG_g_val), .H(REG_h_val),
        .enable(control_lines[1]), .selector(MUX_LOGIC_SIDE_A_select), 
        .out(MUX_ALU_input_a)
    );

    mux_9to1 # (.WORD_SIZE(BYTE)) uut_muxer_alu_input_b (
        .A(REG_a_val), .B(REG_b_val), .C(REG_c_val), .D(REG_d_val), .E(REG_e_val), .F(REG_f_val), .G(REG_g_val), .H(REG_h_val), 
        .IMM8(DATAPATH_instruction[7:0]),
        .enable(control_lines[2]), .selector(MUX_LOGIC_SIDE_B_select), .out(MUX_ALU_input_b)
    );

    alu # (.WORD_SIZE(BYTE)) uut_alu (
        .input_A(MUX_ALU_input_a), .input_B(MUX_ALU_input_b), 
        .mode_select(control_lines[7:4]), .flags(ALU_flags), .output_C(ALU_value_out)
    );

    demux_1to8 # (.WORD_SIZE(BYTE)) uut_demux_alu_out (
        .input_value(ALU_value_out), .enable(control_lines[3]), .selector(MUX_LOGIC_SIDE_A_select),
        .A(ALU_DEMUX_a), .B(ALU_DEMUX_b), .C(ALU_DEMUX_c), .D(ALU_DEMUX_d), .E(ALU_DEMUX_e), .F(ALU_DEMUX_f), .G(ALU_DEMUX_g), .H(ALU_DEMUX_h)
    );

    load_register_glue_logic # (.REGISTER_VAL(6)) uut_load_mux_glue_g (
        .mux_register_select(MUX_LOGIC_SIDE_A_select), .load_flag(DATAPATH_load_flag), 
        .alu_output_flag(control_lines[3]), .load_mux_select(LOADMUX_glue_g_select)
    );

    load_register_glue_logic # (.REGISTER_VAL(7)) uut_load_mux_glue_h (
        .mux_register_select(MUX_LOGIC_SIDE_A_select), .load_flag(DATAPATH_load_flag),
        .alu_output_flag(control_lines[3]), .load_mux_select(LOADMUX_glue_h_select)
    );

    mux_2to1 uut_load_mux_reg_g (
        .A(ALU_DEMUX_g), .B(DATAPATH_load[15:8]), .enable(1'b1), .selector(LOADMUX_glue_g_select), .out(LOADMUX_REG_g_value)
    );

    mux_2to1 uut_load_mux_reg_h (
        .A(ALU_DEMUX_h), .B(DATAPATH_load[7:0]), .enable(1'b1), .selector(LOADMUX_glue_h_select), .out(LOADMUX_REG_h_value)
    );

	vga_driver uut_vga_driver (
		.clock_25mhz(clk_25), .x(vga_x), .y(vga_y), .hsync(vga_hsync), .vsync(vga_vsync), .in_active_area(vga_in_active_area)
	);

	vga_vram_interface uut_vga_vram_if (
		.x(vga_x[9:1]), .y(vga_y[9:1]), .vram_in(VRAM_data_out_b), .in_active_area(vga_in_active_area),
		.vram_addr(VGA_VRAM_addr_b), .pixel_data(pixel_info), .clock(clk_25)
	);

	ega_colour_palette_logic uut_ega_colour (
		.index(pixel_info), .colour(pixel_colour)
	);

	seg_decode uut_seg_decode_reg_a_hi (
		.index(REG_a_val[7:4]), .output_value(seg_bus_hi)
	);

	seg_decode uut_seg_decode_reg_a_lo (
		.index(REG_a_val[3:0]), .output_value(seg_bus_lo)
	);

endmodule



// VGA IMPLENENTATION ONLY
/*module tau_processor (
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

endmodule*/
