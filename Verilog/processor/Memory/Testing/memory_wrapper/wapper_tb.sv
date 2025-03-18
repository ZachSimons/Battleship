`timescale 1ns/1ps

module wrapper_tb();

  // -----------------------------------------------------
  // Local parameters (adjust as needed)
  // -----------------------------------------------------
  localparam CLK_PERIOD = 10;

  // -----------------------------------------------------
  // DUT I/O signals (adjust names and widths to match your design)
  // -----------------------------------------------------
  logic              clk;
  logic              rst_n;
  logic              wrt_en;
  logic              rd_en;
  logic  [1:0]       width;        // For selecting byte/halfword/word
  logic              mem_unsigned; // For selecting signed/unsigned read
  logic  [31:0]      wrt_data;
  logic  [31:0]      wrt_addr;
  logic  [31:0]      rd_data;
 
  // -----------------------------------------------------
  // Instantiate the DUT
  // -----------------------------------------------------
  data_memory_wrapper dut (
    .clk          (clk),
    .rst_n        (rst_n),
    .rd_en        (rd_en),
    .wrt_en       (wrt_en),
    .mem_unsigned (mem_unsigned),
    .width        (width),
    .wrt_data     (wrt_data),
    .wrt_addr     (wrt_addr),
    .rd_data      (rd_data)
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
    rst_n         = 1'b0;
    wrt_en        = 1'b0;
    rd_en         = 1'b0;
    width         = 2'b00;  // 00 -> byte, 01 -> halfword, 10 -> word (example)
    mem_unsigned  = 1'b0;   // 0 -> signed, 1 -> unsigned
    wrt_data      = 32'h0;
    wrt_addr      = 32'h0;

    // Release reset
    # (CLK_PERIOD * 2);
    rst_n = 1'b1;

    // -------------------------------------------------
    // 1) Write a single byte, read back as signed
    // -------------------------------------------------
    // Write 0xFF to wrt_addr 0x0 (lowest 8 bits = 0xFF)
    wrt_en   = 1'b1;
    width    = 2'b10;         // Byte
    wrt_data = 32'hFFFFFF8F;  // Low byte = 0xFF
    wrt_addr = 32'h0;
    #CLK_PERIOD;
    wrt_en   = 1'b0;
    #CLK_PERIOD;

    // Read back as signed (mem_unsigned = 0)
    width        = 2'b10; // Byte
    mem_unsigned = 1'b0;  // Signed
    rd_en        = 1'b1;
    #CLK_PERIOD; // wait 1 cycle for read
    
    $display("[TEST 1 - Byte Signed] wrt_addr=0x%08h Read=0x%08h (Expect sign-extended: 0xFFFFFF8F)",
             wrt_addr, rd_data);

    // -------------------------------------------------
    // 2) Read back same location as unsigned
    // -------------------------------------------------
    mem_unsigned = 1'b1;  // Unsigned
    #CLK_PERIOD; 
    $display("[TEST 2 - Byte Unsigned] wrt_addr=0x%08h Read=0x%08h (Expect zero-extended: 0x0000008F)",
             wrt_addr, rd_data);

    // -------------------------------------------------
    // 3) Write a halfword, read back as signed
    // -------------------------------------------------
    // Write 0xABCD to wrt_addr 0x4 (lowest 16 bits)
    rd_en         = 1'b0;         
    wrt_en        = 1'b1;
    width         = 2'b01;         // Halfword
    mem_unsigned  = 1'b0;          // Signed
    wrt_data      = 32'hFFFFABCD;  // Low halfword = 0xABCD
    wrt_addr      = 32'h1;
    #CLK_PERIOD;
    wrt_en = 1'b0;
    #CLK_PERIOD;

    // Read back as signed
    width         = 2'b01; // Halfword
    mem_unsigned  = 1'b0;  // Signed
    rd_en         = 1'b1;
    #CLK_PERIOD;
    $display("[TEST 3 - Halfword Signed] wrt_addr=0x%08h Read=0x%08h",
             wrt_addr, rd_data);

    // -------------------------------------------------
    // 4) Read back same halfword as unsigned
    // -------------------------------------------------
    mem_unsigned = 1'b1;  // Unsigned
    #CLK_PERIOD;
    $display("[TEST 4 - Halfword Unsigned] wrt_addr=0x%08h Read=0x%08h",
             wrt_addr, rd_data);

    // -------------------------------------------------
    // 5) Write a full word, read back
    // -------------------------------------------------
    rd_en         = 1'b0; 
    wrt_en        = 1'b1;
    width         = 2'b0;         // Word
    mem_unsigned  = 1'b0;          // Signed/unsigned won't matter for full word
    wrt_data      = 32'hDEAD_BEEF;
    wrt_addr      = 32'h00000002;
    #CLK_PERIOD;
    wrt_en = 1'b0;
    #CLK_PERIOD;

    // Read back full word
    rd_en   = 1'b1; 
    width   = 2'b10; // Word
    
    #CLK_PERIOD;
    $display("[TEST 5 - Word Read] wrt_addr=0x%08h Read=0x%08h (Expect 0xDEAD_BEEF)",
             wrt_addr, rd_data);

    // -------------------------------------------------
    // Wrap up
    // -------------------------------------------------
    # (CLK_PERIOD * 2);
    $display("All tests complete.");
    $finish;
  end

endmodule
