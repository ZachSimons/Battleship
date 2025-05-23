// Have two IPs (one for D-Memory and one for I-Memory)
`timescale 1 ps / 1 ps
module memory(
    input logic         clk,
    input logic         rst_n,
    input logic         mem_unsigned_mem,
    input logic         mem_rd_en_mem,
    input logic         mem_wrt_en_mem,
    input logic         reg_wrt_en_mem,
    input logic         stallmem,
    input logic [1:0]   width_mem,
    input logic [1:0]   wb_sel_mem,
    input logic [4:0]   wrt_reg_mem,
    input logic [31:0]  pc_mem,    
    input logic [31:0]  reg2_data_mem,
    input logic [31:0]  alu_mem,
    input logic [31:0]  instruction_mem,
    output logic        reg_wrt_en_wb,
    output logic        mem_error,
    output logic [1:0]  wb_sel_wb,
    output logic [4:0]  wrt_reg_wb,
    output logic [31:0] read_data_wb,
    output logic [31:0] pc_wb,
    output logic [31:0] alu_wb,
    output logic [31:0] instruction_wb
);
//////////////NET INSTANTIATION/////////////////////
logic [31:0] wrapper_rd_data;


//////////////MODULE INSTANTIATION///////////////////
data_memory_wrapper dmem (
    .clk(clk),
    .rst_n(rst_n),
    .wrt_en(mem_wrt_en_mem),
    .rd_en(mem_rd_en_mem),
    .mem_unsigned(mem_unsigned_mem),
    .width(width_mem),
    .wrt_data(reg2_data_mem),
    .wrt_addr(alu_mem),
    .rd_data(wrapper_rd_data),
    .mem_error(mem_error)
);

/////////////////PIPELINE STAGE FF///////////////////
always_ff @(posedge clk) begin
    if(!rst_n) begin
        reg_wrt_en_wb <= '0;
        wb_sel_wb <= '0;
        wrt_reg_wb <= '0;
        read_data_wb <= '0;
        pc_wb <= '0;
        alu_wb <= '0;
    end
    else if (!stallmem) begin
        reg_wrt_en_wb <= reg_wrt_en_mem;
        wb_sel_wb <= wb_sel_mem;
        wrt_reg_wb <= wrt_reg_mem; 
        read_data_wb <= wrapper_rd_data;
        pc_wb <= pc_mem;
        alu_wb <= alu_mem;
        instruction_wb <= instruction_mem;
    end
end


////////////////COMBINATIONAL LOGIC//////////////////
//Stage Muxes






endmodule





