onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clock /testbench_compute_2/clk
add wave -noupdate -label {program counter} -radix hexadecimal /testbench_compute_2/PC_value
add wave -noupdate -label instruction -radix hexadecimal -radixshowbase 0 /testbench_compute_2/DATAPATH_instruction
add wave -noupdate -label {register A} -radix hexadecimal /testbench_compute_2/REG_a_val
add wave -noupdate -format Literal -label {ZERO FLAG} {/testbench_compute_2/ALU_flags[7]}
add wave -noupdate -format Literal -label {SIGN FLAG} {/testbench_compute_2/ALU_flags[6]}
add wave -noupdate -format Literal -label {CARRY FLAG} {/testbench_compute_2/ALU_flags[5]}
add wave -noupdate -format Literal -label {OVERFLOW FLAG} {/testbench_compute_2/ALU_flags[4]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 156
configure wave -valuecolwidth 38
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
WaveRestoreZoom {0 ps} {168 ps}
