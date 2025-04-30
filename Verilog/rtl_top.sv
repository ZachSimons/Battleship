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

logic interrupt_board, interrupt_key_local, accelerator_data, sac, snd, uad, ppu_send, ppu_send_ff, sac_reg, fire, snd_ff, uad_ff;
logic [31:0] interrupt_source_data, interface_data, spart_data;
logic [31:0] ppu_reg, acc_reg, comm_reg;
logic [1:0] direction;

logic [23:0] interrupt_board_ff;
logic [7:0] byte_tx;
logic send_tx, tx_latch;
logic [23:0] tx_data;

always_ff @(posedge sys_clk) begin
    if(!rst_n) begin
        ppu_reg <= 0;
        acc_reg <= 0;
        comm_reg <= 0;
        sac_reg <= 0;
        ppu_send_ff <= 0;
        snd_ff <= 0;
        uad_ff <= 0;
        interrupt_board_ff <= 0;
    end
    else begin
        interrupt_board_ff <= interrupt_board ? spart_data[23:0] : interrupt_board_ff;
        ppu_send_ff <= ppu_send;
        snd_ff <= snd;
        uad_ff <= uad;
        ppu_reg <= ppu_send ? interface_data : ppu_reg;
        acc_reg <= uad ? interface_data : acc_reg;
        comm_reg <= snd ? interface_data : comm_reg;
        sac_reg <= (~sac_reg & sac) ? sac :  sac_reg;
    end
end

keyboard DUT (
    .sys_clk(sys_clk), 
    .rst_n (rst_n), 
    .ps2_clk(PS2_CLK), 
    .ps2_data(PS2_DAT), 
    .direction(direction), 
    .fire(fire), 
    .done(interrupt_key_local)
);

accelerator accel (
    .data(acc_reg),
    .clk(sys_clk),
    .rst_n(rst_n),
    .update_ship(uad_ff),
    .start(sac),
    .update_board(ppu_send_ff),
    .valid_out(accelerator_data)
);

ppu_top ppu_top_i (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .receive(ppu_send_ff),
    .ppu_data(ppu_reg),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_B(VGA_B),
    .VGA_CLK(VGA_CLK),
    .VGA_G(VGA_G),
    .VGA_HS(VGA_HS),
    .VGA_R(VGA_R),
    .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_VS(VGA_VS)
);

logic [31:0] interrupt_data;

always begin
    case({fire, direction})
        3'b000:
            interrupt_data = 32'd103;
        3'b001:
            interrupt_data = 32'd104;
        3'b010:
            interrupt_data = 32'd102;
        3'b011:
            interrupt_data = 32'd105;
        default:
            interrupt_data = 32'd106;
    endcase
end

proc processor_i (
    .clk(sys_clk),
    .rst_n(rst_n),
    .interrupt_key(interrupt_key_local),
    .interrupt_eth(interrupt_board),
    .interrupt_source_data(interrupt_board ? spart_data : (interrupt_key_local) ? interrupt_data : '0),
    .accelerator_data(accelerator_data),
    .sac(sac),
    .snd(snd),
    .uad(uad),
    .ppu_send(ppu_send),
    .interface_data(interface_data),
    .seed(SW)
);

assign spart_data[31:24] = 8'h00;

test_spart spart_top_i(   
    .clk(sys_clk),
    .rst_n(rst_n),
    .start_transmission(snd_ff),
    .tdata(comm_reg),
    .rdata(spart_data[23:0]),
    .rx_done(interrupt_board),
    .rxd(BOARD_NUM ? GPIO[1] : GPIO[35]),
    .txd(BOARD_NUM ? GPIO[35] : GPIO[1]),
    .baud(16'd100)
);

assign LEDR[0] = BOARD_NUM == 0;
assign LEDR[1] = BOARD_NUM == 1;

// assign HEX2 = OFF;
// assign HEX3 = OFF;
// assign HEX4 = OFF;
// assign HEX5 = OFF;

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
always_comb begin
    case(interrupt_board_ff[11:8])
        4'd0: HEX2 = HEX_0;
        4'd1: HEX2 = HEX_1;
        4'd2: HEX2 = HEX_2;
        4'd3: HEX2 = HEX_3;
        4'd4: HEX2 = HEX_4;
        4'd5: HEX2 = HEX_5;
        4'd6: HEX2 = HEX_6;
        4'd7: HEX2 = HEX_7;
        4'd8: HEX2 = HEX_8;
        4'd9: HEX2 = HEX_9;
        4'd10: HEX2 = HEX_10;
        4'd11: HEX2 = HEX_11;
        4'd12: HEX2 = HEX_12;
        4'd13: HEX2 = HEX_13;
        4'd14: HEX2 = HEX_14;
        4'd15: HEX2 = HEX_15;
    endcase
end
always_comb begin
    case(interrupt_board_ff[15:12])
        4'd0: HEX3 = HEX_0;
        4'd1: HEX3 = HEX_1;
        4'd2: HEX3 = HEX_2;
        4'd3: HEX3 = HEX_3;
        4'd4: HEX3 = HEX_4;
        4'd5: HEX3 = HEX_5;
        4'd6: HEX3 = HEX_6;
        4'd7: HEX3 = HEX_7;
        4'd8: HEX3 = HEX_8;
        4'd9: HEX3 = HEX_9;
        4'd10: HEX3 = HEX_10;
        4'd11: HEX3 = HEX_11;
        4'd12: HEX3 = HEX_12;
        4'd13: HEX3 = HEX_13;
        4'd14: HEX3 = HEX_14;
        4'd15: HEX3 = HEX_15;
    endcase
end
always_comb begin
    case(interrupt_board_ff[19:16])
        4'd0: HEX4 = HEX_0;
        4'd1: HEX4 = HEX_1;
        4'd2: HEX4 = HEX_2;
        4'd3: HEX4 = HEX_3;
        4'd4: HEX4 = HEX_4;
        4'd5: HEX4 = HEX_5;
        4'd6: HEX4 = HEX_6;
        4'd7: HEX4 = HEX_7;
        4'd8: HEX4 = HEX_8;
        4'd9: HEX4 = HEX_9;
        4'd10: HEX4 = HEX_10;
        4'd11: HEX4 = HEX_11;
        4'd12: HEX4 = HEX_12;
        4'd13: HEX4 = HEX_13;
        4'd14: HEX4 = HEX_14;
        4'd15: HEX4 = HEX_15;
    endcase
end
always_comb begin
    case(interrupt_board_ff[23:20])
        4'd0: HEX5 = HEX_0;
        4'd1: HEX5 = HEX_1;
        4'd2: HEX5 = HEX_2;
        4'd3: HEX5 = HEX_3;
        4'd4: HEX5 = HEX_4;
        4'd5: HEX5 = HEX_5;
        4'd6: HEX5 = HEX_6;
        4'd7: HEX5 = HEX_7;
        4'd8: HEX5 = HEX_8;
        4'd9: HEX5 = HEX_9;
        4'd10: HEX5 = HEX_10;
        4'd11: HEX5 = HEX_11;
        4'd12: HEX5 = HEX_12;
        4'd13: HEX5 = HEX_13;
        4'd14: HEX5 = HEX_14;
        4'd15: HEX5 = HEX_15;
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

// accelerator ACC(
//     .data(data),
//     .clk(sys_clk),
//     .rst_n(rst_n),
//     .update_ship(update_ship),
//     .start(start),
//     .update_board(update_board),
//     .valid_out(accelerator_data)
// );



endmodule