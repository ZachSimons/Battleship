module PPU (rst_n,
            sys_clk,
            vga_clk, 
            r, 
            g, 
            b, 
            VGA_BLANK_N, 
            VGA_CLK, 
            VGA_HS, 
            VGA_SYNC_N, 
            VGA_VS,
            receive,
            board,
            square_update,
            square_state,
            ship_type,
            ship_section,
            vert,
            square_sel,
            ai,
            turn,
            finish);

input rst_n, sys_clk, vga_clk;
input receive;
input board;
input [6:0] square_update;
input [1:0] square_state;
input [1:0] ship_type;
input [2:0] ship_section;
input vert;
input square_sel;
input ai;
input [1:0] turn;
input [1:0] finish;

output [7:0] r, g, b;
output VGA_BLANK_N, VGA_HS, VGA_SYNC_N, VGA_VS, VGA_CLK;


// game board params
parameter BOARD_WIDTH = 173; // includes border size
parameter BOARD_HEIGHT = 173; // includes border size
parameter BORDER_WIDTH = 6;
parameter SQUARE_SIZE = 16;
parameter BOARD0_OFFSET_X = 83;
parameter BOARD0_OFFSET_Y = 170;
parameter BOARD1_OFFSET_X = 361;
parameter BOARD1_OFFSET_Y = 170;
parameter LETTERS_HEIGHT = 23;
parameter NUMBERS_WIDTH = 23;

// background params
parameter TITLE_OFFSET_X = 160;
parameter TITLE_OFFSET_Y = 16;
parameter TITLE_WIDTH = 321;
parameter TITLE_HEIGHT = 64;
parameter TURN_OFFSET_X = 170;
parameter TURN_OFFSET_Y = 94;
parameter TURN_WIDTH = 300;
parameter TURN_HEIGHT = 36;
parameter SHORELINE_OFFSET_Y = 416;
parameter WATER_WIDTH = 64;
parameter FINISH_OFFSET_X = 180;
parameter FINISH_OFFSET_Y = 170;
parameter FINISH_WIDTH = 280;
parameter FINISH_HEIGHT = 140;

// ship params
parameter SHIP2_WIDTH = 33;
parameter SHIP3_WIDTH = 49;
parameter SHIP4_WIDTH = 65;
parameter SHIP5_WIDTH = 81;

// hit and miss sprite params
parameter HIT_MISS_WIDTH = 17;

// row pixels
parameter ROW0 = BOARD0_OFFSET_Y + LETTERS_HEIGHT + BORDER_WIDTH; // figure out why we need to subtract 1
parameter ROW10 =  ROW0 + (SQUARE_SIZE * 10);

// column pixels
parameter COL0_B0 = BOARD0_OFFSET_X + NUMBERS_WIDTH + BORDER_WIDTH;
parameter COL10_B0 = COL0_B0 + (SQUARE_SIZE * 10);
parameter COL0_B1 = BOARD1_OFFSET_X + NUMBERS_WIDTH + BORDER_WIDTH;
parameter COL10_B1 = COL0_B1 + (SQUARE_SIZE * 10);

logic [9:0] next_x, next_y;
logic [7:0] r_in, g_in, b_in;
logic [7:0] rgb;
logic game_bound_logic;
logic in_game_bound;
logic letter_bound_logic;
logic in_letter_bound;
logic number_bound_logic;
logic in_number_bound;

// updating info of each square
// take in new info when receive is asserted
logic [9:0] square_info [0:1][0:99];

// update background/foreground sprites
// bit ordering {turn, finish}
logic curr_turn;
logic [1:0] curr_finish;

always_ff @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
        square_info <= '{default:10'b0};
        curr_turn <= 0;
        curr_finish <= 0;
    end
    else if (receive) begin
        // turn update bit
        if (turn[1]) begin
            curr_turn <= turn[0];
        end
        // finish update bit
        else if (finish[1]) begin
            curr_finish <= finish;
        end
        // else update square
        else begin
            square_info[board][square_update] <= {square_state, ship_type, ship_section, vert, square_sel, ai};
        end
    end
end

// current square calculation
// MSB specifies which board
// format {BOARD, SQUARE_#}
// when rst or not inside a grid default to all 1's
logic [7:0] curr_square;
logic board0_bound;
logic board1_bound;
logic [9:0] dx_b0;
logic [9:0] dx_b1;
logic [9:0] dy;
//logic [9:0] dy_b0;
//logic [9:0] dy;
logic [3:0] square_x_b0;
logic [3:0] square_x_b1;
logic [3:0] square_y;
// logic [3:0] square_y_b0;
// logic [3:0] square_y_b1;

assign board0_bound = next_x < COL10_B0 && next_x >= COL0_B0 && next_y < ROW10 && next_y >= ROW0;
assign board1_bound = next_x < COL10_B1 && next_x >= COL0_B1 && next_y < ROW10 && next_y >= ROW0;

assign dx_b0 = next_x - COL0_B0;
assign square_x_b0 = dx_b0[7:4];
assign dx_b1 = next_x - COL0_B1;
assign square_x_b1 = dx_b1[7:4];

assign dy = next_y - ROW0;
assign square_y = dy[7:4];

always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin  
        curr_square <= '1;
    end
    // check which board we are on
    else if (board0_bound) begin
        curr_square[7] <= 0;
        curr_square[6:0] <= (square_y * 10) + square_x_b0;

    end
    else if (board1_bound) begin
        curr_square[7] <= 1;
        curr_square[6:0] <= (square_y * 10) + square_x_b1; 
    end
    else begin
        curr_square <= '1;
    end
end

// game boundaries logic/regs
logic board_0_bound;
logic in_board_0;
logic board_1_bound;
logic title_bound, turn_bound, finish_bound;
logic in_title_bound, in_turn_bound, in_finish_bound;
assign board_0_bound = next_x < BOARD0_OFFSET_X+NUMBERS_WIDTH+BOARD_WIDTH & next_x > BOARD0_OFFSET_X-1 & next_y < BOARD0_OFFSET_Y+LETTERS_HEIGHT+BOARD_WIDTH & next_y > BOARD0_OFFSET_Y-1; 
assign board_1_bound = next_x < BOARD1_OFFSET_X+NUMBERS_WIDTH+BOARD_WIDTH & next_x > BOARD1_OFFSET_X-1 & next_y < BOARD1_OFFSET_Y+LETTERS_HEIGHT+BOARD_WIDTH & next_y > BOARD1_OFFSET_Y-1;
assign game_bound_logic = board_0_bound | board_1_bound;
assign title_bound = next_x < TITLE_OFFSET_X+TITLE_WIDTH & next_x >= TITLE_OFFSET_X & next_y < TITLE_OFFSET_Y+TITLE_HEIGHT & next_y >= TITLE_OFFSET_Y;
assign turn_bound = next_x < TURN_OFFSET_X+TURN_WIDTH & next_x >= TURN_OFFSET_X & next_y < TURN_OFFSET_Y+TURN_HEIGHT & next_y >= TURN_OFFSET_Y;
assign finish_bound = next_x < FINISH_OFFSET_X+FINISH_WIDTH & next_x >= FINISH_OFFSET_X & next_y < FINISH_OFFSET_Y+FINISH_HEIGHT & next_y >= FINISH_OFFSET_Y;

// logic here assumes we are in game bound
assign letter_bound_logic = next_y > BOARD0_OFFSET_Y-1 & next_y < BOARD0_OFFSET_Y+LETTERS_HEIGHT;
assign number_bound_logic = (next_x > BOARD0_OFFSET_X-1 & next_x < BOARD0_OFFSET_X+NUMBERS_WIDTH) |  (next_x > BOARD1_OFFSET_X-1 & next_x < BOARD1_OFFSET_X+NUMBERS_WIDTH);

always_ff @(posedge vga_clk) begin
    if (!rst_n) begin
        in_board_0 <= 0;
        in_game_bound <= 0;
        in_letter_bound <= 0;
        in_number_bound <= 0;
        in_title_bound <= 0;
        in_turn_bound <= 0;
        in_finish_bound <= 0;
    end 
    else begin
        in_board_0 <= board_0_bound;
        in_game_bound <= game_bound_logic;
        in_letter_bound <= letter_bound_logic;
        in_number_bound <= number_bound_logic;
        in_title_bound <= title_bound;
        in_turn_bound <= turn_bound;
        in_finish_bound <= finish_bound;
    end
end

// address comb logic for title
logic [31:0] title_addr;
assign title_addr = ((next_y - TITLE_OFFSET_Y) * (TITLE_WIDTH) + (next_x - TITLE_OFFSET_X));

// address comb logic for turn sprites
logic [31:0] turn_addr;
assign turn_addr = ((next_y - TURN_OFFSET_Y) * (TURN_WIDTH) + (next_x - TURN_OFFSET_X));

// address comb logic for board
logic [31:0] board0_addr;
logic [31:0] board1_addr;
assign board0_addr = ((next_y - BOARD0_OFFSET_Y) * (NUMBERS_WIDTH + BOARD_WIDTH)) + (next_x - BOARD0_OFFSET_X);
assign board1_addr = ((next_y - BOARD1_OFFSET_Y) * (NUMBERS_WIDTH + BOARD_WIDTH)) + (next_x - BOARD1_OFFSET_X);

// address comb logic for shoreline
logic [31:0] shoreline_addr;
assign shoreline_addr = ((next_y - SHORELINE_OFFSET_Y) * WATER_WIDTH) + (next_x % WATER_WIDTH);

// address comb logic for water
logic [31:0] water_addr;
assign water_addr = ((next_y * WATER_WIDTH) % (WATER_WIDTH * WATER_WIDTH)) + (next_x % WATER_WIDTH);

// address comb logic for end screen
logic [31:0] finish_addr;
assign finish_addr = ((next_y - FINISH_OFFSET_Y) * (FINISH_WIDTH) + (next_x - FINISH_OFFSET_X));

// signals needed for ship/sprite address calculation
logic [2:0] next_square_ship_sec;
logic [3:0] next_dx;
logic [3:0] next_square_x;
assign next_dx = board_0_bound ? dx_b0 : dx_b1;
assign next_square_x = board_0_bound ? square_x_b0 : square_x_b1;
assign next_square_ship_sec = square_info[board_1_bound][(square_y * 10) + next_square_x][5:3];

// address comb logic for ship2
logic [31:0] ship2_addr_hor;
logic [31:0] ship2_addr_vert;
assign ship2_addr_hor = (dy[3:0] * SHIP2_WIDTH) + next_dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship2_addr_vert = (SHIP2_WIDTH - 1) + (next_dx[3:0] * SHIP2_WIDTH) - dy[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship3
logic [31:0] ship3_addr_hor;
logic [31:0] ship3_addr_vert;
assign ship3_addr_hor = (dy[3:0] * SHIP3_WIDTH) + next_dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship3_addr_vert = (SHIP3_WIDTH - 1) + (next_dx[3:0] * SHIP3_WIDTH) - dy[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship4
logic [31:0] ship4_addr_hor;
logic [31:0] ship4_addr_vert;
assign ship4_addr_hor = (dy[3:0] * SHIP4_WIDTH) + next_dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship4_addr_vert = (SHIP4_WIDTH - 1) + (next_dx[3:0] * SHIP4_WIDTH) - dy[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship5
logic [31:0] ship5_addr_hor;
logic [31:0] ship5_addr_vert;
assign ship5_addr_hor = (dy[3:0] * SHIP5_WIDTH) + next_dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship5_addr_vert = (SHIP5_WIDTH - 1) + (next_dx[3:0] * SHIP5_WIDTH) - dy[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// hit/miss sprite address calculation
// different address for each board
logic [31:0] hit_miss_addr_b0;
logic [31:0] hit_miss_addr_b1;
assign hit_miss_addr_b0 = (dy[3:0] * HIT_MISS_WIDTH) + next_dx[3:0];
assign hit_miss_addr_b1 = (dy[3:0] * HIT_MISS_WIDTH) + next_dx[3:0];

// current square values
// mux select values to output correct pixel
logic [9:0] curr_square_data;
logic [1:0] curr_square_state;
logic [1:0] curr_ship_type; 
logic curr_vert;
logic curr_square_sel;
logic curr_ai;
assign curr_square_data = square_info[curr_square[7]][curr_square[6:0]];
assign curr_square_state = curr_square_data[9:8];
assign curr_ship_type = curr_square_data[7:6];
assign curr_vert = curr_square_data[2];
assign curr_square_sel = curr_square_data[1];
assign curr_ai = curr_square_data[0];

// board sprite memory
logic [7:0] rgb_board_b0;
logic [7:0] rgb_board_b1;

board_labels_rom rom0 (
	.address_a(board0_addr),
    .address_b(board1_addr),
	.clock(vga_clk),
	.q_a(rgb_board_b0),
    .q_b(rgb_board_b1));

// chooose board output and apply blue filter for game border
logic [7:0] board_sel;
logic [7:0] rgb_board_filtered;
assign board_sel = (in_board_0) ? rgb_board_b0 : rgb_board_b1;
assign rgb_board_filtered = (board_sel == 8'h14 || board_sel == 8'hBC) ? (board_sel >> 2) : board_sel;

// shoreline sprite memory
logic [15:0] rgb_shoreline;
shoreline_rom rom0_1 (
	.address(shoreline_addr),
	.clock(vga_clk),
	.q(rgb_shoreline));

// water sprite memory
logic [15:0] rgb_water;
water_rom rom0_2 (
	.address(water_addr),
	.clock(vga_clk),
	.q(rgb_water));

// title sprite memory
logic [7:0] rgb_title;
title_rom rom0_3 (
    .address(title_addr),
	.clock(vga_clk),
	.q(rgb_title));

// waiting spite memory
logic [7:0] rgb_turn;
logic [7:0] rgb_waiting;
waiting_rom rom0_4 (
    .address(turn_addr),
	.clock(vga_clk),
	.q(rgb_waiting));

// your turn sprite memory
logic [7:0] rgb_your_turn;
your_turn_rom rom0_5 (
    .address(turn_addr),
	.clock(vga_clk),
	.q(rgb_your_turn));

// comb logic to choose which subtext to display based off PPU data
assign rgb_turn = curr_turn ? rgb_your_turn : rgb_waiting;

// you win sprite memory
logic [7:0] rgb_finish;
logic [7:0] rgb_win;
win_screen_rom rom0_6 (
    .address(finish_addr),
	.clock(vga_clk),
	.q(rgb_win));

// you lose sprite memory
logic [7:0] rgb_lose;
lose_screen_rom rom0_7 (
    .address(finish_addr),
	.clock(vga_clk),
	.q(rgb_lose));

assign rgb_finish = curr_finish[0] ? rgb_win : rgb_lose;

// ship 2 sprite memrory
logic [7:0] rgb_ship2_hor;
logic [7:0] rgb_ship2_vert;
ship2_rom rom1 (
    .address_a(ship2_addr_hor),
    .address_b(ship2_addr_vert),
	.clock(vga_clk),
	.q_a(rgb_ship2_hor),
    .q_b(rgb_ship2_vert));

// ship 3 sprite memory
logic [7:0] rgb_ship3_hor;
logic [7:0] rgb_ship3_vert;
ship3_rom rom2 (
    .address_a(ship3_addr_hor),
    .address_b(ship3_addr_vert),
	.clock(vga_clk),
	.q_a(rgb_ship3_hor),
    .q_b(rgb_ship3_vert));

logic [7:0] rgb_ship4_hor;
logic [7:0] rgb_ship4_vert;
ship4_rom rom3 (
    .address_a(ship4_addr_hor),
    .address_b(ship4_addr_vert),
	.clock(vga_clk),
	.q_a(rgb_ship4_hor),
    .q_b(rgb_ship4_vert));

logic [7:0] rgb_ship5_hor;
logic [7:0] rgb_ship5_vert;
ship5_rom rom4 (
    .address_a(ship5_addr_hor),
    .address_b(ship5_addr_vert),
	.clock(vga_clk),
	.q_a(rgb_ship5_hor),
    .q_b(rgb_ship5_vert));

// miss player memory
logic [7:0] rgb_miss_player;
miss_player_rom rom5 (
	.address(hit_miss_addr_b0),
	.clock(vga_clk),
	.q(rgb_miss_player));

// hit player memory
logic [7:0] rgb_hit_player;
hit_player_rom rom6 (
	.address(hit_miss_addr_b0),
	.clock(vga_clk),
	.q(rgb_hit_player));

// miss ship memory
logic [7:0] rgb_miss_ship;
miss_ship_rom rom7 (
	.address(hit_miss_addr_b1),
	.clock(vga_clk),
	.q(rgb_miss_ship));

// hit ship memory
logic [7:0] rgb_hit_ship;
hit_ship_rom rom8 (
	.address(hit_miss_addr_b1),
	.clock(vga_clk),
	.q(rgb_hit_ship));

//ship type mux
logic [7:0] ship_type_mux;
always_comb begin
    case (curr_ship_type)
        2'b00 : ship_type_mux = curr_vert ? rgb_ship2_vert : rgb_ship2_hor;
        2'b01 : ship_type_mux = curr_vert ? rgb_ship3_vert : rgb_ship3_hor;
        2'b10 : ship_type_mux = curr_vert ? rgb_ship4_vert : rgb_ship4_hor;
        2'b11 : ship_type_mux = curr_vert ? rgb_ship5_vert : rgb_ship5_hor; 
    endcase
end

// object mux
// check which board for miss and hit sprites as we have a diff sprites for each board
logic [7:0] object_mux;
always_comb begin
    case(curr_square_state & {2{(curr_square != 8'hFF)}})
        2'b00 : object_mux = rgb_board_filtered; // board pixel
        2'b01 : object_mux = curr_square[7] ? rgb_miss_ship : rgb_miss_player; // miss pixel
        2'b10 : object_mux = curr_square[7] ? rgb_hit_ship : rgb_hit_player; // hit pixel
        2'b11 : object_mux = ship_type_mux; // ship pixel
    endcase
end

// flop dx and dy signals to check if we are not currently on grid line
// this is needed for the square_sel signal
// also flop next_y for shoreline sprite
logic [3:0] curr_off_x_b0, curr_off_y; 
logic [9:0] curr_y;
always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        curr_off_x_b0 <= 0;
        curr_off_y <= 0;
        curr_y <= 0;
    end
    else begin
        curr_off_x_b0 <= dx_b0[3:0];
        curr_off_y <= dy[3:0];
        curr_y <= next_y;
    end
end

logic on_grid_y;
logic on_grid_x;
assign on_grid_x = (curr_off_x_b0 == 0);
assign on_grid_y = (curr_off_y == 0);

// final rgb mux & calculations to checks if we need to invert pixel or set pixel green for AI algo

// make ai square on screen green
logic [7:0] rgb_ai;
assign rgb_ai = (~(on_grid_x | on_grid_y) & curr_ai) ? 8'b000_111_00 : object_mux;
assign rgb = (~(on_grid_x | on_grid_y) & curr_square_sel) ? ~rgb_ai : rgb_ai;

// logic to add background sprites
logic [7:0] r_game_text, g_game_text, b_game_text;

assign r_game_text = (in_title_bound & (rgb_title != 8'h00)) ? {rgb_title[7:5], 5'b0} : 
                     (in_turn_bound & (rgb_turn != 8'h00)) ?  {rgb_turn[7:5], 5'b0}  :  
                     {rgb_water[15:11], 3'b0};

assign g_game_text = (in_title_bound & (rgb_title != 8'h00)) ? {rgb_title[4:2], 5'b0} : 
                     (in_turn_bound & (rgb_turn != 8'h00)) ? {rgb_turn[4:2], 5'b0}   : 
                     {rgb_water[10:5], 2'b0};

assign b_game_text = (in_title_bound & (rgb_title != 8'h00)) ? {rgb_title[1:0], 6'b0} : 
                     (in_turn_bound & (rgb_turn != 8'h00)) ? {rgb_turn[1:0], 6'b0} :
                     {rgb_water[4:0], 3'b0};


// back ground rgb values
logic [7:0] r_back, g_back, b_back;
assign r_back = (curr_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[15:11], 3'b0} : r_game_text;
assign g_back = (curr_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[10:5], 2'b0} : g_game_text;
assign b_back = (curr_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[4:0], 3'b0} : b_game_text;

// main game rgb
// set transparency on numbers & letters so black background doesn't show
logic [7:0] r_game, g_game, b_game;
assign r_game = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[15:11], 3'b0} : {rgb[7:5], 5'b0}) : r_back;
assign g_game = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[10:5], 2'b0} : {rgb[4:2], 5'b0}) : g_back;
assign b_game = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[4:0], 3'b0} : {rgb[1:0], 6'b0}) : b_back;

// overiide all pixel in finish bound with finish sprite once game ends
assign r_in = (in_finish_bound & curr_finish[1]) ? {rgb_finish[7:5], 5'b0} : r_game;
assign g_in = (in_finish_bound & curr_finish[1]) ? {rgb_finish[4:2], 5'b0} : g_game;
assign b_in = (in_finish_bound & curr_finish[1]) ? {rgb_finish[1:0], 6'b0} : b_game;

// vga controller
vga_driver draw   ( .clock(vga_clk),        // 25 MHz PLL
                    .rst_n(rst_n),      // Active high reset, manipulated by instantiating module
                    .r_in(r_in),               // Pixel colors for pixel being drawn
                    .g_in(g_in),
                    .b_in(b_in),
                    .next_x(next_x),        // X-coordinate (range [0, 639]) of next pixel to be drawn
                    .next_y(next_y),        // Y-coordinate (range [0, 479]) of next pixel to be drawn
                    .hsync(VGA_HS),         // All of the connections to the VGA screen below
                    .vsync(VGA_VS),
                    .red(r),
                    .green(g),
                    .blue(b),
                    .sync(VGA_SYNC_N),
                    .clk(VGA_CLK),
                    .blank(VGA_BLANK_N)
);

endmodule