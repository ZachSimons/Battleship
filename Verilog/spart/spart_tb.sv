module spart_tb();


logic clk, rst_n, tx_rx, rx_tx, tx_send_tx, rx_send_tx, tx_interrupt_board, rx_interrupt_board; 
logic [23:0] tx_tx_data, tx_rx_data, rx_rx_data, rx_tx_data;


test_spart spart_tx_dut(
    .clk(clk),
    .rst_n(rst_n),
    .start_transmission(tx_send_tx),
    .tdata(tx_tx_data),
    .rxd(rx_tx),
    .txd(tx_rx),
    .rx_done(tx_interrupt_board),
    .rdata(tx_rx_data),
    .baud(16'd100)
);

test_spart spart_rx_dut(
    .clk(clk),
    .rst_n(rst_n),
    .start_transmission(rx_send_tx),
    .tdata(rx_tx_data),
    .rxd(tx_rx),
    .txd(rx_tx),
    .rx_done(rx_interrupt_board),
    .rdata(rx_rx_data),
    .baud(16'd100)
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
    //tx_send_tx = 0;

    repeat(1000000) @(posedge clk); //Waiting for spart
    $stop;

end



//test be sending values from one spart to another

always begin
    #5 clk = ~clk;
end


endmodule