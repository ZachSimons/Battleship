module instruction_decoder_tb();


logic [31:0] instruction;
logic random, ppu_send, write_en, unsigned_sel, rd_en, jalr, rti, data_sel, wrt_en, auipc, imm_sel, rsi, sac, snd;
logic [1:0] wb_sel, width, type_sel;
logic [3:0] alu_op, bj_inst;

instruction_decoder DEC (
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
    .snd(snd)
);

task automatic run_test(
        input [31:0] instr,
        input expected_random,
        input expected_ppu_send,
        input expected_write_en,
        input expected_wb_sel,
        input expected_unsigned_sel,
        input expected_rd_en,
        input expected_width,
        input expected_jalr,
        input expected_rti,
        input expected_data_sel,
        input expected_wrt_en,
        input expected_alu_op,
        input expected_bj_inst,
        input expected_auipc,
        input expected_imm_sel,
        input expected_type_sel,
        input expected_rsi,
        input expected_sac,
        input expected_snd
    );
        instruction = instr;
        #10;
        if (random !== expected_random || ppu_send !== expected_ppu_send || write_en !== expected_write_en ||
            wb_sel !== expected_wb_sel || unsigned_sel !== expected_unsigned_sel || rd_en !== expected_rd_en ||
            width !== expected_width || jalr !== expected_jalr || rti !== expected_rti || data_sel !== expected_data_sel ||
            wrt_en !== expected_wrt_en || alu_op !== expected_alu_op || bj_inst !== expected_bj_inst ||
            auipc !== expected_auipc || imm_sel !== expected_imm_sel || type_sel !== expected_type_sel ||
            rsi !== expected_rsi || sac !== expected_sac || snd !== expected_snd) begin
            $display("FAIL: instruction=%b", instr);
        end else begin
            $display("PASS: instruction=%b", instr);
        end
    endtask

always begin
    #5 clk = ~clk;
end

inital begin
    //alu ops
    run_test();
    //alu ops imm
    run_test();
    //store h
    //store w
    //store b
    //Load U
    //Load
    //branch
    //JAL
    //JALR
    //AUIPC
    //LUI
    //RTI
    //RSI
    //UGS
    //AUD
    //SAC
    //RDI
    //LDR
    //SND
    
    $stop;
end

endmodule