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
//Varable Initalization
clk = 0;
rst_n = 0;
branch = 0;
rti = 0;
rsi = 0;
interrupt_eth = 0;
interrupt_key = 0;
prog_en = 0;
prog_data = 0;
prog_addr = 0;
pc_ex = 0;
pc_tracker = 4; 
err_cnt = 0;

repeat(2) @(posedge clk);

@(negedge clk)
//Test that PC is incremnenting by 4 each cycle
rst_n = 1;
for(int i = 0; i < 4; i++) begin
    @(posedge clk);
    #1
    if(pc_dec != pc_tracker) begin
        $display("PC didn't increment correctly on iteration %d", i);
        err_cnt++;
    end
    pc_tracker += 4;
end


//Test that branch command causes pc_ex to be used
@(negedge clk)
pc_ex = 32'd796;
branch = 1;

@(posedge clk);
#1;
if(pc_dec != 32'd800) begin
    $display("pc_ex wasn't used");
    err_cnt++;
end


//Test that interrupt causes PC to be stored in i-reg and pc is set to 4
@(negedge clk);
branch = 0;
pc_ex = 0;
interrupt_eth = 1;

@(posedge clk);
#1;
interrupt_eth = 0; //Deassert the interrupt flag
if(pc_dec != 32'd8) begin
    $display("interrupt PC didn't update");
    err_cnt++;
end


if(idut.i_reg != 32'd800) begin
    $display("i_reg has incorrect value");
    err_cnt++;
end

@(posedge clk);
#1;
if(pc_dec != 32'd12) begin
    $display("PC after interrrupt didn't increment properly");
    err_cnt++;
end


//Test that another interrupt can't happen until RTI or RSI are asserted
@(negedge clk);
interrupt_key = 1;

@(posedge clk)
#1
interrupt_key = 0;
if(idut.i_reg != 32'd800) begin
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

@(posedge clk)
#1
rti = 0;
if(pc_dec != 32'd804) begin
    $display("failed to return from interrupt");
    err_cnt++;
end

//Test that the other interrupt type can cause interrupt
@(negedge clk);
interrupt_key = 1;

@(posedge clk)
#1
interrupt_key = 0;
if(pc_dec != 32'd8) begin
    $display("interrupt wasn't handled proprely");
    err_cnt++;
end

if(idut.i_reg != 32'd800) begin //Problem for tomorrow
    $display("i_reg updated when it shouldn't have");
    err_cnt++;
end
//Test that rsi clears i-reg and uses next instruction



//Test that instruction memory can be programmed and works (may have to do more testing after break)

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