module branch_ctrl(bj_inst, inA, inB, branch);

    input [3:0] bj_inst;
    input [31:0] inA, inB;
    output logic branch;

    always_comb begin
        case(bj_inst)
            4'b1000: begin // BEQ
                branch = inA == inB;
            end
            4'b1001: begin // BNE
                branch = inA != inB;
            end
            4'b1100: begin // BLT
                branch = inA < inB;
            end
            4'b1101: begin // BGE
                branch = inA >= inB;
            end
            4'b1110: begin // BLTU
                branch = {1'b0, inA} < {1'b0, inB};
            end
            4'b1111: begin // BGEU
                branch = {1'b0, inA} >= {1'b0, inB};
            end
            default: begin // Not a branch instruction
                branch = 0;
            end
        endcase
    end
endmodule