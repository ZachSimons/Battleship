`timescale 1ns/1ps

module wrapper_tb();

// Testbench signals
logic          clk;
logic          rst_n;
logic          wrt_en;
logic          rd_en;
logic          mem_unsigned;
logic   [1:0]  width;
logic  [31:0]  wrt_data;
logic  [31:0]  wrt_addr;
logic  [31:0]  rd_data;
logic          mem_error;
logic          write_controler;


// Instantiate the DUT (Device Under Test)
data_memory_wrapper dut (
  .clk         (clk),
  .rst_n       (rst_n),
  .wrt_en      (wrt_en),
  .rd_en       (rd_en),
  .mem_unsigned(mem_unsigned),
  .width       (width),
  .wrt_data    (wrt_data),
  .wrt_addr    (wrt_addr),
  .rd_data     (rd_data),
  .mem_error   (mem_error)
);

//Test bench data
logic [31:0]   seed;
logic [31:0]   err_count;
logic [31:0]   expected_data;
logic [31:0]   save_data    [0:999];
logic [1:0]    save_width   [0:999];
logic [1:0]    save_bank    [0:999];
logic          save_aligned [0:999];


// Clock generator: toggles every 5 ns
always begin
  #5 clk = ~clk;
end

// Test
initial begin
  //Initalization
  clk = '0;
  rst_n = '0;
  wrt_en = '0;
  rd_en = '0;
  mem_unsigned = '0;
  width = '0;
  wrt_data = '0;
  wrt_addr = '0;
  err_count = '0;
  
  repeat(2) @(posedge clk);
  
  @(negedge clk);
  rst_n = 1;

  //Large amount of random writes
  $display("Starting Random Writes");
  for(integer i = 0; i < 1000; i++) begin
    @(negedge clk);
    width = $random(seed); //Choose Random width
    if(width == 2'd3) begin
      save_width[i] = 0;
      width = 0;
    end else begin
      save_width[i] = width;
    end

    wrt_data = $random(seed); //Choose Random Write Data
    save_data[i] = wrt_data;

    save_bank[i] = $random(seed); //Choose a "random" bank to address to
    //Handle if width is 3
    wrt_addr = (i * 4) + save_bank[i]; 

    //Only Write if the memory is aligned

    write_controler = ((width == 2'b10) && (wrt_addr[0] == 1)) || ((width == 2'b00) && (wrt_addr[1:0] != 2'b00));
    if(!write_controler) begin
      wrt_en = 1;
      save_aligned[i] = 1;
    end
    else begin
      #1;
      if(!mem_error) begin
        $display("mem_error wasn't asserted on iteration %d", i);
        err_count++;
      end
      save_aligned[i] = 0;
    end

    @(negedge clk);
    wrt_en = 0;
  end

  repeat(2) @(posedge clk);
  $display("Verifying Random Writes");
  //Verfying that writes where sucessful if aligned
  for(integer j = 0; j < 1000; j++) begin
    @(negedge clk);
    width = save_width[j];
    wrt_addr = (j * 4) + save_bank[j];
    mem_unsigned = $random(seed); //Assign a random value for unsigned
    rd_en = 1;

    repeat(2) @(posedge clk);
    #1;
    //@(negedge clk);
    if(save_aligned[j]) begin //Data was aligned so check if the rd_data is correct
      //$display("%d", {mem_unsigned, width});
      case({mem_unsigned, width})
        3'b000: begin  //Full word signed
          expected_data = save_data[j];           
          if(expected_data != rd_data) begin
            $display("Error Full: Data written was different than data read from memory. Expected: 0x%h, ReadValue 0x%h, index %d", expected_data, rd_data, j);
            err_count+=1;
          end
        end  
        3'b001: begin  //LSB byte signed        
          expected_data = {{5'd24{save_data[j][7]}}, save_data[j][7:0]};                
          if(expected_data != rd_data) begin
            $display("Error byte signed: Data written was different than data read from memory. Expected: 0x%h, ReadValue 0x%h, index %d", expected_data, rd_data, j);
            err_count+=1;
          end
        end                      
        3'b010: begin //Half signed
          expected_data = {{5'd16{save_data[j][15]}}, save_data[j][15:0]};                
          if(expected_data != rd_data) begin
            $display("Error half signed: Data written was different than data read from memory. Expected: 0x%h, ReadValue 0x%h, index %d", expected_data, rd_data, j);
            err_count+=1;
          end
        end
        3'b101: begin //LSB byte unsigned
          expected_data = {{5'd24{1'b0}}, save_data[j][7:0]};                
          if(expected_data != rd_data) begin
            $display("Error byte unsigned: Data written was different than data read from memory. Expected: 0x%h, ReadValue 0x%h, index %d", expected_data, rd_data, j);
            err_count+=1;
          end
        end
        3'b110: begin //Half byte unsigned
          expected_data = {{5'd16{1'b0}}, save_data[j][15:0]};                
          if(expected_data != rd_data) begin
              $display("Error half unsigned: Data written was different than data read from memory. Expected: 0x%h, ReadValue 0x%h, index %d", expected_data, rd_data, j);
              err_count+=1;
          end
        end
      endcase 
    end
    else begin   //Data wasn't aligned check to see if error was thrown and data read is zero
      if(!mem_error) begin
        $display("mem_error wasn't asserted");
        err_count+=1;
      end
      if(rd_data != 0) begin
        $display("Error: Data was read from memory even though address was unaligned. Expected: 0, ReadValue 0x%h", rd_data);
        err_count+=1;
      end
    end
    if(err_count > 20) begin
      $display("Too many errors so exiting testbench early");
      $stop;
    end

    @(negedge clk);
    rd_en = 0;
  end
  

  if(err_count != 0) 
    $display("%d Errors found in test bench. See above", err_count);
  else 
    $display("Yahoo all tests pass :)");
  $stop;
end

endmodule
