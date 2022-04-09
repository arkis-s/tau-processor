onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_alu/a
add wave -noupdate /testbench_alu/b
add wave -noupdate -radix decimal /testbench_alu/a
add wave -noupdate -radix decimal /testbench_alu/b
add wave -noupdate -radix unsigned /testbench_alu/a
add wave -noupdate -radix unsigned /testbench_alu/b
add wave -noupdate /testbench_alu/mode
add wave -noupdate /testbench_alu/c
add wave -noupdate -radix decimal /testbench_alu/c
add wave -noupdate -radix unsigned /testbench_alu/c
add wave -noupdate -expand /testbench_alu/flags
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ps} 0}
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
WaveRestoreZoom {0 ps} {64 ps}
