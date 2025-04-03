module fetch(
    input clk,
    input rst_n,
    input branch,
    input rti, //Interrupt handled -> Jump back to I-reg
    input rsi, //Interrupt handled -> got to next instruction and clear I-Reg
    input interrupt_key, //I-Reg enable signal
    input interrupt_eth,
    input flush,
    input stall,
    input [31:0] pc_ex,
    output logic [31:0] instruction_dec,
    output logic [31:0] pc_dec
);
//////////////NET INSTANTIATION/////////////////////
logic interrupt_latch, interrupt_control, warmup; //Doesn't have to be a latched signal 
logic [1:0]  stall;
logic [31:0] i_reg, nxt_pc, pc, instruction_fe, nxt_pc_sync;
logic [31:0] branch_mux, rti_mux, pc_control;


//////////////MODULE INSTANTIATION///////////////////
//Make byte addressable (not as complicated as d-memory)
placeholder_mem imem(
    .clk(clk),
    .rst_n(rst_n),
    .addr(pc),
    .q(instruction_fe)
);


//TODO for stall
//1. Add write_disable for f-d FFs
//2. Add wirte_disable for PC
//2. Add Flushing logic for d-f FFs

/////////////////PIPELINE STAGE FF///////////////////
//NOP Is encoded as addi x0 x0 0 -> 32'h00000013;
//TODO impliment stalling & nops at some pointr
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        instruction_dec <= 32'h00000013; //Needs to be halt or NOP
        pc_dec <= '0;
    end
    else if (/*Flush*/) begin
        pc_dec <= 0;
        instruction_dec <= 32'h00000013; 
    end
    else if (/*stall*/) begin
        pc_dec <= pc_dec;
        instruction_dec <= instruction_dec;
    end
    else begin
        instruction_dec <= instruction_fe;
        pc_dec <= nxt_pc;
    end
end

//TODO fix later
//rst_n warmup 
always_ff @(posedge clk) begin //TODO fix bug regarding rst_n asserted between clock cycles
    warmup <= rst_n; 
end 

//PC syncronization
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        nxt_pc_sync <= '0;
    end 
    else begin
        nxt_pc_sync <= nxt_pc;
    end
end

//TODO debounce may need to only detect interrupt_key and interrupt_eth rising edges
////////////////////// LOGIC ////////////////////////

//What happens when interrupt and stall both happen?


//PC control Logic 
assign pc_control = interrupt_control ? 32'h00000004: //TODO for testing purposes the address is 1 MAKE SURE TO CHANGE
                    rti               ? i_reg        : branch_mux; 
assign branch_mux = branch ? pc_ex : nxt_pc;

//Need to not increase the pc when stalling/hazard
assign nxt_pc = pc + 4; //TODO for testing purposes this is 1 MAKE SURE TO CHANGE

//PC register
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        pc <= '0;
    end
    else if (/*stall*/) begin
        pc <= pc;
    end
    else begin
        pc <= pc_control;
    end
end

//Interrupt Logic
//TODO may need to debounce rti and rsi depending on if they are sync to the cpu pipeline
//While interrupt being handled another interrupt must not be able to happen
assign interrupt_control = (interrupt_key | interrupt_eth) & ~interrupt_latch;

always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        interrupt_latch <= 0;
    end
    else if(rti || rsi) begin
        interrupt_latch <= 0;
    end
    else if(interrupt_key | interrupt_eth) begin
        interrupt_latch <= 1;
    end
end

//Instruction register to hold nxt_pc
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        i_reg <= '0;
    end
    else if(rsi) begin
        i_reg <= '0;
    end 
    else if(interrupt_control) begin 
        i_reg <= branch_mux;
    end
end




endmodule