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

  test_info_t test_list[] = '{
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
      test_name      : "NOP #2",
      instr_code     : 32'h00000013,  // NOP (ADDI x0,x0,0)
      reg_to_check   : 5'd0,
      expected_val   : 32'h0         // x0 always 0
    },
    '{
      test_name      : "NOP #3",
      instr_code     : 32'h00000013,  // NOP (ADDI x0,x0,0)
      reg_to_check   : 5'd0,
      expected_val   : 32'h0         // x0 always 0
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
      test_name      : "ORI x6, x1, 0xABCD",
      instr_code     : 32'hbcd0e313, // blank
      reg_to_check   : 5'd6,
      expected_val   : 32'h0000ABCD   // if x1=1 => 1 | 0xABCD => 0xABCD
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
    repeat (4) @(posedge clk);

    // For each instruction in test_list:
    for (int i = 0; i < $size(test_list); i++) begin
      repeat (3) @(posedge clk);
  
      // Now check the register
      check_register(
        test_list[i].reg_to_check, 
        test_list[i].expected_val, 
        test_list[i].test_name
      );
    end
  
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
