module decode(
    input clk,
    input rst_n,
    input [31:0] instruction,
    input [31:0] next_pc,
    input write_enable,
    input branch,
    input [4:0] write_reg,
    input [31:0] write_data,
    output [31:0] read_data1_ex,
    output [31:0] read_data2_ex,
    output [31:0] imm_out_ex,
    output [31:0] next_pc_ex,
    output [4:0] write_reg_ex,
    output [31:0] read_data1_dec,
    output random_ex,
    output ppu_send,
    output write_en_ex,
    output [1:0] wb_sel_ex,
    output unsigned_sel_ex,
    output rd_en_ex,
    output [1:0] width_ex,
    output jalr_ex,
    output rti_ex,
    output data_sel_ex,
    output wrt_en_ex,
    output rdi_ex,
    output [3:0] alu_op_ex,
    output [3:0] bj_inst_ex,
    output rsi_ex,
    output sac,
    output snd,
    output uad,
    output [4:0] read_register1_ex,
    output [4:0] read_register2_ex
);


logic [31:0] src_data1;
logic [31:0] imm[4:0];
logic random, write_en, unsigned_sel, rd_en, jalr, rti, data_sel, wrt_en, rsi, rdi;
logic [1:0] wb_sel, width, type_sel;
logic [3:0] alu_op, bj_inst;
logic [4:0] read_register1, read_register2;

//sign extensions
assign imm[0]= {20{instruction[31]},instruction[31:20]};
assign imm[1]= {20{instruction[31]},instruction[31:25],instruction[11:7]};
assign imm[2]= {21{instruction[31]},instruction[7],instruction[30:27],instruction[11:6]};
assign imm[3]= instruction[31:12] << 12;
assign imm[4]= {13{instruction[31]},instruction[19:12],instruction[20],instruction[30:21]}

//muxs
assign imm_out = imm_sel ? imm[type_sel] : imm[0];
assign read_data1 = auipc ? src_data1 : next_pc;

assign read_data1_dec = read_data1;
assign read_register1 = instruction[19:15];
assign read_register2 = instruction[24:20];

//pipeline
always_ff @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
        read_data1_ex <= 0;
        read_data2_ex <= 0;
        imm_out_ex <= 0;
        next_pc_ex <= 0;
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
    end
    else begin
        read_data1_ex <=read_data1;
        read_data2_ex <= read_data2;
        imm_out_ex <= imm_out;
        next_pc_ex <= next_pc;
        write_reg_ex <= write_reg;
        random_ex <= random;
        write_en_ex <= write_en;
        wb_sel_ex <= wb_sel;
        unsigned_sel_ex <= unsigned_sel;
        rd_en_ex <= rd_en;
        width_ex <= width;
        jalr_ex <= jalr;
        rti_ex <= rti;
        data_sel_ex <= data_sel;
        wrt_en_ex <= wrt_en;
        alu_op_ex <= alu_op;
        bj_inst_ex <= bj_inst;
        rsi_ex <= rsi;
        rdi_ex <= rdi;
        read_register1_ex <= read_register1;
        read_register2_ex <= read_register2;
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
    .rdi(rdi)
);


endmodule