onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label instruction /testbench_memory_controller/instruction
add wave -noupdate -label {program counter address} -radix hexadecimal /testbench_memory_controller/pc_addr
add wave -noupdate -label {input address (E, F)} -radix hexadecimal /testbench_memory_controller/input_addr_ef
add wave -noupdate -label {input data (G, H)} -radix hexadecimal /testbench_memory_controller/input_data_gh
add wave -noupdate -divider outputs
add wave -noupdate -expand -group {program ram} -label {program ram read(0)/write(1)} -radix hexadecimal /testbench_memory_controller/p_ram_rw
add wave -noupdate -expand -group {program ram} -label {program ram address in} -radix hexadecimal /testbench_memory_controller/p_ram_addr
add wave -noupdate -expand -group {program ram} -label {program ram data in} -radix hexadecimal /testbench_memory_controller/p_ram_data
add wave -noupdate -expand -group {video ram} -label {video ram read(0)/write(1)} -radix hexadecimal /testbench_memory_controller/v_ram_rw
add wave -noupdate -expand -group {video ram} -label {video ram address in} -radix hexadecimal /testbench_memory_controller/v_ram_addr
add wave -noupdate -expand -group {video ram} -label {video ram data in} -radix hexadecimal /testbench_memory_controller/v_ram_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
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
WaveRestoreZoom {0 ps} {16 ps}
