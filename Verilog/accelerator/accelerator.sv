module accelerator(
    input [31:0] ship_data,
    input clk,
    input rst_n,
    input enable
);

    logic [6:0] ship_pos[4:0];
    logic ship_vert[4:0];

    //ship registers
    always_ff @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            for(int i = 0; i < 5; i++) begin
                ship_pos[i] <= 0;
                ship_vert[i] <= 0;
            end
        end
        else if (enable)begin
            if(ship_data[23:21]<5) begin
                ship_pos[ship_data[23:21]] <= ship_data[31:25];
                ship_vert[ship_data[23:21]] <= ship_data[24];
            end
            if(ship_data[12:10]<5) begin
                ship_pos[ship_data[12:10]] <= ship_data[20:14];
                ship_vert[ship_data[12:10]] <= ship_data[13];
            end    
        end
    end


endmodule