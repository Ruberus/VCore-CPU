`timescale 1ns / 1ps

module Comparator(
    input wire [3:0] ins_cond,
    input wire [3:0] flag,
    input wire clkcmp,
    output reg exec,
    input wire w_en
);

reg [3:0] stored_flag = 4'b0000;

always @(posedge clkcmp) begin
    if (w_en) begin
        stored_flag <= flag;
    end
end

// N[0] C[1] Z[2] V[3]
always @(*) begin
    exec = 1'b0;
    case (ins_cond)
        4'b0000: begin // GE
            if (stored_flag[0] == stored_flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b0001: begin // EQ
            if (stored_flag[2] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b0010: begin // NE
            if (stored_flag[2] == 1'b0) begin
                exec = 1'b1;
            end
        end
        4'b0011: begin // GEU / CS
            if (stored_flag[1] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b0100: begin // GT
            if (stored_flag[2] == 1'b0 && stored_flag[0] == stored_flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b0101: begin // GTU
            if (stored_flag[1] == 1'b1 && stored_flag[2] == 1'b0) begin
                exec = 1'b1;
            end
        end
        4'b0110: begin // LE
            if (stored_flag[2] == 1'b1 || stored_flag[0] != stored_flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b0111: begin // LEU
            if (stored_flag[1] == 1'b0 || stored_flag[2] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b1000: begin // LT
            if (stored_flag[0] != stored_flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b1001: begin // LTU
            if (stored_flag[1] == 1'b0) begin
                exec = 1'b1;
            end
        end
        4'b1010: begin // AL
            exec = 1'b1;
        end
        default: begin
            exec = 1'b0;
        end
    endcase
end

endmodule