module placeholder_mem(
    input clk,
    input rst_n,
    input [31:0] addr,
    output [31:0] q
);

logic [31:0] bram [0:255];
logic [7:0] addr_q;

initial begin
    $readmemh("rom_contents.hex", bram);
end


always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        addr_q <= '0;
    end else begin
        addr_q <= addr[9:2]; //1 and 0 not included 
    end
end

assign q = bram[addr_q];

endmodule