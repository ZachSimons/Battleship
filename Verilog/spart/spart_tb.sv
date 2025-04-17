module spart_tb();


logic clk, rst_n, tx_rx, rx_tx, tx_send_tx, rx_send_tx, tx_interrupt_board, rx_interrupt_board; 
logic [23:0] tx_tx_data, tx_rx_data, rx_rx_data, rx_tx_data;


spart_top spart_tx_dut(
    .clk(clk),
    .rst_n(rst_n),
    .send_tx(tx_send_tx),
    .tx_data(tx_tx_data),
    .rxd(rx_tx),
    .txd(tx_rx),
    .interrupt_board(tx_interrupt_board),
    .rx_data(tx_rx_data)
);

spart_top spart_rx_dut(
    .clk(clk),
    .rst_n(rst_n),
    .send_tx(rx_send_tx),
    .tx_data(rx_tx_data),
    .rxd(tx_rx),
    .txd(rx_tx),
    .interrupt_board(rx_interrupt_board),
    .rx_data(rx_rx_data)
);

initial begin
    clk = 0;
    rst_n = 0;
    tx_send_tx = 0;
    rx_send_tx = 0;
    tx_tx_data = 24'hbeefde;
    rx_tx_data = 0;


    @(negedge clk)
    rst_n = 1;

    repeat(2) @(posedge clk);

    @(negedge clk);
    tx_send_tx = 1;

    @(negedge clk);
    tx_send_tx = 0;

    repeat(100) @(posedge clk); //Waiting for spart


end



//test be sending values from one spart to another

always begin
    #5 clk = ~clk;
end


endmodule