module data_memory_wrapper(
    input               clk,
    input               rst_n,
    input               wrt_en,
    input               rd_en,
    input               mem_unsigned,
    input  logic [1:0]  width,
    input  logic [31:0] wrt_data,
    input  logic [31:0] wrt_addr,
    output logic [31:0] rd_data
);
//////////////SIGNAL INSTATIATION////////////////////

logic [31:0] wrap_rd_data, wrap_wrt_data;



//////////////MODULE INSTANTIATION///////////////////
//address is [14:0]
//Swappable if more or less data-memory is needed
dmemory dmem(
	.aclr(~rst_n),
	.address(wrt_addr[14:0]),
	.clock(clk),
	.data(wrap_wrt_data),
	.rden(rd_en),
	.wren(wrt_en),
	.q(wrap_rd_data)
);

////////////////////////LOGIC//////////////////////////



always_comb begin
    case(width)
        2'b10: wrap_wrt_data = {{5'd24{1'b0}}, wrt_data[7:0]};  //SB
        2'b01: wrap_wrt_data = {{5'd16{1'b0}}, wrt_data[15:0]}; //SH
        default: wrap_wrt_data =  wrt_data;                     //SW
    endcase
end

always_comb begin
    case({mem_unsigned, width}) 
        3'b001: rd_data = {{5'd24{1'b0}}, wrap_rd_data[7:0]};              //LH
        3'b010: rd_data = {{5'd16{1'b0}}, wrap_rd_data[15:0]};             //LB
        3'b101: rd_data = {{5'd24{wrap_rd_data[7]}}, wrap_rd_data[7:0]};   //LBU
        3'b110: rd_data = {{5'd16{wrap_rd_data[15]}}, wrap_rd_data[15:0]}; //LHU
        default: rd_data = wrap_rd_data;                                   //LW
    endcase
end





endmodule