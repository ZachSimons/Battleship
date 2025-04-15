module Branch_Control_tb();

    logic err;
    logic [31:0] inA, inB;
    logic [3:0] bj_inst;
    logic out, expected;
    
    branch_ctrl iDUT(.inA(inA), .inB(inB), .bj_inst(bj_inst), .branch(out));
    
    logic [31:0] seed;
    logic [9:0] count;
    initial begin
        err = 0;
        count = 0;
        for(integer i = 0; i < 1048576; i += 1) begin
            // Generate values
            inA = $random(seed);
            inB = $random(seed);
            bj_inst = $random(seed);
            #1;
            // Check output
            case(bj_inst)
                4'b1000: begin
                    expected = inA == inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d == %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1001: begin
                    expected = inA !== inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d != %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1011: begin
                    expected = 1;
                    if(expected !== out) begin
                        $display("ERROR: at %d found JAL is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1100: begin
                    expected = inA < inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d < %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1101: begin
                    expected = inA >= inB;
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d >= %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1110: begin
                    expected = {1'b0, inA} < {1'b0, inB};
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d <(u) %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                4'b1111: begin
                    expected = {1'b0, inA} >= {1'b0, inB};
                    if(expected !== out) begin
                        $display("ERROR: at %d found %d >=(u) %d is %d instead of %d!", i, inA, inB, out, expected);
                        err = 1;
                        count += 1;
                    end
                end
                default: begin
                    expected = 0;
                    if(expected !== out) begin
                        $display("ERROR: at %d branched on invalid instr %b!", i, bj_inst);
                        err = 1;
                        count += 1;
                    end
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