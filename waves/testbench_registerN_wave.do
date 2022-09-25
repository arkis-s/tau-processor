onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_registerN/clk
add wave -noupdate -label {input bus} -radix hexadecimal /testbench_registerN/input_bus
add wave -noupdate -label {output bus} -radix hexadecimal /testbench_registerN/output_bus
add wave -noupdate -label {register value} -radix hexadecimal /testbench_registerN/uut_reg/register_val
add wave -noupdate -label enable /testbench_registerN/en
add wave -noupdate -label read /testbench_registerN/r
add wave -noupdate -label write /testbench_registerN/w
add wave -noupdate -label reset /testbench_registerN/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 256
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
WaveRestoreZoom {0 ps} {100 ps}
