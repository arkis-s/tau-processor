onerror {resume}
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[14:12]} mem_c_mode
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[10:8]} datapath_mode
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_compute_2/clk
add wave -noupdate -label {exec driver -> program counter enable} /testbench_compute_2/ED_PC_en
add wave -noupdate -label {program counter value} -radix hexadecimal /testbench_compute_2/PC_value
add wave -noupdate -label {program counter load} -radix hexadecimal {/testbench_compute_2/control_lines[15]}
add wave -noupdate -label {halt check -> exec driver enable} /testbench_compute_2/HJ_ED_enable
add wave -noupdate -label {opcode index for microcode} -radix hexadecimal /testbench_compute_2/OPCODE_TRANSLATOR_index
add wave -noupdate -label {microcode sequencer index} -radix hexadecimal /testbench_compute_2/MICROSEQUENCER_address
add wave -noupdate -label {microcode control lines} -radix hexadecimal -childformat {{{/testbench_compute_2/control_lines[15]} -radix hexadecimal} {{/testbench_compute_2/control_lines[14]} -radix hexadecimal} {{/testbench_compute_2/control_lines[13]} -radix hexadecimal} {{/testbench_compute_2/control_lines[12]} -radix hexadecimal} {{/testbench_compute_2/control_lines[11]} -radix hexadecimal} {{/testbench_compute_2/control_lines[10]} -radix hexadecimal} {{/testbench_compute_2/control_lines[9]} -radix hexadecimal} {{/testbench_compute_2/control_lines[8]} -radix hexadecimal} {{/testbench_compute_2/control_lines[7]} -radix hexadecimal} {{/testbench_compute_2/control_lines[6]} -radix hexadecimal} {{/testbench_compute_2/control_lines[5]} -radix hexadecimal} {{/testbench_compute_2/control_lines[4]} -radix hexadecimal} {{/testbench_compute_2/control_lines[3]} -radix hexadecimal} {{/testbench_compute_2/control_lines[2]} -radix hexadecimal} {{/testbench_compute_2/control_lines[1]} -radix hexadecimal} {{/testbench_compute_2/control_lines[0]} -radix hexadecimal}} -subitemconfig {{/testbench_compute_2/control_lines[15]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[14]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[13]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[12]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[11]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[10]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[9]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[8]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[7]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[6]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[5]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[4]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[3]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[2]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[1]} {-height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[0]} {-height 15 -radix hexadecimal}} /testbench_compute_2/control_lines
add wave -noupdate -label {exec driver -> microcode rom enable} /testbench_compute_2/ED_MCR_en
add wave -noupdate -label {exec driver -> microsequencer enable} /testbench_compute_2/ED_MCS_en
add wave -noupdate -label {exec driver -> microsequencer load n} /testbench_compute_2/ED_MCS_load_n
add wave -noupdate -divider {MEMORY CONTROLLER}
add wave -noupdate -radix hexadecimal /testbench_compute_2/mem_c_mode
add wave -noupdate -label {mem controller -> program memory r0w1} /testbench_compute_2/MC_PRAM_rw
add wave -noupdate -label {mem controller -> program memory address} -radix hexadecimal /testbench_compute_2/MC_PRAM_addr
add wave -noupdate -label {program memory data out} -radix hexadecimal /testbench_compute_2/PRAM_data_out
add wave -noupdate -label {mem controller -> program memory data in} -radix hexadecimal /testbench_compute_2/MC_PRAM_data
add wave -noupdate -divider DATAPATH
add wave -noupdate -radix hexadecimal /testbench_compute_2/datapath_mode
add wave -noupdate -color Gold -label instruction -radix hexadecimal /testbench_compute_2/DATAPATH_instruction
add wave -noupdate -color Gold -label {microcode control lines} -radix hexadecimal -childformat {{{/testbench_compute_2/control_lines[15]} -radix hexadecimal} {{/testbench_compute_2/control_lines[14]} -radix hexadecimal} {{/testbench_compute_2/control_lines[13]} -radix hexadecimal} {{/testbench_compute_2/control_lines[12]} -radix hexadecimal} {{/testbench_compute_2/control_lines[11]} -radix hexadecimal} {{/testbench_compute_2/control_lines[10]} -radix hexadecimal} {{/testbench_compute_2/control_lines[9]} -radix hexadecimal} {{/testbench_compute_2/control_lines[8]} -radix hexadecimal} {{/testbench_compute_2/control_lines[7]} -radix hexadecimal} {{/testbench_compute_2/control_lines[6]} -radix hexadecimal} {{/testbench_compute_2/control_lines[5]} -radix hexadecimal} {{/testbench_compute_2/control_lines[4]} -radix hexadecimal} {{/testbench_compute_2/control_lines[3]} -radix hexadecimal} {{/testbench_compute_2/control_lines[2]} -radix hexadecimal} {{/testbench_compute_2/control_lines[1]} -radix hexadecimal} {{/testbench_compute_2/control_lines[0]} -radix hexadecimal}} -subitemconfig {{/testbench_compute_2/control_lines[15]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[14]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[13]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[12]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[11]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[10]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[9]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[8]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[7]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[6]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[5]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[4]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[3]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[2]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[1]} {-color Gold -height 15 -radix hexadecimal} {/testbench_compute_2/control_lines[0]} {-color Gold -height 15 -radix hexadecimal}} /testbench_compute_2/control_lines
add wave -noupdate -label peek -radix hexadecimal /testbench_compute_2/DATAPATH_peek
add wave -noupdate -label load -radix hexadecimal /testbench_compute_2/DATAPATH_load
add wave -noupdate -label {new program counter value} -radix hexadecimal -radixshowbase 0 /testbench_compute_2/uut_decision_unit/new_address
add wave -noupdate -divider ALU
add wave -noupdate -radix unsigned /testbench_compute_2/REG_a_val
add wave -noupdate -radix unsigned /testbench_compute_2/REG_b_val
add wave -noupdate -radix unsigned /testbench_compute_2/REG_c_val
add wave -noupdate -radix unsigned /testbench_compute_2/REG_d_val
add wave -noupdate -color Magenta -format Literal -label ZF {/testbench_compute_2/ALU_flags[7]}
add wave -noupdate -color Magenta -format Literal -label SF {/testbench_compute_2/ALU_flags[6]}
add wave -noupdate -color Magenta -format Literal -label CF {/testbench_compute_2/ALU_flags[5]}
add wave -noupdate -color Magenta -format Literal -label OF {/testbench_compute_2/ALU_flags[4]}
add wave -noupdate /testbench_compute_2/ALU_flags
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {133 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {315 ps}
