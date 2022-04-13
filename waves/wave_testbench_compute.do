onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label {clock a} /testbench_compute/clk_a
add wave -noupdate -label {exec driver enable} /testbench_compute/ED_enable
add wave -noupdate -label {exec driver -> program counter enable} /testbench_compute/ED_PC_enable
add wave -noupdate -label {program counter value} -radix hexadecimal -radixshowbase 0 /testbench_compute/PC_value
add wave -noupdate -label {mem controller -> prog mem r(0)w(1)} /testbench_compute/MC_PRAM_rw
add wave -noupdate -label {mem controller -> prog mem address} /testbench_compute/MC_PRAM_addr
add wave -noupdate -label {mem controller -> prog mem data in} /testbench_compute/MC_PRAM_data
add wave -noupdate -label {mem controller -> vram r(0)w(1)} /testbench_compute/MC_VRAM_rw
add wave -noupdate -label {mem controller -> vram address} /testbench_compute/MC_VRAM_addr
add wave -noupdate -label {mem controller -> vram data in} /testbench_compute/MC_VRAM_data
add wave -noupdate -label {prog mem data out (instruction)} /testbench_compute/PRAM_data_out
add wave -noupdate -label {opcode translation index} /testbench_compute/OPCODE_TRANSLATION_data
add wave -noupdate -label {exec driver -> microcode sequencer load (n)} /testbench_compute/ED_MCS_load
add wave -noupdate -label {exec driver -> microcode sequencer enable} /testbench_compute/ED_MCS_enable
add wave -noupdate -label {microcode sequencer -> microcode rom index} /testbench_compute/MCS_MCR_index
add wave -noupdate -label {exec driver -> microcode rom enable} /testbench_compute/ED_MCR_enable
add wave -noupdate -label {microcode rom control lines} /testbench_compute/MCR_control_lines
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
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
WaveRestoreZoom {0 ps} {431 ps}
