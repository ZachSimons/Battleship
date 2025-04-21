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
//Syntheise memory and fetch stages (DONE)
//Implement stalling for D-mem & I-mem (DONE)
//Implement hazards for pipeline (DONE)
//Test with basic instructions (DONE)
//Implement forwarding (once processor is working) (DONE)

//TESTING PROCESSOR!!!!

//////////////NET INSTANTIATION/////////////////////
//Signal naming convention signalname_comingfrom_goingto example: nxtpc_fe_dec
//Module naming convention means the stage of the pipeline a signal is in. 

//Testing Signals
logic memerror; 


//Interrupt
logic interrupt_latch, interrupt, stall_interrupt;
logic pending_interrupt, memrden_if, interrupt_data_set;
logic [31:0] interrupt_data;

//Flushing, stalling, and hazards
logic flush, pfstall, stallmem, hazard, hazard_stall, stallpc;
logic [4:0] rdreg1_if_id, rdreg2_if_id;

//Fetch
logic stall_override, rti_de_fe, rsi_de_fe, branch_ex_fe, memrden_if_dec;
logic [31:0] inst_fe_dec, nxtpc_fe_dec, pc_fe_dec;



//Decode
logic random_dec_ex, regwrten_dec_ex, unsigned_dec_ex, memrden_dec_ex, jalr_dec_ex, datasel_dec_ex, 
        memwrten_dec_ex, lui_ex, rdi_dec_ex, ignore_fwd_ex, interrupt_branch_alert_de_fe, sac_id_ex;

logic [1:0] wbsel_dec_ex, width_dec_ex;
logic [3:0] aluop_dec_ex, bjinst_dec_ex;
logic [4:0] wrtreg_dec_ex;
logic [31:0] rd1_dec_ex, rd2_dec_ex, nxtpc_dec_ex, immout_dec_ex, instruction_dec_ex, currpc_dec_ex;


//Execute
logic memwrten_ex_mem, regwrten_ex_mem, unsigned_ex_mem, memrden_ex_mem, rdi_ex_mem;
logic [1:0] wbsel_ex_mem, width_ex_mem;
logic [4:0] wrtreg_ex_mem;
logic [31:0] nxtpc_ex_mem, aluresult_ex_mem, memwrtdata_ex_mem, branchpc_ex_fe, instruction_ex_mem;

//Memory
logic regwrten_mem_wb;
logic [1:0] wbsel_mem_wb;
logic [4:0] wrtreg_mem_wb;
logic [31:0] readdata_mem_wb, nxtpc_mem_wb, alu_mem_wb, instruction_mem_wb;

//Writeback
logic regwrten_wb_dec, halt_wb_fe;
logic [4:0] wrtreg_wb_dec;
logic [31:0] wbdata_wb_dec;


//Forwarding
logic [4:0] rdreg1_dec_ex, rdreg2_dec_ex;
logic [1:0] forward_control1, forward_control2;

//////////////MODULE INSTANTIATION///////////////////
fetch proc_fe( 
    .clk(clk),
    .rst_n(rst_n),
    .branch(branch_ex_fe),                    
    .rti(rti_de_fe),              
    .rsi(rsi_de_fe),            
    .interrupt(interrupt), 
    .interrupt_branch_alert(interrupt_branch_alert_de_fe),
    .flush(flush),
    .stall_override(stall_override),
    .stall_mem(hazard | stallmem),
    .stall_pc(stallpc | hazard),
    .hazard(hazard),
    .halt(halt_wb_fe),
    .pc_ex(branchpc_ex_fe),       
    .instruction_dec(inst_fe_dec),
    .pc_next_dec(nxtpc_fe_dec),
    .pc_curr_dec(pc_fe_dec),
    .memrden_if(memrden_if)
);


decode proc_de(
    .clk(clk),
    .rst_n(rst_n),
    .instruction(inst_fe_dec),
    .next_pc(nxtpc_fe_dec),
    .curr_pc(pc_fe_dec),
    .write_enable(regwrten_wb_dec), 
    .flush(flush), //TODO This controls flushing
    .hazard(hazard),
    .interrupt_branch_alert(interrupt_branch_alert_de_fe),
    .stall_mem(stallmem),           
    .write_reg(wrtreg_wb_dec),   
    .write_data(wbdata_wb_dec),   
    .read_data1_ex(rd1_dec_ex),
    .read_data2_ex(rd2_dec_ex),
    .imm_out_ex(immout_dec_ex),
    .next_pc_ex(nxtpc_dec_ex),
    .curr_pc_ex(currpc_dec_ex),
    .write_reg_ex(wrtreg_dec_ex),
    .instruction_ex(instruction_dec_ex),              
    .random_ex(random_dec_ex), 
    .ppu_send_ex(ppu_send),            
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
    .snd_ex(snd),            
    .uad_ex(uad),             
    .read_register1_ex(rdreg1_dec_ex),
    .read_register2_ex(rdreg2_dec_ex),
    .read_register1_if_id(rdreg1_if_id),
    .read_register2_if_id(rdreg2_if_id),
    .memread_if_id(memrden_if_dec),
    .ignore_fwd_ex(ignore_fwd_ex),
    .lui_ex(lui_ex),
    .sac_ex(sac_id_ex) 
);

execute proc_ex(
    .clk(clk),
    .rst_n(rst_n),
    .next_pc_exe(nxtpc_dec_ex),
    .curr_pc_exe(currpc_dec_ex),
    .reg1(rd1_dec_ex),
    .reg2(rd2_dec_ex),
    .lui_ex(lui_ex),
    .acc_data(accelerator_data),
    .sac_ex(sac_id_ex),
    .imm(immout_dec_ex),
    .instruction_ex(instruction_dec_ex),
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
    .rdi_data(interrupt_data),   //TODO from external device
    .stall_mem(stallmem),
    .forward_control1(forward_control1),
    .forward_control2(forward_control2),
    .wbdata_wb_ex(wbdata_wb_dec),
    .next_pc_mem(nxtpc_ex_mem),
    .interface_data(interface_data),
    .write_data_mem(memwrtdata_ex_mem),
    .alu_result_mem(aluresult_ex_mem),
    .branch_pc(branchpc_ex_fe), 
    .instruction_mem(instruction_ex_mem),
    .wb_sel_mem(wbsel_ex_mem),
    .read_width_mem(width_ex_mem),
    .wrt_dst_mem(wrtreg_ex_mem),
    .mem_wrt_en_mem(memwrten_ex_mem),
    .reg_wrt_en_mem(regwrten_ex_mem),
    .read_unsigned_mem(unsigned_ex_mem),
    .rd_en_mem(memrden_ex_mem),
    .branch(branch_ex_fe)         
);

memory proc_mem(
    .clk(clk),
    .rst_n(rst_n),
    .mem_unsigned_mem(unsigned_ex_mem),
    .mem_rd_en_mem(memrden_ex_mem),
    .mem_wrt_en_mem(memwrten_ex_mem),
    .reg_wrt_en_mem(regwrten_ex_mem),
    .stallmem(stallmem),
    .width_mem(width_ex_mem),
    .wb_sel_mem(wbsel_ex_mem),
    .wrt_reg_mem(wrtreg_ex_mem),
    .pc_mem(nxtpc_ex_mem),
    .reg2_data_mem(memwrtdata_ex_mem),
    .alu_mem(aluresult_ex_mem),
    .instruction_mem(instruction_ex_mem),
    .reg_wrt_en_wb(regwrten_mem_wb),
    .mem_error(memerror),
    .wb_sel_wb(wbsel_mem_wb),
    .wrt_reg_wb(wrtreg_mem_wb),
    .read_data_wb(readdata_mem_wb),
    .pc_wb(nxtpc_mem_wb),
    .alu_wb(alu_mem_wb),
    .instruction_wb(instruction_mem_wb)
);


forwarding proc_forward(
    .mem_wb_reg_write(regwrten_mem_wb),
    .ex_mem_reg_write(regwrten_ex_mem),
    .ignore_fwd_ex(ignore_fwd_ex),
    .id_ex_reg_reg1(rdreg1_dec_ex),
    .id_ex_reg_reg2(rdreg2_dec_ex),
    .mem_wb_reg(wrtreg_mem_wb),
    .ex_mem_reg(wrtreg_ex_mem),
    .instruction_ex(instruction_dec_ex),
    .forward_control1(forward_control1),
    .forward_control2(forward_control2)
);


hazard proc_hazard(
    .clk(clk),
    .rst_n(rst_n),
    .memread_if_id(memrden_if_dec),
    .memread_id_ex(memrden_dec_ex),
    .memread_ex_mem(memrden_ex_mem),
    .memwrite_ex_mem(memwrten_ex_mem),
    .src_reg1_if_id(rdreg1_if_id),
    .src_reg2_if_id(rdreg2_if_id),
    .dst_reg_id_ex(wrtreg_dec_ex),
    .hazard(hazard),
    .stall_pc(stallpc),
    .stall_mem(hazard_stall)
);



//////////////////////WB STAGE//////////////////////
always_comb begin
    case(wbsel_mem_wb) 
        2'b00: wbdata_wb_dec = '0;
        2'b01: wbdata_wb_dec = nxtpc_mem_wb;
        2'b10: wbdata_wb_dec = readdata_mem_wb;
        2'b11: wbdata_wb_dec = alu_mem_wb; 
    endcase 
end

assign regwrten_wb_dec = regwrten_mem_wb;
assign wrtreg_wb_dec = wrtreg_mem_wb;

always_ff @(posedge clk) begin
    if (!rst_n) begin
        halt_wb_fe <= 0;
    end
    else begin
        halt_wb_fe <= (instruction_mem_wb == 32'h00000073) ? 1 : halt_wb_fe;
    end
end

///////////////////Flushing/Stalling logic/////////////////////
always_ff @(posedge clk) begin
    pfstall <= flush; //After a flush a stall must happen to wait for I-mem
end

//TODO fix later
//rst_n warmup 


assign flush = branch_ex_fe /*| interrupt */| rti_de_fe | rsi_de_fe;
assign stallmem = (hazard_stall && (~stall_override)); //To handle both Pc changing and 



////////////////Interrupt Logic///////////////////////

//TODO may need to debounce rti and rsi depending on if they are sync to the cpu pipeline
//TODO debounce may need sync interrupt to the CPU pipeline
//While interrupt being handled another interrupt must not be able to 

assign stall_interrupt = memrden_if || memrden_if_dec || memrden_dec_ex || memrden_ex_mem;

//assign interrupt = stall_interrupt ? 0 : (interrupt_key | interrupt_eth) & ~interrupt_latch;

always_ff @(posedge clk) begin
    if(!rst_n) begin
        interrupt <= 1'b0;
        interrupt_data <= '0;
        pending_interrupt <= 0;
        interrupt_data_set <= 1'b0;
    end
    else if (~stall_interrupt)begin
        interrupt <= ((interrupt_key | interrupt_eth) & ~interrupt_latch) | pending_interrupt;
        interrupt_data <= (((interrupt_key | interrupt_eth) & ~interrupt_latch) | pending_interrupt) ? interrupt_source_data : interrupt_data;
        pending_interrupt <= 1'b0;
        interrupt_data_set <= 1'b0;
    end
    else begin
        interrupt <= 1'b0;
        pending_interrupt <= pending_interrupt ? 1'b1 : ((interrupt_key | interrupt_eth) & ~interrupt_latch);
        if (~interrupt_data_set) begin
            interrupt_data <= interrupt_source_data;
            interrupt_data_set <= 1'b1;                 // might need a conditional to set this
        end
        else begin
            interrupt_data <= interrupt_data;
            interrupt_data_set <= interrupt_data_set;
        end
    end
end


always_ff @(posedge clk) begin
    if(!rst_n) begin
        interrupt_latch <= 0;
    end
    else if(rti_de_fe | rsi_de_fe) begin
        interrupt_latch <= 0;
    end
    else if(interrupt) begin
        interrupt_latch <= 1;
    end
end


//Output data
assign sac = sac_id_ex;


//`ifdef SIMULATION  // Only included during simulation

typedef enum logic [7:0] {
    INVALID,
    LUI,
    AUIPC,
    JAL,
    JALR,
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU,
    LB,
    LH,
    LW,
    LBU,
    LHU,
    SB,
    SH,
    SW,
    ADDI,
    SLTI,
    SLTIU,
    XORI,
    ORI,
    ANDI,
    SLLI,
    SRLI,
    SRAI,
    ADD,
    SUB,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    SRA,
    OR,
    AND,
    RTI,
    RSI,
    RDI,
    SND,
    UGS,
    SAC,
    LDR,
    UAD, 
    NOP
} instr_t;

instr_t decoded_instr_dbg;

always_comb begin
    unique case (inst_fe_dec[6:0])  // opcode
        7'b0110111: decoded_instr_dbg = LUI;
        7'b0010111: decoded_instr_dbg = AUIPC;
        7'b1101111: decoded_instr_dbg = JAL;
        7'b1100111: decoded_instr_dbg = JALR;
        7'b1100011: begin
            case (inst_fe_dec[14:12])
                3'b000: decoded_instr_dbg = BEQ;
                3'b001: decoded_instr_dbg = BNE;
                3'b100: decoded_instr_dbg = BLT;
                3'b101: decoded_instr_dbg = BGE;
                3'b110: decoded_instr_dbg = BLTU;
                3'b111: decoded_instr_dbg = BGEU;
                default: decoded_instr_dbg = INVALID;
            endcase
        end
        7'b0000011: begin
            case (inst_fe_dec[14:12])
                3'b000: decoded_instr_dbg = LB;
                3'b001: decoded_instr_dbg = LH;
                3'b010: decoded_instr_dbg = LW;
                3'b100: decoded_instr_dbg = LBU;
                3'b101: decoded_instr_dbg = LHU;
                default: decoded_instr_dbg = INVALID;
            endcase
        end
        7'b0100011: begin
            case (inst_fe_dec[14:12])
                3'b000: decoded_instr_dbg = SB;
                3'b001: decoded_instr_dbg = SH;
                3'b010: decoded_instr_dbg = SW;
                default: decoded_instr_dbg = INVALID;
            endcase
        end
        7'b0010011: begin
            case (inst_fe_dec[14:12])
                3'b000: decoded_instr_dbg = (inst_fe_dec == 32'h00000013) ? NOP : ADDI;
                3'b010: decoded_instr_dbg = SLTI;
                3'b011: decoded_instr_dbg = SLTIU;
                3'b100: decoded_instr_dbg = XORI;
                3'b110: decoded_instr_dbg = ORI;
                3'b111: decoded_instr_dbg = ANDI;
                3'b001: decoded_instr_dbg = SLLI;
                3'b101: decoded_instr_dbg = (inst_fe_dec[31:25] == 7'b0000000) ? SRLI :
                                            (inst_fe_dec[31:25] == 7'b0100000) ? SRAI :
                                            INVALID;
                default: decoded_instr_dbg = INVALID;
            endcase
        end
        7'b0110011: begin
            case ({inst_fe_dec[31:25], inst_fe_dec[14:12]})
                {7'b0000000, 3'b000}: decoded_instr_dbg = ADD;
                {7'b0100000, 3'b000}: decoded_instr_dbg = SUB;
                {7'b0000000, 3'b001}: decoded_instr_dbg = SLL;
                {7'b0000000, 3'b010}: decoded_instr_dbg = SLT;
                {7'b0000000, 3'b011}: decoded_instr_dbg = SLTU;
                {7'b0000000, 3'b100}: decoded_instr_dbg = XOR;
                {7'b0000000, 3'b101}: decoded_instr_dbg = SRL;
                {7'b0100000, 3'b101}: decoded_instr_dbg = SRA;
                {7'b0000000, 3'b110}: decoded_instr_dbg = OR;
                {7'b0000000, 3'b111}: decoded_instr_dbg = AND;
                default: decoded_instr_dbg = INVALID;
            endcase
        end
        // Custom opcodes
        7'b0001000: decoded_instr_dbg = RTI;
        7'b0001001: decoded_instr_dbg = RSI;
        7'b0001010: decoded_instr_dbg = RDI;
        7'b0001011: decoded_instr_dbg = SND;
        7'b0101000: decoded_instr_dbg = UGS;
        7'b0101001: decoded_instr_dbg = SAC;
        7'b0101010: decoded_instr_dbg = LDR;
        7'b0101011: decoded_instr_dbg = UAD;
        default: decoded_instr_dbg = INVALID;
    endcase
end

//`endif  // SIMULATION





endmodule