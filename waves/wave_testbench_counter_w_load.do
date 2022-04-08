onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_counter_w_load/clock
add wave -noupdate -label enable /testbench_counter_w_load/enable
add wave -noupdate -label load /testbench_counter_w_load/load
add wave -noupdate -label data /testbench_counter_w_load/data
add wave -noupdate -label address /testbench_counter_w_load/address
add wave -noupdate -label address -radix unsigned -radixshowbase 0 /testbench_counter_w_load/address
add wave -noupdate -label data -radix unsigned -radixshowbase 0 /testbench_counter_w_load/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 113
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
WaveRestoreZoom {0 ps} {179 ps}
