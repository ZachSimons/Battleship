//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module driver(
    input clk,
    input rst_n,
    input [1:0] br_cfg,
    output logic iocs,
    output logic iorw,
    input rda,
    input tbr,
    output logic [1:0] ioaddr,
    inout [7:0] databus
    );

logic [15:0] baudrate;

// for UART transmit
logic [7:0] uart_reg;

// mux for baudrate based off br_cfg
always_comb begin
    case(br_cfg)
        2'b00 : baudrate = 16'd10416;
        2'b01 : baudrate = 16'd5208;
        2'b10 : baudrate = 16'd2604;
        2'b11 : baudrate = 16'd1302;
    endcase
end

always_ff @(posedge clk) begin
    if (rda) begin
        uart_reg <= databus;
    end
end

////// STATE MACHINE ///////
typedef enum logic[2:0] {BAUD_LOW, BAUD_HIGH, IDLE, RECEIVE, TRANSMIT} state_t;
state_t state, next_state;

// next state each cycle
always_ff @(posedge clk) begin
	if (!rst_n) begin
		state <= BAUD_LOW;
	end
	else begin
		state <= next_state;
	end
end

assign databus = (state == BAUD_LOW) ?      baudrate[7:0] :
                 (state == BAUD_HIGH) ?    baudrate[15:8] :
                 (state == RECEIVE) ?           uart_reg  :
                                                      8'bz; 

// next state transistion logic
always_comb begin
    iocs = 0;
    iorw = 0;
    ioaddr = 0;
    next_state = state;

    case(state)
        BAUD_LOW : begin
            ioaddr = 2'b10;
            next_state = BAUD_HIGH;
        end

        BAUD_HIGH : begin
            ioaddr = 2'b11;
            next_state = TRANSMIT;
        end

        IDLE : begin
            if (snd & tbr) begin
                iocs = 1;
                next_state = TRANSMIT;
            end
            else if (rda) begin
                iorw = 1;
                next_state = RECEIVE;
            end
        end

        RECEIVE : begin
            iorw = 1;
            if ()
                next_state = IDLE;
        end

        TRANSMIT : begin
            if (tbr)
                next_state = IDLE;
        end

        default : next_state = IDLE;
    endcase
end

endmodule
