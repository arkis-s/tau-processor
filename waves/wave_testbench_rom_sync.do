onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_rom_sync/clock
add wave -noupdate /testbench_rom_sync/read_enable
add wave -noupdate /testbench_rom_sync/address
add wave -noupdate /testbench_rom_sync/data
add wave -noupdate -radix hexadecimal /testbench_rom_sync/address
add wave -noupdate -radix hexadecimal /testbench_rom_sync/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {131 ps} 0}
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
WaveRestoreZoom {176 ps} {1349 ps}
