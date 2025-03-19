module mac (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] data_in,
    input  logic        dval_in,
    output logic [7:0]  packet_byte_out,
    output logic        packet_ready
);

logic [55:0] PREAMBLE   = 56'h55555555555555; // 7 bytes of 0x55
logic [7:0]  SFD        = 8'hD5;               // Start Frame Delimiter: 0xD5
logic [47:0] SOURCE_MAC = 48'h000A35C70000;
logic [47:0] DEST_MAC   = 48'h000A35C60000;
logic [15:0] ETH_TYPE   = 16'h6969;            // Custom Ethertype for your protocol
logic [31:0] CRC        = 32'hDEADBEEF;        // Example CRC value (to be computed)
parameter DEPTH = 7 + 1 + 6 + 6 + 2 + 4;

////////////////// FIFO to store data being serialized //////////////////
integer i;
logic [7:0] memory [DEPTH];
logic [$clog2(DEPTH):0] size;

always_ff @(posedge clk) begin
    if (!rst_n) begin
        memory <= '{default: '0};
        size <= '0;
    end
    else if (wren && !full) begin
        for (i = 0; i < DEPTH-1; i++) begin
            memory[i + 1] <= memory[i];
        end
        memory[0] <= i_data;
        if (!rden)
            size <= full ? size : size + 1'b1;
    end
    else if (!wren && rden)
        size <= empty ? size : size - 1'b1;
    else
        size <= size;
end

assign empty = ~|size;
assign full = size == DEPTH;
assign o_data = (size == '0) | !rden ? '0 : memory[size-1];


typedef enum logic [1:0]{IDLE, START_SHIFT, PAD_DATA, FINISH_SHIFT} state_t;
state_t state, nxt_state;

always_ff @ (posedge clk) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

always_comb begin
    nxt_state = state;

    case(state)
        IDLE : begin
            if (dval_in)
                nxt_state = START_SHIFT;
        end
        START_SHIFT : begin

        end
    endcase
end

endmodule
