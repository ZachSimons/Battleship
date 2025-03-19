module udp_wrap (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] data_in,
    input  logic        dval_in,
    output logic [31:0] packet_out,
    output logic        packet_ready
);

logic [15:0] source_ip = 16'h0001;
logic [15:0] dest_ip = 16'h0002;
logic [15:0] size = 16'h000C;
logic [15:0] checksum_noninv;
logic [15:0][4] packet_head;

assign checksum_noninv = source_ip + dest_ip + 16'h0011 + size;

assign packet_head = {source_ip, dest_ip, size, !checksum_noninv}; 

assign packet_out = {packet_head, data_in};

endmodule