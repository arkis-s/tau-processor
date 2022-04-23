onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_vga_driver_generator/clock
add wave -noupdate -label hsync /testbench_vga_driver_generator/hsync
add wave -noupdate -label vsync /testbench_vga_driver_generator/vsync
add wave -noupdate -label x -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/x
add wave -noupdate -label y -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/y
add wave -noupdate -label {addr x} -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/addr_x
add wave -noupdate -label {addr y} -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/addr_y
add wave -noupdate -label {in active area} /testbench_vga_driver_generator/in_active_area
add wave -noupdate -label {vram address} -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/vram_addr
add wave -noupdate -color Gold -label {vram data} -radix hexadecimal -radixshowbase 0 /testbench_vga_driver_generator/vram_data
add wave -noupdate -label {vram buffer} -radix hexadecimal /testbench_vga_driver_generator/uut_vram_interface/vram_buffer
add wave -noupdate -color Gold -label {pixel data} -radix hexadecimal -radixshowbase 0 /testbench_vga_driver_generator/pixel
add wave -noupdate -label {interface state} -radix unsigned -radixshowbase 0 /testbench_vga_driver_generator/uut_vram_interface/state
add wave -noupdate -label {vga addr} -radix unsigned /testbench_vga_driver_generator/uut_vram_interface/current_vga_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {95 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 271
configure wave -valuecolwidth 93
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
WaveRestoreZoom {0 ps} {145 ps}
