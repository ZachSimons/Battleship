module hazard (
    input memread_id_ex,
    input memread_ex_mem,
    input memwrite_ex_mem,
    input interrupt,
    input branch,
    input rti,
    input [4:0] src_reg1_if_id,
    input [4:0] src_reg2_if_id,
    input [4:0] dst_reg_id_ex,
    output hazard,
    output stall_mem
);

assign hazard = (memread_id_ex && ((dst_reg_id_ex == src_reg1_if_id) || (dst_reg_id_ex == src_reg2_if_id))); //load --- stall fetch/decode insert nop ---
assign stall_mem = (memread_ex_mem || memwrite_ex_mem || interrupt || branch || rti); //load, write, interrupt, branch, rti return --- full pipeline stall ---


endmodule