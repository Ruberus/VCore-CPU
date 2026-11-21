`timescale 1ns / 1ps

module tb_mux;
    reg  [31:0] in0, in1;
    reg         selmux;
    wire [31:0] out;

    integer errors = 0;
    integer i;

    // Device under test
    mux dut (
        .in0(in0),
        .in1(in1),
        .selmux(selmux),
        .out(out)
    );

    task check(input [31:0] expected);
        begin
            #1;
            if (out !== expected) begin
                $display("FAIL: sel=%b in0=%h in1=%h got=%h expected=%h",
                         selmux, in0, in1, out, expected);
                errors = errors + 1;
            end else
                $display("PASS: sel=%b out=%h", selmux, out);
        end
    endtask

    initial begin
        // Directed tests
        in0 = 32'hAAAA_AAAA; in1 = 32'h5555_5555;
        selmux = 1'b0; #10; check(in0);
        selmux = 1'b1; #10; check(in1);

        // Edge values
        in0 = 32'h0000_0000; in1 = 32'hFFFF_FFFF;
        selmux = 1'b0; #10; check(32'h0000_0000);
        selmux = 1'b1; #10; check(32'hFFFF_FFFF);

        // Changing the unselected input must not affect the output
        selmux = 1'b0;
        in1 = 32'h1234_5678; #10; check(in0);
        selmux = 1'b1;
        in0 = 32'h8765_4321; #10; check(in1);

        // Random tests
        for (i = 0; i < 50; i = i + 1) begin
            in0 = $random;
            in1 = $random;
            selmux = $random;
            #10;
            check(selmux ? in1 : in0);
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule