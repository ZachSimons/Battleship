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
    input snd,
    input [7:0] tx_data,
    output logic [1:0] ioaddr,
    inout [7:0] databus
    );

logic [15:0] baudrate;

// mux for baudrate based off br_cfg
always_comb begin
    case(br_cfg)
        2'b00 : baudrate = 16'd10416;
        2'b01 : baudrate = 16'd5208;
        2'b10 : baudrate = 16'd2604;
        2'b11 : baudrate = 16'd1302;
    endcase
end

////// STATE MACHINE ///////
typedef enum logic {IDLE, TRANSMIT} state_t;
state_t state, next_state;

// next state each cycle
always_ff @(posedge clk) begin
	if (!rst_n) begin
		state <= IDLE;
	end
	else begin
		state <= next_state;
	end
end

// assign databus = (state == BAUD_LOW) ?      baudrate[7:0] :
//                  (state == BAUD_HIGH) ?    baudrate[15:8] :
//                                                       8'bz; 

// next state transistion logic
always_comb begin
    iocs = 0;
    iorw = 0;
    ioaddr = 0;
    databus = 8'bz;
    next_state = state;

    case(state)
        // BAUD_LOW : begin
        //     databus = baudrate[7:0];
        //     ioaddr = 2'b10;
        //     next_state = BAUD_HIGH;
        // end

        // BAUD_HIGH : begin
        //     databus = baudrate[15:8];
        //     ioaddr = 2'b11;
        //     next_state = IDLE;
        // end

        IDLE : begin
            if (snd & tbr) begin
                iocs = 1;
                databus = tx_data;
                next_state = TRANSMIT;
            end
            else if (rda) begin
                iorw = 1;
            end
        end

        TRANSMIT : begin
            if (tbr)
                next_state = IDLE;
        end

        default : next_state = IDLE;
    endcase
end

endmodule
