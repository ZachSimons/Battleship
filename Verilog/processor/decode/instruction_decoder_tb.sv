module instruction_decoder_tb();

logic clk, rst_n;
logic [31:0] instruction;
logic random, ppu_send, write_en, unsigned_sel, rd_en, jalr, rti, data_sel, wrt_en, auipc, imm_sel, rsi, sac, snd, uad, rdi;
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
    .snd(snd),
    .uad(uad),
    .rdi(rdi)
);

task automatic run_test(
        input [31:0] instr,
        input logic unsigned expected_random,
        input logic unsigned expected_ppu_send,
        input logic unsigned expected_write_en,
        input logic unsigned [1:0] expected_wb_sel,
        input logic unsigned expected_unsigned_sel,
        input logic unsigned expected_rd_en,
        input logic unsigned [1:0] expected_width,
        input logic unsigned expected_jalr,
        input logic unsigned expected_rti,
        input logic unsigned expected_data_sel,
        input logic unsigned expected_wrt_en,
        input logic unsigned [3:0] expected_alu_op,
        input logic unsigned [3:0] expected_bj_inst,
        input logic unsigned expected_auipc,
        input logic unsigned expected_imm_sel,
        input logic unsigned [1:0] expected_type_sel,
        input logic unsigned expected_rsi,
        input logic unsigned expected_sac,
        input logic unsigned expected_snd,
        input logic unsigned expected_uad,
        input logic unsigned expected_rdi
    );
        instruction = instr;
        @(posedge clk);
        @(posedge clk); // Ensure at least one full clock cycle for propagation

        if ($unsigned(random) != expected_random || 
            $unsigned(ppu_send) != expected_ppu_send || 
            $unsigned(write_en) != expected_write_en ||
            $unsigned(wb_sel) != expected_wb_sel || 
            $unsigned(unsigned_sel) != expected_unsigned_sel || 
            $unsigned(rd_en) != expected_rd_en ||
            $unsigned(width) != expected_width || 
            $unsigned(jalr) != expected_jalr || 
            $unsigned(rti) != expected_rti || 
            $unsigned(data_sel) != expected_data_sel ||
            $unsigned(wrt_en) != expected_wrt_en || 
            $unsigned(alu_op) != expected_alu_op || 
            $unsigned(bj_inst) != expected_bj_inst ||
            $unsigned(auipc) != expected_auipc || 
            $unsigned(imm_sel) != expected_imm_sel || 
            $unsigned(type_sel) != expected_type_sel ||
            $unsigned(rsi) != expected_rsi || 
            $unsigned(sac) != expected_sac || 
            $unsigned(snd) != expected_snd ||
            $unsigned(rdi) != expected_rdi ||
            $unsigned(uad) != expected_uad) begin

            $display("FAIL: instruction=%b", instr);
            $display("Expected: random=%b, ppu_send=%b, write_en=%b, wb_sel=%b, unsigned_sel=%b, rd_en=%b, width=%b, jalr=%b, rti=%b, data_sel=%b, wrt_en=%b, alu_op=%b, bj_inst=%b, auipc=%b, imm_sel=%b, type_sel=%b, rsi=%b, sac=%b, snd=%b", 
                expected_random, expected_ppu_send, expected_write_en, expected_wb_sel, expected_unsigned_sel, expected_rd_en, 
                expected_width, expected_jalr, expected_rti, expected_data_sel, expected_wrt_en, expected_alu_op, expected_bj_inst, 
                expected_auipc, expected_imm_sel, expected_type_sel, expected_rsi, expected_sac, expected_snd, expected_uad, expected_rdi);
            
            $display("Actual:   random=%b, ppu_send=%b, write_en=%b, wb_sel=%b, unsigned_sel=%b, rd_en=%b, width=%b, jalr=%b, rti=%b, data_sel=%b, wrt_en=%b, alu_op=%b, bj_inst=%b, auipc=%b, imm_sel=%b, type_sel=%b, rsi=%b, sac=%b, snd=%b", 
                random, ppu_send, write_en, wb_sel, unsigned_sel, rd_en, 
                width, jalr, rti, data_sel, wrt_en, alu_op, bj_inst, 
                auipc, imm_sel, type_sel, rsi, sac, snd, uad, rdi);
        end else begin
            $display("PASS: instruction=%b", instr);
        end
    endtask

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    rst_n = 0;
    instruction = 0;
    @(posedge clk);
    rst_n = 1;
    @(posedge clk);
    //alu ops
    run_test(32'b00000000000100010000000110110011, 1'b0, 1'b0, 1'b1, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //alu ops imm
    run_test(32'b00000000000100010000000110010011, 1'b0, 1'b0, 1'b1, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //store h
    run_test(32'b00000000000100010001000110100011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0001, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //store w
    run_test(32'b00000000000100010010000110100011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0010, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //store b
    run_test(32'b00000000000100010000000110100011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b1, 1'b1, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //Load U
    run_test(32'b00000000000100010100000110000011, 1'b0, 1'b0, 1'b1, 2'b10, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0100, 4'b0000, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //Load
    run_test(32'b00000000000100010000000110000011, 1'b0, 1'b0, 1'b1, 2'b10, 1'b1, 1'b1, 2'b01, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //branch
    run_test(32'b00000000000100010000000111100011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000, 4'b1000, 1'b1, 1'b1, 2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //JAL
    run_test(32'b00000000000100010000000111101111, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b1011, 1'b1, 1'b1, 2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //JALR
    run_test(32'b00000000000100010000000111100111, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 1'b0, 2'b00, 1'b1, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b1011, 1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //AUIPC
    run_test(32'b00000000000100010000000110010111, 1'b0, 1'b0, 1'b1, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b0, 1'b1, 2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //LUI
    run_test(32'b00000000000100010000000110110111, 1'b0, 1'b0, 1'b1, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //RTI
    run_test(32'b00000000000100010000000110001000, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //RSI
    run_test(32'b00000000000100010000000110001001, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b0, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
    //UGS
    run_test(32'b00000000000100010000000110101000, 1'b0, 1'b1, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //AUD
    run_test(32'b00000000000100010000000110101011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
    //SAC
    run_test(32'b00000000000100010000000110101001, 1'b0, 1'b0, 1'b1, 2'b00, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    //RDI
    run_test(32'b00000000000100010000000110001010, 1'b0, 1'b0, 1'b1, 2'b10, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    //LDR
    run_test(32'b00000000000100010000000110101010, 1'b1, 1'b0, 1'b1, 2'b10, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    //SND
    run_test(32'b00000000000100010000000110001011, 1'b0, 1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 4'b0000, 4'b0000, 1'b1, 1'b1, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);

    $display("Tests Finished");

    $stop;
end

endmodule