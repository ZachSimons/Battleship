`timescale 1ns/1ps

module wrapper_tb();

  // -----------------------------------------------------
  // Local parameters (adjust as needed)
  // -----------------------------------------------------
  localparam CLK_PERIOD = 10;

  // -----------------------------------------------------
  // DUT I/O signals (adjust names and widths to match your design)
  // -----------------------------------------------------
  reg              clk;
  reg              rst_n;
  reg              wr_en;
  reg  [1:0]       width;        // For selecting byte/halfword/word
  reg              mem_unsigned; // For selecting signed/unsigned read
  reg  [31:0]      wr_data;
  reg  [31:0]      address;
  wire [31:0]      rd_data;

  // -----------------------------------------------------
  // Instantiate the DUT
  // -----------------------------------------------------
  data_memory_wrapper dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .wr_en      (wr_en),
    .width      (width),
    .mem_unsigned (mem_unsigned),
    .wr_data    (wr_data),
    .address    (address),
    .rd_data    (rd_data)
  );

  // -----------------------------------------------------
  // Clock generation
  // -----------------------------------------------------
  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // -----------------------------------------------------
  // Test sequence
  // -----------------------------------------------------
  initial begin
    // Initial values
    rst_n        = 1'b0;
    wr_en        = 1'b0;
    width        = 2'b00;  // 00 -> byte, 01 -> halfword, 10 -> word (example)
    mem_unsigned = 1'b0;   // 0 -> signed, 1 -> unsigned
    wr_data      = 32'h0;
    address      = 32'h0;

    // Release reset
    # (CLK_PERIOD * 2);
    rst_n = 1'b1;

    // -------------------------------------------------
    // 1) Write a single byte, read back as signed
    // -------------------------------------------------
    // Write 0xFF to address 0x0 (lowest 8 bits = 0xFF)
    wr_en   = 1'b1;
    width   = 2'b00;         // Byte
    wr_data = 32'h000000FF;  // Low byte = 0xFF
    address = 32'h00000000;
    #CLK_PERIOD;
    wr_en   = 1'b0;
    #CLK_PERIOD;

    // Read back as signed (mem_unsigned = 0)
    width        = 2'b00; // Byte
    mem_unsigned = 1'b0;  // Signed
    address      = 32'h00000000;
    #CLK_PERIOD; // wait 1 cycle for read
    $display("[TEST 1 - Byte Signed] Address=0x%08h Read=0x%08h (Expect sign-extended: 0xFFFFFFFF)",
             address, rd_data);

    // -------------------------------------------------
    // 2) Read back same location as unsigned
    // -------------------------------------------------
    mem_unsigned = 1'b1;  // Unsigned
    #CLK_PERIOD; 
    $display("[TEST 2 - Byte Unsigned] Address=0x%08h Read=0x%08h (Expect zero-extended: 0x000000FF)",
             address, rd_data);

    // -------------------------------------------------
    // 3) Write a halfword, read back as signed
    // -------------------------------------------------
    // Write 0xABCD to address 0x4 (lowest 16 bits)
    wr_en        = 1'b1;
    width        = 2'b01;         // Halfword
    mem_unsigned = 1'b0;          // Signed
    wr_data      = 32'h0000ABCD;  // Low halfword = 0xABCD
    address      = 32'h00000004;
    #CLK_PERIOD;
    wr_en = 1'b0;
    #CLK_PERIOD;

    // Read back as signed
    width        = 2'b01; // Halfword
    mem_unsigned = 1'b0;  // Signed
    address      = 32'h00000004;
    #CLK_PERIOD;
    $display("[TEST 3 - Halfword Signed] Address=0x%08h Read=0x%08h",
             address, rd_data);

    // -------------------------------------------------
    // 4) Read back same halfword as unsigned
    // -------------------------------------------------
    mem_unsigned = 1'b1;  // Unsigned
    #CLK_PERIOD;
    $display("[TEST 4 - Halfword Unsigned] Address=0x%08h Read=0x%08h",
             address, rd_data);

    // -------------------------------------------------
    // 5) Write a full word, read back
    // -------------------------------------------------
    wr_en        = 1'b1;
    width        = 2'b10;         // Word
    mem_unsigned = 1'b0;          // Signed/unsigned won't matter for full word
    wr_data      = 32'hDEAD_BEEF;
    address      = 32'h00000008;
    #CLK_PERIOD;
    wr_en = 1'b0;
    #CLK_PERIOD;

    // Read back full word
    width   = 2'b10; // Word
    address = 32'h00000008;
    #CLK_PERIOD;
    $display("[TEST 5 - Word Read] Address=0x%08h Read=0x%08h (Expect 0xDEAD_BEEF)",
             address, rd_data);

    // -------------------------------------------------
    // Wrap up
    // -------------------------------------------------
    # (CLK_PERIOD * 2);
    $display("All tests complete.");
    $finish;
  end

endmodule
