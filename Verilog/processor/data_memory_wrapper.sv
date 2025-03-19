module data_memory_wrapper(
    input               clk,
    input               rst_n,
    input               wrt_en,
    input               rd_en,
    input               mem_unsigned,
    input  logic [1:0]  width,
    input  logic [31:0] wrt_data,
    input  logic [31:0] wrt_addr,
    output logic [31:0] rd_data,
    output logic        mem_error
);
//////////////SIGNAL INSTATIATION////////////////////

logic [5:0] wrt_en_control, rd_en_control;
logic [4:0] rd_data_control;
logic [3:0] bank_wrt_en, bank_rd_en; 
logic [7:0] bank0_wrt_data, bank1_wrt_data, bank2_wrt_data, bank3_wrt_data, bank0_rd_data, bank1_rd_data, bank2_rd_data, bank3_rd_data;
logic not_aligned;



//input address is 15 bits total wrt_addr [14:0]

//////////////MODULE INSTANTIATION///////////////////
//Swappable if more or less data-memory is needed
dmembank dbank0 (
    .aclr(~rst_n),
	.address(wrt_addr[14:2]),
	.clock(clk),
	.data(bank0_wrt_data),
	.rden(bank_rd_en[0]),
	.wren(bank_wrt_en[0]),
	.q(bank0_rd_data)
); 

dmembank dbank1 (
    .aclr(~rst_n),
	.address(wrt_addr[14:2]),
	.clock(clk),
	.data(bank1_wrt_data),
	.rden(bank_rd_en[1]),
	.wren(bank_wrt_en[1]),
	.q(bank1_rd_data)
); 

dmembank dbank2 (
    .aclr(~rst_n),
	.address(wrt_addr[14:2]),
	.clock(clk),
	.data(bank2_wrt_data),
	.rden(bank_rd_en[2]),
	.wren(bank_wrt_en[2]),
	.q(bank2_rd_data)
); 

dmembank dbank3 (
    .aclr(~rst_n),
	.address(wrt_addr[14:2]),
	.clock(clk),
	.data(bank3_wrt_data),
	.rden(bank_rd_en[3]),
	.wren(bank_wrt_en[3]),
	.q(bank3_rd_data)
); 

////////////////////////LOGIC//////////////////////////
//not_aligned if half operation is requested and wrt_addr is odd or a full word operation is requested and wrt_addr != 0
assign not_aligned = ((width == 2'b10) & wrt_addr[0]) | ((width == 2'b00) & (wrt_addr[1:0] != 2'b00))

assign mem_error = not_aligned; 

//bank wrt_en signals
assign wrt_en_control = {not_aligned, wrt_en, width, wrt_addr[1:0]}
always_comb begin
    case(wrt_en_control) 
        6'b010100: bank_wrt_en = 4'b0001        //width 01 and addr 00 (byte @ b0)
        6'b010101: bank_wrt_en = 4'b0010        //width 01 and addr 01 (byte @ b1)
        6'b010110: bank_wrt_en = 4'b0100        //width 01 and addr 10 (byte @ b2)
        6'b010111: bank_wrt_en = 4'b1000        //width 01 and addr 11 (byte @ b3)
        6'b011000: bank_wrt_en = 4'b0011        //width 10 and addr 00 (half @ b0 & b1)
        6'b011010: bank_wrt_en = 4'b1100        //width 10 and addr 10 (half @ b2 & b3)
        6'b010000: bank_wrt_en = 4'b1111        //width 00 and addr 00 (full word)
        default:   bank_wrt_en = 4'b0000        //No write currently happening                          
    endcase
end

//bank rd_en signals
assign rd_en_control = {not_aligned, rd_en, width, wrt_addr[1:0]}
always_comb begin
    case(rd_en_control) 
        6'b010100: bank_rd_en = 4'b0001        //width 01 and addr 00 (byte @ b0)
        6'b010101: bank_rd_en = 4'b0010        //width 01 and addr 01 (byte @ b1)
        6'b010110: bank_rd_en = 4'b0100        //width 01 and addr 10 (byte @ b2)
        6'b010111: bank_rd_en = 4'b1000        //width 01 and addr 11 (byte @ b3)
        6'b011000: bank_rd_en = 4'b0011        //width 10 and addr 00 (half @ b0 & b1)
        6'b011010: bank_rd_en = 4'b1100        //width 10 and addr 10 (half @ b2 & b3)
        6'b010000: bank_rd_en = 4'b1111        //width 00 and addr 00 (full word)
        default:   bank_rd_en = 4'b0000        //No write currently happening                          
    endcase
end

//bank wrt_data signals
always_comb begin
    case(width) 
        2'b00: begin  //Store full
            bank0_wrt_data = wrt_data[7:0];
            bank1_wrt_data = wrt_data[15:8];
            bank2_wrt_data = wrt_data[23:16];
            bank3_wrt_data = wrt_data[31:24];
        end
        2'b01: begin //Store byte
            bank0_wrt_data = wrt_data[7:0];
            bank1_wrt_data = wrt_data[7:0];
            bank2_wrt_data = wrt_data[7:0];
            bank3_wrt_data = wrt_data[7:0];
        end
        2'b10: begin //Store Half
            bank0_wrt_data = wrt_data[7:0];
            bank1_wrt_data = wrt_data[15:8];
            bank2_wrt_data = wrt_data[7:0];
            bank3_wrt_data = wrt_data[15:8];
        end
        default: begin //Default catch all
            bank0_wrt_data = '0;
            bank1_wrt_data = '0;
            bank2_wrt_data = '0;
            bank3_wrt_data = '0;
        end                              
    endcase
end

//bank read_data signals
assign rd_data_control = {mem_unsigned, width, wrt_addr[1:0]}
always_comb begin
    case(rd_data_control) 
        5'b00000: rd_data = {bank3_rd_data, bank2_rd_data, bank1_rd_data, bank0_rd_data}; //Load full 

        5'b00100: rd_data = {{5'd24{bank0_rd_data[7]}}, bank0_rd_data}; //Load byte signed b0
        5'b00101: rd_data = {{5'd24{bank1_rd_data[7]}}, bank1_rd_data}; //Load byte signed b1
        5'b00110: rd_data = {{5'd24{bank2_rd_data[7]}}, bank2_rd_data}; //Load byte signed b2
        5'b00111: rd_data = {{5'd24{bank3_rd_data[7]}}, bank3_rd_data}; //Load byte signed b3

        5'b01000: rd_data = {{5'd16{bank1_rd_data[7]}}, bank1_rd_data, bank0_rd_data}; //Load half signed b0 & b1
        5'b01010: rd_data = {{5'd16{bank3_rd_data[7]}}, bank3_rd_data, bank2_rd_data}; //Load half signed b2 & b3

        5'b10100: rd_data = {{5'd24{1'b0}}, bank0_rd_data}; //Load byte unsigned b0
        5'b10101: rd_data = {{5'd24{1'b0}}, bank1_rd_data}; //Load byte unsigned b1
        5'b10110: rd_data = {{5'd24{1'b0}}, bank2_rd_data}; //Load byte unsigned b2
        5'b10111: rd_data = {{5'd24{1'b0}}, bank3_rd_data}; //Load byte unsigned b3

        5'b11000: rd_data = {{5'd16{1'b0}}, bank1_rd_data, bank0_rd_data}; //Load half unsigned b0 & b1
        5'b11010: rd_data = {{5'd16{1'b0}}, bank3_rd_data, bank2_rd_data}; //Load half unsigned b2 & b3

        default: rd_data = '0; //Default catch all
    endcase
end

endmodule