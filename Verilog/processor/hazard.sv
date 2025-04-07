module hazard (
    input clk,
    input rst_n,
    input memread_id_ex,
    input memread_ex_mem,
    input memwrite_ex_mem,
    input [4:0] src_reg1_if_id,
    input [4:0] src_reg2_if_id,
    input [4:0] dst_reg_id_ex,
    input flush_stall,
    output hazard,
    output logic stall_mem
);

logic post_flush;
logic stall_mem_latch;
logic [1:0] stall_mem_curr;
logic temp; 


assign hazard = (memread_id_ex && ((dst_reg_id_ex == src_reg1_if_id) || (dst_reg_id_ex == src_reg2_if_id))); //load --- stall fetch/decode insert nop ---



always_ff @(posedge clk) begin
    if (!rst_n) begin
        stall_mem_curr <= 0;
        stall_mem_latch <= 0;
    end 
    else if(temp & ~stall_mem_latch) begin
        stall_mem_curr <= 2;
        stall_mem_latch <= 1;
    end
    else begin
        stall_mem_curr <= (stall_mem_curr != 0) ? stall_mem_curr - 1 : stall_mem_curr;
        stall_mem_latch <= (stall_mem_curr > 1);
    end
end

assign stall_mem = |stall_mem_curr;
assign temp = (memread_id_ex | flush_stall); //load, write, interrupt, branch, rti return --- full pipeline stall ---



//TODO handle  stalling and flushing



endmodule