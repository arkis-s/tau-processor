`include ".\\src\\alu.sv"
`include ".\\src\\counter.sv"
`include ".\\src\\decision_unit.sv"
`include ".\\src\\execution_driver.sv"
`include ".\\src\\memory_controller.sv"
`include ".\\src\\muxers_demuxers.sv"
`include ".\\src\\ram.sv"
`include ".\\src\\rom.sv"
`include ".\\src\\reg_immN_control.sv"
`include ".\\src\\misc.sv"
`include ".\\src\\datapath_controller.sv"


module testbench_compute_primitive;

    localparam CLOCK = 5;
    reg clk = 0;
    always #CLOCK clk = ~clk;

    localparam WORD_SIZE = 16;
    localparam BYTE = 8;
    localparam MICROCODE_WIDTH = 16;

    wire [WORD_SIZE-1:0] program_counter_value,
                            p_ram_address, v_ram_address, p_ram_data, v_ram_data,
                            PRAM_data_out, 
                            DATAPATH_instruction, DATAPATH_peek, DATAPATH_load;

    wire p_ram_rw, v_ram_rw;

    reg pc_en = 0;
    reg [2:0] memory_controller_mode = 0, datapath_controller_mode = 0;

    counter_w_load # (.ADDRESS_WIDTH(16), .DATA_WIDTH(16))
    uut_program_counter (
        .clock(clk), .load(1'b1), .enable(pc_en),
        .address(16'b0), .data(program_counter_value)
    );

    memory_controller # (.INPUT_ADDRESS_WIDTH(16), .INPUT_DATA_WIDTH(16))
    uut_memory_controller (
        .program_counter_address(program_counter_value), .input_address(16'b0),
        .input_data(16'b0), .microcode_control(memory_controller_mode),
        .p_ram_rw(p_ram_rw), .v_ram_rw(v_ram_rw),
        .p_ram_address(p_ram_address), .v_ram_address(v_ram_address),
        .p_ram_data(p_ram_data), .v_ram_data(v_ram_data) 
    );

    ram_single_port_sync # (.ADDRESS_WIDTH(16), .DATA_WIDTH(16), .MEMORY_DEPTH(64), .INIT_FILE(".\\mem_init\\test_program.mem"))
    uut_program_ram (
        .clock(clk), .enable(1'b1), .rw(p_ram_rw),
        .address(p_ram_address), .data_in(p_ram_data),
        .data_out(PRAM_data_out)
    );

    datapath_controller # (.WORD_SIZE(16), .MODE_SELECT_SIZE(3)) uut_datapath_controller (
        .p_ram_data(PRAM_data_out), .v_ram_data(), .mode(datapath_controller_mode),
        .instruction(DATAPATH_instruction), .peek(DATAPATH_peek),
        .load(DATAPATH_load)
    );


    initial begin

        #10; memory_controller_mode <= 5; datapath_controller_mode <= 1;
        #10; pc_en = 1; memory_controller_mode <= 0; datapath_controller_mode <= 0;
        #20; //pc_en = 0;

        $stop;

    end
endmodule

module testbench_compute_2;

    // clock
    localparam CLK_5 = 5;
    reg clk = 0;
    always #CLK_5 clk = ~clk;

    localparam WORD_SIZE = 16, MICROCODE_WIDTH = 16, BYTE = 8;

    wire [MICROCODE_WIDTH-1:0] control_lines;

    wire [WORD_SIZE-1:0] PC_value, PC_new_address,
                        DATAPATH_instruction, DATAPATH_peek, DATAPATH_load,
                        MC_PRAM_addr, MC_PRAM_data, MC_VRAM_addr_a, MC_VRAM_data_in_a,
                        PRAM_data_out, VRAM_data_out_a,
                        OPCODE_TRANSLATOR_index, MICROSEQUENCER_address;
    
    wire HJ_ED_enable, 
        ED_MCS_load_n, ED_MCS_en, ED_MCR_en, ED_PC_en, ED_PC_load_n,
        MC_PRAM_rw, MC_VRAM_a_rw,
        DATAPATH_load_flag, LOADMUX_gh_enable, LOADMUX_gh_select,
        LOADMUX_glue_g_select, LOADMUX_glue_h_select;

    wire [2:0] MUX_LOGIC_SIDE_A_select;
    wire [3:0] MUX_LOGIC_SIDE_B_select;

    wire [7:0] MUX_ALU_input_a, MUX_ALU_input_b, ALU_value_out, ALU_flags,
                ALU_DEMUX_a, ALU_DEMUX_b, ALU_DEMUX_c, ALU_DEMUX_d, ALU_DEMUX_e, ALU_DEMUX_f, ALU_DEMUX_g, ALU_DEMUX_h,
                REG_a_val, REG_b_val, REG_c_val, REG_d_val, REG_e_val, REG_f_val, REG_g_val, REG_h_val,
                LOADMUX_REG_g_value, LOADMUX_REG_h_value;


    assign LOADMUX_gh_enable = ((~DATAPATH_load_flag & control_lines[3]) | (DATAPATH_load_flag & ~control_lines[3]));

    assign LOADMUX_gh_select = (DATAPATH_load_flag & ~control_lines[3]);

    halt_check uut_halt_check (.opcode(DATAPATH_instruction[15:8]), .result(HJ_ED_enable));

    execution_driver uut_execution_driver (
        .clock(clk), .enable(HJ_ED_enable), .instruction_finish_control_line(control_lines[11]),
        .halt(~HJ_ED_enable), .jump_flag(control_lines[15]),
        .microcode_sequencer_load_n(ED_MCS_load_n), .microcode_sequencer_enable(ED_MCS_en), 
        .microcode_rom_read_enable(ED_MCR_en), 
        .program_counter_enable(ED_PC_en), .program_counter_load_n(ED_PC_load_n)
    );

    counter_w_load # (.ADDRESS_WIDTH(16), .DATA_WIDTH(16)) uut_program_counter (
        .clock(clk), .load(ED_PC_load_n), .enable(ED_PC_en),
        .address(PC_new_address), .data(PC_value)
    );

    memory_controller uut_memory_controller (
        .program_counter_address(PC_value), .input_address({REG_e_val, REG_f_val}), .input_data({REG_g_val, REG_h_val}),
        .microcode_control(control_lines[14:12]),
        .p_ram_rw(MC_PRAM_rw), .p_ram_address(MC_PRAM_addr), .p_ram_data(MC_PRAM_data),
        .v_ram_rw(MC_VRAM_a_rw), .v_ram_address(MC_VRAM_addr_a), .v_ram_data(MC_VRAM_data_in_a)
    );

    ram_single_port_sync # (.INIT_FILE(".\\mem_init\\test_program.mem")) uut_program_ram (
        .clock(clk), .enable(1'b1), .rw(MC_PRAM_rw), 
        .address(MC_PRAM_addr), .data_in(MC_PRAM_data), .data_out(PRAM_data_out)
    );

    ram_dual_port_sync # (.INIT_FILE(".\\mem_init\\vram_init.mem")) uut_video_ram (
        .clock_a(clk), .enable_a(1'b1), .rw_a(MC_VRAM_a_rw), 
        .address_a(MC_VRAM_addr_a), .data_in_a(MC_VRAM_data_in_a), .data_out_a(VRAM_data_out_a),

        .clock_b(), .enable_b(1'b0), .rw_b(1'b0),
        .address_b(), .data_in_b(), .data_out_b()
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
        .data(OPCODE_TRANSLATOR_index)
    );

    counter_w_load # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16)
    ) uut_microcode_sequencer (
        .clock(clk), .load(ED_MCS_load_n), .enable(ED_MCS_en),
        .address(OPCODE_TRANSLATOR_index), .data(MICROSEQUENCER_address)
    );

     ROM_async # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(MICROCODE_WIDTH), 
        .MEMORY_DEPTH(64), .INIT_FILE(".\\mem_init\\microcode.mem")
    ) uut_microcode_rom (
        .read_enable(ED_MCR_en), 
        .address(MICROSEQUENCER_address), .data(control_lines)
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

    register_N # (.WORD_SIZE(BYTE)) uut_reg_a (.clock(clk), .input_value(ALU_DEMUX_a), .output_value(REG_a_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_b (.clock(clk), .input_value(ALU_DEMUX_b), .output_value(REG_b_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_c (.clock(clk), .input_value(ALU_DEMUX_c), .output_value(REG_c_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_d (.clock(clk), .input_value(ALU_DEMUX_d), .output_value(REG_d_val));

    register_N # (.WORD_SIZE(BYTE)) uut_reg_e (.clock(clk), .input_value(ALU_DEMUX_e), .output_value(REG_e_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_f (.clock(clk), .input_value(ALU_DEMUX_f), .output_value(REG_f_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_g (.clock(clk), .input_value(LOADMUX_REG_g_value), .output_value(REG_g_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_h (.clock(clk), .input_value(LOADMUX_REG_h_value), .output_value(REG_h_val));

  
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

    initial begin

        #300;
        $stop;
    end


endmodule