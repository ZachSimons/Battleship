module placeholder_mem(
    input clk,
    input rst_n,
    input read_en,
    input [31:0] addr,
    output logic [31:0] q
); 

logic [31:0] bram [0:255];
logic [31:0] addr_q;
logic read_en_ff;

initial begin
    $readmemh("custom.hex", bram);
end

always_ff @(posedge clk) begin
    if (!rst_n) begin
        read_en_ff <= 0;
        addr_q <= '0;
    end
    else begin
        read_en_ff <= read_en;
        addr_q <= addr[9:2];
    end
end 

always_ff @(posedge clk) begin
    if(!rst_n) begin
        q <= '0;
    end
    else if (read_en_ff) begin
        q <= bram[addr_q];
    end
    else begin
        q <= '0;
    end
end

endmodule