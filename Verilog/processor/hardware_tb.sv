`timescale 1ns/1ps
module hardware_tb();

    logic sys_clk, rst_n, interrupt_key_local, interrupt_board, sac, snd, uad, ppu_send;
    logic [31:0] spart_data, interface_data, interrupt_data;

    proc processor_i (
        .clk(sys_clk),
        .rst_n(rst_n),
        .interrupt_key(interrupt_key_local),
        .interrupt_eth(interrupt_board),
        .interrupt_source_data(interrupt_board ? spart_data : (interrupt_key_local) ? interrupt_data : '0),
        .accelerator_data(accelerator_data),
        .sac(sac),
        .snd(snd),
        .uad(uad),
        .ppu_send(ppu_send),
        .interface_data(interface_data)
    );

    initial begin
        sys_clk = 0;
        interrupt_key_local = 0;
        interrupt_board = 0;
        interrupt_data = 0;
        spart_data = 0;
        @(negedge sys_clk);
        rst_n = 0;
        repeat(2) @(negedge sys_clk);
        rst_n = 1;
        repeat(100000) @(negedge sys_clk);
        interrupt_board = 1;
        @(negedge sys_clk);
        interrupt_board = 0;
        repeat(100000) @(negedge sys_clk);
        $stop;
    end
    
    always #5 sys_clk = ~sys_clk;

endmodule