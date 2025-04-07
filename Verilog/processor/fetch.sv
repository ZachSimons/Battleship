module fetch(
    input clk,
    input rst_n,
    input branch,
    input rti, //Interrupt handled -> Jump back to I-reg
    input rsi, //Interrupt handled -> got to next instruction and clear I-Reg
    input interrupt,
    input flush,
    input stall,
    input [31:0] pc_ex,
    output logic [31:0] instruction_dec,
    output logic [31:0] pc_next_dec,
    output logic [31:0] pc_curr_dec
);
//////////////NET INSTANTIATION/////////////////////
logic stall_mem1; //Doesn't have to be a latched signal 
logic [1:0] warmup;
logic [31:0] i_reg, nxt_pc, pc_q, instruction_fe, imem_out;
logic [31:0] branch_mux, rti_mux, pc_d;
logic [31:0] pc_next_dec_q0, pc_next_dec_q1, pc_curr_dec_q0, pc_curr_dec_q1;


//Use 0x00100073 as halt

//////////////MODULE INSTANTIATION///////////////////
//Make byte addressable (not as complicated as d-memory)
placeholder_mem imem(
    .clk(clk),
    .rst_n(rst_n),
    .read_en(~|warmup),
    .addr(pc_q),
    .q(imem_out)
);

always_ff @(posedge clk) begin
    stall_mem1 <= stall;
end

assign instruction_fe = (stall | stall_mem1) ? instruction_fe : 
                        ((^imem_out === 1'bX) | (~|imem_out) | |warmup) ? 32'h00000013 : imem_out;


//Flushing -> IFD needs to go to 0 and NOP. PC still needs to update to the correct value
//stall_mem -> IFD needs to stay same value. PC still needs to stay same value
//stall_nop -> identical to stall_mem
//TODO possibly fix bug if interrupt happens while stalling


/////////////////PIPELINE STAGE FF///////////////////
//NOP Is encoded as addi x0 x0 0 -> 32'h00000013;
//TODO impliment stalling & nops at some pointr
always_ff @(posedge clk) begin
    if(!rst_n) begin
        instruction_dec <= 32'h00000013; //Needs to be halt or NOP
    end
    else if (flush) begin
        instruction_dec <= 32'h00000013; //IDK if this needs to be combinational
    end
    else if (stall | warmup) begin
        instruction_dec <= instruction_dec;
    end
    else begin
        instruction_dec <= instruction_fe;
    end
end

always_ff @(posedge clk) begin
    if(!rst_n) begin
        pc_next_dec <= '0;
        pc_curr_dec <= '0;
        pc_next_dec_q0 <= '0;
        pc_curr_dec_q0 <= '0;
        pc_next_dec_q1 <= '0;
        pc_curr_dec_q1 <= '0;
    end
    else if (flush) begin
        pc_next_dec_q0 <= 0;
        pc_curr_dec_q0 <= 0;
        pc_next_dec_q1 <= 0;
        pc_curr_dec_q1 <= 0;
        pc_next_dec <= 0;
        pc_curr_dec <= 0;
    end
    else if (stall) begin
        pc_next_dec_q0 <= nxt_pc;
        pc_curr_dec_q0 <= pc_q;
        pc_next_dec_q1 <= pc_next_dec_q0;
        pc_curr_dec_q1 <= pc_curr_dec_q0;
        pc_next_dec <= 0;
        pc_curr_dec <= 0;
    end
    else begin
        pc_next_dec_q0 <= nxt_pc;
        pc_curr_dec_q0 <= pc_q;
        pc_next_dec_q1 <= pc_next_dec_q0;
        pc_curr_dec_q1 <= pc_curr_dec_q0;
        pc_next_dec <= pc_next_dec_q1;
        pc_curr_dec <= pc_curr_dec_q1;
    end
end

//TODO fix later
//rst_n warmup 
always_ff @(posedge clk) begin //TODO fix bug regarding rst_n asserted between clock cycles
    if (!rst_n)
        warmup <= 1;
    else
        warmup <= (warmup != 0) ? warmup - 1'b1 : warmup;
end 


////////////////////// LOGIC ////////////////////////

//What happens when interrupt and stall both happen? Interrupt should overpower stall

//Order of PC change interrupt -> RTI -> branch
//PC control Logic 
assign pc_d =       interrupt ? 32'h00000004 :
                    rti       ? i_reg        : branch_mux; 
assign branch_mux = branch ? pc_ex : nxt_pc;

//Need to not increase the pc when stalling/hazard
assign nxt_pc = pc_q + 4;

//PC register
always_ff @(posedge clk) begin
    if(!rst_n) begin
        pc_q <= '0;
    end
    else if (stall | warmup/*& ~interrupt*/) begin
        pc_q <= pc_q;
    end
    else begin
        pc_q <= pc_d;
    end
end

//Instruction register to hold nxt_pc
always_ff @(posedge clk) begin
    if(!rst_n) begin
        i_reg <= '0;
    end
    else if(rsi) begin
        i_reg <= '0;
    end 
    else if (stall /*& ~interrupt*/) begin //TODO determine via testing if needed
        i_reg <= i_reg;
    end
    else if(interrupt) begin 
        i_reg <= branch_mux;
    end
end

endmodule