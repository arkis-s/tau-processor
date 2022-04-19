onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_compute_primitive/clk
add wave -noupdate -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/program_counter_value
add wave -noupdate /testbench_compute_primitive/pc_en
add wave -noupdate -expand -group {memory controller et al} -radix unsigned /testbench_compute_primitive/memory_controller_mode
add wave -noupdate -expand -group {memory controller et al} -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/p_ram_address
add wave -noupdate -expand -group {memory controller et al} -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/PRAM_data_out
add wave -noupdate -expand -group datapath -radix unsigned /testbench_compute_primitive/datapath_controller_mode
add wave -noupdate -expand -group datapath -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/DATAPATH_instruction
add wave -noupdate -expand -group datapath -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/DATAPATH_peek
add wave -noupdate -expand -group datapath -radix hexadecimal -radixshowbase 0 /testbench_compute_primitive/DATAPATH_load
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 318
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
WaveRestoreZoom {0 ps} {120 ps}
