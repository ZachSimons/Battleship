module Execute_tb();

    // Testing
    logic err;
    logic clk, rst_n;
    logic [31:0] seed;
    logic [9:0] count;
    // Inputs
    logic [31:0] next_pc_exe, reg1, reg2, imm;
    logic [3:0] bj_inst_exe, alu_op_exe;
    logic [1:0] wb_sel_exe, read_width_exe;
    logic wrt_dst_exe, random_exe, mem_wrt_en_exe, reg_wrt_en_exe, read_unsigned_exe, rd_en_exe, jalr_exe, data_sel_exe;
    // Outputs
    logic [31:0] next_pc_mem, write_data_mem, alu_result_mem, branch_pc;
    logic [1:0] wb_sel_mem, read_width_mem;
    logic wrt_dst_mem, random_mem, mem_wrt_en_mem, reg_wrt_en_mem, read_unsigned_mem, rd_en_mem, branch;
    // Expecteds
    logic [31:0] branch_pc_expected, alu_inB_expected;

    execute iDUT(.clk(clk), .rst_n(rst_n), .next_pc_exe(next_pc_exe), .reg1(reg1), .reg2(reg2), .imm(imm), .bj_inst_exe(bj_inst_exe), .alu_op_exe(alu_op_exe), .wb_sel_exe(wb_sel_exe), .read_width_exe(read_width_exe), .wrt_dst_exe(wrt_dst_exe), .random_exe(random_exe), .mem_wrt_en_exe(mem_wrt_en_exe), .reg_wrt_en_exe(reg_wrt_en_exe), .read_unsigned_exe(read_unsigned_exe), .rd_en_exe(rd_en_exe), .jalr_exe(jalr_exe), .data_sel_exe(data_sel_exe), .next_pc_mem(next_pc_mem), .write_data_mem(write_data_mem), .alu_result_mem(alu_result_mem), .branch_pc(branch_pc), .wb_sel_mem(wb_sel_mem), .read_width_mem(read_width_mem), .wrt_dst_mem(wrt_dst_mem), .random_mem(random_mem), .mem_wrt_en_mem(mem_wrt_en_mem), .reg_wrt_en_mem(reg_wrt_en_mem), .read_unsigned_mem(read_unsigned_mem), .rd_en_mem(rd_en_mem), .branch(branch));

    initial begin
        err = 0;
        count = 0;
        clk = 0;
        @(negedge clk);
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;
        for(integer i = 0; i < 1048576; i += 1) begin
            // Randomize inputs
            next_pc_exe = $random(seed);
            reg1 = $random(seed);
            reg2 = $random(seed);
            imm = $random(seed);
            bj_inst_exe = $random(seed);
            alu_op_exe = $random(seed);
            wb_sel_exe = $random(seed);
            read_width_exe = $random(seed);
            wrt_dst_exe = $random(seed);
            random_exe = $random(seed);
            mem_wrt_en_exe = $random(seed);
            reg_wrt_en_exe = $random(seed);
            read_unsigned_exe = $random(seed);
            rd_en_exe = $random(seed);
            jalr_exe = $random(seed);
            data_sel_exe = $random(seed);
            @(negedge clk);
            if(jalr_exe)
                branch_pc_expected = reg1 + imm;
            else
                branch_pc_expected = next_pc_exe + imm;
            if(data_sel_exe)
                alu_inB_expected = imm;
            else
                alu_inB_expected = reg2;
            // Verify outputs
            if(next_pc_mem !== next_pc_exe) begin
                $display("ERROR: at %d next_pc_exe not flopped correctly exe: %h mem: %h!", i, next_pc_exe, next_pc_mem);
                err = 1;
                count += 1;
            end
            if(write_data_mem !== reg2) begin
                $display("ERROR: at %d write_data not flopped correctly exe: %h mem: %h!", i, reg2, write_data_mem);
                err = 1;
                count += 1;
            end
            // ALU RESULT NOT TESTED, INPUT TESTED INSTEAD
            if(iDUT.alu_inB !== alu_inB_expected) begin
                $display("ERROR: at %d alu_inB calculated incorrectly calculated: %h expected: %h!", i, iDUT.alu_inB, alu_inB_expected);
                err = 1;
                count += 1;
            end
            if(branch_pc !== branch_pc_expected) begin
                $display("ERROR: at %d branch_pc calculated incorrectly calculated: %h expected: %h!", i, branch_pc, branch_pc_expected);
                err = 1;
                count += 1;
            end
            if(wb_sel_mem !== wb_sel_exe) begin
                $display("ERROR: at %d wb_sel not flopped correctly exe: %h mem: %h!", i, wb_sel_exe, wb_sel_mem);
                err = 1;
                count += 1;
            end
            if(read_width_mem !== read_width_exe) begin
                $display("ERROR: at %d read_width not flopped correctly exe: %h mem: %h!", i, read_width_exe, read_width_mem);
                err = 1;
                count += 1;
            end
            if(random_mem !== random_exe) begin
                $display("ERROR: at %d random not flopped correctly exe: %h mem: %h!", i, random_exe, random_mem);
                err = 1;
                count += 1;
            end
            if(mem_wrt_en_mem !== mem_wrt_en_exe) begin
                $display("ERROR: at %d mem_wrt_en not flopped correctly exe: %h mem: %h!", i, mem_wrt_en_exe, mem_wrt_en_mem);
                err = 1;
                count += 1;
            end
            if(reg_wrt_en_mem !== reg_wrt_en_exe) begin
                $display("ERROR: at %d reg_wrt_en not flopped correctly exe: %h mem: %h!", i, reg_wrt_en_exe, reg_wrt_en_mem);
                err = 1;
                count += 1;
            end
            if(read_unsigned_mem !== read_unsigned_exe) begin
                $display("ERROR: at %d read_unsigned not flopped correctly exe: %h mem: %h!", i, read_unsigned_exe, read_unsigned_mem);
                err = 1;
                count += 1;
            end
            if(rd_en_mem !== rd_en_exe) begin
                $display("ERROR: at %d rd_en not flopped correctly exe: %h mem: %h!", i, rd_en_exe, rd_en_mem);
                err = 1;
                count += 1;
            end
            // BRANCH NOT TESTED HERE, SEE BRANCH_CONTROL TESTS
            if(count > 1000) begin
                $display("Too many errors, aborting tests!");
                $stop;
            end
        end

        if(err)
            $display("Not all tests passed, see above for errors!");
        else
            $display("YAHOO!! All tests passed!");
        $stop;
    end

    always #5 clk = ~clk;

endmodule
