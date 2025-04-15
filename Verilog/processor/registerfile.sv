module registerfile(
    input clk, 
    input rst_n, 
    input [4:0] src_reg1, 
    input [4:0] src_reg2, 
    input [4:0] dst_reg, 
    input write_reg, 
    input [31:0] dst_data, 
    output [31:0] src_data1, 
    output [31:0] src_data2
);

logic [31:0] regfile[31:0];
logic [31:0] data1, data2;

assign src_data1 = data1;
assign src_data2 = data2;


always @(posedge clk, negedge rst_n) begin
    //on reset set all registers to 0
    if(~rst_n) begin
        for(int i = 0; i < 32; i++) begin
            regfile[i] <= '0;
        end
    end
    //handle register operations
    else begin
        //write
        if(write_reg & dst_reg != 0) begin
            regfile[dst_reg] <= dst_data;
        end
    end   
end

always @(*) begin
    if(write_reg && dst_reg == src_reg1 & (dst_reg != 0)) begin //rf bypass
        data1 = dst_data;
    end
    else begin
        data1 = regfile[src_reg1];
    end
    
    if(write_reg && dst_reg == src_reg2 & (dst_reg != 0)) begin //rf bypass
        data2 = dst_data;
    end
    else begin
        data2 = regfile[src_reg2];
    end
end

endmodule