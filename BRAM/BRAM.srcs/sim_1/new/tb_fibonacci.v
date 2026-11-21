`timescale 1ns / 1ps

// Fibonacci(4) with a loop (3 passes), dense layout: word = PC/4.
// Needs the saved-flags Comparator: CMP -> stored flags -> conditional jump.
//   PC 0x00  ADD  r0, r0, r0         ; filler (absorbs the stale first opcode)
//   PC 0x04  ADDI r3, r3, 1          ; b = F1 = 1
//   PC 0x08  ADDI r5, r5, 3          ; counter = 3
//   PC 0x0C  ADD  r4, r2, r3         ; loop: t = a + b
//   PC 0x10  MOV  r3 -> r2           ; a = b
//   PC 0x14  MOV  r4 -> r3           ; b = t
//   PC 0x18  SUBI r5, r5, 1          ; counter--
//   PC 0x1C  CMP  r5, r0             ; counter vs 0
//   PC 0x20  ADDI r1, r1, -20 (NE)   ; jump back to 0x0C while counter != 0
//
// Each pass: t = a + b; a = b; b = t.  After 3 passes b = F4 = 3, a = F3 = 2.
// Final registers: r1 = 0x24 (PC), r2 = 2, r3 = 3, r4 = 3, r5 = 0, everything else 0.
// The first instruction (ADD r0, r0, r0) is a harmless filler that absorbs the stale first opcode.
//
// Load fib4_loop.coe into the BRAM IP. Run with "run all".
module tb_fib4_loop;
    localparam [31:0] END_PC    = 32'h24;
    localparam [31:0] LOOP_HEAD = 32'h0C;
    localparam        PASSES    = 3;
    parameter MAX_CYCLES = 1500;

    reg clk = 0;
    reg reset = 1;
    wire [3:0] led;

    integer cycles = 0;
    integer errors = 0;
    integer it = 0;
    integer i;
    reg runaway = 0;
    reg [31:0] exp_a [0:2];
    reg [31:0] exp_b [0:2];
    reg [31:0] exp_n [0:2];
    reg [31:0] exp_reg [0:31];

    VCore dut (
        .clk(clk),
        .reset(~reset),     // the design resets on a LOW level (board button is inverted)
        .led(led)
    );

    always #5 clk = ~clk;   // 100 MHz

always @(posedge clk)
    if (!reset && dut.my_CU.Opcode === 5'b00111 && dut.my_CU.state >= 3'b011)
        $display("%0t CMP: st=%0d cmp_en=%b alu_op=%b rd1=%0d rd2=%0d alu_flag=%b stored=%b",
                 $time, dut.my_CU.state, dut.my_CU.comparator_en, dut.my_CU.ALU_Opcode,
                 dut.my_register_file.reado_1, dut.my_register_file.reado_2,
                 dut.my_comparator.flag, dut.my_comparator.stored_flag);

    // Each time the CU is about to fetch the loop's first instruction, check a, b and the counter.
    // (Sampled in FETCH, when the PC register is stable.)  stored_flag is printed to help debugging.
    always @(posedge clk)
        if (!reset && !runaway && dut.my_CU.state === 3'b000 && dut.my_PC_read === LOOP_HEAD) begin
            if (it < PASSES) begin
                if (dut.my_register_file.registers[2] !== exp_a[it] ||
                    dut.my_register_file.registers[3] !== exp_b[it] ||
                    dut.my_register_file.registers[5] !== exp_n[it]) begin
                    $display("FAIL at loop start #%0d: a=%0d b=%0d count=%0d, expected a=%0d b=%0d count=%0d  (saved flags V Z C N = %b)",
                             it + 1, dut.my_register_file.registers[2], dut.my_register_file.registers[3],
                             dut.my_register_file.registers[5], exp_a[it], exp_b[it], exp_n[it],
                             dut.my_comparator.stored_flag);
                    errors = errors + 1;
                end else
                    $display("ok   loop start #%0d: a=%0d b=%0d count=%0d  (saved flags V Z C N = %b)",
                             it + 1, exp_a[it], exp_b[it], exp_n[it], dut.my_comparator.stored_flag);
            end else begin
                $display("FAIL: the loop started pass #%0d but should have exited after %0d passes.", it + 1, PASSES);
                $display("      count r5 = %0d, saved flags (V Z C N) = %b, expected 0110 (Z=1, C=1) after the last CMP",
                         dut.my_register_file.registers[5], dut.my_comparator.stored_flag);
                errors = errors + 1;
                runaway = 1;
            end
            it = it + 1;
        end

    initial begin
        exp_a[0] = 0; exp_b[0] = 1; exp_n[0] = 3;
        exp_a[1] = 1; exp_b[1] = 1; exp_n[1] = 2;
        exp_a[2] = 1; exp_b[2] = 2; exp_n[2] = 1;
        for (i = 0; i < 32; i = i + 1) exp_reg[i] = 32'b0;
        exp_reg[1] = END_PC;
        exp_reg[2] = 32'd2;
        exp_reg[3] = 32'd3;
        exp_reg[4] = 32'd3;
        exp_reg[5] = 32'd0;

        repeat (4) @(posedge clk);      // hold reset: clears all registers, PC = 0
        @(negedge clk);
        reset = 0;

        // Done when the CU is fetching at END_PC (only trust the PC in FETCH: a jump briefly leaves a junk value in r1).
        while (!(dut.my_CU.state === 3'b000 && dut.my_PC_read === END_PC) && cycles < MAX_CYCLES && !runaway) begin
            @(posedge clk);
            cycles = cycles + 1;
        end
        repeat (2) @(posedge clk);

        if (runaway)
            $display("Stopped early: the loop never exited.");
        else if (cycles >= MAX_CYCLES) begin
            $display("TIMEOUT: PC=%h, loop passes seen: %0d", dut.my_PC_read, it);
            errors = errors + 1;
        end else
            $display("Program finished after %0d cycles, %0d loop passes", cycles, it);

        if (!runaway && it != PASSES) begin
            $display("FAIL: expected %0d loop passes, saw %0d", PASSES, it);
            errors = errors + 1;
        end
        if (!runaway)
            for (i = 0; i < 32; i = i + 1)
                if (dut.my_register_file.registers[i] !== exp_reg[i]) begin
                    $display("FAIL: r%0d = %0d, expected %0d", i, dut.my_register_file.registers[i], exp_reg[i]);
                    errors = errors + 1;
                end

        $display("Fibonacci(4) = r3 = %0d (expected 3)", dut.my_register_file.registers[3]);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule