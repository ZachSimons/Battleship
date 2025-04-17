module spart_top (
    input clk,
    input rst_n,
    input send_tx,
    input [23:0] tx_data,
    input rxd,
    output logic txd,
    output logic interrupt_board,
    output logic [23:0] rx_data
);

logic [7:0][2:0] rx_shift_reg;
logic [23:0] tx_shift_reg;
logic [7:0] byte_rx, byte_tx;
logic send_tx_byte, tbr, rda;
logic [1:0] rx_byte_cnt, tx_byte_cnt;

/////////////////// Pack RX data ///////////////////
always_ff @ (posedge clk) begin
    if (!rst_n) begin
        rx_shift_reg <= '0;
        rx_byte_cnt <= '0;
    end
    else if (&rx_byte_cnt) begin
        rx_shift_reg <= '{default: '0};
        rx_byte_cnt <= 0;
    end
    else if (rda) begin
        rx_shift_reg[rx_byte_cnt] <= byte_rx;
        rx_byte_cnt <= rx_byte_cnt + 1'b1;
    end
end

assign interrupt_board = &rx_byte_cnt;
assign rx_data = rx_shift_reg;
///////////////////////////////////////////////////

/////////////////// Unpack TX data to send ///////////////////
always_ff @ (posedge clk) begin
    if (!rst_n) begin
        tx_shift_reg <= '0;
        tx_byte_cnt <= '0;
    end
    else if (~|tx_byte_cnt & send_tx) begin
        tx_shift_reg <= tx_data;
        tx_byte_cnt <= 2;
    end
    else if (tbr) begin
        tx_shift_reg <= tx_shift_reg >> 8;
        tx_byte_cnt <= tx_byte_cnt - 1'b1;
    end
end

assign byte_tx = tx_shift_reg[7:0];
assign send_tx_byte = tbr & ~|tx_byte_cnt;
/////////////////////////////////////////////////////////////

spart spart_i(   
    .clk(clk),
    .rst_n(rst_n),
    .send_tx(send_tx_byte),
    .tx_data(byte_tx),
    .rx_data(byte_rx),
    .rda(rda),
    .tbr(tbr),
    .rxd(rxd),
    .txd(txd)
);

endmodule