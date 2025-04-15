module ALU_tb();

    logic err;
    logic [31:0] inA, inB, out, expected;
    logic [2:0] alu_op;
    logic option_bit;
    
    alu iDUT(.inA(inA), .inB(inB), .alu_op(alu_op), .option_bit(option_bit), .out(out));
    
    logic [31:0] seed;
    logic [9:0] count;
    initial begin
        err = 0;
        count = 0;
        for(integer i = 0; i < 1048576; i += 1) begin
            // Generate values
            inA = $random(seed);
            inB = $random(seed);
            alu_op = $random(seed);
            option_bit = $random(seed);
            #1;
            // Check output
            case(alu_op)
                3'b000: begin
                    if(option_bit)
                        expected = inA - inB;
                    else
                        expected = inA + inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d +%d %d = %d instead of %d!", i, inA, option_bit, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b001: begin
                    expected = inA << inB[4:0];
                    if(expected !== out) begin
                        $display("ERROR: at %d found %b << %b = %b instead of %b!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b010: begin
                    expected = {{31{1'b0}}, inA < inB};
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d < %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b011: begin
                    expected = {{31{1'b0}}, {1'b0, inA} < {1'b0, inB}};
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d <(u) %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b100: begin
                    expected = inA ^ inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %b ^ %b = %b instead of %b!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b101: begin
                    if(option_bit)
                        expected = inA >>> inB[4:0];
                    else
                        expected = inA >> inB[4:0];
                    if(expected !== out) begin
                        $display("ERROR: at %d found %b >>%b %b = %b instead of %b!", i, inA, option_bit, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b110: begin
                    expected = inA | inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %b | %b = %b instead of %b!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                3'b111: begin
                    expected = inA & inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %b & %b = %b instead of %b!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                default: begin
                    $display("ERROR: at %d found %b as alu_op!", i, alu_op);
                    err = 1;
                    count += 1;
                end
            endcase
            #5;
            if(count > 1000) begin
                $display("Too many errors, aborting tests!");
                $stop;
            end
        end

        if(err)
            $display("Not all tests passed, see above for errors!");
        else
            $display("YAHOO!! All tests passed!");
        $stop;
    end
endmodule