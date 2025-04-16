//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
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
module spart(
    input clk,
    input rst_n,
    input iocs,
    input iorw,
    output logic rda,
    output logic tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
);

 logic en;
 logic [8:0] transmit;
 logic [8:0] recieve;
 logic [4:0] t_cnt;
 logic [4:0] r_cnt;
 logic t_start;
 logic r_start;
 logic [7:0] tx_data_reg;

 assign txd = transmit[0];
 assign databus = ((~|ioaddr) && iorw && rda) ? recieve[7:0] : 8'bz;

 always_ff@(posedge clk) begin
    if (!rst_n) begin
        transmit <= 9'b1;
        t_cnt <= 0;
        tbr <= 1;
        tx_data_reg <= 0;
        t_start <= 0;
    end
    else if(iocs && (!iorw) && (~|ioaddr)) begin
        t_cnt <= 0;
        tbr <= 0;
        tx_data_reg <= 8'b0110_0001;
        t_start <= 1;
    end
    else if(en && t_start) begin
        if (t_cnt == 4'd0) begin
            transmit <= {tx_data_reg, 1'b0};
            t_cnt <= t_cnt + 1;
        end
        else if (t_cnt == 4'd10) begin
            tbr <= 1;
            t_start <= 0;
        end
        else begin
            t_cnt <= t_cnt + 1;
            transmit <= {1'b1, transmit[8:1]};
        end
    end
 end

always_ff@(posedge clk) begin
    if(!rst_n) begin
        rda <= 0;
        recieve <= 9'b1;
        r_cnt <= 0;
        r_start <= 0;
    end 
    else if (en) begin
        recieve <= {rxd, recieve[8:1]};
        if (!r_start && !rxd) begin
            rda <= 0;
            r_cnt <= 1;
            r_start <= 1;
        end
        else
            r_cnt <= r_cnt + 1;
        if ((r_cnt == 4'd9) && r_start) begin
            r_start <= 0;
            rda <= 1;
        end
    end
    else
        rda <= 0;
end

baud_rate baud0(.clk(clk), .rst_n(rst_n), .ioaddr(ioaddr), .databus(databus), .enable(en));

endmodule
