module instruction_decoder(
    input [31:0] instruction,
    output logic random,
    output logic ppu_send,
    output logic write_en,
    output logic [1:0] wb_sel,
    output logic unsigned_sel,
    output logic rd_en,
    output logic [1:0] width,
    output logic jalr,
    output logic rti,
    output logic data_sel,
    output logic wrt_en,
    output logic [3:0] alu_op,
    output logic [3:0] bj_inst,
    output logic auipc,
    output logic imm_sel,
    output logic [1:0] type_sel,
    output logic rsi,
    output logic sac,
    output logic snd,
    output logic uad,
    output logic rdi,
    output logic ignore_fwd,
    output logic lui
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
                    (opcode==7'b0101001) || (opcode==7'b0001010) || (opcode==7'b0101010) || (opcode==7'b1100111)) ? 1'b1 : 1'b0;

 //if memory out should be sign extended or not
assign unsigned_sel = ((opcode==7'b000011)&&((sel==3'b000) || (sel==3'b001) || (sel==3'b010))) ? 1'b1 : 1'b0;

//if memory is being read or not
assign rd_en = (opcode==7'b0000011) ? 1'b1 : 1'b0; 

//if jalr read from reg
assign jalr = (opcode==7'b1100111) ? 1'b1 : 1'b0; 

//if return from interrupt
assign rti = (opcode==7'b0001000) ? 1'b1 : 1'b0; 

//selects if aluin2 is imm or read data 2
assign data_sel = (opcode==7'b0110011 || opcode==7'b1100011) ? 1'b0 : 1'b1; 

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
                  ((opcode==7'b1101111))? 3 :
                  (opcode==7'b1100011) ? 1 : 0;

//if auipc needs to pass pc or not
assign auipc = (opcode==7'b0010111) ? 1'b0 : 1'b1;

//width of mem (1=byte), (2=half), (0=full)
assign width = ((opcode==7'b0000011 && (sel==3'b000 || sel==3'b100)) || (opcode==7'b0100011 && sel==3'b000)) ? 1 :
               ((opcode==7'b0000011 && (sel==3'b001 || sel==3'b101)) || (opcode==7'b0100011 && sel==3'b001)) ? 2 : 0;

//alu operation
assign alu_op = (opcode == 7'b0110011) ? {instruction[30],instruction[14:12]} : 
                (opcode == 7'b0000011 || opcode == 7'b0100011) ? '0  : {1'b0,instruction[14:12]};

//branch, jump or not
assign bj_inst = (opcode==7'b1101111 || opcode==7'b1100111) ? 4'b1011 :
                 (opcode==7'b1100011) ? {1'b1,instruction[14:12]} : 4'b0000;

//sets high when accelerator gets new data
assign uad = (opcode==7'b0101011) ? 1'b1 : 1'b0;

//
assign rdi = (opcode==7'b0001010) ? 1'b1 : 1'b0;

assign ignore_fwd = (opcode == 7'b0110111) || (opcode == 7'b0010111);

assign lui = (opcode == 7'b0110111);

endmodule
