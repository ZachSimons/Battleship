module placeholder_mem(
    input clk,
    input rst_n,
    input [31:0] addr,
    output logic [31:0] q
); 

logic [31:0] bram [0:255];
logic [31:0] addr_q;

initial begin
    $readmemh("program_test.mem", bram);
end

always_ff @(posedge clk) begin
    if(!rst_n) begin
        addr_q <= '0;
        q <= '0;
    end else begin
        addr_q <= addr[9:2];
        q <= bram[addr_q];
    end
end






endmodule