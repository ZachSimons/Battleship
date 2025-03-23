module fetch(
    input clk,
    input rst_n,
    input branch,
    input rti, //Interrupt handled -> Jump back to I-reg
    input rsi, //Interrupt handled -> got to next instruction and clear I-Reg
    input interrupt_key, //I-Reg enable signal
    input interrupt_eth,
    input prog_en,
    input [31:0] prog_data,
    input [31:0] prog_addr,
    input [31:0] pc_ex,
    output logic [31:0] instruction_dec,
    output logic [31:0] pc_dec
);
//////////////NET INSTANTIATION/////////////////////
logic interrupt_latch, interrupt_control; //Doesn't have to be a latched signal 
logic [31:0] i_reg, nxt_pc, pc, instruction_fe;
logic [31:0] branch_mux, rti_mux, interrupt_mux, prog_mux;


//////////////MODULE INSTANTIATION///////////////////
//Make byte addressable (not as complicated as d-memory)
inst_memory_wrapper imem(
    .clk(clk),
    .rst_n(rst_n),
    .wrt_en(prog_en), 
    .wrt_data(prog_data),
    .addr(prog_mux),
    .rd_data(instruction_fe)
);


/////////////////PIPELINE STAGE FF///////////////////
//TODO impliment flushing & nops at some point
always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        instruction_dec <= '0;
        pc_dec <= '0;
    end
    else begin
        instruction_dec <= instruction_fe;
        pc_dec <= nxt_pc;
    end
end

////////////////////// LOGIC ////////////////////////
assign branch_mux = branch ? pc_ex : nxt_pc;
assign rti_mux = rti ? i_reg : branch_mux;
assign interrupt_mux = interrupt_control ? 32'h00000004 : rti_mux; 
assign nxt_pc = pc + 4;
assign interrupt_control = (interrupt_key | interrupt_eth) & ~interrupt_latch;
assign prog_mux = prog_en ? prog_addr : pc; 

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

always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        pc <= '0;
    end
    else begin
        pc <= interrupt_mux;
    end
end


endmodule