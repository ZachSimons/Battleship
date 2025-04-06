onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_tb/clk
add wave -noupdate /proc_tb/dut/rst_n
add wave -noupdate /proc_tb/dut/decoded_instr_dbg
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/nxt_pc
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_q
add wave -noupdate /proc_tb/dut/proc_fe/instruction_fe
add wave -noupdate /proc_tb/dut/proc_fe/instruction_dec
add wave -noupdate /proc_tb/dut/proc_de/instruction_ex
add wave -noupdate /proc_tb/dut/proc_mem/instruction_mem
add wave -noupdate /proc_tb/dut/proc_mem/instruction_wb
add wave -noupdate /proc_tb/dut/flush
add wave -noupdate /proc_tb/dut/pfstall
add wave -noupdate /proc_tb/dut/stallmem
add wave -noupdate /proc_tb/dut/hazard
add wave -noupdate /proc_tb/dut/proc_de/REGFILE/regfile
add wave -noupdate -divider Memory
add wave -noupdate /proc_tb/dut/proc_mem/mem_unsigned_mem
add wave -noupdate /proc_tb/dut/proc_mem/mem_rd_en_mem
add wave -noupdate /proc_tb/dut/proc_mem/mem_wrt_en_mem
add wave -noupdate /proc_tb/dut/proc_mem/width_mem
add wave -noupdate /proc_tb/dut/proc_mem/reg2_data_mem
add wave -noupdate /proc_tb/dut/proc_mem/alu_mem
add wave -noupdate /proc_tb/dut/proc_mem/wrapper_rd_data
add wave -noupdate -divider Decode
add wave -noupdate /proc_tb/dut/proc_de/read_data1_ex
add wave -noupdate /proc_tb/dut/proc_de/read_data2_ex
add wave -noupdate -divider Execute
add wave -noupdate /proc_tb/dut/aluresult_ex_mem
add wave -noupdate /proc_tb/dut/memwrtdata_ex_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {308859 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
WaveRestoreZoom {239363 ps} {366955 ps}
