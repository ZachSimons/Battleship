// Have two IPs (one for D-Memory and one for I-Memory)
module memory(
    input logic         clk,
    input logic         rst_n,
    input logic         mem_unsigned_mem,
    input logic         mem_rd_en_mem,
    input logic         mem_wrt_en_mem,
    input logic         reg_wrt_en_mem,
    input logic         random_mem,
    input logic         rdi_mem.
    input logic [1:0]   width_mem,
    input logic [1:0]   wb_sel_mem,
    input logic [4:0]   wrt_reg_mem,
    input logic [31:0]  pc_mem,
    input logic [31:0]  rdi_data,      
    input logic [31:0]  reg2_data_mem,
    input logic [31:0]  alu_mem,
    output logic        reg_wrt_en_wb,
    output logic [1:0]  wb_sel_wb
    output logic [4:0]  wrt_reg_wb,
    output logic [31:0] read_data_wb,
    output logic [31:0] pc_wb,
    output logic [31:0] alu_wb
);


//////////////MODULE INSTANTIATION///////////////////


/////////////////PIPELINE STAGE FF///////////////////
always_ff @(posedge clk, negedge rst) begin
    if(!rst_n) begin
        reg_wrt_en_wb <= '0;
        wb_sel_wb <= '0;
        wrt_reg_wb <= '0;
        read_data_wb <= '0;
        pc_wb <= '0;
        alu_wb <= '0;
    end
    else begin
        //TODO add FF passthroughs
        reg_wrt_en_wb <= reg_wrt_en_mem;
        wb_sel_wb <= wb_sel_mem;
        wrt_reg_wb <= wrt_reg_mem; 
        //TODO read_data_wb <= 
        pc_wb <= pc_mem;
        alu_wb <= alu_mem;
    end
end


////////////////COMBINATIONAL LOGIC//////////////////






endmodule





