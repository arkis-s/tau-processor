onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label operation /testbench_alu/opcode
add wave -noupdate -color Magenta -format Literal -label {ZERO FLAG} {/testbench_alu/flags[7]}
add wave -noupdate -color Magenta -format Literal -label {SIGN FLAG} {/testbench_alu/flags[6]}
add wave -noupdate -color Magenta -format Literal -label {CARRY FLAG} {/testbench_alu/flags[5]}
add wave -noupdate -color Magenta -format Literal -label {OVERFLOW FLAG} {/testbench_alu/flags[4]}
add wave -noupdate -divider signed
add wave -noupdate -radix decimal /testbench_alu/a
add wave -noupdate -radix decimal /testbench_alu/b
add wave -noupdate -radix decimal /testbench_alu/c
add wave -noupdate -divider unsigned
add wave -noupdate -radix unsigned /testbench_alu/a
add wave -noupdate -radix unsigned /testbench_alu/b
add wave -noupdate -radix unsigned /testbench_alu/c
add wave -noupdate -divider binary
add wave -noupdate /testbench_alu/a
add wave -noupdate /testbench_alu/b
add wave -noupdate /testbench_alu/c
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {111 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {73 ps} {129 ps}
