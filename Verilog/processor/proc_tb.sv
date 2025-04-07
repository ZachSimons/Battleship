`timescale 1ns/1ps

module proc_tb;

  logic clk;
  logic rst_n;
  logic interrupt_key;
  logic interrupt_eth;
  logic accelerator_data;
  logic [31:0] interrupt_source_data;

  logic sac, snd, uad, ppu_send;
  logic [31:0] interface_data;


  int test_index;
  

  typedef struct {
    string  test_name;
    logic [5:0] reg_to_check;  
    logic [31:0] instr_code;     
    logic [31:0] expected_val;
  } test_info_t;

  test_info_t test_list_jumps[] = '{
    '{
      test_name      : "addi x1, x0, 100",
      instr_code     : 32'h06400093,
      reg_to_check   : 5'd1,
      expected_val   : 32'd100  
    },
    '{
      test_name      : "addi x2, x0, 100",
      instr_code     : 32'h06400093,
      reg_to_check   : 5'd2,
      expected_val   : 32'd100  
    },
    '{
      test_name      : "jal x30, 12",
      instr_code     : 32'h00c00f6f,
      reg_to_check   : 5'd30,
      expected_val   : 32'd12  
    },
    '{
      test_name      : "addi x1, x1, 100",
      instr_code     : 32'h06408093,
      reg_to_check   : 5'd1,
      expected_val   : 32'd200 
    },
    '{
      test_name      : "addi x2, x0, 50",
      instr_code     : 32'h06408093,
      reg_to_check   : 5'd2,
      expected_val   : 32'd50 
    },
    '{
      test_name      : "addi x2, x0, 50",
      instr_code     : 32'h06408093,
      reg_to_check   : 5'd2,
      expected_val   : 32'd50 
    },
    '{
      test_name      : "jalr x0, x30, 0",
      instr_code     : 32'h000f0067,
      reg_to_check   : 5'd0,
      expected_val   : 32'd0 
    },
    '{
      test_name      : "sub x1, x1, x2",
      instr_code     : 32'h402080b3,
      reg_to_check   : 5'd1,
      expected_val   : 32'd150 
    },
    '{
      test_name      : "jal x0 16",
      instr_code     : 32'h0100006f,
      reg_to_check   : 5'd0,
      expected_val   : 32'd0
    },
    '{
      test_name      : "ADDI x11, x11, 0xEF",
      instr_code     : 32'h0ef58593,
      reg_to_check   : 5'd11,
      expected_val   : 32'h000000EF
    },
    '{
      test_name      : "//SW  x11, 2(x3)",
      instr_code     : 32'h00b1a123,
      reg_to_check   : 5'd0,
      expected_val   : 32'h0
    },
    '{
      test_name      : "//LW x5, 2(x3)",
      instr_code     : 32'h0021a283,
      reg_to_check   : 5'd5,
      expected_val   : 32'h000000EF
    }
  };


  test_info_t test_list[] = '{
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
      expected_val   : 32'hFFFFFABD   // if x1=1 => 1 | 0xABCD => 0xABCD
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
      expected_val   : 32'hDEADBEEF  
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
    accelerator_data = 0;
    interrupt_source_data = 32'hDEADBEEF;

    

    #20;
    rst_n = 1;
    repeat (7) @(posedge clk);

    // For each instruction in test_list:
    for (int i = 0; i < $size(test_list_jumps); i++) begin
      repeat (1) @(posedge clk);

      if ((dut.instruction_ex_mem[6:0] == 7'b0000011)) repeat(2) @(posedge clk);

      if ((dut.instruction_ex_mem == 32'h00000013)) @(posedge clk);
      // Now check the register
      #1;
      check_register(
        test_list_jumps[i].reg_to_check, 
        test_list_jumps[i].expected_val, 
        test_list_jumps[i].test_name
      );
    end
    repeat(10) @(posedge clk);
    $display("Finished stepping through all instructions!");
    $stop;
  end
  
  task check_register(
    input [4:0]  reg_num,
    input [31:0] expected_val,
    input string test_name
  );
    begin
      automatic logic [31:0] actual_val = dut.proc_de.REGFILE.regfile[reg_num];
      if (actual_val !== expected_val) begin
        $error("FAILED: %s => Register x%0d mismatch: expected %h, got %h",
               test_name, reg_num, expected_val, actual_val);
      end else begin
        $display("SUCCESS: %s => Register x%0d matched expected value %h",
                 test_name, reg_num, actual_val);
      end
    end
  endtask


endmodule
