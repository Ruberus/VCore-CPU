`timescale 1ns / 1ps

module tb_load_store_formatter;
    reg  [4:0]  opcode;
    reg  [31:0] mem_read_data;
    reg         clk;
    wire [31:0] output_data;

    integer errors = 0;
    integer i, j;
    reg [31:0] expected;

    // Device under test
    load_store_formatter dut (
        .opcode(opcode),
        .mem_read_data(mem_read_data),
        .clk(clk),
        .output_data(output_data)
    );

    // clk is unused by the DUT (purely combinational), but drive it anyway
    initial clk = 0;
    always #5 clk = ~clk;

    // Reference model
    function [31:0] model(input [4:0] op, input [31:0] d);
        begin
            case (op)
                5'b01100: model = {24'b0, d[7:0]};              // LBU
                5'b01101: model = {{24{d[7]}}, d[7:0]};         // LB
                5'b01110: model = {16'b0, d[15:0]};             // LHU
                5'b01111: model = {{16{d[15]}}, d[15:0]};       // LH
                default:  model = d;                            // LW / others
            endcase
        end
    endfunction

    task check(input [31:0] exp);
        begin
            #1;
            if (output_data !== exp) begin
                $display("FAIL: opcode=%b data=%h got=%h expected=%h",
                         opcode, mem_read_data, output_data, exp);
                errors = errors + 1;
            end else
                $display("PASS: opcode=%b data=%h out=%h",
                         opcode, mem_read_data, output_data);
        end
    endtask

    initial begin
        // Directed tests (hand-computed expected values)
        mem_read_data = 32'hDEADBEEF;
        opcode = 5'b01100; #10; check(32'h000000EF);   // LBU
        opcode = 5'b01101; #10; check(32'hFFFFFFEF);   // LB (sign bit 1)
        opcode = 5'b01110; #10; check(32'h0000BEEF);   // LHU
        opcode = 5'b01111; #10; check(32'hFFFFBEEF);   // LH (sign bit 1)
        opcode = 5'b00000; #10; check(32'hDEADBEEF);   // default passthrough

        // Positive sign bits
        mem_read_data = 32'h12345678;
        opcode = 5'b01101; #10; check(32'h00000078);   // LB (sign bit 0)
        opcode = 5'b01111; #10; check(32'h00005678);   // LH (sign bit 0)

        // Edge values
        mem_read_data = 32'h0000_0000;
        opcode = 5'b01101; #10; check(32'h0);
        mem_read_data = 32'h0000_0080;
        opcode = 5'b01101; #10; check(32'hFFFFFF80);   // LB boundary
        opcode = 5'b01100; #10; check(32'h00000080);   // LBU boundary
        mem_read_data = 32'h0000_8000;
        opcode = 5'b01111; #10; check(32'hFFFF8000);   // LH boundary
        opcode = 5'b01110; #10; check(32'h00008000);   // LHU boundary

        // Every opcode (all 32) against several data patterns
        for (i = 0; i < 32; i = i + 1) begin
            opcode = i[4:0];
            for (j = 0; j < 20; j = j + 1) begin
                mem_read_data = (j == 0) ? 32'hFFFFFFFF :
                                (j == 1) ? 32'h00000000 : $random;
                #10;
                check(model(opcode, mem_read_data));
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule