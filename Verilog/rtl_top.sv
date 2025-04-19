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
	output logic        VGA_VS
);

logic interrupt_board, interrupt_key_local, accelerator_data, sac, snd, uad, ppu_send, ppu_send_ff, sac_reg, fire, snd_ff;
logic [31:0] interrupt_source_data, interface_data, spart_data;
logic [31:0] ppu_reg, acc_reg, comm_reg;
logic [1:0] direction;

always_ff @(posedge sys_clk) begin
    if(!rst_n) begin
        ppu_reg <= 0;
        acc_reg <= 0;
        comm_reg <= 0;
        sac_reg <= 0;
        ppu_send_ff <= 0;
        snd_ff <= 0;
    end
    else begin
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

assign interrupt_board = 0;
assign spart_data = '0;

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
    .interrupt_source_data(interrupt_board ? spart_data : (interrupt_key_local) ? {29'b0, fire, direction} : '0),
    .accelerator_data(accelerator_data),
    .sac(sac),
    .snd(snd),
    .uad(uad),
    .ppu_send(ppu_send),
    .interface_data(interface_data)
);


endmodule