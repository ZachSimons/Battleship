module hazard (
    input clk,
    input rst_n,
    input sac_id_ex,
    input memread_if_id,
    input memread_id_ex,
    input memread_ex_mem,
    input memwrite_ex_mem,
    input [4:0] src_reg1_if_id,
    input [4:0] src_reg2_if_id,
    input [4:0] dst_reg_id_ex,
    output hazard,
    output logic stall_pc,
    output logic stall_mem
);

//logic stall_mem_latch;
logic [1:0] stall_mem_curr;
//logic stall_pc_latch;
logic [1:0] stall_pc_curr;
//logic tempmem, temppc; 

logic load_haz, sac_haz, sac_haz_repeat;

//load and sac --- stall fetch/decode insert nop ---
assign hazard = ((memread_id_ex | sac_id_ex) && ((dst_reg_id_ex == src_reg1_if_id) || (dst_reg_id_ex == src_reg2_if_id))); 


always_ff @(posedge clk) begin
    if (!rst_n) begin
        stall_mem_curr <= 0;
    end 
    else if(memread_id_ex & ~|stall_mem_curr) begin
        stall_mem_curr <= 2;
    end
    else begin
        stall_mem_curr <= (stall_mem_curr != 0) ? stall_mem_curr - 1 : stall_mem_curr;
    end
end

assign stall_mem = |stall_mem_curr;
//assign tempmem = (memread_id_ex); //load, write, interrupt, branch, rti return --- full pipeline stall ---

always_ff @(posedge clk) begin
    if (!rst_n) begin
        stall_pc_curr <= 0;
        //stall_pc_latch <= 0;
    end 
    else if(memread_if_id & ~|stall_pc_curr) begin
        stall_pc_curr <= 2;
        //stall_pc_latch <= 1;
    end
    else begin
        stall_pc_curr <= (stall_pc_curr != 0) ? stall_pc_curr - 1 : stall_pc_curr;
        //stall_pc_latch <= (stall_pc_curr > 1);
    end
end

//assign temppc = memread_if_id;
assign stall_pc = |stall_pc_curr;
//TODO handle  stalling and flushing




endmodule