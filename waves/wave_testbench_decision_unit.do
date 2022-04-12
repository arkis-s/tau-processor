onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label instruction /testbench_decision_unit/instruction
add wave -noupdate -label {program counter address} -radix hexadecimal /testbench_decision_unit/pc_addr
add wave -noupdate -label {peek address} -radix hexadecimal /testbench_decision_unit/peek_addr
add wave -noupdate -label {alu flags} /testbench_decision_unit/flags
add wave -noupdate -label {new address} -radix hexadecimal /testbench_decision_unit/new_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {112 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 196
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
WaveRestoreZoom {41 ps} {283 ps}
