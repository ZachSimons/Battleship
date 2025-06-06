module decode(
    input clk,
    input rst_n,
    input hazard,
    input stall_mem,
    input flush,
    input [31:0] instruction,
    input [31:0] next_pc,
    input [31:0] curr_pc,
    input write_enable,
    input [4:0] write_reg,
    input [31:0] write_data,
    output logic interrupt_branch_alert,
    output logic [31:0] read_data1_ex,
    output logic [31:0] read_data2_ex,
    output logic [31:0] imm_out_ex,
    output logic [31:0] next_pc_ex,
    output logic [31:0] curr_pc_ex,
    output logic [4:0] write_reg_ex,
    output logic [31:0] instruction_ex,
    output logic random_ex,
    output logic ppu_send_ex,
    output logic write_en_ex,
    output logic [1:0] wb_sel_ex,
    output logic unsigned_sel_ex,
    output logic rd_en_ex,
    output logic [1:0] width_ex,
    output logic jalr_ex,
    output logic rti_ex,
    output logic data_sel_ex,
    output logic wrt_en_ex,
    output logic rdi_ex,
    output logic [3:0] alu_op_ex,
    output logic [3:0] bj_inst_ex,
    output logic rsi_ex,
    output logic sac,
    output logic snd_ex,
    output logic uad_ex,
    output logic [4:0] read_register1_ex,
    output logic [4:0] read_register2_ex,
    output logic [4:0] read_register1_if_id,
    output logic [4:0] read_register2_if_id,
    output logic memread_if_id,
    output logic ignore_fwd_ex,
    output logic lui_ex,
    output logic sac_ex
);


logic [31:0] src_data1;
logic [31:0] imm[4:0];
logic [4:0] write_reg_dec; 
logic ppu_send, uad, snd, random, lui, write_en, unsigned_sel, rd_en, jalr, rti, data_sel, wrt_en, rsi, rdi, auipc, imm_sel, fluhaz, ignore_fwd;
logic [1:0] wb_sel, width, type_sel;
logic [3:0] alu_op, bj_inst;
logic [31:0] read_data2, read_data1, imm_out;


//Branching would be inst

//sign extensions
assign imm[0]= {{20{instruction[31]}},instruction[31:20]}; 
assign imm[1]= {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
assign imm[2]= {{21{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8]};
assign imm[3]= instruction[31:12] << 12;
assign imm[4]= {{13{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21]};

//muxs
assign imm_out = imm_sel ? imm[type_sel+1] : imm[0];
assign read_data1 = auipc ? src_data1 : curr_pc;

assign read_register1_if_id = instruction[19:15];
assign read_register2_if_id = instruction[24:20];
assign write_reg_dec = instruction[11:7];

assign fluhaz = hazard | flush;


assign interrupt_branch_alert = (instruction[6:0] == 7'b1100011) || (instruction[6:0] == 7'b1100111) || (instruction[6:0] == 7'b1101111);

assign memread_if_id = ~fluhaz & rd_en;


//pipeline
always_ff @(posedge clk) begin
    if(~rst_n) begin
        read_data1_ex <= 0;
        read_data2_ex <= 0;
        imm_out_ex <= 0;
        next_pc_ex <= 0;
        curr_pc_ex <= 0;
        write_reg_ex <= 0;
        random_ex <= 0;
        write_en_ex <= 0;
        wb_sel_ex <= 0;
        unsigned_sel_ex <= 0;
        rd_en_ex <= 0;
        width_ex <= 0;
        jalr_ex <= 0;
        rti_ex <= 0;
        data_sel_ex <= 0;
        wrt_en_ex <= 0;
        alu_op_ex <= 0;
        bj_inst_ex <= 0;
        rsi_ex <= 0;
        rdi_ex <= 0;
        read_register1_ex <= 0;
        read_register2_ex <= 0;
        ignore_fwd_ex <= 0;
        lui_ex <= 0;
        snd_ex <= 0;
        uad_ex <= 0;
        ppu_send_ex <= 0;
        sac_ex <= 0;
    end
    else if(~stall_mem) begin
        read_data1_ex <= ~fluhaz ? read_data1 : 0;
        read_data2_ex <= ~fluhaz ? read_data2 : 0;
        imm_out_ex <= ~fluhaz ? imm_out : 0;
        next_pc_ex <= ~fluhaz ? next_pc : 0;
        curr_pc_ex <= ~fluhaz ? curr_pc : 0;
        write_reg_ex <= ~fluhaz ? write_reg_dec : 0;
        random_ex <= ~fluhaz ? random : 0;
        write_en_ex <= ~fluhaz ? write_en : 0;
        wb_sel_ex <= ~fluhaz ? wb_sel : 0;
        unsigned_sel_ex <= ~fluhaz ? unsigned_sel : 0;
        rd_en_ex <= ~fluhaz ? rd_en : 0;
        width_ex <= ~fluhaz ? width : 0;
        jalr_ex <= ~fluhaz ? jalr : 0;
        rti_ex <= ~fluhaz ? rti : 0;
        data_sel_ex <= ~fluhaz ? data_sel : 0;
        wrt_en_ex <= ~fluhaz ? wrt_en : 0;
        alu_op_ex <= ~fluhaz ? alu_op : 0;
        bj_inst_ex <= ~fluhaz ? bj_inst : 0;
        rsi_ex <= ~fluhaz ? rsi : 0;
        rdi_ex <= ~fluhaz ? rdi : 0;
        read_register1_ex <= ~fluhaz ? read_register1_if_id  : 0;
        read_register2_ex <= ~fluhaz ? read_register2_if_id  : 0;
        ignore_fwd_ex <= ~fluhaz ? ignore_fwd : 0;
        lui_ex <= ~fluhaz ? lui : 0;
        instruction_ex <= ~fluhaz ? instruction : 32'h00000013;
        snd_ex <= ~fluhaz ? snd : 0;
        uad_ex <= ~fluhaz ? uad : 0;
        ppu_send_ex <= ~fluhaz ? ppu_send : 0;
        sac_ex <= ~fluhaz ? sac : 0; 
    end
end

////// Modules //////

registerfile REGFILE(
    .clk(clk), 
    .rst_n(rst_n), 
    .src_reg1(instruction[19:15]), 
    .src_reg2(instruction[24:20]), 
    .dst_reg(write_reg), 
    .write_reg(write_enable), 
    .dst_data(write_data), 
    .src_data1(src_data1), 
    .src_data2(read_data2)
);

instruction_decoder DECODE(
    .instruction(instruction),
    .random(random),
    .ppu_send(ppu_send),
    .write_en(write_en),
    .wb_sel(wb_sel),
    .unsigned_sel(unsigned_sel),
    .rd_en(rd_en),
    .width(width),
    .jalr(jalr),
    .rti(rti),
    .data_sel(data_sel),
    .wrt_en(wrt_en),
    .alu_op(alu_op),
    .bj_inst(bj_inst),
    .auipc(auipc),
    .imm_sel(imm_sel),
    .type_sel(type_sel),
    .rsi(rsi),
    .sac(sac),
    .snd(snd),
    .uad(uad),
    .rdi(rdi),
    .ignore_fwd(ignore_fwd),
    .lui(lui)
);


endmodule
