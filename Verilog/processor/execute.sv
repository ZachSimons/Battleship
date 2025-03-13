module execute(clk, rst_n, wrt_dst_exe, next_pc_exe, random_exe, mem_wrt_en_exe, reg_wrt_en_exe, wb_sel_exe, read_unsigned_exe, rd_en_exe, read_width_exe, jalr_exe, data_sel_exe, alu_op_exe, bj_inst_exe, reg1, reg2, imm, wrt_dst_mem, next_pc_mem, random_mem, mem_wrt_en_mem, reg_wrt_en_mem, wb_sel_mem, read_unsigned_mem, rd_en_mem, read_width_mem, branch, write_data_mem, alu_result_mem, branch_pc);

    input clk, rst_n;
    input [31:0] next_pc_exe, reg1, reg2, imm;
    input [3:0] bj_inst_exe, alu_op_exe;
    input [1:0] wb_sel_exe, read_width_exe;
    input wrt_dst_exe, random_exe, mem_wrt_en_exe, reg_wrt_en_exe, read_unsigned_exe, rd_en_exe, jalr_exe, data_sel_exe;
    output logic [31:0] next_pc_mem, write_data_mem, alu_result_mem, branch_pc;
    output logic [1:0] wb_sel_mem, read_width_mem;
    output logic wrt_dst_mem, random_mem, mem_wrt_en_mem, reg_wrt_en_mem, read_unsigned_mem, rd_en_mem, branch;

    logic [31:0] alu_inB, branch_base, alu_result_exe;

    assign alu_inB = data_sel ? imm : reg2;
    assign branch_base = jalr ? reg1 : next_pc_exe;
    assign branch_pc = branch_base + imm;

    alu EXE_ALU(.inA(reg1), .inB(alu_inB), .alu_op(alu_op_exe[2:0]), .option_bit(alu_op_exe[3]), .out(alu_result));
    branch_ctrl EXE_BRANCH_CTRL(.bj_inst(bj_inst_exe), .inA(reg1), .inB(reg2), .branch(branch));

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            next_pc_mem <= 0;
            write_data_mem <= 0;
            alu_result_mem <= 0;
            wb_sel_mem <= 0;
            read_width_mem <= 0;
            wrt_dst_mem <= 0;
            random_mem <= 0;
            mem_wrt_en_mem <= 0;
            reg_wrt_en_mem <= 0;
            read_unsigned_mem <= 0;
            rd_en_mem <= 0;
        end else begin
            next_pc_mem <= next_pc_exe;
            write_data_mem <= write_data_exe;
            alu_result_mem <= alu_result_exe;
            wb_sel_mem <= wb_sel_exe;
            read_width_mem <= read_width_exe;
            wrt_dst_mem <= wrt_dst_exe;
            random_mem <= random_exe;
            mem_wrt_en_mem <= mem_wrt_en_exe;
            reg_wrt_en_mem <= reg_wrt_en_exe;
            read_unsigned_mem <= read_unsigned_exe;
            rd_en_mem <= rd_en_exe;
        end
    end

endmodule