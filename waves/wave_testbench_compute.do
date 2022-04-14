onerror {resume}
quietly virtual signal -install /testbench_compute { /testbench_compute/MCR_control_lines[14:12]} mem_controller_mode_select
quietly virtual signal -install /testbench_compute { /testbench_compute/MCR_control_lines[10:8]} datapath_control
quietly virtual signal -install /testbench_compute { /testbench_compute/MCR_control_lines[7:4]} ALU_mode_select
quietly virtual signal -install /testbench_compute { /testbench_compute/MCR_control_lines[2:0]} ALU_MUX_OBA_enable
quietly virtual signal -install /testbench_compute { /testbench_compute/MCR_control_lines[3:1]} ALU_MUXERS_OBA
quietly WaveActivateNextPane {} 0
add wave -noupdate -label {clock a} /testbench_compute/clk_a
add wave -noupdate -label {exec driver enable} /testbench_compute/ED_enable
add wave -noupdate -label {exec driver -> program counter enable} /testbench_compute/ED_PC_enable
add wave -noupdate -label {program counter value} -radix hexadecimal -radixshowbase 0 /testbench_compute/PC_value
add wave -noupdate -expand -group {memory controller} -label {memory controller mode select} -radix hexadecimal /testbench_compute/mem_controller_mode_select
add wave -noupdate -expand -group {memory controller} -label {mem controller -> prog mem r(0)w(1)} /testbench_compute/MC_PRAM_rw
add wave -noupdate -expand -group {memory controller} -label {mem controller -> prog mem address} -radix hexadecimal /testbench_compute/MC_PRAM_addr
add wave -noupdate -expand -group {memory controller} -label {mem controller -> prog mem data in} -radix hexadecimal /testbench_compute/MC_PRAM_data
add wave -noupdate -expand -group {memory controller} -label {mem controller -> vram r(0)w(1)} /testbench_compute/MC_VRAM_rw
add wave -noupdate -expand -group {memory controller} -label {mem controller -> vram address} -radix hexadecimal /testbench_compute/MC_VRAM_addr
add wave -noupdate -expand -group {memory controller} -label {mem controller -> vram data in} -radix hexadecimal /testbench_compute/MC_VRAM_data
add wave -noupdate -label {prog mem data out (instruction)} -radix hexadecimal -childformat {{{/testbench_compute/PRAM_data_out[15]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[14]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[13]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[12]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[11]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[10]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[9]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[8]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[7]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[6]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[5]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[4]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[3]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[2]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[1]} -radix hexadecimal} {{/testbench_compute/PRAM_data_out[0]} -radix hexadecimal}} -subitemconfig {{/testbench_compute/PRAM_data_out[15]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[14]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[13]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[12]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[11]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[10]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[9]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[8]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[7]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[6]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[5]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[4]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[3]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[2]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[1]} {-radix hexadecimal} {/testbench_compute/PRAM_data_out[0]} {-radix hexadecimal}} /testbench_compute/PRAM_data_out
add wave -noupdate -label {opcode translation index} -radix hexadecimal /testbench_compute/OPCODE_TRANSLATION_data
add wave -noupdate -label {exec driver -> microcode sequencer enable} /testbench_compute/ED_MCS_enable
add wave -noupdate -label {exec driver -> microcode sequencer load (n)} /testbench_compute/ED_MCS_load
add wave -noupdate -label {exec driver -> microcode rom enable} /testbench_compute/ED_MCR_enable
add wave -noupdate -label {microcode sequencer -> microcode rom index} -radix hexadecimal /testbench_compute/MCS_MCR_index
add wave -noupdate -label {microcode rom control lines} -radix hexadecimal -childformat {{{/testbench_compute/MCR_control_lines[15]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[14]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[13]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[12]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[11]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[10]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[9]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[8]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[7]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[6]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[5]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[4]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[3]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[2]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[1]} -radix hexadecimal} {{/testbench_compute/MCR_control_lines[0]} -radix hexadecimal}} -subitemconfig {{/testbench_compute/MCR_control_lines[15]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[14]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[13]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[12]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[11]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[10]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[9]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[8]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[7]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[6]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[5]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[4]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[3]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[2]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[1]} {-height 15 -radix hexadecimal} {/testbench_compute/MCR_control_lines[0]} {-height 15 -radix hexadecimal}} /testbench_compute/MCR_control_lines
add wave -noupdate -divider DATAPATH
add wave -noupdate -label {prog mem data out (instruction)} -radix hexadecimal /testbench_compute/PRAM_data_out
add wave -noupdate /testbench_compute/datapath_control
add wave -noupdate -radix hexadecimal /testbench_compute/MUX2t1_DATAPATH_word
add wave -noupdate -radix hexadecimal /testbench_compute/DATAPATH_instruction
add wave -noupdate -radix hexadecimal /testbench_compute/DATAPATH_load
add wave -noupdate -radix hexadecimal /testbench_compute/DATAPATH_peek
add wave -noupdate -radix hexadecimal /testbench_compute/DATAPATH_void
add wave -noupdate -divider ALU
add wave -noupdate /testbench_compute/ALU_mode_select
add wave -noupdate /testbench_compute/ALU_MUXERS_OBA
add wave -noupdate -label {microcode immediate value flag} -radix hexadecimal {/testbench_compute/MCR_control_lines[0]}
add wave -noupdate -radix unsigned -childformat {{{/testbench_compute/MUX_LOGIC_SIDE_A_select[2]} -radix unsigned} {{/testbench_compute/MUX_LOGIC_SIDE_A_select[1]} -radix unsigned} {{/testbench_compute/MUX_LOGIC_SIDE_A_select[0]} -radix unsigned}} -subitemconfig {{/testbench_compute/MUX_LOGIC_SIDE_A_select[2]} {-height 15 -radix unsigned} {/testbench_compute/MUX_LOGIC_SIDE_A_select[1]} {-height 15 -radix unsigned} {/testbench_compute/MUX_LOGIC_SIDE_A_select[0]} {-height 15 -radix unsigned}} /testbench_compute/MUX_LOGIC_SIDE_A_select
add wave -noupdate -radix unsigned /testbench_compute/MUX_LOGIC_SIDE_B_select
add wave -noupdate -radix hexadecimal /testbench_compute/MUX_ALU_input_a
add wave -noupdate -radix hexadecimal /testbench_compute/MUX_ALU_input_b
add wave -noupdate -radix hexadecimal /testbench_compute/ALU_value_out
add wave -noupdate /testbench_compute/ALU_flags
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_a
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_b
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_c
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_d
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_e
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_f
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_g
add wave -noupdate -group {ALU -> DEMUX} /testbench_compute/ALU_DEMUX_h
add wave -noupdate -divider REGISTERS
add wave -noupdate -radix hexadecimal /testbench_compute/REG_a_val
add wave -noupdate -radix hexadecimal /testbench_compute/REG_b_val
add wave -noupdate -radix hexadecimal /testbench_compute/REG_c_val
add wave -noupdate -radix hexadecimal /testbench_compute/REG_d_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {104 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 335
configure wave -valuecolwidth 139
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {398 ps}
