module test_spart(
    input clk,
    input rst_n,
    input rxd,
    output [23:0] rdata,
    output txd,
    input [23:0] tdata,
    output logic rx_done,
    input start_transmission,
    input [15:0] baud
);

    typedef enum logic [1:0] {IDLE, READ, WRITE} state_t;
    state_t state, next_state;

    logic [24:0] shift_reg, read_reg;
    logic rx_ff, enable_rx, enable_tx, load, reset_cnt, reset_rd, reset_baud_cnt;

    logic [15:0] count;
    logic [4:0] cnt;

    assign txd = shift_reg[0];
    assign rdata = read_reg[24:1];

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
        end else if(reset_cnt) begin
            cnt <= 0;
        end else if(enable_tx) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= cnt;
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            read_reg <= '1;
        end else if(reset_rd) begin
            read_reg <= '1;
        end else if(enable_rx) begin
            read_reg <= {rxd, read_reg[24:1]};
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            count <= baud;
            enable_rx <= 0;
            enable_tx <= 0;
        end else if(reset_baud_cnt) begin
            count <= baud;
            enable_rx <= 0;
            enable_tx <= 0;
        end else if(count === (baud / 2)) begin
            count <= count - 1;
            enable_tx <= 0;
            enable_rx <= 1;
        end else if(count === 16'h0000) begin
            count <= baud;
            enable_tx <= 1;
            enable_rx <= 0;
        end else begin
            count <= count - 1;
            enable_rx <= 0;
            enable_tx <= 0;
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            shift_reg <= '1;
        end else if(load) begin
            shift_reg <= {tdata, 1'b0};
        end else if(enable_tx) begin
            shift_reg <= {1'b1, shift_reg[24:1]};
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        rx_ff <= rxd;
    end

    always_comb begin
        next_state = state;
        rx_done = 0;
        reset_cnt = 0;
        load = 0;
        reset_rd = 0;
        reset_baud_cnt = 0;
        case(state)
            WRITE: begin
                if(cnt === 5'd25) begin
                    next_state = IDLE;
                end
            end
            READ: begin
                if(read_reg[0] === 1'b0) begin
                    rx_done = 1'b1;
                    next_state = IDLE;
                end
            end
            default: begin
                if(start_transmission) begin
                    load = 1;
                    reset_cnt = 1;
                    reset_baud_cnt = 1;
                    next_state = WRITE;
                end
                if(~rxd & rx_ff) begin
                    reset_cnt = 1;
                    reset_rd = 1;
                    reset_baud_cnt = 1;
                    next_state = READ;
                end
            end
        endcase
    end

endmodule