`timescale 1ns / 1ps

module tb_register_file;
    // DUT inputs
    reg  [31:0] w_data;
    reg  [4:0]  read_1_addr, read_2_addr, read_4_addr, w_addr, RF_Opcode, mov_addr;
    reg         read1_en, read2_en, read4_en, w_en, clk, reset;
    // DUT outputs
    wire [31:0] reado_1, reado_2, reado_4, PC_read;

    localparam MOV = 5'b01011;

    integer errors = 0;
    integer i;
    reg [31:0] model [0:31];      // reference copy of the register file
    reg [31:0] exp1, exp2, exp4;  // expected contents of the output registers
    reg [31:0] old;

    register_file dut (
        .PC_read(PC_read),
        .reado_1(reado_1), .reado_2(reado_2), .reado_4(reado_4),
        .w_data(w_data),
        .read_1_addr(read_1_addr), .read_2_addr(read_2_addr), .read_4_addr(read_4_addr),
        .w_addr(w_addr),
        .read1_en(read1_en), .read2_en(read2_en), .read4_en(read4_en), .w_en(w_en),
        .clk(clk),
        .reset(reset),
        .RF_Opcode(RF_Opcode),
        .mov_addr(mov_addr)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // ---------- helpers ----------
    // Inputs are changed 1 ns after a clock edge, so they are stable well
    // before the next edge. tick = "let one clock edge happen".
    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task check(input [31:0] got, input [31:0] exp, input [8*28-1:0] name);
        begin
            if (got !== exp) begin
                $display("FAIL [%0t ns] %0s: got=%h expected=%h", $time, name, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    task do_write(input [4:0] a, input [31:0] d);
        begin
            w_en = 1; w_addr = a; w_data = d; RF_Opcode = 5'b0;
            tick;
            w_en = 0;
            model[a] = d;
        end
    endtask

    task do_read(input [4:0] a1, input [4:0] a2, input [4:0] a4,
                 input e1, input e2, input e4);
        begin
            read_1_addr = a1; read_2_addr = a2; read_4_addr = a4;
            read1_en = e1;    read2_en = e2;    read4_en = e4;
            tick;
        end
    endtask

    // ---------- tests ----------
    initial begin
        // defaults
        w_data = 0; read_1_addr = 0; read_2_addr = 0; read_4_addr = 0;
        w_addr = 0; RF_Opcode = 0;   mov_addr = 0;
        read1_en = 0; read2_en = 0; read4_en = 0; w_en = 0; reset = 1;
        for (i = 0; i < 32; i = i + 1) model[i] = 32'b0;

        tick;   // first clock edge with reset = 1: clears all registers
        reset = 0;

        // 1. Power-up state: all registers are initialised to 0
        check(PC_read, 32'b0, "PC_read at power-up");
        for (i = 0; i < 32; i = i + 1) begin
            do_read(i, (i + 1) % 32, (i + 2) % 32, 1, 1, 1);
            check(reado_1, 32'b0, "power-up reg (port 1)");
            check(reado_2, 32'b0, "power-up reg (port 2)");
            check(reado_4, 32'b0, "power-up reg (port 4)");
        end

        // 2. Write every register, then read each back on all three ports
        for (i = 1; i < 32; i = i + 1)
            do_write(i, 32'hA5A50000 ^ (i * 32'h01010101));
        check(PC_read, model[1], "PC_read follows r1");

        for (i = 0; i < 32; i = i + 1) begin
            do_read(i, (i + 7) % 32, (i + 15) % 32, 1, 1, 1);
            check(reado_1, model[i],             "readback port 1");
            check(reado_2, model[(i + 7) % 32],  "readback port 2");
            check(reado_4, model[(i + 15) % 32], "readback port 4");
        end

        // 3. Reads are registered: outputs must not change before the clock edge
        do_read(3, 3, 3, 1, 1, 1);
        read_1_addr = 9; read_4_addr = 9;
        #2;
        check(reado_1, model[3], "no comb read port 1");
        check(reado_4, model[3], "no comb read port 4");
        tick;
        check(reado_1, model[9], "registered read port 1");
        check(reado_4, model[9], "registered read port 4");

        // 4. Read enables: each output holds its value when its enable is 0
        do_read(3, 4, 5, 1, 1, 1);
        do_read(10, 11, 12, 0, 0, 0);
        check(reado_1, model[3], "port 1 held (all en=0)");
        check(reado_2, model[4], "port 2 held (all en=0)");
        check(reado_4, model[5], "port 4 held (all en=0)");

        do_read(10, 11, 13, 1, 0, 0);
        check(reado_1, model[10], "port 1 enabled only");
        check(reado_2, model[4],  "port 2 still held");
        check(reado_4, model[5],  "port 4 still held");

        do_read(14, 11, 15, 0, 1, 0);
        check(reado_1, model[10], "port 1 held");
        check(reado_2, model[11], "port 2 enabled only");
        check(reado_4, model[5],  "port 4 still held (2)");

        do_read(14, 12, 15, 0, 0, 1);
        check(reado_1, model[10], "port 1 held (2)");
        check(reado_2, model[11], "port 2 held (2)");
        check(reado_4, model[15], "port 4 enabled only");

        // 5. w_en = 0 must not write
        w_addr = 20; w_data = 32'hDEAD0001; w_en = 0;
        tick;
        do_read(20, 20, 20, 1, 1, 1);
        check(reado_1, model[20], "no write when w_en=0");

        // 6. Read and write the same register in the same cycle: reads old value
        old = model[7];
        w_en = 1; w_addr = 7; w_data = 32'h11112222; RF_Opcode = 5'b0;
        read_1_addr = 7; read_2_addr = 7; read_4_addr = 7;
        read1_en = 1; read2_en = 1; read4_en = 1;
        tick;
        w_en = 0; model[7] = 32'h11112222;
        check(reado_1, old, "read-during-write port 1");
        check(reado_2, old, "read-during-write port 2");
        check(reado_4, old, "read-during-write port 4");
        do_read(7, 7, 7, 1, 1, 1);
        check(reado_1, model[7], "new value next cycle");

        // 7. MOV: reg[mov_addr] <= reg[read_1_addr]; normal write is suppressed
        read1_en = 0; read2_en = 0; read4_en = 0;
        read_1_addr = 7; mov_addr = 10; RF_Opcode = MOV;
        w_en = 1; w_addr = 15; w_data = 32'hBAD0BAD0;
        tick;
        RF_Opcode = 5'b0; w_en = 0;
        model[10] = model[7];
        do_read(10, 15, 10, 1, 1, 1);
        check(reado_1, model[7],  "MOV copied the value");
        check(reado_2, model[15], "w_en ignored during MOV");
        check(reado_4, model[10], "MOV dest on port 4");

        // 8. Register 0 behaviour
        do_write(0, 32'hFFFFFFFF);
        do_read(0, 0, 0, 1, 1, 1);
        if (reado_1 !== 32'b0)
            $display("INFO: r0 is writable (not hardwired to zero)");
        check(reado_1, model[0], "r0 write/readback");
        do_write(0, 32'b0);

        // 8b. Reset clears every register and output, and beats a simultaneous write
        reset = 1; w_en = 1; w_addr = 5; w_data = 32'hFFFFFFFF; RF_Opcode = 5'b0;
        tick;
        reset = 0; w_en = 0;
        for (i = 0; i < 32; i = i + 1) model[i] = 32'b0;
        check(reado_1, 32'b0, "reset clears reado_1");
        check(reado_2, 32'b0, "reset clears reado_2");
        check(reado_4, 32'b0, "reset clears reado_4");
        check(PC_read, 32'b0, "reset clears PC_read");
        for (i = 0; i < 32; i = i + 1) begin
            do_read(i, (i + 1) % 32, (i + 2) % 32, 1, 1, 1);
            check(reado_1, 32'b0, "after reset reg (port 1)");
            check(reado_2, 32'b0, "after reset reg (port 2)");
            check(reado_4, 32'b0, "after reset reg (port 4)");
        end
        do_write(9, 32'hCAFEF00D);
        do_read(9, 9, 9, 1, 1, 1);
        check(reado_1, model[9], "write works after reset");

        // 9. Random test against the reference model
        do_read(0, 1, 2, 1, 1, 1);
        exp1 = model[0];
        exp2 = model[1];
        exp4 = model[2];
        check(reado_1, exp1, "pre-random sync p1");
        check(reado_2, exp2, "pre-random sync p2");
        check(reado_4, exp4, "pre-random sync p4");

        for (i = 0; i < 1000; i = i + 1) begin
            w_en = $random;  w_addr = $random;  w_data = $random;
            read1_en = $random;  read2_en = $random;  read4_en = $random;
            read_1_addr = $random;  read_2_addr = $random;  read_4_addr = $random;
            mov_addr = $random;
            RF_Opcode = ({$random} % 4 == 0) ? MOV : 5'b0;

            // expected outputs use register values from before this edge
            if (read1_en) exp1 = model[read_1_addr];
            if (read2_en) exp2 = model[read_2_addr];
            if (read4_en) exp4 = model[read_4_addr];
            if (RF_Opcode == MOV) model[mov_addr] = model[read_1_addr];
            else if (w_en)        model[w_addr]   = w_data;

            tick;
            check(reado_1, exp1,      "random port 1");
            check(reado_2, exp2,      "random port 2");
            check(reado_4, exp4,      "random port 4");
            check(PC_read, model[1],  "random PC_read");
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
