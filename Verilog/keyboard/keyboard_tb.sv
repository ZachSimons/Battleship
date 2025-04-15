module keyboard_tb();

//inputs 
logic sys_clk, rst_n, ps2_clk, ps2_data;

// for ps2_data 
logic [32:0] data_reg;

keyboard DUT (.sys_clk(sys_clk), .rst_n (rst_n), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .direction(), .fire(), .done());

initial begin
sys_clk = 0;
rst_n = 0;
ps2_clk = 1;

@(posedge sys_clk);
@(negedge sys_clk);
rst_n = 1;

repeat (11) @(posedge ps2_clk);
repeat (10) @(posedge sys_clk);  

repeat (11) @(posedge ps2_clk);
repeat (10) @(posedge sys_clk);  

repeat (11) @(posedge ps2_clk);
repeat (10) @(posedge sys_clk);  
$stop();
end

// fake PS2 device
// sim "Enter" key being pressed
always @(ps2_clk, negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= {   1'b1, 1'b0, 8'h5A, 1'b0, 
                        1'b1, 1'b0, 8'hF0, 1'b0, 
                        1'b1, 1'b0, 8'h5A, 1'b0};
    end
    else if (!ps2_clk) begin
        data_reg <= {1'b1, data_reg[32:1]};
    end 
end

assign ps2_data = data_reg[0];

// estimated ratios between 50Mhz system clock and 15KHz PS/2 clock
always begin
    #3 sys_clk = ~sys_clk;
end

always begin
    #10000 ps2_clk = ~ps2_clk;
end

endmodule