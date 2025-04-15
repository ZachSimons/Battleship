`timescale 1 ps / 1 ps
module mem_stage_tb();

//Input
logic         clk;
logic         rst_n;
logic         mem_unsigned_mem;
logic         mem_rd_en_mem;
logic         mem_wrt_en_mem;
logic         reg_wrt_en_mem;
logic         random_mem;
logic         rdi_mem;
logic [1:0]   width_mem;
logic [1:0]   wb_sel_mem;
logic [4:0]   wrt_reg_mem;
logic [31:0]  pc_mem;
logic [31:0]  rdi_data;
logic [31:0]  reg2_data_mem;
logic [31:0]  alu_mem;

//Ouput
logic        reg_wrt_en_wb;
logic        mem_error;
logic [1:0]  wb_sel_wb;
logic [4:0]  wrt_reg_wb;
logic [31:0] read_data_wb;
logic [31:0] pc_wb;
logic [31:0] alu_wb;

memory idut (
    .clk(clk),
    .rst_n(rst_n),
    .mem_unsigned_mem(mem_unsigned_mem),
    .mem_rd_en_mem(mem_rd_en_mem),
    .mem_wrt_en_mem(mem_wrt_en_mem),
    .reg_wrt_en_mem(reg_wrt_en_mem),
    .random_mem(random_mem),
    .rdi_mem(rdi_mem),
    .width_mem(width_mem),
    .wb_sel_mem(wb_sel_mem),
    .wrt_reg_mem(wrt_reg_mem),
    .pc_mem(pc_mem),
    .rdi_data(rdi_data),      
    .reg2_data_mem(reg2_data_mem),
    .alu_mem(alu_mem),
    .reg_wrt_en_wb(reg_wrt_en_wb),
    .mem_error(mem_error),
    .wb_sel_wb(wb_sel_wb),
    .wrt_reg_wb(wrt_reg_wb),
    .read_data_wb(read_data_wb),
    .pc_wb(pc_wb),
    .alu_wb(alu_wb)
);

initial begin
    clk = 0;
    rst_n = 0;
    mem_unsigned_mem = 0;
    mem_rd_en_mem = 0;
    mem_wrt_en_mem = 0;
    reg_wrt_en_mem = 0;
    random_mem = 0;
    rdi_mem = 1; //Default value
    width_mem = 0; //Full width
    wb_sel_mem = 0;
    wrt_reg_mem = 0;
    pc_mem = 0;
    rdi_data = 0;
    reg2_data_mem = 32'hdeadbeef; //Write Data
    alu_mem = 4; //Write address

    //Things to test. Functionality of memory_wrapper (single read and write)
    repeat(2) @(negedge clk);
    //Setup for interfacing with memory
    rst_n = 1;
    mem_wrt_en_mem = 1;
    repeat(2) @(negedge clk);
    mem_wrt_en_mem = 0;
    mem_rd_en_mem = 1;
    repeat(3) @(posedge clk);
    #1;
    if(read_data_wb != 32'hdeadbeef) begin
        $disply("Basic memory test failed");
        $stop;
    end
    
    //Setting back to default
    @(negedge clk);
    mem_rd_en_mem = 0; 
    reg2_data_mem = 0;
    alu_mem = 0;
    //Setup for LFSR
    random_mem = 1;
    repeat(1000) @(posedge clk);
    //Manually check to see if all the values are random


    @(negedge clk);
    reg_wrt_en_mem = 1;
    wb_sel_mem = 2;
    wrt_reg_mem = 17;
    pc_mem = 32'hdeadbeef;
    alu_mem = 32'hbeefdead;
    rdi_data = 32'hF8F8F8F8;
    rdi_mem = 0;
    @(negedge clk);

    //Check passthrough on wb signals
    $stop;

end



always begin
    #5 clk = ~clk;
end



endmodule