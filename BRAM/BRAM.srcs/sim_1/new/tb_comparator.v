`timescale 1ns / 1ps

module tb_Comparator;
    reg  [3:0] ins_cond;
    reg  [3:0] flag;
    reg        clkcmp;
    wire       exec;
    reg        w_en;     // input of the DUT (flag-capture enable), driven by the testbench

    integer errors = 0;
    integer c, f, k;
    reg [3:0] rc, rf;

    Comparator dut (
        .ins_cond(ins_cond),
        .flag(flag),
        .clkcmp(clkcmp),
        .exec(exec),
        .w_en(w_en)
    );

    initial clkcmp = 0;
    always #5 clkcmp = ~clkcmp;

    // Reference model. Flag bits: N[0] C[1] Z[2] V[3]
    function model(input [3:0] cond, input [3:0] fl);
        reg N, C, Z, V;
        begin
            N = fl[0]; C = fl[1]; Z = fl[2]; V = fl[3];
            case (cond)
                4'b0000: model = (N == V);          // GE
                4'b0001: model = Z;                 // EQ
                4'b0010: model = ~Z;                // NE
                4'b0011: model = C;                 // CS / HS
                4'b0100: model = ~Z & (N == V);     // GT
                4'b0101: model = C & ~Z;            // GTU
                4'b0110: model = Z | (N != V);      // LE
                4'b0111: model = ~C | Z;            // LEU
                4'b1000: model = (N != V);          // LT
                4'b1001: model = ~C;                // LTU
                4'b1010: model = 1'b1;              // AL
                default: model = 1'b0;              // undefined codes never execute
            endcase
        end
    endfunction

    task apply_and_check(input [3:0] cond, input [3:0] fl);
        begin
            ins_cond = cond;
            flag     = fl;
            #10;
            if (exec !== model(cond, fl)) begin
                $display("FAIL: cond=%b flag(VZCN)=%b got exec=%b expected=%b",
                         cond, fl, exec, model(cond, fl));
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        ins_cond = 0; flag = 0; w_en = 0;
        #10;

        // Hand-checked sanity cases
        apply_and_check(4'b0001, 4'b0100);  // EQ with Z=1  -> 1
        apply_and_check(4'b0010, 4'b0100);  // NE with Z=1  -> 0
        apply_and_check(4'b1010, 4'b0000);  // AL           -> 1
        apply_and_check(4'b0001, 4'b0000);  // EQ with Z=0  -> 0 (exec must drop back after AL)
        apply_and_check(4'b1011, 4'b1111);  // undefined    -> 0

        // Every condition x every flag combination, ascending
        for (c = 0; c < 16; c = c + 1)
            for (f = 0; f < 16; f = f + 1)
                apply_and_check(c[3:0], f[3:0]);

        // Same sweep descending (exposes outputs that hold a stale value)
        for (c = 15; c >= 0; c = c - 1)
            for (f = 15; f >= 0; f = f - 1)
                apply_and_check(c[3:0], f[3:0]);

        // Random order
        for (k = 0; k < 500; k = k + 1) begin
            rc = $random;
            rf = $random;
            apply_and_check(rc, rf);
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule