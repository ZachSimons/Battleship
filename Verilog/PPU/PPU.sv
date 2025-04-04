module PPU (rst_n, vga_clk, r, g, b, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

input rst_n, vga_clk;
output [7:0] r, g, b;
output VGA_BLANK_N, VGA_HS, VGA_SYNC_N, VGA_VS, VGA_CLK;

parameter BOARD_WIDTH = 173;
parameter BOARD_HEIGHT = 173;

// add 1 due to board already being offseted on x & y by 1
parameter BOARD_OFFSET_X = 234;
parameter BOARD1_OFFSET_Y = 67;
parameter BOARD2_OFFSET_Y = BOARD1_OFFSET_Y + BOARD_HEIGHT;

logic [9:0] next_x, next_y;
logic [7:0] r_in, g_in, b_in;
logic [7:0] rgb;
logic [31:0] row_off;

// make this logic simpler
assign row_off = (next_y >= BOARD2_OFFSET_Y) ? BOARD2_OFFSET_Y : BOARD1_OFFSET_Y;

board_rom rom (
	.address((BOARD_WIDTH * (next_y - row_off)) + (next_x - BOARD_OFFSET_X)),
	.clock(vga_clk),
	.q(rgb));

// current rgb value in memory
//assign rgb = mem[(BOARD_WIDTH * next_y) + next_x];

// input RGB signals for vga controller
/*always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        r_in <= 0;
        g_in <= 0;
        b_in <= 0;
    end
    else if ((next_x < BOARD_WIDTH) && (next_y < BOARD_HEIGHT)) begin //render board on top left of the screen
        r_in <= {rgb[15:11], 3'b0};
        g_in <= {rgb[10:5], 2'b0};
        b_in <= {rgb[4:0], 3'b0};    
    end
    else begin // make everything else black
        r_in <= 0;
        g_in <= 0;
        b_in <= 0;
    end
end*/

// current pixel registers
logic [9:0] curr_x, curr_y;
always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        curr_x <= 0;
        curr_y <= 0;
    end
    else begin
        curr_x <= next_x;
        curr_y <= next_y;
    end
end

assign r_in = curr_x < BOARD_WIDTH+BOARD_OFFSET_X && curr_x > BOARD_OFFSET_X-1 && curr_y < BOARD_HEIGHT+BOARD2_OFFSET_Y && curr_y > BOARD1_OFFSET_Y-1 ? {rgb[7:5], 5'b0} : '1;
assign g_in = curr_x < BOARD_WIDTH+BOARD_OFFSET_X && curr_x > BOARD_OFFSET_X-1 && curr_y < BOARD_HEIGHT+BOARD2_OFFSET_Y && curr_y > BOARD1_OFFSET_Y-1 ? {rgb[4:2], 5'b0} : '1;
assign b_in = curr_x < BOARD_WIDTH+BOARD_OFFSET_X && curr_x > BOARD_OFFSET_X-1 && curr_y < BOARD_HEIGHT+BOARD2_OFFSET_Y && curr_y > BOARD1_OFFSET_Y-1 ? {rgb[1:0], 6'b0} : '1;

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