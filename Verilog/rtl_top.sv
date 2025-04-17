module rtl_top #(
    parameter bit BOARD_NUM = 0
)(
    input  logic        sys_clk,
    input  logic        rst_n,

    input  logic [3:0]	KEY,
    input  logic [9:0]	SW,
    output logic [9:0]	LEDR,
    //////////// KEYBOARD ////////////
    inout  logic        PS2_CLK,
	inout  logic        PS2_CLK2,
	inout  logic        PS2_DAT,
	inout  logic        PS2_DAT2,
	//////////// VGA /////////////////
	output logic        VGA_BLANK_N,
	output logic [7:0]  VGA_B,
	output logic        VGA_CLK,
	output logic [7:0]  VGA_G,
	output logic        VGA_HS,
	output logic [7:0]  VGA_R,
	output logic        VGA_SYNC_N,
	output logic        VGA_VS,
    //////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		 [35:0]	GPIO,
    //////////// SEG7 //////////
    output logic [6:0]	HEX0,
	output logic [6:0]	HEX1,
	output logic [6:0]	HEX2,
	output logic [6:0]	HEX3,
	output logic [6:0]	HEX4,
	output logic [6:0]	HEX5
);

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

logic interrupt_board, interrupt_key_local, accelerator_data, sac, snd, uad, ppu_send, ppu_send_ff, sac_reg, fire, snd_ff;
logic [31:0] interrupt_source_data, interface_data, spart_data;
logic [31:0] ppu_reg, acc_reg, comm_reg;
logic [1:0] direction;

logic [7:0] interrupt_board_ff;
logic [7:0] byte_tx;
logic send_tx, tx_latch;

always_ff @(posedge sys_clk) begin
    if(!rst_n) begin
        // ppu_reg <= 0;
        // acc_reg <= 0;
        // comm_reg <= 0;
        // sac_reg <= 0;
        // ppu_send_ff <= 0;
        // snd_ff <= 0;
        interrupt_board_ff <= 0;
    end
    else begin
        interrupt_board_ff <= interrupt_board ? spart_data[7:0] : interrupt_board_ff;
        // ppu_send_ff <= ppu_send;
        // snd_ff <= snd;
        // ppu_reg <= ppu_send ? interface_data : ppu_reg;
        // acc_reg <= uad ? interface_data : acc_reg;
        // comm_reg <= snd ? interface_data : comm_reg;
        // sac_reg <= (~sac_reg & sac) ? sac :  sac_reg;
    end
end

// keyboard DUT (
//     .sys_clk(sys_clk), 
//     .rst_n (rst_n), 
//     .ps2_clk(PS2_CLK), 
//     .ps2_data(PS2_DAT), 
//     .direction(direction), 
//     .fire(fire), 
//     .done(interrupt_key_local)
// );

spart spart_i(   
    .clk(sys_clk),
    .rst_n(rst_n),
    .txsend(send_tx),
    .txdata(byte_tx),
    .rxdata(spart_data),
    .rda(interrupt_board),
    .rxd(BOARD_NUM ? GPIO[3] : GPIO[5]),
    .txd(BOARD_NUM ? GPIO[5] : GPIO[3])
);

logic key_ff, key_ff2, key_ff3;

assign byte_tx = SW[7:0];
assign send_tx = ~key_ff2 & key_ff3;

always_ff @ (posedge sys_clk) begin
    if (!rst_n) begin
        key_ff <= 1;
        key_ff2 <= 1;
        key_ff3 <= 1;
    end
    else begin
        key_ff <= KEY[1];
        key_ff2 <= key_ff;
        key_ff3 <= key_ff2;
    end
end

assign LEDR[0] = BOARD_NUM == 0;
assign LEDR[1] = BOARD_NUM == 1;


assign HEX2 = OFF;
assign HEX3 = OFF;
assign HEX4 = OFF;
assign HEX5 = OFF;

always_comb begin
    case(interrupt_board_ff[3:0])
        4'd0: HEX0 = HEX_0;
        4'd1: HEX0 = HEX_1;
        4'd2: HEX0 = HEX_2;
        4'd3: HEX0 = HEX_3;
        4'd4: HEX0 = HEX_4;
        4'd5: HEX0 = HEX_5;
        4'd6: HEX0 = HEX_6;
        4'd7: HEX0 = HEX_7;
        4'd8: HEX0 = HEX_8;
        4'd9: HEX0 = HEX_9;
        4'd10: HEX0 = HEX_10;
        4'd11: HEX0 = HEX_11;
        4'd12: HEX0 = HEX_12;
        4'd13: HEX0 = HEX_13;
        4'd14: HEX0 = HEX_14;
        4'd15: HEX0 = HEX_15;
    endcase
end

always_comb begin
    case(interrupt_board_ff[7:4])
        4'd0: HEX1 = HEX_0;
        4'd1: HEX1 = HEX_1;
        4'd2: HEX1 = HEX_2;
        4'd3: HEX1 = HEX_3;
        4'd4: HEX1 = HEX_4;
        4'd5: HEX1 = HEX_5;
        4'd6: HEX1 = HEX_6;
        4'd7: HEX1 = HEX_7;
        4'd8: HEX1 = HEX_8;
        4'd9: HEX1 = HEX_9;
        4'd10: HEX1 = HEX_10;
        4'd11: HEX1 = HEX_11;
        4'd12: HEX1 = HEX_12;
        4'd13: HEX1 = HEX_13;
        4'd14: HEX1 = HEX_14;
        4'd15: HEX1 = HEX_15;
    endcase
end

// ppu_top ppu_top_i (
//     .sys_clk(sys_clk),
//     .rst_n(rst_n),
//     .receive(ppu_send_ff),
//     .ppu_data(ppu_reg),
//     .VGA_BLANK_N(VGA_BLANK_N),
//     .VGA_B(VGA_B),
//     .VGA_CLK(VGA_CLK),
//     .VGA_G(VGA_G),
//     .VGA_HS(VGA_HS),
//     .VGA_R(VGA_R),
//     .VGA_SYNC_N(VGA_SYNC_N),
//     .VGA_VS(VGA_VS)
// );

// proc processor_i (
//     .clk(sys_clk),
//     .rst_n(rst_n),
//     .interrupt_key(interrupt_key_local),
//     .interrupt_eth(interrupt_board),
//     .interrupt_source_data(interrupt_board ? spart_data : (interrupt_key_local) ? {29'b0, fire, direction} : '0),
//     .accelerator_data(accelerator_data),
//     .sac(sac),
//     .snd(snd),
//     .uad(uad),
//     .ppu_send(ppu_send),
//     .interface_data(interface_data)
// );


endmodule