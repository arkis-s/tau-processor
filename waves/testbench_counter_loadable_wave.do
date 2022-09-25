onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_counter_loadable/clk
add wave -noupdate -label enable /testbench_counter_loadable/en
add wave -noupdate -label count /testbench_counter_loadable/count
add wave -noupdate -label load /testbench_counter_loadable/load
add wave -noupdate -label rest /testbench_counter_loadable/rst
add wave -noupdate -label load_value -radix hexadecimal -radixshowbase 0 /testbench_counter_loadable/load_value
add wave -noupdate -label output_val -radix hexadecimal -radixshowbase 0 /testbench_counter_loadable/output_counter_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {69 ps}
