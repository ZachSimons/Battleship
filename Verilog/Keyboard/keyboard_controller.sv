module keyboard (sys_clk, rst_n, ps2_clk, ps2_data, direction, fire, done);

input  sys_clk, rst_n;               // system signals 
input  ps2_clk, ps2_data;     // ps2 data & clock

output logic [1:0] direction;     // outputs for processor/interrupt 
output fire, done;          

logic [4:0] count;
logic [10:0] shift_reg [0:1];
logic [1:0] finish;
logic extend;

assign finish[0] = (count == 5'd11);
assign finish[1] = (count == 5'd22);

// counter to count # of ps2_clk cycles
// use for when data is done
always @(negedge ps2_clk, negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
    end 
    else if ((finish[0] & ~extend) | finish[1]) begin
        count <= 1;
    end
    else begin
        count <= count + 1;
    end
end

// shift register for data
// shift_reg[0] holds first byte sent from keyboard
// LSB gets sent first
always @(negedge ps2_clk, negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= '{default:11'b0};
    end
    else if ((count >= 4'd11)) begin
        shift_reg[1] <= {ps2_data, shift_reg[1][10:1]};
    end
    else begin
        shift_reg[0] <= {ps2_data, shift_reg[0][10:1]};
    end
end

// signals for determining dir
logic w, a, s, d, enter, space;
logic up, down, left, right;
logic [7:0] bytes [0:1];
assign bytes[0] = shift_reg[0][8:1];
assign bytes[1] = shift_reg[1][8:1];

// single byte keys
assign w = (bytes[0] == 8'h1D);
assign s = (bytes[0] == 8'h1B);
assign a = (bytes[0] == 8'h1C);
assign d = (bytes[0] == 8'h23);
assign space = (bytes[0] == 8'h29);
assign enter = (bytes[0] == 8'h5A);

// check if input is an extended key if first byte is F0 or E0
assign extend = (bytes[0] == 8'hE0 || bytes[0] == 8'hF0);

// extended key bytes
assign up = (bytes[1] == 8'h75);
assign left = (bytes[1] == 8'h6B);
assign down = (bytes[1] == 8'h72);
assign right = (bytes[1] == 8'h74);

// comb logic for dir output
always_comb begin  
    if (w | up) begin
        direction = 2'b00;
    end 
    else if (s | down) begin
        direction = 2'b01;
    end
    else if (a | left) begin
        direction = 2'b10;
    end
    else begin
        // default to right dir
        direction = 2'b11;
    end
end

// only assign done when finish & correct byte regs are correct
// this done is high until the next transaction
logic set_done;
assign set_done = finish[0] ? (w | s | a | d | fire) : 
                  finish[1] ? ((bytes[0] == 8'hE0) & (up | down | left | right)) :
                  0;

// fire when space or enter are pressed
assign fire = (space | enter);

// flip flop to assign signal for only 1 cycle of sys_clk
// we'll do this by checking for rising edge after doubling flopping signal
logic done_ff1, done_ff2, done_ff3;
always @(posedge sys_clk, negedge rst_n) begin
    if(!rst_n) begin
        done_ff1 <= 0;
        done_ff2 <= 0;
        done_ff3 <= 0;
    end
    done_ff1 <= set_done;
    done_ff2 <= done_ff1;
    done_ff3 <= done_ff2;
end

assign done = done_ff2 & ~done_ff3;

endmodule
