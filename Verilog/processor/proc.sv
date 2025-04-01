module proc(
    input clk,
    input rst_n,
    input interrupt_key,
    input interrupt_eth,
    //TODO add processor inputs
    output sac,
    output snd,
    output uad,
);

//TODO for poc
//Instantate all modules
//Connect all modules up
//Determine processor inputs
//Syntheise memory and fetch stages
//Implement stalling for D-mem & I-mem
//Implement hazards for pipeline
//Test with basic instructions
//Implement forwarding (once processor is working)

//////////////NET INSTANTIATION/////////////////////
//Signal naming convention signalname_comingfrom_goingto example: nxtpc_fe_dec
//Module naming convention means the stage of the pipeline a signal is in. 

//Fetch
logic rti_de_fe, rsi_de_fe, branch_ex_fe;
logic [31:0] inst_fe_dec, nxtpc_fe_dec;


//Decode
logic random_dec_ex;
logic [4:0]  wrtreg_dec_ex;
logic [31:0] rd1_dec_ex, rd2_dec_ex, nxtpc_dec_ex, immout_dec_ex;



//Execute
logic [31:0]





//////////////MODULE INSTANTIATION///////////////////
fetch proc_fe(
    .clk(clk),
    .rst_n(rst_n),
    .branch(branch_ex_fe),                    
    .rti(rti_de_fe),              
    .rsi(rsi_de_fe),            
    .interrupt_key(interrupt_key), 
    .interrupt_eth(interrupt_eth),
    .pc_ex(branchpc_ex_fe),       
    .instruction_dec(inst_fe_dec),
    .pc_dec(nxtpc_fe_dec)
);


decode proc_de(
    .clk(clk),
    .rst_n(rst_n),
    .instruction(inst_fe_dec),
    .next_pc(nxtpc_fe_dec),
    .write_enable(), //TODO From wb
    .branch(),       //TODO This controls flushing
    .write_reg(),    //TODO from wb
    .write_data(),   //TODO from wb
    .read_data1_ex(rd1_dec_ex),
    .read_data2_ex(rd2_dec_ex),
    .imm_out_ex(immout_dec_ex),
    .next_pc_ex(nxtpc_dec_ex),
    .write_reg_ex(wrtreg_dec_ex),
    .read_data1_dec(), //TODO to external Devices
    .random_ex(random_dec_ex), 
    .ppu_send(),
    .write_en_ex(),
    .wb_sel_ex(),
    .unsigned_sel_ex(),
    .rd_en_ex(),
    .width_ex(),
    .jalr_ex(),
    .rti_ex(rti_de_fe), //To fetch
    .data_sel_ex(),
    .wrt_en_ex(),
    .rdi_ex(),
    .alu_op_ex(),
    .bj_inst_ex(),
    .auipc(),
    .imm_sel(),
    .type_sel_ex(),
    .rsi_ex(rsi_de_fe), //To fetch
    .sac(),
    .snd(),
    .uad()
);

execute proc_ex(
    .clk(clk),
    .rst_n(rst_n),
    .next_pc_exe(nxtpc_dec_ex),
    .reg1(rd1_dec_ex),
    .reg2(rd2_dec_ex),
    .imm(immout_dec_ex),
    .bj_inst_exe(),
    .alu_op_exe(),
    .wb_sel_exe(),
    .read_width_exe(),
    .wrt_dst_exe(wrtreg_dec_ex),
    .random_exe(random_dec_ex),
    .mem_wrt_en_exe(),
    .reg_wrt_en_exe(),
    .read_unsigned_exe(),
    .rd_en_exe(),
    .jalr_exe(),
    .data_sel_exe(),
    .next_pc_mem(),
    .write_data_mem(),
    .alu_result_mem(),
    .branch_pc(branchpc_ex_fe), 
    .wb_sel_mem(),
    .read_width_mem(),
    .wrt_dst_mem(),
    .random_mem(),
    .mem_wrt_en_mem(),
    .reg_wrt_en_mem(),
    .read_unsigned_mem(),
    .rd_en_mem(),
    .branch(branch_ex_fe)                   
);

memory proc_mem(
    .clk(),
    .rst_n(),
    .mem_unsigned_mem(),
    .mem_rd_en_mem(),
    .mem_wrt_en_mem(),
    .reg_wrt_en_mem(),
    .random_mem(),
    .rdi_mem(),
    .width_mem(),
    .wb_sel_mem(),
    .wrt_reg_mem(),
    .pc_mem(),
    .rdi_data(),      
    .reg2_data_mem(),
    .alu_mem(),
    .reg_wrt_en_wb(),
    .mem_error(),
    .wb_sel_wb(),
    .wrt_reg_wb(),
    .read_data_wb(),
    .pc_wb(),
    .alu_wb()
);


//////////////////////WB STAGE//////////////////////

always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin

    end 
    else begin

    end
end










endmodule