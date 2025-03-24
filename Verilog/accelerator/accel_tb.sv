module accel_tb();

logic [31:0] ship_data;
logic clk;
logic rst_n;
logic enable;
logic start;
logic valid_out;


logic [6:0] space1, space2;
logic [2:0] ship_type1, ship_type2;
logic vert1, vert2;

assign ship_data = {space1, vert1, ship_type1, space2, vert2, ship_type2, 10'b0000000000};

accelerator ACC(
    .ship_data(ship_data),
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .start(start),
    .valid_out(valid_out)
);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    rst_n = 0;
    enable = 0;
    start = 0;
    space1 = 0;
    vert1 = 0;
    ship_type1 = 0;
    space2 = 0;
    vert2 = 0;
    ship_type2 = 0;
    @(posedge clk);
    rst_n = 1;

    //send ship vals
    @(posedge clk);
    enable = 1;
    space1 = 0;
    vert1 = 0;
    ship_type1 = 0;
    space2 = 10;
    vert2 = 0;
    ship_type2 = 1;
    @(posedge clk);
    enable = 1;
    space1 = 20;
    vert1 = 0;
    ship_type1 = 2;
    space2 = 30;
    vert2 = 0;
    ship_type2 = 3;
    @(posedge clk);
    enable = 1;
    space1 = 44;
    vert1 = 1;
    ship_type1 = 4;
    space2 = 0;
    vert2 = 0;
    ship_type2 = 7;
    @(posedge clk);
    enable = 0;
    start = 1;

    #200;
    $stop();

end

endmodule