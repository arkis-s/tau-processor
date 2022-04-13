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

    wire [WORD_SIZE-1:0] PC_value;
    wire ED_PC_enable;

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
        .microcode_control(),
        .p_ram_rw(MC_PRAM_rw), .p_ram_address(MC_PRAM_addr), .p_ram_data(MC_PRAM_data),
        .v_ram_rw(MC_VRAM_rw), .v_ram_address(MC_VRAM_addr), .v_ram_data(MC_VRAM_data)
    );

    wire [WORD_SIZE-1:0] PRAM_data_out;

    // program ram
    ram_single_port_sync # (
        .ADDRESS_WIDTH(16), .DATA_WIDTH(16),
        .MEMORY_DEPTH(64), .INIT_FILE(".\\mem_init\\test_program.mem")
    ) uut_program_ram (
        .clock(clk_a), .enable(), .rw(MC_PRAM_rw),
        .address(MC_PRAM_addr), .data_in(MC_PRAM_data),
        .data_out(PRAM_data_out)
    );

    wire [WORD_SIZE-1:0] OPCODE_TRANSLATION_data;

    // opcode-to-microcode translator rom
    ROM_async # (
        .ADDRESS_WIDTH(8), .MEMORY_DEPTH(8),
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
        .clock(clk_a), .load(ED_MSC_load), .enable(ED_MCS_enable),
        .address(OPCODE_TRANSLATION_data), .data(MCS_MCR_index)
    );

    localparam MICROCODE_WIDTH = 20;
    wire ED_MCR_enable;
    wire [MICROCODE_WIDTH-1:0] MCR_control_lines;


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
        .instruction_finish_control_line(MCR_control_lines[19]),
        .microcode_sequencer_load_n(ED_MCS_load),
        .microcode_sequencer_enable(ED_MCS_enable),
        .microcode_rom_read_enable(ED_MCR_enable),
        .program_counter_enable(ED_PC_enable)
    );


    initial begin
        
        #10;
        ED_enable = 1;
        #400;

        $stop;

    end



endmodule