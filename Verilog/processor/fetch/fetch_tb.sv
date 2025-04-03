module fetch_tb();

logic clk;
logic rst_n;
logic branch;
logic rti;
logic rsi;
logic interrupt_key;
logic interrupt_eth;
logic [31:0] pc_ex;
logic [31:0] instruction_dec;
logic [31:0] pc_dec;
logic [31:0] pc_tracker;
logic [31:0] err_cnt;


fetch idut (
    .clk(clk),
    .rst_n(rst_n),
    .branch(branch),
    .rti(rti), 
    .rsi(rsi), 
    .interrupt_key(interrupt_key), 
    .interrupt_eth(interrupt_eth),
    .pc_ex(pc_ex),
    .instruction_dec(instruction_dec),
    .pc_dec(pc_dec)
); 

//Maybe add error such that a RTI can't happen if i-reg = 0


initial begin
//Things to test:
//Varable Initalization
clk = 0;
rst_n = 0;
branch = 0;
rti = 0;
rsi = 0;
interrupt_eth = 0;
interrupt_key = 0;
pc_ex = 0;
pc_tracker = 4; 
err_cnt = 0;

repeat(2) @(posedge clk);

@(negedge clk)
//Test that PC is incremnenting by 4 each cycle
rst_n = 1;

@(posedge clk);
for(int i = 0; i < 4; i++) begin
    @(posedge clk);
    #1
    if(pc_dec != pc_tracker) begin
        $display("PC didn't increment correctly on iteration %d : %d : %d", i, pc_dec, pc_tracker);
        err_cnt++;
    end
    pc_tracker += 4;
end


//Test that when a branch was detected we flushed the pipeline register 
//and waited for correct pc and instruction
@(negedge clk)
pc_ex = 32'd40;
branch = 1;

@(negedge clk);
branch = 0;
repeat (2) @(posedge clk);
#1;
if(idut.inst_pc != 40) begin
    $display("pc_ex wasn't used");
    err_cnt++;
end
if(instruction_dec != 8'hAA) begin
    $display("Incorrect instruction was displayed");
    err_cnt++;
end

repeat(3) @(posedge clk) //Simulating time passing

//Test that interrupt causes PC to be stored in i-reg and pc is set to 1
@(negedge clk);
branch = 0;
pc_ex = 0;
interrupt_eth = 1;

@(negedge clk);
interrupt_eth = 0;

repeat (2) @(posedge clk);
#1;
if(pc_dec != 32'd8) begin
    $display("interrupt PC didn't update");
    err_cnt++;
end
if(idut.i_reg != 32'd64) begin
    $display("i_reg has incorrect value");
    err_cnt++;
end
//$display("%d", idut.i_reg);

@(posedge clk);
#1;
if(pc_dec != 32'd12) begin
    $display("PC after interrrupt didn't increment properly");
    err_cnt++;
end



//Test that another interrupt can't happen until RTI or RSI are asserted
@(negedge clk);
interrupt_eth = 1;

@(posedge clk)
#1
interrupt_eth = 0;
if(idut.i_reg != 32'd64) begin
    $display("i_reg updated when it shouldn't have");
    err_cnt++;
end

if(pc_dec != 32'd16) begin
    $display("updated interrupt when interrupt signal was currenlty being handled");
    err_cnt++;
end


//Test that RTI uses PC stored in i-reg
@(negedge clk);
rti = 1;
@(negedge clk);
rti = 0;
repeat (2) @(posedge clk);
#1;
if(pc_dec != 32'd68) begin
    $display("failed to return from interrupt %d", pc_dec);
    err_cnt++;
end

repeat(5) @(posedge clk); //Simulating time passing

//Test that the other interrupt type can cause interrupt
@(negedge clk);
interrupt_key = 1;

@(negedge clk);
interrupt_key = 0;

repeat (2) @(posedge clk);
#1;
if(pc_dec != 32'd8) begin
    $display("interrupt PC didn't update");
    err_cnt++;
end
if(idut.i_reg != 32'd96) begin
    $display("i_reg has incorrect value");
    err_cnt++;
end
//$display("%d", idut.i_reg);

@(posedge clk);
#1;
if(pc_dec != 32'd12) begin
    $display("PC after interrrupt didn't increment properly");
    err_cnt++;
end

//Test that rsi clears i-reg and uses next instruction
@(negedge clk);
rsi = 1;
@(negedge clk);
rsi = 0;
@(posedge clk);
#1;
if(pc_dec != 32'd20) begin
    $display("Failed to continue");
    err_cnt++;
end
if(idut.i_reg != 0) begin
    $display("didn't clear i_reg");
    err_cnt++;
end

repeat (5) @(posedge clk);
//I-mem will rom so it won't be programmable

if(err_cnt != 0) begin
    $display("Errors found in test bench. Please handle %d", err_cnt);
end else begin
    $display("All tests pass :)");
end

$stop;

end



always begin
    #5 clk = ~clk;
end


endmodule