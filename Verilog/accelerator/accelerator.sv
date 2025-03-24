module accelerator(
    input [31:0] ship_data,
    input clk,
    input rst_n,
    input enable,
    input start,
    output valid_out
);

    logic [6:0] ship_pos[4:0];
    localparam [2:0] ship_length[4:0] = '{2,3,3,4,5};
    logic ship_vert[4:0];

    logic [1:0] game_state[99:0];
    logic [4:0] test;


    assign valid_out = &test;

    //ship registers
    always_ff @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            for(int i = 0; i < 5; i++) begin
                ship_pos[i] <= 0;
                ship_vert[i] <= 0;
            end
        end
        else if (enable)begin
            if(ship_data[23:21]<5) begin
                ship_pos[ship_data[23:21]] <= ship_data[31:25];
                ship_vert[ship_data[23:21]] <= ship_data[24];
            end
            if(ship_data[12:10]<5) begin
                ship_pos[ship_data[12:10]] <= ship_data[20:14];
                ship_vert[ship_data[12:10]] <= ship_data[13];
            end    
        end
    end

    //gamestate register
    always_ff @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            for(int i = 0; i < 100; i++) begin
                game_state[i] <= 0;
            end
        end
        else begin
            //update register here from memory
            //game_state[0] <= 2'b01;
            //game_state[57] <= 2'b01;
        end
    end

    always@(*) begin
        if(~rst_n) begin
            test=5'b11111;
        end
        else if(start) begin //on accelerate start, compare each ship with the baord and with every other ship to confirm no conflicts, output a valid/not-valid signal
            test = 5'b11111;
            for(int i = 0; i < 5 ; i++) begin //for every ship
                if(~ship_vert[i]) begin //for a hori ship
                    for(int z = 0; z < ship_length[i]; z++) begin //for each sqaure in a ship
                        test[i] = test[i]&(game_state[ship_pos[i] + z] == 2'b00); //check if square is valid with board
                        for(int s = 0; s < 5; s++) begin //for each ship that is not current ship
                            if(s!=i) begin 
                                if(~ship_vert[s]) begin //for another hori ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each square in other ship
                                        test[i] = test[i]&(~((ship_pos[i]+z)==(ship_pos[s]+d))); //if squares match then invalid
                                    end
                                end
                                else begin //for a vert ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each sqaure in other ship
                                        test[i] = test[i]&(~((ship_pos[i]+z)==(ship_pos[s]+(d*10)))); //if square match then invalid
                                    end
                                end
                            end
                        end 
                    end
                end
                else begin //for a vert ship
                    for(int z = 0; z < ship_length[i]; z++) begin
                        test[i] = test[i]&(game_state[ship_pos[i] + (z*10)] == 2'b00);
                        for(int s = 0; s < 5; s++) begin //for each ship that is not current ship
                            if(s!=i) begin 
                                if(~ship_vert[s]) begin //for a hori ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each square in other ship
                                        test[i] = test[i]&(~((ship_pos[i]+(z*10))==(ship_pos[s]+d))); //if squares match then invalid
                                    end
                                end
                                else begin //for another vert ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each sqaure in other ship
                                        test[i] = test[i]&(~((ship_pos[i]+(z*10))==(ship_pos[s]+(d*10)))); //if square match then invalid
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

endmodule