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

    // Hold reset
    #20;
    rst_n = 1;

    // Wait for a while to simulate
    #200;

    // Show register values
    $display("x1 = %h", dut.proc_de.REGFILE.regfile[1]);
    $display("x2 = %h", dut.proc_de.REGFILE.regfile[2]);
    $display("x3 = %h", dut.proc_de.REGFILE.regfile[3]);

    $stop;
  end

endmodule
