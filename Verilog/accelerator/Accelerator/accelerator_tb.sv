module accelerator_tb;
    // DUT Inputs
    reg [31:0] data;
    reg clk, rst_n, update_ship, start, update_board;
    
    // DUT Output
    wire valid_out;

    // Instantiate DUT
    accelerator dut (
        .data(data),
        .clk(clk),
        .rst_n(rst_n),
        .update_ship(update_ship),
        .start(start),
        .update_board(update_board),
        .valid_out(valid_out)
    );

    // Game state and ship definitions
    reg [1:0] board [0:99];   // 10x10 board
    reg [6:0] ship_positions[4:0];  // Ship start positions
    reg ship_orientations[4:0];     // 0 = horizontal, 1 = vertical
    localparam [2:0] ship_lengths[4:0] = '{2,3,3,4,5};

    integer i, j, s, z;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Reset logic
    initial begin
        clk = 0;
        rst_n = 0;
        update_ship = 0;
        update_board = 0;
        start = 0;
        #10 rst_n = 1;
    end

    // Task to randomly initialize the board
    task init_board;
        for (i = 0; i < 100; i = i + 1) begin
            board[i] = (i % 10 == 0) ? 2'b01 : 2'b00;  // Block some squares
        end
    endtask

    // Task to place ships randomly ensuring they don’t go off the board
    task place_ships;
        for (s = 0; s < 5; s = s + 1) begin
            ship_orientations[s] = $random % 2; // 0 = horizontal, 1 = vertical
            if (ship_orientations[s]) begin
                ship_positions[s] = $random % (100 - 10 * (ship_lengths[s] - 1));
            end else begin
                ship_positions[s] = ($random % 10) + 10 * ($random % (10 - (ship_lengths[s] - 1)));
            end
        end
    endtask

    // Task to send ship placement data to DUT
    task send_ships;
        update_ship = 1;
        for (s = 0; s < 5; s = s + 1) begin
            data = {ship_positions[s], ship_orientations[s], s, 8'b0};
            #10;
        end
        update_ship = 0;
    endtask

    // Task to update board state
    task send_board;
        update_board = 1;
        for (i = 0; i < 100; i = i + 1) begin
            data = {i, board[i], 8'b0};
            #5;
        end
        update_board = 0;
    endtask

    // Task to validate expected vs actual results
    task check_validity;
    reg [4:0] expected_valid;
    integer s, j, z, i;
    integer pos, other_pos;

    expected_valid = 5'b11111; // Assume all ships are valid at the start
    pos = 0;
    other_pos = 0;

    for (s = 0; s < 5; s = s + 1) begin
        for (z = 0; z < ship_lengths[s]; z = z + 1) begin
            pos = ship_positions[s] + (ship_orientations[s] ? z * 10 : z);
            $display("Checking ship %d, position %d (z=%d)", s, pos, z);

            if (board[pos] !== 2'b00) begin
                expected_valid[s] = 0;
                $display("Ship %d invalid due to board position %d", s, pos);
            end

            for (j = 0; j < s; j = j + 1) begin
                for (i = 0; i < ship_lengths[j]; i = i + 1) begin
                    other_pos = ship_positions[j] + (ship_orientations[j] ? i * 10 : i);
                    if (pos == other_pos) begin
                        expected_valid[s] = 0;
                        $display("Ship %d invalid due to overlap with ship %d at %d", s, j, pos);
                    end
                end
            end
        end
    end

    #10;
    $display("Final expected_valid: %b", expected_valid);
    $display("valid_out: %b", valid_out);

    if (valid_out === &expected_valid)
        $display("Test Passed! Expected valid: %b, Got: %b", expected_valid, valid_out);
    else
        $display("Test Failed! Expected valid: %b, Got: %b", expected_valid, valid_out);
endtask

    // Test sequence
    initial begin
        init_board();
        place_ships();
        send_board();
        send_ships();

        #10 start = 1;
        #10 start = 0;

        check_validity();

        $stop;
    end
endmodule