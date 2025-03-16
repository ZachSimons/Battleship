`timescale 1ns / 1ps

module memory_tester;

    // ------------------
    // Testbench Signals
    // ------------------
    reg          aclr;
    reg  [15:0]  address;
    reg  [3:0]   byteena;
    reg          clock;
    reg  [31:0]  data;
    reg  [1:0]   rden;
    reg  [1:0]   wren;
    wire [31:0]  q_mem1;
    wire [31:0]  q_mem2;

    // ------------------
    // DUT Instantiations
    // ------------------
    // Adjust the module name "memory" if your memory module is named differently.
    cpu_bram mem1 (
        .aclr    (aclr),
        .address (address),
        .byteena (byteena),
        .clock   (clock),
        .data    (data),
        .rden    (rden[0]),
        .wren    (wren[0]),
        .q       (q_mem1)
    );

    cpu_bram_d mem2 (
        .aclr    (aclr),
        .address (address),
        .byteena (byteena),
        .clock   (clock),
        .data    (data),
        .rden    (rden[1]),
        .wren    (wren[1]),
        .q       (q_mem2)
    );

    // --------------
    // Clock Generation
    // --------------
    // 10 ns period => 100 MHz clock
    always #5 clock = ~clock;

    integer i;

    // --------------
    // Initial Block
    // --------------
    initial begin
        // Initialize signals
        clock   = 0;
        aclr    = 0;
        address = 0;
        byteena = 4'b1111;  // Enable all bytes by default
        data    = 0;
        rden    = 0;
        wren    = 0;

        // Apply reset
        aclr = 1;
        #20;            // hold reset for a couple of cycles
        aclr = 0;
        #20;

        $display("===== Begin Memory Tests =====");

        // -------------------------------
        // 1) Basic Write/Read Comparisons
        // -------------------------------
        // Write to addresses 0 through 4, then read back
        for (i = 0; i < 5; i = i + 1) begin
            // Write data
            address = i;
            data    = 32'hA000_0000 + i; // just a pattern
            wren    = 2'b11;
            rden    = 0;
            #10;  // wait 1 clock cycle
            wren    = 0;
            @(negedge clock);  // wait another cycle to safely end the write

            // Read data back
            rden    = 2'b11;
            #10;  // wait 1 clock cycle to latch data
            rden    = 0;
            @(negedge clock);  // wait another cycle for stable output

            // Check outputs
            $display("[Addr %0d] Wrote: 0x%08h | mem1=0x%08h, mem2=0x%08h",
                     i, (32'hA000_0000 + i), q_mem1, q_mem2);

            if (q_mem1 !== q_mem2) begin
                $display("  ** ERROR: mem1 != mem2 at address %0d **", i);
            end
        end

        // -----------------------------------
        // 2) Byte-Enable (Partial Write) Test
        // -----------------------------------
        // Example: Write only the lower 16 bits of the word
        address = 16'h000A;
        data    = 32'hDEAD_BEEF;
        
        
        //byteena = 4'b0011;  // Only write the lower half-word
        wren    = 1;
        #10;
        wren    = 0;
        #10;

        // Now read it back
        rden = 3;
        #10;
        rden = 0;
        #10;

        $display("Partial Write Test @ Address 0x000A:");
        $display("  Wrote 0xDEAD_BEEF with byteena=4'b0011 (low half only).");
        $display("  mem1 read = 0x%08h", q_mem1);
        $display("  mem2 read = 0x%08h", q_mem2);
        if (q_mem1 !== q_mem2) begin
            $display("  ** ERROR: mem1 != mem2 in partial write test **");
        end

        // --------------------------------
        // 3) Another Partial Write Example
        // --------------------------------
        // Write only the upper 16 bits of the word
        address = 16'h000B;
        data    = 32'h1234_ABCD;
        byteena = 4'b1100;  // Only write the upper half-word
        wren    = 3;
        #10;
        wren    = 0;
        #10;

        // Read it back
        rden = 3;
        #10;
        rden = 0;
        #10;

        $display("Partial Write Test @ Address 0x000B:");
        $display("  Wrote 0x1234_ABCD with byteena=4'b1100 (upper half only).");
        $display("  mem1 read = 0x%08h", q_mem1);
        $display("  mem2 read = 0x%08h", q_mem2);
        if (q_mem1 !== q_mem2) begin
            $display("  ** ERROR: mem1 != mem2 in partial write test (upper half) **");
        end

        // Done with tests
        $display("===== All Tests Complete =====");



        



        $stop;
    end

endmodule
