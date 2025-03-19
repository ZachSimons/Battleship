module eth_top (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] rtl_data_in,
    input  logic        rtl_dval_in,
    // GMII Signals
    input  logic [7:0]  gmii_rxd,
    output logic        gmii_rx_resetn,
    output logic        gmii_rxclk,
    input  logic        gmii_rxdv,
    input  logic        gmii_rxclk,
    output logic [7:0]  gmii_txd,
    output logic        gmii_tx_resetn,
    output logic        gmii_txclk,
    output logic        gmii_txer,
    output logic        gmii_txen,
    // MDIO Signals
    output logic        mdio_clk,
    inout  logic        mdio_data
);




endmodule