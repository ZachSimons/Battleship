module placeholder_mem(
    input clk,
    input rst_n,
    input read_en,
    input hazard,
    input [31:0] addr,
    output logic [31:0] q
); 

logic [31:0] bram [0:2047];
logic [31:0] addr_q;
logic read_en_ff;


// `ifdef SYNTHESIS
//     // synthesis-only: bram initialized through toolchain
//     initial begin
//         $readmemh("test.hex", bram);
//     end
// `else
//     initial begin
//         string testname;
//         string hexfile;
//   
//         if (!$value$plusargs("TEST=%s", testname)) begin
//             testname = "default";
//         end
// 
//         hexfile = {testname, ".hex"};
//         $display("Loading program from: %s", hexfile);
//         $readmemh(hexfile, bram);
//     end
// `endif

initial begin
   $readmemh("basic_test_code.hex", bram);
end


always_ff @(posedge clk) begin
    if (!rst_n) begin
        read_en_ff <= 0;
        addr_q <= '0;
    end
    else begin
        read_en_ff <= read_en;
        addr_q <= addr[12:2];
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