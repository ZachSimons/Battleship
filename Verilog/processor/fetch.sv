module fetch(
    input clk,
    input rst_n,
    input branch,
    input rti, //Interrupt handled -> Jump back to I-reg
    input rsi, //Interrupt handled -> got to next instruction and clear I-Reg
    input interrupt,
    input flush,
    input interrupt_branch_alert,
    input stall_mem,
    input stall_pc,
    input hazard,
    input halt,
    input [31:0] pc_ex,
    output logic stall_override,
    output logic [31:0] instruction_dec,
    output logic [31:0] pc_next_dec,
    output logic [31:0] pc_curr_dec,
    output logic memrden_if
);
//////////////NET INSTANTIATION/////////////////////
logic hazard1;
logic stall_mem1; //Doesn't have to be a latched signal 
logic warmup, inter_temp, inter_stall;
logic [1:0] flushnop;
logic [31:0] i_reg, nxt_pc, pc_q, instruction_fe, imem_out;
logic [31:0] branch_mux, rti_mux, pc_d;
logic [31:0] pc_next_dec_q0, pc_next_dec_q1, pc_curr_dec_q0, pc_curr_dec_q1;
logic branch_in_fetch, branch_mem;
logic [1:0] interrupt_nop, interrupt_temp_enable;
//Use 0x00100073 as halt


//////////////MODULE INSTANTIATION///////////////////
//Make byte addressable (not as complicated as d-memory)
placeholder_mem imem(
    .clk(clk),
    .rst_n(rst_n),
    .read_en(~|warmup),
    .hazard(hazard),
    .addr(pc_q),
    .q(imem_out)
);

always_ff @(posedge clk) begin
    stall_mem1 <= stall_mem;
end

logic [31:0] instruction_fe_q;
always_ff @(posedge clk) begin
    instruction_fe_q <= instruction_fe;
end

assign instruction_fe = (stall_mem1) ? instruction_fe_q : 
                        ((^imem_out === 1'bX) | (~|imem_out) | |warmup | (flush && ~inter_temp) | |flushnop | |interrupt_nop) ? 32'h00000013 : imem_out;


assign memrden_if = (instruction_fe[6:0] == 7'b0000011);
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
    else if (flush && ~inter_temp) begin
        instruction_dec <= 32'h00000013; //IDK if this needs to be combinational
    end
    else if (|flushnop | warmup | stall_mem) begin
        instruction_dec <= instruction_dec;
    end
    else begin
        instruction_dec <= instruction_fe;
    end
end

//
always_ff @(posedge clk) begin
    if(!rst_n) begin
        pc_next_dec <= '0;
        pc_curr_dec <= '0;
        pc_next_dec_q0 <= '0;
        pc_curr_dec_q0 <= '0;
        pc_next_dec_q1 <= '0;
        pc_curr_dec_q1 <= '0;
    end
    else if (flush && ~inter_temp) begin //DONT KNWO IF THIS WORKS
        pc_next_dec_q0 <= 0;
        pc_curr_dec_q0 <= 0;
        pc_next_dec_q1 <= 0;
        pc_curr_dec_q1 <= 0;
        pc_next_dec <= 0;
        pc_curr_dec <= 0;
    end
    else if (|flushnop) begin
        pc_next_dec_q0 <= nxt_pc;
        pc_curr_dec_q0 <= pc_q;
        pc_next_dec_q1 <= pc_next_dec_q0;
        pc_curr_dec_q1 <= pc_curr_dec_q0;
        pc_next_dec <= 0;
        pc_curr_dec <= 0;
    end
    else if (stall_mem | halt) begin
        pc_next_dec_q0 <= pc_next_dec_q0;
        pc_curr_dec_q0 <= pc_curr_dec_q0;
        pc_next_dec_q1 <= pc_next_dec_q1;
        pc_curr_dec_q1 <= pc_curr_dec_q1;
        pc_next_dec <= pc_next_dec;
        pc_curr_dec <= pc_curr_dec;
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


//After Flush is asserted keep pushing nops till instructions are ready (2 cycles)
always_ff @(posedge clk) begin
    if (!rst_n) begin
        flushnop <= 0;
    end
    else if(flush && ~inter_temp) begin
        flushnop <= 2;
    end
    else begin
        flushnop <= (flushnop != 0) ? flushnop - 1'b1 : flushnop;
    end
end




////////////////////// LOGIC ////////////////////////

//What happens when interrupt and stall both happen? Interrupt should overpower stall

//Order of PC change interrupt -> RTI -> branch
//PC control Logic 
assign pc_d =       interrupt ? 32'h00000004 :
                    rti       ? i_reg        : 
                    rsi       ? pc_ex        : //PC FROM BRANCH WHEN RSI
                    inter_temp ? nxt_pc : branch_mux; // DONT KNWO IF THIS WOKRS
assign branch_mux = interrupt ? pc_curr_dec_q0 : (branch /*&& inter_temp*/) ? pc_ex : nxt_pc; /////////////////DONT KNOW IF THIS WORKS

//Need to not increase the pc when stalling/hazard
assign nxt_pc = pc_q + 4;

//PC register
always_ff @(posedge clk) begin
    if(!rst_n) begin
        pc_q <= '0;
    end
    else if (hazard) begin
        pc_q <= pc_curr_dec_q0;
    end
    else if (stall_pc | warmup | hazard1/*& ~interrupt*/) begin
        pc_q <= pc_q;
    end
    else begin
        pc_q <= pc_d;
    end
end


assign branch_in_fetch = ((instruction_fe[6:0] == 7'b1100011) || (instruction_fe[6:0] == 7'b1100111) || (instruction_fe[6:0] == 7'b1101111));
assign stall_override = inter_stall;


always_ff @(posedge clk) begin
    hazard1 <= hazard;
end



//Instruction register to hold nxt_pc
always_ff @(posedge clk) begin
    if(!rst_n) begin
        i_reg <= '0;
        inter_temp <= 0;
        inter_stall <= 0;
    end
    else if(rsi | rti) begin
        i_reg <= '0;
    end 
    else if (stall_mem /*& ~interrupt*/) begin //TODO determine via testing if needed
        i_reg <= i_reg;
    end
    else if(interrupt) begin 
        i_reg <= (branch) ? pc_ex : 
                 (branch_mem) ? pc_q :
                 branch_mux;
        inter_temp <= 1;
        inter_stall <= 0;
    end
    else if((|interrupt_temp_enable) && inter_temp && (branch || interrupt_branch_alert || branch_in_fetch)) begin  //DONT KNWO IF THIS WORKS
        i_reg <= branch ? branch_mux : i_reg;
        inter_stall <= 0;
    end
    else begin
        inter_temp <= 0;
        inter_stall <= 0;
    end
end

//interrupt nop gen
always_ff @(posedge clk) begin
    if(!rst_n) begin
        interrupt_nop <= 0;
        interrupt_temp_enable <= 0;
    end
    else if(interrupt) begin
        interrupt_nop <= 2;
        interrupt_temp_enable <= 3;
    end
    else begin
        interrupt_nop <= (interrupt_nop != 0) ? interrupt_nop - 1'b1 : interrupt_nop;
        interrupt_temp_enable <= (interrupt_temp_enable != 0) ? interrupt_temp_enable - 1'b1 : interrupt_temp_enable;
    end
end

always_ff @(posedge clk) begin
    if(!rst_n) begin
        branch_mem <= 0;
    end
    else begin
        branch_mem <= branch;
    end
end

//for 2 cyles after a interrupt goes high while interrupt flag is low, redirect branch returns into i reg instead of pc
//remove flushing the pipeline for a interrupt



endmodule