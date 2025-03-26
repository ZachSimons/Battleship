module inst_memory_wrapper(
    input               clk,
    input               rst_n,
    input               wrt_en, 
    input  logic [31:0] wrt_data,
    input  logic [31:0] addr,
    output logic [31:0] rd_data
);
//////////////NET INSTANTIATION/////////////////////
logic [7:0] bank0_wrt_data, bank1_wrt_data, bank2_wrt_data, bank3_wrt_data, bank0_rd_data, bank1_rd_data, bank2_rd_data, bank3_rd_data;
logic [3:0] bank_wrt_en;


//TODO Fix this such that it increments like byte addressable memory but isn't actually byte addressable

//////////////MODULE INSTANTIATION///////////////////
//banks are the same size as dmem (8K)
//Swappable if need more or less data
imembank bank0(
    .aclr(~rst_n),
	.address(addr[14:2]),
	.clock(clk),
	.data(bank0_wrt_data),
	.wren(wrt_en),
	.q(bank0_rd_data)
); 

imembank bank1(
    .aclr(~rst_n),
	.address(addr[14:2]),
	.clock(clk),
	.data(bank1_wrt_data),
	.wren(wrt_en),
	.q(bank1_rd_data)
); 

imembank bank2(
    .aclr(~rst_n),
	.address(addr[14:2]),
	.clock(clk),
	.data(bank2_wrt_data),
	.wren(wrt_en),
	.q(bank2_rd_data)
); 

imembank bank3(
    .aclr(~rst_n),
	.address(addr[14:2]),
	.clock(clk),
	.data(bank3_wrt_data),
	.wren(wrt_en),
	.q(bank3_rd_data)
); 

////////////////////////LOGIC//////////////////////////

//Assumed that data will always be aligned
assign bank0_wrt_data = wrt_data[7:0];
assign bank1_wrt_data = wrt_data[15:8];
assign bank2_wrt_data = wrt_data[23:16];
assign bank3_wrt_data = wrt_data[31:24];

assign rd_data = {bank3_rd_data, bank2_rd_data, bank1_rd_data, bank0_rd_data};


endmodule