module fetch_tb();

logic clk;
logic rst_n;
logic branch;
logic rti;
logic rsi;
logic interrupt_key;
logic interrupt_eth;
logic prog_en;
logic [31:0] prog_data;
logic [31:0] prog_addr;
logic [31:0] pc_ex;
logic [31:0] instruction_dec;
logic [31:0] pc_dec;


fetch idut (
    .clk(clk),
    .rst_n(rst_n),
    .branch(branch),
    .rti(rti), 
    .rsi(rsi), 
    .interrupt_key(interrupt_key), 
    .interrupt_eth(interrupt_eth),
    .prog_en(prog_en),
    .prog_data(prog_data),
    .prog_addr(prog_addr),
    .pc_ex(pc_ex),
    .instruction_dec(instruction_dec),
    .pc_dec(pc_dec)
); 

//Maybe add error such that a RTI can't happen if i-reg = 0


initial begin
//Things to test:

//Test that branch command causes pc_ex to be used

//Test that interrupt causes PC to be stored in i-reg and pc is set to 4

//Test that another interrupt can't happen until RTI or RSI are asserted

//Test that RTI uses PC stored in i-reg

//Test that the other interrupt type can cause interrupt

//Test that rsi clears i-reg and uses next instruction

//Test that instruction memory can be programmed and works (may have to do after break)

end



always begin
    #5 clk = ~clk;
end


endmodule