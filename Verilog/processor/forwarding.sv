module forwarding(
    input mem_wb_reg_write,
    input ex_mem_reg_write,
    input [4:0] id_ex_reg_reg1,
    input [4:0] id_ex_reg_reg2,
    input [4:0] mem_wb_reg,
    input [4:0] ex_mem_reg,
    input ignore_fwd_ex,
    output logic [1:0] forward_control1,
    output logic [1:0] forward_control2
);

assign forward_control1 = (ignore_fwd_ex) ? 0 :
                          (mem_wb_reg_write & (mem_wb_reg == id_ex_reg_reg1)) ? 2'b01 :
                          (ex_mem_reg_write & (ex_mem_reg == id_ex_reg_reg1)) ? 2'b10 : 2'b00;
                          
assign forward_control2 = (ignore_fwd_ex) ? 0 :
                          (mem_wb_reg_write & (mem_wb_reg == id_ex_reg_reg2)) ? 2'b01 :
                          (ex_mem_reg_write & (ex_mem_reg == id_ex_reg_reg2)) ? 2'b10 : 2'b00;

endmodule