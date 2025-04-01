module pc_sync_tb();

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


initial begin
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
    pc_ex = 6;

    repeat(2) @(posedge clk);

    @(negedge clk);
    rst_n = 1;


    repeat(10) @(posedge clk);
    @(negedge clk);
    branch = 1;

    @(negedge clk);
    branch = 0;
    repeat(10) @(posedge clk);
    $stop;
end




always begin
    #5 clk = ~clk;
end


endmodule