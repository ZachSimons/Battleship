`timescale 1ns/1ps

module proc_tb;

  logic [31:0] ppu_sim, acc_sim, comm_sim;
  logic [1:0] sac_sim; 
  logic clk;
  logic rst_n;
  logic interrupt_key;
  logic interrupt_eth;
  logic accelerator_data;
  logic [31:0] interrupt_source_data;
  logic [31:0] expected_pc;

  logic sac, snd, uad, ppu_send;
  logic [31:0] interface_data;

  integer basic_instr_err = 0;
  string testname;

  int test_index;

  typedef struct {
    string  test_name;
    logic [5:0] reg_to_check;  
    logic [31:0] instr_code;     
    logic [31:0] expected_val;
  } test_info_t;


  test_info_t basic_test_list[] = '{
    '{
      test_name      : "ORI x24, x24, 0xF",
      instr_code     : 32'h00fc6c13,
      reg_to_check   : 5'd24,
      expected_val   : 32'h0000000F  
    },
    '{
      test_name      : "AUIPC x25, 0x12345 (PC=4)",
      instr_code     : 32'h12345c97, // AUIPC x25, 0x12345 (opcode=0x17)
      reg_to_check   : 5'd25,
      expected_val   : 32'h12345004  // Expected: 4 + (0x12345 << 12) = 0x12345004
    },
    '{
      test_name      : "ADDI x1, x1, 1",
      instr_code     : 32'h00100093,  // sets x1 = x1 + 1
      reg_to_check   : 5'd1,
      expected_val   : 32'h00000001   // after 1st ADDI, x1 = 1
    },
    '{
      test_name      : "ADDI x2, x2, 2",
      instr_code     : 32'h00200113,  // sets x2 = x2 + 2
      reg_to_check   : 5'd2,
      expected_val   : 32'h00000002
    },
    '{
      test_name      : "ADD x3, x1, x2",
      instr_code     : 32'h002081B3,  // x3 = x1 + x2 => 1 + 2 = 3
      reg_to_check   : 5'd3,
      expected_val   : 32'h00000003
    },
    '{
      test_name      : "SUB x4, x1, x2",
      instr_code     : 32'h40208233,  // x4 = x1 - x2 => 1 - 2 => 0xFFFFFFFF
      reg_to_check   : 5'd4,
      expected_val   : 32'hFFFFFFFF
    },
    '{
      test_name      : "OR x5, x1, x2",
      instr_code     : 32'h0020e2b3,  // x5 = x1 | x2 => 3
      reg_to_check   : 5'd5,
      expected_val   : 32'h00000003
    },
    '{
      test_name      : "SLTI x3, x1, 10",
      instr_code     : 32'h00a0a193, // blank
      reg_to_check   : 5'd3,
      expected_val   : 32'h00000001   // if x1=1 => (1 < 10) => 1
    },
    '{
      test_name      : "SLTIU x4, x1, 10",
      instr_code     : 32'h00a0b213, // blank
      reg_to_check   : 5'd4,
      expected_val   : 32'h00000001   // unsigned compare if x1=1 => 1
    },
    '{
      test_name      : "XORI x5, x1, 0xFF",
      instr_code     : 32'h0ff0c293, // blank
      reg_to_check   : 5'd5,
      expected_val   : 32'h000000FE   // if x1=1 => 1 ^ 0xFF => 0xFE
    },
    '{
      test_name      : "ORI x6, x1, 0xABC",
      instr_code     : 32'hbcd0e313, // blank
      reg_to_check   : 5'd6,
      expected_val   : 32'hfffffabd   // if x1=1 => 1 | 0xABCD => 0xABCD
    },
    '{
      test_name      : "ANDI x7, x1, 0xF",
      instr_code     : 32'h00f0f393, // blank
      reg_to_check   : 5'd7,
      expected_val   : 32'h00000001   // if x1=1 => 1 & 0xF => 1
    },
    '{
      test_name      : "SLLI x8, x1, 2",
      instr_code     : 32'h00209413, // blank
      reg_to_check   : 5'd8,
      expected_val   : 32'h00000004   // if x1=1 => (1 << 2) => 4
    },
    '{
      test_name      : "SRLI x9, x1, 1",
      instr_code     : 32'h0010d493, // blank
      reg_to_check   : 5'd9,
      expected_val   : 32'h00000000   // if x1=1 => (1 >>u 1) => 0
    },
    '{
      test_name      : "SRAI x10, x1, 1",
      instr_code     : 32'h4010d513, // blank
      reg_to_check   : 5'd10,
      expected_val   : 32'h00000000   // if x1=1 => sign-extended shift => 0
    },
    '{
      test_name      : "SLL x3, x1, x2",
      instr_code     : 32'h002091B3,
      reg_to_check   : 5'd3,
      expected_val   : 32'h00000004  // 1 << 2 = 4
    },
    '{
      test_name      : "SLT x4, x1, x2",
      instr_code     : 32'h0020A233,
      reg_to_check   : 5'd4,
      expected_val   : 32'h00000001  // (1 < 2) => 1
    },
    '{
      test_name      : "SLTU x5, x1, x2",
      instr_code     : 32'h0020B2B3,
      reg_to_check   : 5'd5,
      expected_val   : 32'h00000001  // (1 < 2) => 1 (unsigned)
    },
    '{
      test_name      : "XOR x6, x1, x2",
      instr_code     : 32'h0020C333,
      reg_to_check   : 5'd6,
      expected_val   : 32'h00000003  // 1 ^ 2 = 3
    },
    '{
      test_name      : "SRL x7, x1, x2",
      instr_code     : 32'h0020D3B3,
      reg_to_check   : 5'd7,
      expected_val   : 32'h00000000  // 1 >> 2 = 0 (logical)
    },
    '{
      test_name      : "SRA x8, x1, x2",
      instr_code     : 32'h4020D433,
      reg_to_check   : 5'd8,
      expected_val   : 32'h00000000  // 1 >> 2 = 0 (arithmetic sign-extended)
    },
    '{
      test_name      : "OR x9, x1, x2",
      instr_code     : 32'h0020E4B3,
      reg_to_check   : 5'd9,
      expected_val   : 32'h00000003  // 1 | 2 = 3
    },
    '{
      test_name      : "AND x10, x1, x2",
      instr_code     : 32'h0020F533,
      reg_to_check   : 5'd10,
      expected_val   : 32'h00000000  // 1 & 2 = 0
    },
    '{
      test_name      : "LUI x11, 0xDEADC",
      instr_code     : 32'hdeadc5b7,  
      reg_to_check   : 5'd11,
      expected_val   : 32'hDEADC000   
    },
    '{
      test_name      : "ADDI x11, x11, 0xEEF",
      instr_code     : 32'heef58593, 
      reg_to_check   : 5'd11,
      expected_val   : 32'hdeadbeef  
    },
    '{
      test_name      : "SB x11, 2(x2)",
      instr_code     : 32'h00b10123,
      reg_to_check   : 5'd0,
      expected_val   : 32'h00000000
    },
    '{
      test_name      : "SH x11, 4(x2)",
      instr_code     : 32'h00b11223,
      reg_to_check   : 5'd0,
      expected_val   : 32'h00000000
    },
    '{
      test_name      : "SW x11, 6(x2)",
      instr_code     : 32'h00b12323,
      reg_to_check   : 5'd0,
      expected_val   : 32'h00000000 
    },
    '{
      test_name      : "LB x12, 2(x2)",
      instr_code     : 32'h00210603,
      reg_to_check   : 5'd12,
      expected_val   : 32'hFFFFFFEF
    },
    '{
      test_name      : "LH x13, 4(x2)",
      instr_code     : 32'h00411683,
      reg_to_check   : 5'd13,
      expected_val   : 32'hFFFFBEEF
    },
    '{
      test_name      : "LW x14, 6(x2)",
      instr_code     : 32'h00612703,
      reg_to_check   : 5'd14,
      expected_val   : 32'hDEADBEEF
    },
    '{
      test_name      : "ADD x15, x14, x0",
      instr_code     : 32'h000707b3,
      reg_to_check   : 5'd15,
      expected_val   : 32'hDEADBEEF  // 1 & 2 = 0
    }
  };
  
  //Simulating interfaces
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      ppu_sim <= 0;
      acc_sim <= 0;
      comm_sim <= 0;
      sac_sim <= 0;
    end
    else begin
      ppu_sim <= ppu_send ? interface_data : ppu_sim;
      acc_sim <= uad ? interface_data : acc_sim;
      comm_sim <= snd ? interface_data : comm_sim;
      sac_sim <= (~sac_sim & sac) ? sac :  sac_sim;
    end
  end
  

  // Instantiate DUT
  proc dut (
    .clk(clk),
    .rst_n(rst_n),
    .interrupt_key(interrupt_key),
    .interrupt_eth(interrupt_eth),
    .interrupt_source_data(interrupt_source_data),
    .accelerator_data(accelerator_data),
    .sac(sac),
    .snd(snd),
    .uad(uad),
    .ppu_send(ppu_send),
    .interface_data(interface_data)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial setup
  initial begin
    // Init
    clk = 0;
    rst_n = 0;
    interrupt_key = 0;
    interrupt_eth = 0;
    accelerator_data = 1;
    expected_pc = 0; 
    interrupt_source_data = 32'hDEADBEEF;

    if (!$value$plusargs("TEST=%s", testname)) begin
        testname = "default";
    end
    $display("Running test logic for: %s", testname);

    #20;
    rst_n = 1;
    repeat (7) @(posedge clk);

    /////////////////////////////////////////////////////////////////
    // BASIC INSTR TESTS
    /////////////////////////////////////////////////////////////////
    // For each instruction in basic_test_list:
    if (testname == "basic_instr_tests") begin
      for (int i = 0; i < $size(basic_test_list); i++) begin
        repeat (1) @(posedge clk);

        if ((dut.instruction_ex_mem[6:0] == 7'b0000011)) repeat(2) @(posedge clk);

        if ((dut.instruction_ex_mem == 32'h00000013)) @(posedge clk);
        // Now check the register
        #1;
        check_basic_register(
          basic_test_list[i].reg_to_check, 
          basic_test_list[i].expected_val, 
          basic_test_list[i].test_name
        );
      end
      if (basic_instr_err == 0) begin
        $display("TEST PASSED: Basic instruction tests");
      end else begin
        $display("TEST FAILED: %d basic instructions failed", basic_instr_err);
      end
    end

    /////////////////////////////////////////////////////////////////
    // JUMP TESTs
    /////////////////////////////////////////////////////////////////
    if (testname == "jal_tests") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[1] != 32'hAA) begin
            @(posedge clk);
          end
          check_test(
            1, 
            32'hAA, 
            "Jump Test"
          );
          disable timeout_jump;
        end
        begin : timeout_jump
          repeat (500) @(posedge clk);
          $error("TEST FAILED: Timeout: Jump test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // SQUARE ROOT TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "sqrt") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[29] != 1) begin
            @(posedge clk);
          end
          check_test(
            10, 
            40, 
            "Square root of 1600"
          );
          disable timeout_sqrt;
        end
        begin : timeout_sqrt
          repeat (600000) @(posedge clk);
          $error("TEST FAILED: Timeout: Square root test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // LOAD & STORE TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "loadstore") begin
      fork 
        begin
          while (dut.proc_de.curr_pc != 220) begin
            @(posedge clk);
          end
          @(posedge clk);
          @(posedge clk);
          #1;
          check_basic_register(
            10, 
            32'h22222222, 
            "array[0] after store"
          );
          check_basic_register(
            11, 
            32'h22222222, 
            "array[1] original"
          );
          check_basic_register(
            12, 
            32'hFFFFFFCC, 
            "array[2] after sw t4"
          );
          check_basic_register(
            13, 
            32'h000000CC, 
            "array[3] after sw t6"
          );
          check_basic_register(
            14, 
            32'h22222222, 
            "result[0] = copy of array[1]"
          );
          check_basic_register(
            15, 
            32'h000000CC, 
            "result[1]"
          );
          disable timeout_ls;
        end
        begin : timeout_ls
          repeat (300) @(posedge clk);
          $error("TEST FAILED: Timeout: Load/Store test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // LOAD HAZARD TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "loadhaz") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[31] != 32'hAA) begin
            @(posedge clk);
          end
          check_basic_register(
            13, 
            32'h00000010, 
            "	Loaded from Mem[0]"
          );
          check_basic_register(
            14, 
            32'h11223344, 
            "	Loaded from Mem[0x100]"
          );
          check_basic_register(
            15, 
            32'h00000014, 
            "	Undefined (Mem[0x300] not set)"
          );
          check_basic_register(
            16, 
            32'h55667788, 
            "Copy of x11"
          );
          check_basic_register(
            5, 
            32'h00000000, 
            "Should be 0, 'F indicates fail"
          );
          disable timeout_lhaz;
        end
        begin : timeout_lhaz
          repeat (200) @(posedge clk);
          $error("TEST FAILED: Timeout: Load hazard test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // BRANCH TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "branch_test") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[27] != 32'h1) begin
            @(posedge clk);
          end
          check_basic_register(
            28, 
            32'h00000006, 
            "Value of 6 indicates 6 passes"
          );
          check_basic_register(
            29, 
            32'h00000000, 
            "Value of 0 indicates 0 fails"
          );
          disable timeout_br;
        end
        begin : timeout_br
          repeat (200) @(posedge clk);
          $error("TEST FAILED: Timeout: Branch test did not complete.");
          $stop;
        end
      join_any
    end
    /////////////////////////////////////////////////////////////////
    // Custom Instructions with Hazards TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "custom_haz") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[31] != 32'hAA) begin
            @(posedge clk);
          end
          if(ppu_sim != 32'h11223344) begin
            $error("INSTRUCTION FAILED: %s => PPU_sim mismatch: expected 32'h11223344, got %h",
              testname, ppu_sim);
          end
          if(acc_sim != 32'h55667788) begin
            $error("INSTRUCTION FAILED: %s => ACC_sim mismatch: expected 32'h55667788, got %h",
              testname, acc_sim);
          end
          if(comm_sim != 32'h22334455) begin
            $error("INSTRUCTION FAILED: %s => com_sim mismatch: expected 32'h22334455, got %h",
              testname, comm_sim);
          end
          if(sac_sim != 1) begin
            $error("INSTRUCTION FAILED: %s => com_sim mismatch: expected 32'h22334455, got %h",
              testname, sac_sim);
          end
          check_basic_register(
            10, 
            32'hffffedf8, 
            "LDR test"
          );
          check_basic_register(
            12, 
            32'hDEADBEF0, 
            "RDI test"
          );
          check_basic_register(
            13, 
            32'h2, 
            "SAC test"
          );
          disable timeout_cz;
        end
        begin : timeout_cz
          repeat (200) @(posedge clk);
          $error("TEST FAILED: Timeout: cus_haz test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // FIB TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "fib") begin
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[31] != 32'h1) begin
          @(posedge clk);
          end
          check_basic_register(
            10, 
            32'd701408733, 
            "44th fib number"
          );
          check_basic_register(
            11, 
            32'd433494437, 
            "43rd fib number"
          );
          check_basic_register(
            12, 
            32'd267914296, 
            "42nd fib number"
          );
          check_basic_register(
            13, 
            32'd165580141, 
            "41st fib number"
          );
          check_basic_register(
            14, 
            32'd102334155, 
            "40th fib number"
          );
          disable timeout_fib;
        end
        begin : timeout_fib
          repeat (1000) @(posedge clk);
          $error("TEST FAILED: Timeout: Fib test did not complete.");
          $stop;
        end
      join_any
    end



    /////////////////////////////////////////////////////////////////
    // INTERRUPT TEST
    /////////////////////////////////////////////////////////////////
    if (testname == "interrupt") begin 
      
      //#100 = 185 iterrupt goes high
      
      #160;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #330;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #330;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #330;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #350;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #310;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;
    
      #280;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #350;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #320;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #340;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #320;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #310;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;

      #320;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;


      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[17] != 32'h1) begin
          @(posedge clk);
          end
          check_basic_register(
            29, 
            32'd000000000, 
            "did all rsi"
          );
          check_basic_register(
            30, 
            32'd000000000, 
            "did all rti"
          );
          disable timeout_int;
        end
        begin : timeout_int
          repeat (1000) @(posedge clk);
          $error("TEST FAILED: Timeout: Interrupt test did not complete.");
          $stop;
        end
      join_any
    end

    /////////////////////////////////////////////////////////////////
    // INTERRUPT BRANCH
    /////////////////////////////////////////////////////////////////
    if (testname == "interrupt_branch") begin 
      
      //TODO
      //Figure out when to assert interrupts
      //Check to see if interrupt went back to 
      //Check I-reg when interrupt happens
      //Will have to check manually if rsi and rti are working correctly
      
      //-3 relative to branch
      #255;
      @(posedge clk);
      interrupt_key = 1;
      expected_pc = dut.proc_fe.pc_d;
      @(posedge clk);
      interrupt_key = 0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end

      //-2 relative to branch
      #325;
      @(posedge clk);
      interrupt_key = 1;
      expected_pc = dut.proc_fe.pc_d;
      @(posedge clk);
      interrupt_key = 0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end

      //-1 relative to branch
      #335;
      @(posedge clk);
      interrupt_key = 1;
      expected_pc = dut.proc_fe.pc_d;
      @(posedge clk);
      interrupt_key = 0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end

      //Interrupt on branch
      #345;
      @(posedge clk);
      interrupt_key = 1;
      expected_pc = dut.proc_fe.pc_d;
      @(posedge clk);
      interrupt_key = 0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end
      

      //+1 relative to branch
      #355;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;
      #1
      expected_pc = dut.branchpc_ex_fe;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end


      //+2 relative to branch
      #365;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;
      #1
      expected_pc = dut.proc_fe.pc_curr_dec_q0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end


      //+3 relative to branch
      #365;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;
      #1
      expected_pc = dut.proc_fe.pc_curr_dec_q0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end


      //On an branch without branching
      #385;
      @(posedge clk);
      interrupt_key = 1;
      @(posedge clk);
      interrupt_key = 0;
      #1
      expected_pc = dut.proc_fe.pc_curr_dec_q0;
      @(posedge clk);
      #1;
      if(dut.proc_fe.i_reg != expected_pc) begin
        $error("INTERRUPT FAILED: %s => i_reg mismatch: %h, got %h", testname, expected_pc, dut.proc_fe.i_reg);
      end


      //interrupt on branch without a branch taken
      fork 
        begin
          while (dut.proc_de.REGFILE.regfile[7] != 32'h8) begin
          @(posedge clk);
          end
          check_basic_register(
            2, 
            32'd4, 
            "did all rsi" 
          );
          check_basic_register(
            3, 
            32'd4, 
            "did all rti"
          );
          disable timeout_int_b;
        end
        begin : timeout_int_b
          repeat (500) @(posedge clk);
          $error("TEST FAILED: Timeout: Interrupt_branch test did not complete.");
          $stop;
        end
      join_any
    end

    repeat (10) @(posedge clk);

    $display("Finished stepping through all instructions!");
    $stop;
  end
  
  task check_basic_register(
    input [4:0]  reg_num,
    input [31:0] expected_val,
    input string test_name
  );
    begin
      automatic logic [31:0] actual_val = dut.proc_de.REGFILE.regfile[reg_num];
      if (actual_val !== expected_val) begin
        $error("INSTRUCTION FAILED: %s => Register x%0d mismatch: expected %h, got %h",
               test_name, reg_num, expected_val, actual_val);
        basic_instr_err += 1;
      end 
    end
  endtask

  task check_test(
    input [4:0]  reg_num,
    input [31:0] expected_val,
    input string test_name
  );
    begin
      automatic logic [31:0] actual_val = dut.proc_de.REGFILE.regfile[reg_num];
      if (actual_val !== expected_val) begin
        $error("TEST FAILED: %s => Register x%0d mismatch: expected %h, got %h",
               test_name, reg_num, expected_val, actual_val);
      end else begin
        $display("TEST PASSED: %s => Register x%0d matched expected value %h",
                 test_name, reg_num, actual_val);
      end
    end
  endtask

endmodule
