onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_tb/clk
add wave -noupdate /proc_tb/rst_n
add wave -noupdate /proc_tb/interrupt_key
add wave -noupdate /proc_tb/interrupt_eth
add wave -noupdate /proc_tb/accelerator_data
add wave -noupdate /proc_tb/interrupt_source_data
add wave -noupdate /proc_tb/sac
add wave -noupdate /proc_tb/snd
add wave -noupdate /proc_tb/uad
add wave -noupdate /proc_tb/ppu_send
add wave -noupdate /proc_tb/interface_data
add wave -noupdate /proc_tb/test_index
add wave -noupdate /proc_tb/dut/interrupt_key
add wave -noupdate /proc_tb/dut/interrupt_eth
add wave -noupdate /proc_tb/dut/interrupt_source_data
add wave -noupdate /proc_tb/dut/sac
add wave -noupdate /proc_tb/dut/snd
add wave -noupdate /proc_tb/dut/uad
add wave -noupdate /proc_tb/dut/ppu_send
add wave -noupdate /proc_tb/dut/interface_data
add wave -noupdate /proc_tb/dut/interrupt_latch
add wave -noupdate /proc_tb/dut/interrupt
add wave -noupdate /proc_tb/dut/flush
add wave -noupdate /proc_tb/dut/proc_fe/flush
add wave -noupdate /proc_tb/dut/proc_fe/branch
add wave -noupdate /proc_tb/dut/proc_fe/inter_temp
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/branch_mux
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_ex
add wave -noupdate /proc_tb/dut/pfstall
add wave -noupdate /proc_tb/dut/stallmem
add wave -noupdate /proc_tb/dut/hazard
add wave -noupdate /proc_tb/dut/hazard_stall
add wave -noupdate /proc_tb/dut/inst_fe_dec
add wave -noupdate /proc_tb/dut/proc_fe/pc_d
add wave -noupdate -radix decimal /proc_tb/dut/nxtpc_fe_dec
add wave -noupdate -radix decimal /proc_tb/dut/pc_fe_dec
add wave -noupdate /proc_tb/dut/decoded_instr_dbg
add wave -noupdate /proc_tb/dut/proc_ex/alu_inB
add wave -noupdate /proc_tb/dut/proc_ex/alu_inA
add wave -noupdate /proc_tb/dut/wbsel_mem_wb
add wave -noupdate /proc_tb/dut/wbdata_wb_dec
add wave -noupdate /proc_tb/dut/accelerator_data
add wave -noupdate /proc_tb/dut/proc_ex/forward_control1
add wave -noupdate /proc_tb/dut/proc_ex/forward_control2
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/i_reg
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/nxt_pc
add wave -noupdate -expand /proc_tb/dut/proc_de/REGFILE/regfile
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1069199 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 96
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
WaveRestoreZoom {7790430 ps} {8037346 ps}
