module baud_rate(
    input clk,
    input rst_n,
    output logic enable
    );

reg [15 : 0] count;

always_ff@(posedge clk) begin
    if(!rst_n) begin
        count <= 16'd10416;
        enable <= 0;
    end
    else if(count == 0) begin
        enable <= 1;
        count <= 16'd10416;
    end
    else begin
        enable <= 0;
        count <= count - 1;
    end
end

endmodule
