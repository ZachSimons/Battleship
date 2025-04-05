module hazard (
    input clk,
    input rst_n,
    input memread_id_ex,
    input memread_ex_mem,
    input memwrite_ex_mem,
    input [4:0] src_reg1_if_id,
    input [4:0] src_reg2_if_id,
    input [4:0] dst_reg_id_ex,
    output hazard,
    output logic stall_mem
);

logic post_flush;
logic stall_mem_latch;
logic temp; 


assign hazard = (memread_id_ex && ((dst_reg_id_ex == src_reg1_if_id) || (dst_reg_id_ex == src_reg2_if_id))); //load --- stall fetch/decode insert nop ---



always_ff @(posedge clk) begin
    if (!rst_n) begin
        stall_mem <= 0;
        stall_mem_latch <= 0;
    end 
    else if(temp & ~stall_mem_latch) begin
        stall_mem <= 1;
        stall_mem_latch <= 1;
    end
    else if(stall_mem_latch) begin
        stall_mem <= 0;
        stall_mem_latch <= 0;
    end
end

assign temp = (memread_ex_mem | memwrite_ex_mem); //load, write, interrupt, branch, rti return --- full pipeline stall ---



//TODO handle  stalling and flushing



endmodule