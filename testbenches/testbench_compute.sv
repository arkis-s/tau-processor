`include ".\\src\\alu.sv"
`include ".\\src\\counter.sv"
`include ".\\src\\decision_unit.sv"
`include ".\\src\\execution_driver.sv"
`include ".\\src\\memory_controller.sv"
`include ".\\src\\muxers_demuxers.sv"
`include ".\\src\\ram.sv"
`include ".\\src\\rom.sv"
`include ".\\src\\reg_immN_control.sv"

module testbench_compute;

    // clock
    localparam CLK_5 = 5;
    reg clk_a = 0;
    always #CLK_5 clk_a = ~clk_a;

    localparam WORD_SIZE = 16;
    localparam MICROCODE_WIDTH = 16;
    localparam BYTE = 8;

    wire [WORD_SIZE-1:0] PC_value;
    wire ED_PC_enable;

    wire [MICROCODE_WIDTH-1:0] MCR_control_lines;

    // program counter
    counter_w_load # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16)
    ) uut_program_counter (
        .clock(clk_a), .load(1'b1), .enable(ED_PC_enable),
        .address(16'b0), .data(PC_value)
    );

    wire MC_PRAM_rw, MC_VRAM_rw;
    wire [WORD_SIZE-1:0] MC_PRAM_addr, MC_PRAM_data, MC_VRAM_addr, MC_VRAM_data;

    // memory controller
    memory_controller # (
        .INPUT_ADDRESS_WIDTH(WORD_SIZE),
        .INPUT_DATA_WIDTH(WORD_SIZE)
    ) uut_memory_controller (
        .program_counter_address(PC_value),
        .input_address(16'b0), .input_data(16'b0),
        .microcode_control(MCR_control_lines[14:12]),
        .p_ram_rw(MC_PRAM_rw), .p_ram_address(MC_PRAM_addr), .p_ram_data(MC_PRAM_data),
        .v_ram_rw(MC_VRAM_rw), .v_ram_address(MC_VRAM_addr), .v_ram_data(MC_VRAM_data)
    );

    wire [WORD_SIZE-1:0] PRAM_data_out;

    // program ram
    ram_single_port_sync # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16),
        .MEMORY_DEPTH(64), .INIT_FILE(".\\mem_init\\test_program.mem")
    ) uut_program_ram (
        .clock(clk_a), .enable(1'b1), .rw(MC_PRAM_rw),
        .address(MC_PRAM_addr), .data_in(MC_PRAM_data),
        .data_out(PRAM_data_out)
    );

    wire [WORD_SIZE-1:0] OPCODE_TRANSLATION_data;

    // opcode-to-microcode translator rom
    ROM_async # (
        .ADDRESS_WIDTH(8), .MEMORY_DEPTH(256),
        .DATA_WIDTH(16),
        .INIT_FILE(".\\mem_init\\opcode_microcode_translate.mem")
    ) uut_opcode_translator_rom (
        .read_enable(1'b1),
        .address(PRAM_data_out[15:8]), .data(OPCODE_TRANSLATION_data)
    );

    wire ED_MCS_load, ED_MCS_enable;
    wire [15:0] MCS_MCR_index;

    // microcode sequencer
    counter_w_load # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16)
    ) uut_microcode_sequencer (
        .clock(clk_a), .load(ED_MCS_load), .enable(ED_MCS_enable),
        .address(OPCODE_TRANSLATION_data), .data(MCS_MCR_index)
    );

    wire ED_MCR_enable;

    // microcode rom
    ROM_async # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(MICROCODE_WIDTH), 
        .MEMORY_DEPTH(64), .INIT_FILE(".\\mem_init\\microcode.mem")
    ) uut_microcode_rom (
        .read_enable(ED_MCR_enable), 
        .address(MCS_MCR_index), .data(MCR_control_lines)
    );

    reg ED_enable = 0;

    // execution driver
    execution_driver uut_execution_driver (
        .clock(clk_a), .enable(ED_enable), 
        .instruction_finish_control_line(MCR_control_lines[11]),
        .microcode_sequencer_load_n(ED_MCS_load),
        .microcode_sequencer_enable(ED_MCS_enable),
        .microcode_rom_read_enable(ED_MCR_enable),
        .program_counter_enable(ED_PC_enable)
    );

    wire [WORD_SIZE-1:0] MUX2t1_DATAPATH_word;

    mux_2to1 # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_mux_2to1_datapath (
        .A(PRAM_data_out), .B(16'b0), 
        .enable(1'b1), .selector(MCR_control_lines[10]), .out(MUX2t1_DATAPATH_word)
    );

    wire [WORD_SIZE-1:0] DATAPATH_instruction, DATAPATH_load, DATAPATH_peek, DATAPATH_void;

    demux_1to3 # (
        .WORD_SIZE(WORD_SIZE)
    ) uut_demux_1to3_datapath (
        .input_value(MUX2t1_DATAPATH_word), .enable(1'b1),
        .selector(MCR_control_lines[9:8]),
        .A(DATAPATH_instruction), .B(DATAPATH_load), .C(DATAPATH_peek), .NC(DATAPATH_void)
    );

    wire [2:0] MUX_LOGIC_SIDE_A_select;
    wire [3:0] MUX_LOGIC_SIDE_B_select;

    muxer_select_decision_logic_a # (.WORD_SIZE(WORD_SIZE)
    ) uut_muxer_decision_logic_A (
        .instruction(DATAPATH_instruction), .imm_flag(MCR_control_lines[0]),
        .mode_select(MUX_LOGIC_SIDE_A_select)
    );

    muxer_select_decision_logic_b # (.WORD_SIZE(WORD_SIZE), .DEFAULT_IMM_SELECTOR_VALUE(8)
    ) uut_muxer_decision_logic_b (
        .instruction(DATAPATH_instruction), .imm_flag(MCR_control_lines[0]),
        .mode_select(MUX_LOGIC_SIDE_B_select)
    );


    wire [BYTE-1:0] MUX_ALU_input_a, MUX_ALU_input_b,
                    ALU_value_out,
                    ALU_DEMUX_a, ALU_DEMUX_b, ALU_DEMUX_c, ALU_DEMUX_d, ALU_DEMUX_e, ALU_DEMUX_f, ALU_DEMUX_g, ALU_DEMUX_h,
                    REG_a_val, REG_b_val, REG_c_val, REG_d_val;

    register_N # (.WORD_SIZE(BYTE)) uut_reg_a (.clock(clk_a), .input_value(ALU_DEMUX_a), .output_value(REG_a_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_b (.clock(clk_a), .input_value(ALU_DEMUX_b), .output_value(REG_b_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_c (.clock(clk_a), .input_value(ALU_DEMUX_c), .output_value(REG_c_val));
    register_N # (.WORD_SIZE(BYTE)) uut_reg_d (.clock(clk_a), .input_value(ALU_DEMUX_d), .output_value(REG_d_val));



    // alu side a input mux
    mux_8to1 # (.WORD_SIZE(BYTE)
    ) uut_muxer_alu_input_a (
        .A(REG_a_val), .B(REG_b_val), .C(REG_c_val), .D(REG_d_val), .E(), .F(), .G(), .H(),
        .enable(MCR_control_lines[1]), .selector(MUX_LOGIC_SIDE_A_select), 
        .out(MUX_ALU_input_a)
    );

    mux_9to1 # (.WORD_SIZE(BYTE)) uut_muxer_alu_input_b (
        .A(REG_a_val), .B(REG_b_val), .C(REG_c_val), .D(REG_d_val), .E(), .F(), .G(), .H(), .IMM8(DATAPATH_instruction[7:0]), .NC(),
        .enable(MCR_control_lines[2]), .selector(MUX_LOGIC_SIDE_B_select), .out(MUX_ALU_input_b)
    );

    wire [7:0] ALU_flags;

    alu # (.WORD_SIZE(BYTE)) uut_alu (
        .input_A(MUX_ALU_input_a), .input_B(MUX_ALU_input_b), 
        .mode_select(MCR_control_lines[7:4]), .flags(ALU_flags), .output_C(ALU_value_out)
    );

    demux_1to8 # (.WORD_SIZE(BYTE)) uut_demux_alu_out (
        .input_value(ALU_value_out), .enable(MCR_control_lines[3]), .selector(MUX_LOGIC_SIDE_A_select),
        .A(ALU_DEMUX_a), .B(ALU_DEMUX_b), .C(ALU_DEMUX_c), .D(ALU_DEMUX_d), .E(ALU_DEMUX_e), .F(ALU_DEMUX_f), .G(ALU_DEMUX_g), .H(ALU_DEMUX_h)
    );

    initial begin
        
        #10;
        ED_enable = 1;
        #400;

        $stop;

    end



endmodule