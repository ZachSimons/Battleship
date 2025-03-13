module alu(inA, inB, out, alu_op, option_bit);

    input [31:0] inA, inB;
    input [2:0] alu_op;
    input option_bit;
    output logic [31:0] out;

    always_comb begin
        case(alu_op)
            3'b000: begin // ADD,SUB
                out = option_bit ? inA - inB : inA + inB;
            end
            3'b001: begin // SLL
                out = inA << inB[4:0];
            end
            3'b010: begin // SLT
                out = inA < inB ? 32'h00000001 : 32'h00000000;
            end
            3'b011: begin // SLTU
                out = {1'b0, inA} < {1'b0, inB} ? 32'h00000001 : 32'h00000000;
            end
            3'b100: begin // XOR
                out = inA ^ inB;
            end
            3'b101: begin // SRL,SRA
                out = option_bit ? (inA >>> inB[4:0]) : (inA >> inB[4:0]);
            end
            3'b110: begin // OR
                out = inA | inB;
            end
            default: begin // AND (111)
                out = inA & inB;
            end
        endcase
    end

endmodule