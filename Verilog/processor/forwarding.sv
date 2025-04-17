module forwarding(
    input mem_wb_reg_write,
    input ex_mem_reg_write,
    input [4:0] id_ex_reg_reg1,
    input [4:0] id_ex_reg_reg2,
    input [4:0] mem_wb_reg,
    input [4:0] ex_mem_reg,
    input ignore_fwd_ex,
    input [31:0] instruction_ex,
    output logic [1:0] forward_control1,
    output logic [1:0] forward_control2
);

//Only use forward2 if r type or store
logic r_type;

assign r_type = (instruction_ex[6:0] == 7'b0110011) | (instruction_ex[6:0] == 7'b0100011) | (instruction_ex[6:0] == 7'b1100011);



assign forward_control1 = (ignore_fwd_ex) ? 0 :
                          (ex_mem_reg_write & (ex_mem_reg == id_ex_reg_reg1)) ? 2'b10 :
                          (mem_wb_reg_write & (mem_wb_reg == id_ex_reg_reg1)) ? 2'b01 : 2'b00;
                          
assign forward_control2 = (ignore_fwd_ex /* | imm_used*/) ? 0 :
                          (r_type & ex_mem_reg_write & (ex_mem_reg == id_ex_reg_reg2)) ? 2'b10 :
                          (r_type & mem_wb_reg_write & (mem_wb_reg == id_ex_reg_reg2)) ? 2'b01 : 2'b00;

endmodule