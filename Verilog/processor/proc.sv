module proc(
    input clk,
    input rst_n,
    input interrupt_key,
    input interrupt_eth,
    input [31:0] interrupt_source_data,
    input accelerator_data,
    //TODO add processor inputs
    output sac,
    output snd,
    output uad,
    output ppu_send,
    output [31:0] interface_data
);

//TODO for poc
//Instantate all modules (DONE)
//Connect all modules up (DONE)
//Determine processor inputs (DONE)
//Syntheise memory and fetch stages 
//Implement stalling for D-mem & I-mem 
//Implement hazards for pipeline
//Test with basic instructions
//Implement forwarding (once processor is working)

//////////////NET INSTANTIATION/////////////////////
//Signal naming convention signalname_comingfrom_goingto example: nxtpc_fe_dec
//Module naming convention means the stage of the pipeline a signal is in. 


//Flushing and Stalling
logic flush, stall;

//Fetch
logic rti_de_fe, rsi_de_fe, branch_ex_fe;
logic [31:0] inst_fe_dec, nxtpc_fe_dec;


//Decode
logic random_dec_ex, regwrten_dec_ex, unsigned_dec_ex, memrden_dec_ex, jalr_dec_ex, datasel_dec_ex, 
        memwrten_dec_ex, rdi_dec_ex;
logic [1:0] wbsel_dec_ex, width_dec_ex;
logic [3:0] aluop_dec_ex, bjinst_dec_ex;
logic [4:0] wrtreg_dec_ex;
logic [31:0] rd1_dec_ex, rd2_dec_ex, nxtpc_dec_ex, immout_dec_ex;


//Execute
logic random_ex_mem, memwrten_ex_mem, regwrten_ex_mem, unsigned_ex_mem, memrden_ex_mem, rdi_ex_mem;
logic [1:0] wbsel_ex_mem, width_ex_mem;
logic [4:0] wrtreg_ex_mem;
logic [31:0] nxtpc_ex_mem, aluresult_ex_mem, memwrtdata_ex_mem;

//Memory
logic regwrten_mem_wb;
logic [1:0] wbsel_mem_wb;
logic [4:0] wrtreg_mem_wb;
logic [31:0] readdata_mem_wb, nxtpc_mem_wb, alu_mem_wb;

//Writeback
logic regwrten_wb_dec;
logic [4:0] wrtreg_wb_dec;
logic [31:0] wbdata_wb_dec;

//Forwarding
logic [4:0] rdreg1_dec_ex, rdreg2_dec_ex;
logic [1:0] forward_control1, forward_control2;

//////////////MODULE INSTANTIATION///////////////////
fetch proc_fe(
    .clk(clk),
    .rst_n(rst_n),
    .branch(branch_ex_fe),            //        
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
    .write_enable(regwrten_wb_dec), 
    .branch(),                   //TODO This controls flushing
    .write_reg(wrtreg_wb_dec),   
    .write_data(wbdata_wb_dec),   
    .read_data1_ex(rd1_dec_ex),
    .read_data2_ex(rd2_dec_ex),
    .imm_out_ex(immout_dec_ex),
    .next_pc_ex(nxtpc_dec_ex),
    .write_reg_ex(wrtreg_dec_ex),
    .read_data1_dec(interface_data), //TODO to external Devices
    .random_ex(random_dec_ex), 
    .ppu_send(ppu_send),            //TODO to external Device
    .write_en_ex(regwrten_dec_ex),   
    .wb_sel_ex(wbsel_dec_ex),
    .unsigned_sel_ex(unsigned_dec_ex),
    .rd_en_ex(memrden_dec_ex),
    .width_ex(width_dec_ex),
    .jalr_ex(jalr_dec_ex),
    .rti_ex(rti_de_fe), 
    .data_sel_ex(datasel_dec_ex),
    .wrt_en_ex(memwrten_dec_ex),
    .rdi_ex(rdi_dec_ex),         
    .alu_op_ex(aluop_dec_ex),
    .bj_inst_ex(bjinst_dec_ex),
    .rsi_ex(rsi_de_fe), 
    .sac(sac),            //TODO to external device
    .snd(snd),            //TODO to external device
    .uad(uad),             //TODO to external device
    .read_register1_ex(rdreg1_dec_ex),
    .read_register2_ex(rdreg2_dec_ex)
);

execute proc_ex(
    .clk(clk),
    .rst_n(rst_n),
    .next_pc_exe(nxtpc_dec_ex),
    .reg1(rd1_dec_ex),
    .reg2(rd2_dec_ex),
    .imm(immout_dec_ex),
    .bj_inst_exe(bjinst_dec_ex),
    .alu_op_exe(aluop_dec_ex),
    .wb_sel_exe(wbsel_dec_ex),
    .read_width_exe(width_dec_ex),
    .wrt_dst_exe(wrtreg_dec_ex),
    .random_exe(random_dec_ex),
    .mem_wrt_en_exe(memwrten_dec_ex),
    .reg_wrt_en_exe(regwrten_dec_ex),
    .read_unsigned_exe(unsigned_dec_ex),
    .rd_en_exe(memrden_dec_ex),
    .jalr_exe(jalr_dec_ex),
    .data_sel_exe(datasel_dec_ex),
    .rdi_ex(rdi_dec_ex),
    .forward_control1(forward_control1),
    .forward_control2(forward_control2),
    .wbdata_wb_ex(wbdata_wb_dec),
    .next_pc_mem(nxtpc_ex_mem),
    .write_data_mem(memwrtdata_ex_mem),
    .alu_result_mem(aluresult_ex_mem),
    .branch_pc(branchpc_ex_fe), 
    .wb_sel_mem(wbsel_ex_mem),
    .read_width_mem(width_ex_mem),
    .wrt_dst_mem(wrtreg_ex_mem),
    .random_mem(random_ex_mem),
    .mem_wrt_en_mem(memwrten_ex_mem),
    .reg_wrt_en_mem(regwrten_ex_mem),
    .read_unsigned_mem(unsigned_ex_mem),
    .rd_en_mem(memrden_ex_mem),
    .branch(branch_ex_fe)  ,
    .rdi_mem(rdi_ex_mem)                 
);

memory proc_mem(
    .clk(clk),
    .rst_n(rst_n),
    .mem_unsigned_mem(unsigned_ex_mem),
    .mem_rd_en_mem(memrden_ex_mem),
    .mem_wrt_en_mem(memwrten_ex_mem),
    .reg_wrt_en_mem(regwrten_ex_mem),
    .random_mem(random_ex_mem),
    .rdi_mem(rdi_ex_mem),
    .width_mem(width_ex_mem),
    .wb_sel_mem(wbsel_ex_mem),
    .wrt_reg_mem(wrtreg_ex_mem),
    .pc_mem(nxtpc_ex_mem),
    .rdi_data(interrupt_source_data),   //TODO from external device
    .reg2_data_mem(memwrtdata_ex_mem),
    .alu_mem(aluresult_ex_mem),
    .reg_wrt_en_wb(regwrten_mem_wb),
    .mem_error(/* don't nessesarly need*/),
    .wb_sel_wb(wbsel_mem_wb),
    .wrt_reg_wb(wrtreg_mem_wb),
    .read_data_wb(readdata_mem_wb),
    .pc_wb(nxtpc_mem_wb),
    .alu_wb(alu_mem_wb)
);


forwarding proc_forward(
    .mem_wb_reg_write(regwrten_mem_wb),
    .ex_mem_reg_write(regwrten_ex_mem),
    .id_ex_reg_reg1(rdreg1_dec_ex),
    .id_ex_reg_reg2(rdreg2_dec_ex),
    .mem_wb_reg(wrtreg_mem_wb),
    .ex_mem_reg(wrtreg_ex_mem),
    .forward_control1(forward_control1),
    .forward_control2(forward_control2)
);

//////////////////////WB STAGE//////////////////////


always_comb begin
    case(wbsel_mem_wb) 
        2'b00: wbdata_wb_dec = {{31{1'b0}}, accelerator_data}; //TODO accelerator
        2'b01: wbdata_wb_dec = nxtpc_mem_wb;
        2'b10: wbdata_wb_dec = readdata_mem_wb;
        2'b11: wbdata_wb_dec = alu_mem_wb; 
    endcase 
end

assign regwrten_wb_dec = regwrten_mem_wb;
assign wrtreg_wb_dec = wrtreg_mem_wb;

///////////////Flushing and Stalling Logic///////////

assign flush = //TODO flushing logic
assign stall = //TODO stalling logic 






endmodule