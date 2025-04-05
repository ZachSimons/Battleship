module execute(
    input                   clk,
    input                   rst_n,
    input           [31:0]  next_pc_exe,
    input           [31:0]  reg1,
    input           [31:0]  reg2,
    input           [31:0]  imm,
    input           [31:0]  instruction_ex,
    input           [3:0]   bj_inst_exe,
    input           [3:0]   alu_op_exe,
    input           [1:0]   wb_sel_exe,
    input           [1:0]   read_width_exe,
    input           [4:0]   wrt_dst_exe,
    input                   random_exe,
    input                   mem_wrt_en_exe,
    input                   reg_wrt_en_exe,
    input                   read_unsigned_exe,
    input                   rd_en_exe,
    input                   jalr_exe,
    input                   data_sel_exe,
    input                   rdi_ex,
    input                   stall_mem,
    input           [1:0]   forward_control1,
    input           [1:0]   forward_control2,
    input           [31:0]  wbdata_wb_ex,
    input                   lui_ex,
    output logic    [31:0]  next_pc_mem,
    output logic    [31:0]  write_data_mem,
    output logic    [31:0]  alu_result_mem,
    output logic    [31:0]  branch_pc,
    output logic    [31:0]  instruction_mem,
    output logic    [1:0]   wb_sel_mem,
    output logic    [1:0]   read_width_mem,
    output logic    [4:0]   wrt_dst_mem,
    output logic            random_mem,
    output logic            mem_wrt_en_mem,
    output logic            reg_wrt_en_mem,
    output logic            read_unsigned_mem,
    output logic            rd_en_mem,
    output logic            branch,
    output logic            rdi_mem
);

    logic [31:0] alu_inB_temp, alu_inB, alu_inA, branch_base, alu_result_exe, alu_output;
    

    assign alu_inB_temp = data_sel_exe ? imm : reg2;
    assign branch_base = jalr_exe ? reg1 : next_pc_exe;
    assign branch_pc = branch_base + imm;

    // Fowarding
    assign alu_inA = (forward_control1 == 2'b01) ? wbdata_wb_ex :
                     (forward_control1 == 2'b10) ? alu_result_mem : reg1;
    assign alu_inB = (forward_control2 == 2'b01) ? wbdata_wb_ex :
                     (forward_control2 == 2'b10) ? alu_result_mem : alu_inB_temp;
    // assign alu_inA = reg1;
    // assign alu_inB = alu_inB_temp;

    assign alu_result_exe = lui_ex ? alu_inB : alu_output;

    alu EXE_ALU(.inA(alu_inA), .inB(alu_inB), .alu_op(alu_op_exe[2:0]), .option_bit(alu_op_exe[3]), .out(alu_output));
    branch_ctrl EXE_BRANCH_CTRL(.bj_inst(bj_inst_exe), .inA(reg1), .inB(reg2), .branch(branch));

    always_ff @(posedge clk) begin
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
            rdi_mem <= 0;
        end else if(~stall_mem) begin
            next_pc_mem <= next_pc_exe;
            write_data_mem <= reg2;
            alu_result_mem <= alu_result_exe;
            wb_sel_mem <= wb_sel_exe;
            read_width_mem <= read_width_exe;
            wrt_dst_mem <= wrt_dst_exe;
            random_mem <= random_exe;
            mem_wrt_en_mem <= mem_wrt_en_exe;
            reg_wrt_en_mem <= reg_wrt_en_exe;
            read_unsigned_mem <= read_unsigned_exe;
            rd_en_mem <= rd_en_exe;
            rdi_mem <= rdi_ex;
            instruction_mem <= instruction_ex;
        end
    end

endmodule