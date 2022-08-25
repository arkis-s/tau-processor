onerror {resume}
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[14:12]} mem_c_mode
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[10:8]} datapath_mode
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[14:12]} memory_controller_mode
quietly virtual signal -install /testbench_compute_2 { /testbench_compute_2/control_lines[10:8]} datapath_controller_mode
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_compute_2/clk
add wave -noupdate /testbench_compute_2/HJ_ED_enable
add wave -noupdate -color Gold -radix hexadecimal /testbench_compute_2/PC_value
add wave -noupdate -color Gold -radix hexadecimal /testbench_compute_2/DATAPATH_instruction
add wave -noupdate -color Gold -radix hexadecimal /testbench_compute_2/control_lines
add wave -noupdate -radix hexadecimal /testbench_compute_2/DATAPATH_load
add wave -noupdate /testbench_compute_2/DATAPATH_load_flag
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_a_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_b_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_c_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_d_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_e_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_f_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_g_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/REG_h_val
add wave -noupdate -radix hexadecimal /testbench_compute_2/LOADMUX_REG_g_value
add wave -noupdate -radix hexadecimal /testbench_compute_2/LOADMUX_REG_h_value
add wave -noupdate /testbench_compute_2/LOADMUX_gh_enable
add wave -noupdate /testbench_compute_2/LOADMUX_gh_select
add wave -noupdate /testbench_compute_2/MUX_LOGIC_SIDE_A_select
add wave -noupdate /testbench_compute_2/MUX_LOGIC_SIDE_B_select
add wave -noupdate -label {DATAPATH instruction} -radix hexadecimal /testbench_compute_2/DATAPATH_instruction
add wave -noupdate -label {DATAPATH load} -radix hexadecimal /testbench_compute_2/DATAPATH_load
add wave -noupdate -label {DATAPATH peek} -radix hexadecimal /testbench_compute_2/DATAPATH_peek
add wave -noupdate -radix hexadecimal /testbench_compute_2/memory_controller_mode
add wave -noupdate -radix hexadecimal /testbench_compute_2/datapath_controller_mode
add wave -noupdate -radix hexadecimal /testbench_compute_2/control_lines
add wave -noupdate -expand -group pram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_PRAM_rw
add wave -noupdate -expand -group pram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_PRAM_addr
add wave -noupdate -expand -group pram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_PRAM_data
add wave -noupdate -expand -group vram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_VRAM_a_rw
add wave -noupdate -expand -group vram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_VRAM_addr_a
add wave -noupdate -expand -group vram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/VRAM_data_out_a
add wave -noupdate -expand -group vram -radix hexadecimal -radixshowbase 0 /testbench_compute_2/MC_VRAM_data_in_a
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 315
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
WaveRestoreZoom {0 ps} {315 ps}
