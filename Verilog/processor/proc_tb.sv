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
