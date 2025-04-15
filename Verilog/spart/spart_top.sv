module spart_top (
    input clk,
    input rst_n,
    input snd,
    input [31:0] tx_data,
    output logic interrupt_board,
    output logic [31:0] rx_data
);

assign interrupt_board = rda & ~tbr;

assign rx_data = rda ? databus : '0;

// Instantiate your spart here
spart spart0(   .clk(clk),
                .rst_n(rst_n),
                .iocs(iocs),
                .iorw(iorw),
                .rda(rda),
                .tbr(tbr),
                .ioaddr(ioaddr),
                .databus(databus),
                .txd(txd),
                .rxd(rxd)
            );

// Instantiate your driver here
driver driver0( .clk(clk),
                .rst_n(rst_n),
                .br_cfg(2'b11),
                .iocs(iocs),
                .iorw(iorw),
                .rda(rda),
                .tbr(tbr),
                .ioaddr(ioaddr),
                .databus(databus)
            );

endmodule