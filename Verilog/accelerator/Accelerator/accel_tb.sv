module accel_tb();

logic [31:0] data;
logic clk;
logic rst_n;
logic update_ship;
logic update_board;
logic start;
logic valid_out;


logic [6:0] space1, space2;
logic [2:0] ship_type1, ship_type2;
logic vert1, vert2;

logic [1:0] board [99:0];
logic ship_orientations[4:0];
logic [6:0] ship_positions[4:0];
localparam [2:0] ship_lengths[4:0] = '{2,3,3,4,5};

assign data = {space1, vert1, ship_type1, space2, vert2, ship_type2, 10'b0000000000};

accelerator ACC(
    .data(data),
    .clk(clk),
    .rst_n(rst_n),
    .update_ship(update_ship),
    .start(start),
    .update_board(update_board),
    .valid_out(valid_out)
);

always begin
    #5 clk = ~clk;
end


task init_board;
    automatic int z = 20;
    for (int i = 0; i < 100; i = i + 1) begin
        @(posedge clk);
        update_board = 1;
        vert2 = 0;
        if(z>0) begin
            if(($random % 4)==0) begin
                board[i] = 2'b01;
                space1 = i;
                ship_type1 = 2'b01;
                z--;
            end
            else begin
                board[i] = 2'b00;
                space1 = i;
                ship_type1 = 2'b00;
            end
        end
        else begin
            board[i] = 2'b00;
            space1 = i;
            ship_type1 = 2'b00;
        end
    end
    @(posedge clk);
    update_board = 0;
endtask

task place_ships;
    for (int s = 0; s < 5; s = s + 1) begin
        ship_orientations[s] = $random % 2; // 0 = horizontal, 1 = vertical
        if (ship_orientations[s]) begin
            ship_positions[s] = $random % (100 - 10 * (ship_lengths[s] - 1));
        end else begin
            ship_positions[s] = ($random % 10) + 10 * ($random % (10 - (ship_lengths[s] - 1)));
        end
    end

    @(posedge clk);
    update_ship=1;
    space1=ship_positions[0];
    vert1=ship_orientations[0];
    ship_type1=0;
    space2=ship_positions[1];
    vert2=ship_orientations[1];
    ship_type2=1;
    @(posedge clk);
    space1=ship_positions[2];
    vert1=ship_orientations[2];
    ship_type1=2;
    space2=ship_positions[3];
    vert2=ship_orientations[3];
    ship_type2=3;
    @(posedge clk);
    space1=ship_positions[4];
    vert1=ship_orientations[4];
    ship_type1=4;
    space2=ship_positions[0];
    vert2=ship_orientations[0];
    ship_type2=7;
    @(posedge clk);
    update_ship = 0;

endtask

task reset;
    clk = 0;
    rst_n = 0;
    update_ship = 0;
    start = 0;
    space1 = 0;
    vert1 = 0;
    ship_type1 = 0;
    space2 = 0;
    vert2 = 0;
    ship_type2 = 0;
    update_board = 0;
endtask

initial begin
    start = 0;
        reset();
        @(posedge clk);
        rst_n = 1;
        init_board();
        @(posedge clk);
        place_ships();
        @(posedge clk);
        start = 1;
        #100;
        @(posedge clk);
    while(valid_out != 1) begin
        start = 0;
        reset();
        @(posedge clk);
        rst_n = 1;
        init_board();
        @(posedge clk);
        place_ships();
        @(posedge clk);
        start = 1;
        #100;
        @(posedge clk);
    end

    $stop();

end

endmodule