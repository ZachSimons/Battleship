module fetch(
    input clk,
    input rst_n,
    input branch,
    input rti, //Interrupt handled -> Jump back to I-reg
    input rsi, //Interrupt handled -> got to next instruction and clear I-Reg
    input interrupt_key, //I-Reg enable signal
    input interrupt_eth,
    input [31:0] pc_ex,
    output logic [31:0] instruction_dec,
    output logic [31:0] pc_dec
);
//////////////NET INSTANTIATION/////////////////////
logic interrupt_latch, interrupt_control, warmup; //Doesn't have to be a latched signal 
logic [1:0]  stall;
logic [31:0] i_reg, nxt_pc, pc, instruction_fe, nxt_pc_sync;
logic [31:0] inst_pc, inst_pc_sync; //These signals are for testing purposes
logic [31:0] branch_mux, rti_mux, pc_control;


//////////////MODULE INSTANTIATION///////////////////
//Make byte addressable (not as complicated as d-memory)
placeholder_mem imem(
    .clk(clk),
    .rst_n(rst_n), //HUH do I need this????
    .addr(pc[7:0]),
    .q(instruction_fe)
);


/////////////////PIPELINE STAGE FF///////////////////
//NOP Is encoded as addi x0 x0 0 -> 32'h00000013;
//TODO impliment stalling & nops at some pointr
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        instruction_dec <= 32'h00000013; //Needs to be halt or NOP
        pc_dec <= '0;
    end
    else if (|stall | ~warmup) begin
        pc_dec <= 0;
        instruction_dec <= 32'h00000013; 
    end
    else begin
        instruction_dec <= instruction_fe;
        pc_dec <= nxt_pc_sync;
    end
end

//rst_n warmup
always_ff @(posedge clk) begin //TODO fix bug regarding rst_n asserted between clock cycles
    warmup <= rst_n; 
end 

//PC syncronization
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        nxt_pc_sync <= '0;
        inst_pc_sync <= '0;
        inst_pc <= 0;
    end 
    else begin
        nxt_pc_sync <= nxt_pc;
        inst_pc_sync <= pc;
        inst_pc <= inst_pc_sync;
    end
end

//TODO debounce may need to only detect interrupt_key and interrupt_eth rising edges

////////////////////// LOGIC ////////////////////////
assign interrupt_control = (interrupt_key | interrupt_eth) & ~interrupt_latch;

assign pc_control = interrupt_control ? 32'h00000004: //TODO for testing purposes the address is 1 MAKE SURE TO CHANGE
                    rti               ? i_reg        : branch_mux; 
assign branch_mux = branch ? pc_ex : nxt_pc;

assign nxt_pc = pc + 4; //TODO for testing purposes this is 1 MAKE SURE TO CHANGE


//TODO may need to debounce rti and rsi depending on if they are sync to the cpu pipeline
//While interrupt being handled another interrupt must not be able to happen
//Interrupt latcher
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


//Staling logic since memory accesses are delayed a cycle
assign stall[0] = branch | interrupt_control | rti;
always_ff @(posedge clk) begin
    stall[1] <= stall[0];
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

//PC register
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        pc <= '0;
    end
    else begin
        pc <= pc_control;
    end
end


endmodule