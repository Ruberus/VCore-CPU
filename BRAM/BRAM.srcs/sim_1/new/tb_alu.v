`timescale 1ns / 1ps

module tb_ALU;
    reg  [3:0]  opcode;
    reg  [31:0] input_A, input_B, lsf_input;
    wire [31:0] output_result, lsf_output_result;
    wire [3:0]  flag;

    integer errors = 0;
    integer i, j, k;
    reg [31:0] edge_val [0:5];
    reg [3:0]  rop;
    reg [31:0] ra, rb, rl;

    ALU dut (
        .opcode(opcode),
        .input_A(input_A),
        .input_B(input_B),
        .output_result(output_result),
        .lsf_output_result(lsf_output_result),
        .flag(flag),
        .lsf_input(lsf_input)
    );

    // ------------------------------------------------------------------
    // Reference model (written independently of the DUT).
    // Opcodes: 1 ADD, 2 SUB, 3 AND, 4 OR, 5 NOT, 7 LSR, 9 LSL, 10 ASR,
    //          11 CMP, 12 address calc (lsf), 13 A+4
    // Flag layout (matches the Comparator): N[0] C[1] Z[2] V[3]
    //   ADD     : C = carry out
    //   SUB/CMP : C = 1 when A >= B unsigned (no borrow)
    // ------------------------------------------------------------------
    function [31:0] ref_result(input [3:0] op, input [31:0] a, input [31:0] b);
        reg signed [31:0] sa;
        begin
            sa = a;
            case (op)
                4'd1:    ref_result = a + b;
                4'd2:    ref_result = a - b;
                4'd3:    ref_result = a & b;
                4'd4:    ref_result = a | b;
                4'd5:    ref_result = ~a;
                4'd7:    ref_result = a >> b;     // logical
                4'd9:    ref_result = a << b;
                4'd10:   ref_result = sa >>> b;   // arithmetic
                4'd13:   ref_result = a + 32'd4;
                default: ref_result = 32'b0;
            endcase
        end
    endfunction

    function [3:0] ref_flag(input [3:0] op, input [31:0] a, input [31:0] b);
        reg [32:0] sum;
        reg [31:0] d;
        reg [3:0]  f;
        begin
            f = 4'b0;
            case (op)
                4'd1: begin
                    sum  = {1'b0, a} + {1'b0, b};
                    f[1] = sum[32];                       // C = carry out
                end
                4'd2: f[1] = (a >= b);                    // C = no borrow
                4'd11: begin
                    d    = a - b;
                    f[0] = d[31];                         // N
                    f[1] = (a >= b);                      // C = no borrow
                    f[2] = (d == 32'b0);                  // Z
                    f[3] = (a[31] != b[31]) && (a[31] != d[31]);   // V
                end
                default: ;
            endcase
            ref_flag = f;
        end
    endfunction

    function [31:0] ref_lsf(input [3:0] op, input [31:0] a, input [31:0] li);
        begin
            ref_lsf = (op == 4'd12) ? (li + a) : 32'b0;
        end
    endfunction

    // ------------------------------------------------------------------
    // Check against the reference model
    // ------------------------------------------------------------------
    task check_vec(input [3:0] op, input [31:0] a, input [31:0] b, input [31:0] li);
        reg [31:0] er, el;
        reg [3:0]  ef;
        begin
            opcode = op; input_A = a; input_B = b; lsf_input = li;
            #1;
            er = ref_result(op, a, b);
            ef = ref_flag(op, a, b);
            el = ref_lsf(op, a, li);
            if (output_result !== er) begin
                $display("FAIL result: op=%0d A=%h B=%h got=%h expected=%h", op, a, b, output_result, er);
                errors = errors + 1;
            end
            if (flag !== ef) begin
                $display("FAIL flag:   op=%0d A=%h B=%h got(VZCN)=%b expected=%b", op, a, b, flag, ef);
                errors = errors + 1;
            end
            if (lsf_output_result !== el) begin
                if (op == 4'd12)
                    $display("FAIL lsf:    op=12 A=%h lsf_in=%h got=%h expected=%h", a, li, lsf_output_result, el);
                else
                    $display("FAIL lsf:    op=%0d lsf_output_result=%h but should be 0 (latch? not assigned for this opcode)", op, lsf_output_result);
                errors = errors + 1;
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Hand-computed directed test (expected values written by hand)
    // ------------------------------------------------------------------
    task directed(input [3:0] op, input [31:0] a, input [31:0] b, input [31:0] li,
                  input [31:0] er, input [3:0] ef, input [31:0] el,
                  input [8*24-1:0] name);
        begin
            opcode = op; input_A = a; input_B = b; lsf_input = li;
            #1;
            if (output_result !== er) begin
                $display("FAIL [%0s] result: got=%h expected=%h", name, output_result, er);
                errors = errors + 1;
            end
            if (flag !== ef) begin
                $display("FAIL [%0s] flag(VZCN): got=%b expected=%b", name, flag, ef);
                errors = errors + 1;
            end
            if (lsf_output_result !== el) begin
                $display("FAIL [%0s] lsf: got=%h expected=%h", name, lsf_output_result, el);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        opcode = 0; input_A = 0; input_B = 0; lsf_input = 0;
        edge_val[0] = 32'h0000_0000;
        edge_val[1] = 32'h0000_0001;
        edge_val[2] = 32'h0000_0002;
        edge_val[3] = 32'h7FFF_FFFF;
        edge_val[4] = 32'h8000_0000;
        edge_val[5] = 32'hFFFF_FFFF;
        #5;

        // ---- Directed tests (flag column is V Z C N, bit 3 down to bit 0) ----
        //       op     A             B             lsf_in        result        flag     lsf_out
        directed(4'd1,  32'd10,       32'd5,        32'd0,        32'd15,       4'b0000, 32'd0, "ADD 10+5");
        directed(4'd1,  32'hFFFFFFFF, 32'd1,        32'd0,        32'd0,        4'b0010, 32'd0, "ADD carry out");
        directed(4'd1,  32'h7FFFFFFF, 32'd1,        32'd0,        32'h80000000, 4'b0000, 32'd0, "ADD 7FFFFFFF+1");
        directed(4'd2,  32'd10,       32'd5,        32'd0,        32'd5,        4'b0010, 32'd0, "SUB 10-5 (no borrow)");
        directed(4'd2,  32'd5,        32'd10,       32'd0,        32'hFFFFFFFB, 4'b0000, 32'd0, "SUB 5-10 (borrow)");
        directed(4'd2,  32'd7,        32'd7,        32'd0,        32'd0,        4'b0010, 32'd0, "SUB 7-7 (no borrow)");
        directed(4'd3,  32'hF0F0F0F0, 32'hFF00FF00, 32'd0,        32'hF000F000, 4'b0000, 32'd0, "AND");
        directed(4'd4,  32'hF0F0F0F0, 32'h0F0F0F0F, 32'd0,        32'hFFFFFFFF, 4'b0000, 32'd0, "OR");
        directed(4'd5,  32'h0000FFFF, 32'd0,        32'd0,        32'hFFFF0000, 4'b0000, 32'd0, "NOT");
        directed(4'd7,  32'h80000000, 32'd4,        32'd0,        32'h08000000, 4'b0000, 32'd0, "LSR 8000_0000 >> 4");
        directed(4'd9,  32'd1,        32'd31,       32'd0,        32'h80000000, 4'b0000, 32'd0, "LSL 1 << 31");
        directed(4'd10, 32'h80000000, 32'd4,        32'd0,        32'hF8000000, 4'b0000, 32'd0, "ASR negative");
        directed(4'd10, 32'h40000000, 32'd4,        32'd0,        32'h04000000, 4'b0000, 32'd0, "ASR positive");
        directed(4'd11, 32'h1234,     32'h1234,     32'd0,        32'd0,        4'b0110, 32'd0, "CMP equal (Z,C)");
        directed(4'd11, 32'd5,        32'd10,       32'd0,        32'd0,        4'b0001, 32'd0, "CMP 5 vs 10 (N)");
        directed(4'd11, 32'd10,       32'd5,        32'd0,        32'd0,        4'b0010, 32'd0, "CMP 10 vs 5 (C)");
        directed(4'd11, 32'h80000000, 32'd1,        32'd0,        32'd0,        4'b1010, 32'd0, "CMP overflow (V,C)");
        directed(4'd11, 32'h7FFFFFFF, 32'hFFFFFFFF, 32'd0,        32'd0,        4'b1001, 32'd0, "CMP overflow (V,N)");
        directed(4'd13, 32'h10,       32'd0,        32'd0,        32'h14,       4'b0000, 32'd0, "A+4");
        directed(4'd13, 32'hFFFFFFFC, 32'd0,        32'd0,        32'd0,        4'b0000, 32'd0, "A+4 wraps");
        directed(4'd12, 32'h20,       32'd0,        32'h100,      32'd0,        4'b0000, 32'h120, "address calc");
        directed(4'd13, 32'h20,       32'd0,        32'h100,      32'h24,       4'b0000, 32'd0, "lsf back to 0 after 12");
        directed(4'd0,  32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'd0,        4'b0000, 32'd0, "opcode 0 (unused)");
        directed(4'd6,  32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'd0,        4'b0000, 32'd0, "opcode 6 (unused)");
        directed(4'd8,  32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'd0,        4'b0000, 32'd0, "opcode 8 (unused)");
        directed(4'd14, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'd0,        4'b0000, 32'd0, "opcode 14 (unused)");
        directed(4'd15, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'd0,        4'b0000, 32'd0, "opcode 15 (unused)");

        // ---- Every opcode x edge operands ------------------------------
        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 6; j = j + 1)
                for (k = 0; k < 6; k = k + 1)
                    check_vec(i[3:0], edge_val[j], edge_val[k], edge_val[(i + j + k) % 6]);

        // ---- Random vectors in random opcode order ---------------------
        for (k = 0; k < 3000; k = k + 1) begin
            rop = $random;
            ra  = $random;
            rb  = $random;
            rl  = $random;
            if (rop == 4'd7 || rop == 4'd9 || rop == 4'd10)
                rb = {$random} % 40;     // shift amounts 0..39 (covers >= 32)
            check_vec(rop, ra, rb, rl);
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule