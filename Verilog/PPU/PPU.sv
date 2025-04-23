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
            square_sel);

input rst_n, sys_clk, vga_clk;
input receive;
input board;
input [6:0] square_update;
input [1:0] square_state;
input [1:0] ship_type;
input [2:0] ship_section;
input vert;
input square_sel;

output [7:0] r, g, b;
output VGA_BLANK_N, VGA_HS, VGA_SYNC_N, VGA_VS, VGA_CLK;


// game board params
parameter BOARD_WIDTH = 173; // includes border size
parameter BOARD_HEIGHT = 173; // includes border size
parameter BORDER_WIDTH = 6;
parameter SQUARE_SIZE = 16;
parameter BOARD_OFFSET_X = 234;
parameter BOARD1_OFFSET_Y = 34;
parameter LETTERS_HEIGHT = 22;
parameter NUMBERS_WIDTH = 23;

parameter BOARD2_OFFSET_Y = BOARD1_OFFSET_Y + LETTERS_HEIGHT + BOARD_HEIGHT;

// water params
parameter SHORELINE_OFFSET_Y = 416;
parameter WATER_WIDTH = 64;

// ship params
parameter SHIP2_WIDTH = 33;
parameter SHIP3_WIDTH = 49;
parameter SHIP4_WIDTH = 65;
parameter SHIP5_WIDTH = 81;

// hit and miss sprite params
parameter HIT_MISS_WIDTH = 17;

// row pixels
parameter ROW0_B0 = BOARD1_OFFSET_Y + LETTERS_HEIGHT + BORDER_WIDTH; // figure out why we need to subtract 1
parameter ROW10_B0 =  ROW0_B0 + (SQUARE_SIZE * 10);
parameter ROW0_B1 = BOARD2_OFFSET_Y + LETTERS_HEIGHT + BORDER_WIDTH;
parameter ROW10_B1 =  ROW0_B1 + (SQUARE_SIZE * 10);

// column pixels
parameter COL0 = BOARD_OFFSET_X + NUMBERS_WIDTH + BORDER_WIDTH;
parameter COL10 = COL0 + (SQUARE_SIZE * 10);

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
logic [8:0] square_info [0:1][0:99];
always_ff @(posedge sys_clk, negedge rst_n) begin
    if (!rst_n) begin
        square_info <= '{default:9'b0};
    end
    else if (receive) begin
        square_info[board][square_update] <= {square_state, ship_type, ship_section, vert, square_sel};
    end
end

// current square calculation
// MSB specifies which board
// format {BOARD, SQUARE_#}
// when rst or not inside a grid default to all 1's
logic [7:0] curr_square;
logic board0_bound;
logic board1_bound;
logic [9:0] dx;
logic [9:0] dy_b0;
logic [9:0] dy_b1;
logic [3:0] square_x;
logic [3:0] square_y_b0;
logic [3:0] square_y_b1;

assign board0_bound = next_x < COL10 && next_x >= COL0 && next_y < ROW10_B0 && next_y >= ROW0_B0;
assign board1_bound = next_x < COL10 && next_x >= COL0 && next_y < ROW10_B1 && next_y >= ROW0_B1;
assign dx = next_x - COL0;
assign square_x = dx[7:4];
assign dy_b0 = next_y - ROW0_B0;
assign dy_b1 = next_y - ROW0_B1;
assign square_y_b0 = dy_b0[7:4];
assign square_y_b1 = dy_b1[7:4];

always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin  
        curr_square <= '1;
    end
    // check which board we are on
    else if (board0_bound) begin
        curr_square[7] <= 0;
        curr_square[6:0] <= (square_y_b0 * 10) + square_x;

    end
    else if (board1_bound) begin
        curr_square[7] <= 1;
        curr_square[6:0] <= (square_y_b1 * 10) + square_x; 
    end
    else begin
        curr_square <= '1;
    end
end

// game boundaries logic/regs
assign game_bound_logic = next_x < NUMBERS_WIDTH+BOARD_WIDTH+BOARD_OFFSET_X && next_x > BOARD_OFFSET_X-1 && next_y < LETTERS_HEIGHT+BOARD_HEIGHT+BOARD2_OFFSET_Y && next_y > BOARD1_OFFSET_Y-1;

assign letter_bound_logic =   next_x < BOARD_WIDTH+BOARD_OFFSET_X+NUMBERS_WIDTH && 
                              next_x > BOARD_OFFSET_X-1 && 
                              ((next_y < BOARD1_OFFSET_Y+LETTERS_HEIGHT
                             && next_y > BOARD1_OFFSET_Y-1) || 
                               (next_y < BOARD2_OFFSET_Y+LETTERS_HEIGHT
                             && next_y > BOARD2_OFFSET_Y-1));

assign number_bound_logic = next_x > BOARD_OFFSET_X-1 && next_x < BOARD_OFFSET_X+NUMBERS_WIDTH && next_y > BOARD1_OFFSET_Y-1 && next_y < LETTERS_HEIGHT+BOARD_HEIGHT+BOARD2_OFFSET_Y;


always_ff @(posedge vga_clk) begin
    if (!rst_n) begin
        in_game_bound <= 0;
        in_letter_bound <= 0;
        in_number_bound <= 0;
    end 
    else begin
        in_game_bound <= game_bound_logic;
        in_letter_bound <= letter_bound_logic;
        in_number_bound <= number_bound_logic;
    end
end

// address reg for board
// only increment addr if we are within game bounds
logic [31:0] board_addr;
always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        board_addr <= 0;
    end
    else if (board_addr == ((BOARD_WIDTH + NUMBERS_WIDTH) * (BOARD_HEIGHT + LETTERS_HEIGHT) - 1)) begin
        board_addr <= 0;
    end
    else if (game_bound_logic) begin
        // always horizontal so add 1
        board_addr <= board_addr + 1;
    end
end

// address comb logic for shoreline
logic [31:0] shoreline_addr;
assign shoreline_addr = ((next_y - SHORELINE_OFFSET_Y) * WATER_WIDTH) + (next_x % WATER_WIDTH);

// address comb logic for water
logic [31:0] water_addr;
assign water_addr = ((next_y * WATER_WIDTH) % (WATER_WIDTH * WATER_WIDTH)) + (next_x % WATER_WIDTH);



// signals needed for ship address calculation
logic [2:0] next_square_ship_sec;
assign next_square_ship_sec = square_info[1][(square_y_b1 * 10) + square_x][4:2];

// address comb logic for ship2
logic [31:0] ship2_addr_hor;
logic [31:0] ship2_addr_vert;
assign ship2_addr_hor = (dy_b1[3:0] * SHIP2_WIDTH) + dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship2_addr_vert = (SHIP2_WIDTH - 1) + (dx[3:0] * SHIP2_WIDTH) - dy_b1[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship3
logic [31:0] ship3_addr_hor;
logic [31:0] ship3_addr_vert;
assign ship3_addr_hor = (dy_b1[3:0] * SHIP3_WIDTH) + dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship3_addr_vert = (SHIP3_WIDTH - 1) + (dx[3:0] * SHIP3_WIDTH) - dy_b1[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship4
logic [31:0] ship4_addr_hor;
logic [31:0] ship4_addr_vert;
assign ship4_addr_hor = (dy_b1[3:0] * SHIP4_WIDTH) + dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship4_addr_vert = (SHIP4_WIDTH - 1) + (dx[3:0] * SHIP4_WIDTH) - dy_b1[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// address comb logic for ship5
logic [31:0] ship5_addr_hor;
logic [31:0] ship5_addr_vert;
assign ship5_addr_hor = (dy_b1[3:0] * SHIP5_WIDTH) + dx[3:0] + (next_square_ship_sec * SQUARE_SIZE); 
assign ship5_addr_vert = (SHIP5_WIDTH - 1) + (dx[3:0] * SHIP5_WIDTH) - dy_b1[3:0] - (next_square_ship_sec * SQUARE_SIZE);

// hit/miss sprite address calculation
// different address for each board
logic [31:0] hit_miss_addr_b0;
logic [31:0] hit_miss_addr_b1;
assign hit_miss_addr_b0 = (dy_b0[3:0] * HIT_MISS_WIDTH) + dx[3:0];
assign hit_miss_addr_b1 = (dy_b1[3:0] * HIT_MISS_WIDTH) + dx[3:0];

// current square values
// mux select values to output correct pixel
logic [8:0] curr_square_data;
logic [1:0] curr_square_state;
logic [1:0] curr_ship_type; 
logic curr_vert;
logic curr_square_sel;
assign curr_square_data = square_info[curr_square[7]][curr_square[6:0]];
assign curr_square_state = curr_square_data[8:7];
assign curr_ship_type = curr_square_data[6:5];
assign curr_vert = curr_square_data[1];
assign curr_square_sel = curr_square_data[0];

// board sprite memory
logic [7:0] rgb_board;
board_labels_rom rom0 (
	.address(board_addr),
	.clock(vga_clk),
	.q(rgb_board));

// blue filter for game border
logic [7:0] rgb_board_filtered;
assign rgb_board_filtered = (rgb_board == 8'h14 || rgb_board == 8'hBC) ? (rgb_board >> 2) : rgb_board;

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
logic [3:0] curr_off_x, curr_off_y_b0;
always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        curr_off_x <= 0;
        curr_off_y_b0 <= 0;
    end
    else begin
        curr_off_x <= dx[3:0];
        curr_off_y_b0 <= dy_b0[3:0];
    end
end

logic on_grid_y;
logic on_grid_x;
assign on_grid_x = (curr_off_x == 0);
assign on_grid_y = (curr_off_y_b0 == 0);

// final rgb mux & calculations to checks if we need to invert pixel for square selection
assign rgb = (~(on_grid_x | on_grid_y) & curr_square_sel) ? ~object_mux : object_mux;

// logic to add shoreline or water background
logic [7:0] r_back, g_back, b_back;
assign r_back = (next_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[15:11], 3'b0} : {rgb_water[15:11], 3'b0};
assign g_back = (next_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[10:5], 2'b0} : {rgb_water[10:5], 2'b0};
assign b_back = (next_y >= SHORELINE_OFFSET_Y) ? {rgb_shoreline[4:0], 3'b0} : {rgb_water[4:0], 3'b0};

// vga controller color inputs
// set transparency on numbers & letters so black background doesn't show
assign r_in = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[15:11], 3'b0} : {rgb[7:5], 5'b0}) : r_back;
assign g_in = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[10:5], 2'b0} : {rgb[4:2], 5'b0}) : g_back;
assign b_in = (in_game_bound) ? (((in_letter_bound || in_number_bound) & ~(rgb >= 8'hB6)) ? {rgb_water[4:0], 3'b0} : {rgb[1:0], 6'b0}) : b_back;

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