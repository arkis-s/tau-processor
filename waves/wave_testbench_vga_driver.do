onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_vga_driver/clock
add wave -noupdate -label hsync /testbench_vga_driver/hsync
add wave -noupdate -label vsync /testbench_vga_driver/vsync
add wave -noupdate -label {in active area} /testbench_vga_driver/in_active_area
add wave -noupdate -label {x coord} -radix unsigned -radixshowbase 0 /testbench_vga_driver/x
add wave -noupdate -label {y coord} -radix unsigned -radixshowbase 0 /testbench_vga_driver/y
add wave -noupdate -label {addr x} -radix unsigned -radixshowbase 0 /testbench_vga_driver/addr_x
add wave -noupdate -label {addr y} -radix unsigned -radixshowbase 0 /testbench_vga_driver/addr_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2978 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
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
WaveRestoreZoom {0 ps} {10500 ps}
