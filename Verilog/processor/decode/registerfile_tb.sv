module registerfile_tb();

logic clk; 
logic rst_n; 
logic [4:0] src_reg1; 
logic [4:0] src_reg2; 
logic [4:0] dst_reg; 
logic write_reg; 
logic [31:0] dst_data; 
logic [31:0] src_data1; 
logic [31:0] src_data2;

registerfile REGFILE(
    .clk(clk), 
    .rst_n(rst_n), 
    .src_reg1(src_reg1), 
    .src_reg2(src_reg2), 
    .dst_reg(dst_reg), 
    .write_reg(write_reg), 
    .dst_data(dst_data), 
    .src_data1(src_data1), 
    .src_data2(src_data2)
);

always begin
    #5 clk = ~clk;
end

initial begin
    // Set initial values and reset
    clk = 0;
    rst_n = 0;
    src_reg1 = 0;
    src_reg2 = 0;
    dst_reg = 0;
    dst_data = 0;
    write_reg = 0;
    @(posedge clk);
    rst_n = 1;

    // TEST1 - write and read 1 register
    @(posedge clk);
    dst_reg = 5;
    dst_data = 5;
    write_reg = 1;
    @(posedge clk);
    dst_reg = 0;
    dst_data = 0;
    write_reg = 0;
    src_reg1 = 5;

    //TEST2 - write and read 2 register
    @(posedge clk);
    src_reg1 = 0;
    src_reg2 = 0;
    dst_reg = 6;
    dst_data = 6;
    write_reg = 1;
    @(posedge clk);
    dst_reg = 0;
    dst_data = 0;
    write_reg = 0;
    src_reg1 = 5;
    src_reg2 = 6;

    //TEST3 - overwrite register and read
    @(posedge clk);
    src_reg1 = 0;
    src_reg2 = 0;
    dst_reg = 5;
    dst_data = 1;
    write_reg = 1;
    @(posedge clk);
    dst_reg = 0;
    dst_data = 0;
    write_reg = 0;
    src_reg1 = 5;

    //TEST4 - rf bypassing
    @(posedge clk);
    src_reg1 = 5;
    src_reg2 = 0;
    dst_reg = 5;
    dst_data = 5;
    write_reg = 1;
    @(posedge clk);
    dst_reg = 0;
    dst_data = 0;
    write_reg = 0;
    src_reg1 = 5;

    //TEST5 - reset
    @(posedge clk);
    rst_n = 0;
    @(posedge clk);
    rst_n = 1;
    @(posedge clk);
    src_reg1 = 5;
    src_reg2 = 6;

    //TEST6 - write no enable
    @(posedge clk);
    src_reg1 = 0;
    src_reg2 = 0;
    dst_reg = 5;
    dst_data = 5;
    write_reg = 0;
    @(posedge clk);
    dst_reg = 0;
    dst_data = 0;
    src_reg1 = 5;

    #200;
    $stop;

end


endmodule