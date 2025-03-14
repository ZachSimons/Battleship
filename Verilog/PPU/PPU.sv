module PPU (rst_n, vga_clk, r, g, b, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

input rst_n, vga_clk;
output [7:0] r, g, b;
output VGA_BLANK_N, VGA_HS, VGA_SYNC_N, VGA_VS, VGA_CLK;

parameter BOARD_WIDTH = 342;
parameter BOARD_HEIGHT = 342;

logic [9:0] next_x, next_y;
logic [7:0] r_in, g_in, b_in;

reg [23:0] mem [0:(BOARD_WIDTH*BOARD_HEIGHT)-1];
logic [23:0] rgb;

// load memory
initial begin
    $readmemh("board_green.hex", mem);
end

// current rgb value in memory
assign rgb = mem[(BOARD_WIDTH * next_y) + next_x];

// input RGB signals for vga controller
always_ff @(posedge vga_clk, negedge rst_n) begin
    if (!rst_n) begin
        r_in <= 0;
        g_in <= 0;
        b_in <= 0;
    end
    else if ((next_x < BOARD_WIDTH) && (next_y < BOARD_HEIGHT)) begin //render board on top left of the screen
        r_in <= rgb[23:16];
        g_in <= rgb[15:8];
        b_in <= rgb[7:0];    
    end
    else begin // make everything else black
        // r_in <= 0;
        // g_in <= 0;
        // b_in <= 0;
    end
end

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