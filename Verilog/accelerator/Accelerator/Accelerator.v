
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Accelerator(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3, 
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire clk, rst_n, update_ship, start, update_board, valid_out;
wire [31:0] data;
reg [31:0] count;

parameter HEX_0 = 7'b1000000;		// zero
parameter HEX_1 = 7'b1111001;		// one
parameter HEX_2 = 7'b0100100;		// two
parameter HEX_3 = 7'b0110000;		// three
parameter HEX_4 = 7'b0011001;		// four
parameter HEX_5 = 7'b0010010;		// five
parameter HEX_6 = 7'b0000010;		// six
parameter HEX_7 = 7'b1111000;		// seven
parameter HEX_8 = 7'b0000000;		// eight
parameter HEX_9 = 7'b0011000;		// nine
parameter HEX_10 = 7'b0001000;	// ten
parameter HEX_11 = 7'b0000011;	// eleven
parameter HEX_12 = 7'b1000110;	// twelve
parameter HEX_13 = 7'b0100001;	// thirteen
parameter HEX_14 = 7'b0000110;	// fourteen
parameter HEX_15 = 7'b0001110;	// fifteen
parameter OFF   = 7'b1111111;		// all off


//=======================================================
//  Structural coding
//=======================================================

assign clk = CLOCK_50;

accelerator ACC(
    .data(data),
    .clk(clk),
    .rst_n(rst_n),
    .update_ship(update_ship),
    .start(start),
    .update_board(update_board),
    .valid_out(valid_out)
);

always @(posedge clk) begin
	if(~rst_n) begin
		count <= 0;
	end
	else begin
		count <= count + 1;
	end
end

assign data = count;
assign start = KEY[3];
assign update_ship = KEY[2];
assign update_board = KEY[1];
assign rst_n = KEY[0];
assign LEDR = {{8{1'b0}}, valid_out, 1'b0};

endmodule
