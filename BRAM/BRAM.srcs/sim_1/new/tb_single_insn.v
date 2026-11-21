`timescale 1ns / 1ps

// All single-instruction tests in ONE simulation, using all_tests.coe (load it once).
// For each test: reset the CPU, deposit the starting registers, point the PC (r1) at the
// test's instruction, run until the PC has moved past it, then check ALL 32 registers.
//
// Memory layout (byte address of each instruction; stored at word PC and word PC/4 so it works
// whether the BRAM uses the address as a word index or drops the low two bits):
//   PC 0x040  and       AND r4, r2, r3
//   PC 0x048  or        OR r4, r2, r3
//   PC 0x050  not       NOT r2 -> r4
//   PC 0x058  lsl       LSL r4, r2, r3
//   PC 0x060  asr       ASR r4, r2, r3
//   PC 0x068  add       ADD r4, r2, r3
//   PC 0x070  sub       SUB r4, r2, r3
//   PC 0x078  addi      ADDI r5, r5, 100
//   PC 0x080  addi_neg  ADDI r5, r5, -3
//   PC 0x088  subi      SUBI r5, r5, 0x30
//   PC 0x090  mov       MOV r2 -> r6
//   PC 0x098  cmp       CMP r2, r3 (5 vs 10)
//   PC 0x0A0  lbu       LBU r4, [r2 + 12]
//   PC 0x0A8  lb        LB  r4, [r2 + 12]
//   PC 0x0B0  lhu       LHU r4, [r2 + 12]
//   PC 0x0B8  lh        LH  r4, [r2 + 12]
//   PC 0x0C0  lw        LW  r4, [r2 + 12]
// Load tests read from byte address 212 (data word 0x89ABCDEF at word 212 and word 53).
//
// Needs BRAM depth >= 213 words. Run with "run all".
module tb_vcore_all;
    reg clk = 0;
    reg reset = 1;
    wire [3:0] led;

    integer i;
    integer cyc;
    integer lag = 0;
    integer test_errors = 0;
    integer passed = 0;
    integer failed = 0;

    reg [31:0] exp_reg [0:31];
    reg [31:0] test_pc;
    reg [8*12-1:0] test_name;
    reg [3:0] flag_seen;
    reg [3:0] exp_flag;
    reg check_flag;

    VCore dut (
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    always #5 clk = ~clk;   // 100 MHz

    // DECODE-timing detector: at EXECUTE the registered Opcode must match the word on bram_data_out
    always @(posedge clk)
        if (!reset && dut.my_CU.state === 3'b010 && dut.my_CU.Opcode !== dut.bram_data_out[31:27])
            lag = lag + 1;

    // ALU flags: valid while the CU is in INCREMENT_PC (ALU_Opcode is still the instruction's)
    always @(negedge clk)
        if (dut.my_CU.state === 3'b011)
            flag_seen <= dut.my_flag;

    // ---------------- helpers ----------------
    task preset(input [4:0] n, input [31:0] v);      // deposit a starting value (also the expected value)
        begin
            dut.my_register_file.registers[n] = v;
            exp_reg[n] = v;
        end
    endtask

    task expect_reg(input [4:0] n, input [31:0] v);  // this register should change to v
        begin
            exp_reg[n] = v;
        end
    endtask

    task expect_flags(input [3:0] f);                // bit order (V Z C N) = [3:0]
        begin
            exp_flag = f;
            check_flag = 1;
        end
    endtask

    task begin_test(input [8*12-1:0] name, input [31:0] pc);
        begin
            @(negedge clk);
            reset = 1;                                // clears every register and restarts the CU
            repeat (3) @(posedge clk);
            @(negedge clk);
            test_name  = name;
            test_pc    = pc;
            lag        = 0;
            check_flag = 0;
            flag_seen  = 4'bxxxx;
            for (i = 0; i < 32; i = i + 1) exp_reg[i] = 32'b0;
            preset(5'd1, pc);                         // r1 is the PC
        end
    endtask

    task finish_test;
        begin
            exp_reg[1] = test_pc + 32'd4;             // PC should have advanced past the instruction
            test_errors = 0;
            cyc = 0;
            reset = 0;                                // release reset (we are at a negedge)
            while (dut.my_PC_read < test_pc + 32'd4 && cyc < 100) begin
                @(posedge clk);
                cyc = cyc + 1;
            end
            repeat (2) @(posedge clk);                // let the last write settle

            if (cyc >= 100) begin
                $display("  TIMEOUT [%0s]: PC=%h, expected it to reach %h", test_name, dut.my_PC_read, test_pc + 32'd4);
                test_errors = test_errors + 1;
            end
            for (i = 0; i < 32; i = i + 1)
                if (dut.my_register_file.registers[i] !== exp_reg[i]) begin
                    $display("  [%0s] r%0d = %h, expected %h", test_name, i, dut.my_register_file.registers[i], exp_reg[i]);
                    test_errors = test_errors + 1;
                end
            if (check_flag && flag_seen !== exp_flag) begin
                $display("  [%0s] flags (V Z C N) = %b, expected %b", test_name, flag_seen, exp_flag);
                test_errors = test_errors + 1;
            end
            if (lag != 0) begin
                $display("  [%0s] DECODE read a stale instruction word", test_name);
                test_errors = test_errors + 1;
            end

            if (test_errors == 0) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end else begin
                $display("FAIL: %0s (%0d problem(s))", test_name, test_errors);
                failed = failed + 1;
            end
        end
    endtask

    // ---------------- tests ----------------
    initial begin
        // ---- and: AND r4, r2, r3 ----
        begin_test("and", 32'h00000040);
        preset(5'd2, 32'hF0F0F0F0);
        preset(5'd3, 32'hFF00FF00);
        expect_reg(5'd4, 32'hF000F000);
        finish_test;

        // ---- or: OR r4, r2, r3 ----
        begin_test("or", 32'h00000048);
        preset(5'd2, 32'hF0F00000);
        preset(5'd3, 32'h0000F0F0);
        expect_reg(5'd4, 32'hF0F0F0F0);
        finish_test;

        // ---- not: NOT r2 -> r4 ----
        begin_test("not", 32'h00000050);
        preset(5'd2, 32'h0000FFFF);
        expect_reg(5'd4, 32'hFFFF0000);
        finish_test;

        // ---- lsl: LSL r4, r2, r3 ----
        begin_test("lsl", 32'h00000058);
        preset(5'd2, 32'h0000000F);
        preset(5'd3, 32'h00000008);
        expect_reg(5'd4, 32'h00000F00);
        finish_test;

        // ---- asr: ASR r4, r2, r3 ----
        begin_test("asr", 32'h00000060);
        preset(5'd2, 32'h80000000);
        preset(5'd3, 32'h00000004);
        expect_reg(5'd4, 32'hF8000000);
        finish_test;

        // ---- add: ADD r4, r2, r3 ----
        begin_test("add", 32'h00000068);
        preset(5'd2, 32'h12345678);
        preset(5'd3, 32'h11111111);
        expect_reg(5'd4, 32'h23456789);
        finish_test;

        // ---- sub: SUB r4, r2, r3 ----
        begin_test("sub", 32'h00000070);
        preset(5'd2, 32'h00000064);
        preset(5'd3, 32'h00000019);
        expect_reg(5'd4, 32'h0000004B);
        finish_test;

        // ---- addi: ADDI r5, r5, 100 ----
        begin_test("addi", 32'h00000078);
        preset(5'd5, 32'h00000020);
        expect_reg(5'd5, 32'h00000084);
        finish_test;

        // ---- addi_neg: ADDI r5, r5, -3 ----
        begin_test("addi_neg", 32'h00000080);
        preset(5'd5, 32'h00000100);
        expect_reg(5'd5, 32'h000000FD);
        finish_test;

        // ---- subi: SUBI r5, r5, 0x30 ----
        begin_test("subi", 32'h00000088);
        preset(5'd5, 32'h00000100);
        expect_reg(5'd5, 32'h000000D0);
        finish_test;

        // ---- mov: MOV r2 -> r6 ----
        begin_test("mov", 32'h00000090);
        preset(5'd2, 32'hCAFEF00D);
        expect_reg(5'd6, 32'hCAFEF00D);
        finish_test;

        // ---- cmp: CMP r2, r3 (5 vs 10) ----
        begin_test("cmp", 32'h00000098);
        preset(5'd2, 32'h00000005);
        preset(5'd3, 32'h0000000A);
        expect_flags(4'b0001);
        finish_test;

        // ---- lbu: LBU r4, [r2 + 12] ----
        begin_test("lbu", 32'h000000A0);
        preset(5'd2, 32'h000000C8);
        expect_reg(5'd4, 32'h000000EF);
        finish_test;

        // ---- lb: LB  r4, [r2 + 12] ----
        begin_test("lb", 32'h000000A8);
        preset(5'd2, 32'h000000C8);
        expect_reg(5'd4, 32'hFFFFFFEF);
        finish_test;

        // ---- lhu: LHU r4, [r2 + 12] ----
        begin_test("lhu", 32'h000000B0);
        preset(5'd2, 32'h000000C8);
        expect_reg(5'd4, 32'h0000CDEF);
        finish_test;

        // ---- lh: LH  r4, [r2 + 12] ----
        begin_test("lh", 32'h000000B8);
        preset(5'd2, 32'h000000C8);
        expect_reg(5'd4, 32'hFFFFCDEF);
        finish_test;

        // ---- lw: LW  r4, [r2 + 12] ----
        begin_test("lw", 32'h000000C0);
        preset(5'd2, 32'h000000C8);
        expect_reg(5'd4, 32'h89ABCDEF);
        finish_test;

        $display("==== %0d passed, %0d failed ====", passed, failed);
        if (failed == 0)
            $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
