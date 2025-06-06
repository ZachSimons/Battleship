module execute(
    input                   clk,
    input                   rst_n,
    input           [31:0]  next_pc_exe,
    input           [31:0]  curr_pc_exe,
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
    input           [31:0]  rdi_data,  
    input                   lui_ex,
    input                   acc_data,
    input                   sac_ex,
    output logic    [31:0]  interface_data,
    output logic    [31:0]  next_pc_mem,
    output logic    [31:0]  write_data_mem,
    output logic    [31:0]  alu_result_mem,
    output logic    [31:0]  branch_pc,
    output logic    [31:0]  instruction_mem,
    output logic    [1:0]   wb_sel_mem,
    output logic    [1:0]   read_width_mem,
    output logic    [4:0]   wrt_dst_mem,
    output logic            mem_wrt_en_mem,
    output logic            reg_wrt_en_mem,
    output logic            read_unsigned_mem,
    output logic            rd_en_mem,
    output logic            branch
);

    logic [31:0] alu_inB_temp, alu_inB, alu_inA, branch_base, alu_result_exe, alu_output;
    logic [31:0] baseB, write_data;
    logic [31:0] lfsr, random_mux;
    logic [31:0] immx2;
    logic [31:0] rdi_mux;
    logic [15:0] lfsr16;
    logic [31:0] acc_mux;

    


    //Branching stuff
    assign branch_base = jalr_exe ? alu_inA : curr_pc_exe;
    assign immx2 = jalr_exe ? imm : imm << 1;
    assign branch_pc = branch_base + immx2;

    // Fowarding
    assign alu_inA = (forward_control1 == 2'b01) ? wbdata_wb_ex :
                     (forward_control1 == 2'b10) ? alu_result_mem : reg1;
    assign baseB =   (forward_control2 == 2'b01) ? wbdata_wb_ex :
                     (forward_control2 == 2'b10) ? alu_result_mem : reg2;
    assign write_data = baseB;

    assign alu_inB = data_sel_exe ? imm : baseB;
 
    assign alu_result_exe = lui_ex ? imm : alu_output;

    assign interface_data = alu_inA;

    alu EXE_ALU(.inA(alu_inA), .inB(alu_inB), .alu_op(alu_op_exe[2:0]), .option_bit(alu_op_exe[3]), .out(alu_output));
    branch_ctrl EXE_BRANCH_CTRL(.bj_inst(bj_inst_exe), .inA(alu_inA), .inB(alu_inB), .branch(branch));

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            next_pc_mem <= 0;
            write_data_mem <= 0;
            alu_result_mem <= 0;
            wb_sel_mem <= 0;
            read_width_mem <= 0;
            wrt_dst_mem <= 0;
            mem_wrt_en_mem <= 0;
            reg_wrt_en_mem <= 0;
            read_unsigned_mem <= 0;
            rd_en_mem <= 0;
        end else if(~stall_mem) begin
            next_pc_mem <= next_pc_exe;
            write_data_mem <= write_data;
            alu_result_mem <= acc_mux;
            wb_sel_mem <= wb_sel_exe;
            read_width_mem <= read_width_exe;
            wrt_dst_mem <= wrt_dst_exe;
            mem_wrt_en_mem <= mem_wrt_en_exe;
            reg_wrt_en_mem <= reg_wrt_en_exe;
            read_unsigned_mem <= read_unsigned_exe;
            rd_en_mem <= rd_en_exe;
            instruction_mem <= instruction_ex;
        end
    end

    ////////////Linear Feedback Register/////////////////
    always_ff @(posedge clk) begin
        if(~rst_n) begin
            lfsr16 <= 16'hb8ab;
        end
        else begin //Determine Taps 16, 15, 13, 4
            lfsr16 <= {lfsr16[14:0], (lfsr16[15] ^ lfsr16[14] ^ lfsr16[12] ^ lfsr16[3])};
        end
    end

    assign lfsr = {{5'd16{lfsr16[15]}}, lfsr16};
    
    assign random_mux = random_exe ? lfsr : alu_result_exe;


    ////////////////RDI///////////////////////////////////
    assign rdi_mux = rdi_ex ? rdi_data : random_mux; 


    ////////////////ACCELERATOR DATA///////////////////////////////////
    assign acc_mux = sac_ex ? {{31{1'b0}}, acc_data} : rdi_mux;
    //TODO

    //remove from WB stage (DONE)
    //add mux after rdi and before execute stage (DONE)
    //Assign the correct value for sac (DONE)
    //Remove mux selection from WB (DONE)
    //add sac signal to execute (done)






endmodule