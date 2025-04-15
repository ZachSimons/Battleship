onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_tb/dut/rst_n
add wave -noupdate /proc_tb/dut/decoded_instr_dbg
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_next_dec
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_curr_dec
add wave -noupdate /proc_tb/dut/proc_fe/instruction_fe
add wave -noupdate /proc_tb/dut/proc_fe/instruction_dec
add wave -noupdate /proc_tb/dut/proc_de/instruction_ex
add wave -noupdate /proc_tb/dut/proc_mem/instruction_mem
add wave -noupdate /proc_tb/dut/proc_mem/instruction_wb
add wave -noupdate /proc_tb/dut/proc_fe/flushnop
add wave -noupdate /proc_tb/dut/flush
add wave -noupdate /proc_tb/dut/stallmem
add wave -noupdate /proc_tb/dut/hazard
add wave -noupdate -childformat {{{/proc_tb/dut/proc_de/REGFILE/regfile[30]} -radix decimal} {{/proc_tb/dut/proc_de/REGFILE/regfile[3]} -radix decimal} {{/proc_tb/dut/proc_de/REGFILE/regfile[2]} -radix decimal} {{/proc_tb/dut/proc_de/REGFILE/regfile[1]} -radix decimal} {{/proc_tb/dut/proc_de/REGFILE/regfile[0]} -radix decimal}} -expand -subitemconfig {{/proc_tb/dut/proc_de/REGFILE/regfile[30]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/REGFILE/regfile[3]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/REGFILE/regfile[2]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/REGFILE/regfile[1]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/REGFILE/regfile[0]} {-height 17 -radix decimal}} /proc_tb/dut/proc_de/REGFILE/regfile
add wave -noupdate -divider Branching
add wave -noupdate /proc_tb/dut/proc_fe/branch
add wave -noupdate -divider Fetch
add wave -noupdate /proc_tb/dut/proc_fe/flush
add wave -noupdate /proc_tb/dut/proc_fe/stall
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/nxt_pc
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_q
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_d
add wave -noupdate -radix decimal /proc_tb/dut/proc_fe/pc_ex
add wave -noupdate -radix decimal /proc_tb/dut/proc_ex/branch_base
add wave -noupdate -radix decimal /proc_tb/dut/proc_ex/immx2
add wave -noupdate -radix decimal /proc_tb/dut/proc_ex/imm
add wave -noupdate /proc_tb/dut/proc_fe/imem/addr_q
add wave -noupdate /proc_tb/dut/proc_fe/imem/q
add wave -noupdate /proc_tb/dut/proc_fe/imem/read_en
add wave -noupdate /proc_tb/dut/proc_fe/imem/read_en_ff
add wave -noupdate -divider Memory
add wave -noupdate /proc_tb/clk
add wave -noupdate /proc_tb/dut/proc_mem/mem_unsigned_mem
add wave -noupdate /proc_tb/dut/proc_mem/mem_rd_en_mem
add wave -noupdate /proc_tb/dut/proc_mem/mem_wrt_en_mem
add wave -noupdate /proc_tb/dut/proc_mem/width_mem
add wave -noupdate /proc_tb/dut/proc_mem/reg2_data_mem
add wave -noupdate /proc_tb/dut/proc_mem/alu_mem
add wave -noupdate /proc_tb/dut/proc_mem/wrapper_rd_data
add wave -noupdate /proc_tb/dut/proc_mem/mem_error
add wave -noupdate /proc_tb/dut/proc_mem/wrt_reg_wb
add wave -noupdate /proc_tb/dut/proc_mem/read_data_wb
add wave -noupdate /proc_tb/dut/proc_mem/wb_sel_wb
add wave -noupdate /proc_tb/dut/proc_mem/random_mem
add wave -noupdate /proc_tb/dut/proc_mem/rdi_mem
add wave -noupdate /proc_tb/dut/proc_mem/random_mux
add wave -noupdate /proc_tb/dut/proc_mem/rdi_mux
add wave -noupdate /proc_tb/dut/wbsel_mem_wb
add wave -noupdate /proc_tb/dut/wrtreg_wb_dec
add wave -noupdate /proc_tb/dut/wbdata_wb_dec
add wave -noupdate -divider Decode
add wave -noupdate /proc_tb/dut/proc_de/auipc
add wave -noupdate /proc_tb/dut/proc_de/fluhaz
add wave -noupdate /proc_tb/dut/proc_de/read_data1
add wave -noupdate /proc_tb/dut/proc_de/read_data1_ex
add wave -noupdate /proc_tb/dut/proc_de/read_data2_ex
add wave -noupdate /proc_tb/dut/proc_de/imm_out_ex
add wave -noupdate /proc_tb/dut/proc_de/REGFILE/regfile
add wave -noupdate /proc_tb/dut/proc_de/read_register1_ex
add wave -noupdate /proc_tb/dut/proc_de/read_register2_ex
add wave -noupdate /proc_tb/dut/proc_de/read_register1_if_id
add wave -noupdate /proc_tb/dut/proc_de/read_register2_if_id
add wave -noupdate /proc_tb/dut/proc_de/REGFILE/write_reg
add wave -noupdate -radix decimal /proc_tb/dut/proc_de/REGFILE/dst_data
add wave -noupdate -radix decimal -childformat {{{/proc_tb/dut/proc_de/imm[4]} -radix decimal} {{/proc_tb/dut/proc_de/imm[3]} -radix decimal} {{/proc_tb/dut/proc_de/imm[2]} -radix decimal} {{/proc_tb/dut/proc_de/imm[1]} -radix decimal} {{/proc_tb/dut/proc_de/imm[0]} -radix decimal}} -subitemconfig {{/proc_tb/dut/proc_de/imm[4]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/imm[3]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/imm[2]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/imm[1]} {-height 17 -radix decimal} {/proc_tb/dut/proc_de/imm[0]} {-height 17 -radix decimal}} /proc_tb/dut/proc_de/imm
add wave -noupdate -divider Execute
add wave -noupdate /proc_tb/dut/proc_ex/lui_ex
add wave -noupdate /proc_tb/dut/proc_ex/alu_inB
add wave -noupdate /proc_tb/dut/proc_ex/alu_inA
add wave -noupdate /proc_tb/dut/aluresult_ex_mem
add wave -noupdate /proc_tb/dut/memwrtdata_ex_mem
add wave -noupdate /proc_tb/dut/proc_ex/EXE_ALU/inA
add wave -noupdate /proc_tb/dut/proc_ex/EXE_ALU/inB
add wave -noupdate /proc_tb/dut/proc_ex/EXE_ALU/alu_op
add wave -noupdate /proc_tb/dut/proc_ex/EXE_ALU/option_bit
add wave -noupdate /proc_tb/dut/proc_ex/EXE_ALU/out
add wave -noupdate /proc_tb/dut/proc_ex/forward_control1
add wave -noupdate /proc_tb/dut/proc_ex/forward_control2
add wave -noupdate /proc_tb/dut/proc_ex/reg2
add wave -noupdate /proc_tb/dut/proc_ex/wbdata_wb_ex
add wave -noupdate /proc_tb/dut/proc_ex/alu_result_mem
add wave -noupdate /proc_tb/dut/proc_ex/alu_inB_temp
add wave -noupdate /proc_tb/dut/proc_ex/imm
add wave -noupdate /proc_tb/dut/proc_de/REGFILE/dst_reg
add wave -noupdate /proc_tb/dut/proc_ex/EXE_BRANCH_CTRL/inA
add wave -noupdate /proc_tb/dut/proc_ex/EXE_BRANCH_CTRL/inB
add wave -noupdate /proc_tb/dut/proc_ex/EXE_BRANCH_CTRL/branch
add wave -noupdate -radix binary /proc_tb/dut/proc_ex/EXE_BRANCH_CTRL/bj_inst
add wave -noupdate -divider hazard
add wave -noupdate /proc_tb/dut/proc_hazard/memread_id_ex
add wave -noupdate /proc_tb/dut/proc_hazard/hazard
add wave -noupdate /proc_tb/dut/proc_hazard/stall_mem
add wave -noupdate /proc_tb/dut/proc_hazard/post_flush
add wave -noupdate /proc_tb/dut/proc_hazard/stall_mem_latch
add wave -noupdate /proc_tb/dut/proc_hazard/stall_mem_curr
add wave -noupdate /proc_tb/dut/proc_hazard/src_reg1_if_id
add wave -noupdate /proc_tb/dut/proc_hazard/src_reg2_if_id
add wave -noupdate /proc_tb/dut/proc_hazard/dst_reg_id_ex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {152660 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 314
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
WaveRestoreZoom {0 ps} {2357250 ps}
