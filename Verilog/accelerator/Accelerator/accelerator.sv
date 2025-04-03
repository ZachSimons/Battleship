module accelerator(
    input [31:0] data,
    input clk,
    input rst_n,
    input update_ship,
    input start,
    input update_board,
    output valid_out
);

    
    localparam bit [2:0] ship_length[4:0] = '{2,3,3,4,5};
    localparam board_num = 0;
    
    logic unsigned [6:0] ship_pos[4:0];
    logic unsigned ship_vert[4:0];
    logic [1:0] game_state[99:0];
    logic [4:0] valid_temp;


    assign valid_out = &valid_temp;

    //ship registers
    always_ff @(posedge clk) begin
        if(~rst_n) begin //reset all ship pos/vert to 0
            for(int i = 0; i < 5; i++) begin
                ship_pos[i] <= 0;
                ship_vert[i] <= 0;
            end
        end
        else if (update_ship)begin //if update_ship is set, pull valid ship data and update respective ship registers
            if(data[23:21]<5) begin //if ship type is not 0-4, ignore it
                ship_pos[data[23:21]] <= data[31:25];
                ship_vert[data[23:21]] <= data[24];
            end
            if(data[12:10]<5) begin //if ship type is not 0-4, ignore it
                ship_pos[data[12:10]] <= data[20:14];
                ship_vert[data[12:10]] <= data[13];
            end    
        end
    end

    //gamestate register
    always_ff @(posedge clk) begin
        if(~rst_n) begin //reset game state to a full board of 0's
            game_state = '{default: '0};
        end
        else if (update_board && (data[13]==board_num))begin //if matching board is updated
            game_state[data[31:25]] <= data[22:21]; //on ppu gamestate update set square to respective status
        end
    end

    always@(*) begin
        if(~rst_n) begin
            valid_temp=5'b11111;
        end
        else if(start) begin //on accelerate start, compare each ship with the baord and with every other ship to confirm no conflicts, output a valid/not-valid signal
            valid_temp = 5'b11111;
            for(int i = 0; i < 5 ; i++) begin //for every ship
                if(~ship_vert[i]) begin //for a hori ship
                    for(int z = 0; z < ship_length[i]; z++) begin //for each sqaure in a ship
                        valid_temp[i] = valid_temp[i]&(game_state[ship_pos[i] + z] == 2'b00); //check if square is valid with board
                        for(int s = 0; s < 5; s++) begin //for each ship that is not current ship
                            if(s!=i) begin 
                                if(~ship_vert[s]) begin //for another hori ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each square in other ship
                                        valid_temp[i] = valid_temp[i]&(~((ship_pos[i]+z)==(ship_pos[s]+d))); //if squares match then invalid
                                    end
                                end
                                else begin //for a vert ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each sqaure in other ship
                                        valid_temp[i] = valid_temp[i]&(~((ship_pos[i]+z)==(ship_pos[s]+(d*10)))); //if square match then invalid
                                    end
                                end
                            end
                        end 
                    end
                end
                else begin //for a vert ship
                    for(int z = 0; z < ship_length[i]; z++) begin
                        valid_temp[i] = valid_temp[i]&(game_state[ship_pos[i] + (z*10)] == 2'b00);
                        for(int s = 0; s < 5; s++) begin //for each ship that is not current ship
                            if(s!=i) begin 
                                if(~ship_vert[s]) begin //for a hori ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each square in other ship
                                        valid_temp[i] = valid_temp[i]&(~((ship_pos[i]+(z*10))==(ship_pos[s]+d))); //if squares match then invalid
                                    end
                                end
                                else begin //for another vert ship
                                    for(int d = 0; d < ship_length[s]; d++) begin //for each sqaure in other ship
                                        valid_temp[i] = valid_temp[i]&(~((ship_pos[i]+(z*10))==(ship_pos[s]+(d*10)))); //if square match then invalid
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