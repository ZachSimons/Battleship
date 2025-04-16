module rtl_top (
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
	inout 		 [35:0]	GPIO
);

logic interrupt_board, interrupt_key_local, accelerator_data, sac, snd, uad, ppu_send, ppu_send_ff, sac_reg, fire, snd_ff;
logic [31:0] interrupt_source_data, interface_data, spart_data;
logic [31:0] ppu_reg, acc_reg, comm_reg;
logic [1:0] direction;

logic [7:0] interrupt_board_ff;
logic [7:0] byte_tx;
logic send_tx, tx_latch;

always_ff @(posedge sys_clk) begin
    if(!rst_n) begin
        ppu_reg <= 0;
        acc_reg <= 0;
        comm_reg <= 0;
        sac_reg <= 0;
        ppu_send_ff <= 0;
        snd_ff <= 0;
        interrupt_board_ff <= 0;
    end
    else begin
        interrupt_board_ff <= interrupt_board ? spart_data[7:0] : interrupt_board_ff;
        ppu_send_ff <= ppu_send;
        snd_ff <= snd;
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

spart_top spart_top_i (
    .clk(sys_clk), 
    .rst_n (rst_n),
    .snd(send_tx),
    .tx_data(byte_tx),
    .rxd(GPIO[5]),
    .txd(GPIO[3]),
    .interrupt_board(interrupt_board),
    .rx_data(spart_data)
);


assign byte_tx = SW[7:0];
assign send_tx = ~key_ff2 & key_ff3;

logic key_ff, key_ff2, key_ff3;
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

assign LEDR = {2'b0, interrupt_board_ff};

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

proc processor_i (
    .clk(sys_clk),
    .rst_n(rst_n),
    .interrupt_key(interrupt_key_local),
    .interrupt_eth(interrupt_board),
    .interrupt_source_data(interrupt_board ? spart_data : (interrupt_key_local) ? {29'b0, fire, direction} : '0),
    .accelerator_data(accelerator_data),
    .sac(sac),
    .snd(snd),
    .uad(uad),
    .ppu_send(ppu_send),
    .interface_data(interface_data)
);


endmodule