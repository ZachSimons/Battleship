module instruction_decoder(
    input [31:0] instruction,
    output random,
    output ppu_send,
    output write_en,
    output [1:0] wb_sel,
    output unsigned_sel,
    output rd_en,
    output [1:0] width,
    output jalr,
    output rti,
    output data_sel,
    output wrt_en,
    output [3:0] alu_op,
    output [3:0] bj_inst,
    output auipc,
    output imm_sel,
    output [1:0] type_sel,
    output rsi,
    output sac,
    output snd
);

logic [6:0] opcode;
logic [2:0] sel;
assign opcode = instruction[6:0];
assign sel = instruction[14:12];


//////////////////////////////////////// Control Signals ///////////////////////////////////////////////

//if random num should be loaded or not
assign random = (opcode==7'b0101010) ? 1'b1 : 1'b0;

//if data is being sent to the ppu
assign ppu_send = (opcode==7'b0101000) ? 1'b1 : 1'b0;

//if data is beig written to a register or not
assign  write_en = ((opcode==7'b0010011) || (opcode==7'b0110011) || (opcode==7'b0010111) || 
                    (opcode==7'b0110111) || (opcode==7'b0000011) || (opcode==7'b1101111) || 
                    (opcode==7'b0101001) || (opcode==7'b0001010) || (opcode==7'b0101010)) ? 1'b1 : 1'b0;

 //if memory out should be sign extended or not
assign unsigned_sel = ((opcode==7'b000011)&&((sel==3'b000) || (sel==3'b001) || (sel==3'b101))) ? 1'b1 : 1'b0;

//if memory is being read or not
assign rd_en = (opcode==7'b0000011) ? 1'b1 : 1'b0; 

//if jalr read from reg
assign jalr = (opcode==7'b1100111) ? 1'b1 : 1'b0; 

//if return from interrupt
assign rti = (opcode==7'b0001000) ? 1'b1 : 1'b0; 

//selects if aluin2 is imm or read data 2
assign data_sel = (opcode==7'b0110011) ? 1'b0 : 1'b1; 

//if mem is being written or not
assign wrt_en = (opcode==7'b0100011) ? 1'b1 : 1'b0; 

//selects which imm to be sent
assign imm_sel = ((opcode==7'b0000011) || (opcode==7'b0010011) || (opcode==7'b1100111) || (opcode==7'b0001001)) ? 1'b0 : 1'b1; 

//if set I-Reg or not
assign rsi = (opcode==7'b0001001) ? 1'b1 : 1'b0; 

//if send accelerator or not
assign sac = (opcode==7'b0101001) ? 1'b1 : 1'b0; 

//if send ethernet or not
assign snd = (opcode==7'b0001011) ? 1'b1 : 1'b0; 

//sets what to write back
assign wb_sel = (opcode==7'b0101001) ? 0 : 
                ((opcode==7'b1101111) || (opcode==7'b1100111)) ? 1 :
                ((opcode==7'b0000011) || (opcode==7'b0101010) || (opcode==7'b0001010)) ? 2 : 3;

//sets what type of instruction it is for imm
assign type_sel = ((opcode==7'b0110111) || (opcode==7'b0010111)) ? 2 :
                  (opcode==7'1101111) ? 3 :
                  (opcode==1100011) ? 1 : 0;

//if auipc needs to pass pc or not
assign auipc = (opcode==7'b0010111) ? 1'b0 : 1'b1;

//width of mem (1=byte), (2=half), (0=full)
assign width = ((opcode==7'b0000011 && (sel==3'b000 || sel==3'b100)) || (opcode==7'b0100011 && sel=3'b000)) ? 1 :
               ((opcode==7'b0000011 && (sel==3'b001 || sel==3'b101)) || (opcode==7'b0100011 && sel=3'b001)) ? 2 : 0;

//alu operation
assign alu_op = {instruction[30],instruction[14:12]};

//branch, jump or not
assign bj_inst = (opcode==7'b1101111 || opcode==7'b1100111) ? 4'b1011 :
                 (opcode==7'b1100011) ? {1'b1,instruction[14:12]} : 4'b0000;

endmodule
