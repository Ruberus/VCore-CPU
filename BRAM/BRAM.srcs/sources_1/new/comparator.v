`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 12:42:01
// Design Name: 
// Module Name: comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Comparator(
    input wire [3:0] ins_cond,
    input wire [3:0] flag,
    input wire clkcmp,
    output reg exec, w_en 
);
reg [3:0] stored_flag;
always @(posedge clkcmp) begin
    if (w_en) begin
        stored_flag<=flag;
    end
end
// N[0] C[1] Z[2] V[3]
always @(*) begin
    case(ins_cond)
        4'b0000: begin
            if (flag[0] == flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b0001: begin
            if (flag[2] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b0010: begin
            if (flag[2] == 1'b0) begin
                exec = 1'b1;
            end
        end
        4'b0011: begin
            if (flag[1] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b0100: begin // GT
            if (flag[2] == 1'b0 && flag[0] == flag[3]) begin
                exec = 1'b1;
            end
        end       
// N[0] C[1] Z[2] V[3]
        4'b0101: begin // GTU
            if (flag[1] == 1'b1 && flag[2] == 1'b0) begin
                exec = 1'b1;
            end
        end
        4'b0110: begin // LE
            if (flag[2] == 1'b1 || flag[0] != flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b0111: begin // LEU
            if (flag[1] == 1'b0 || flag[2] == 1'b1) begin
                exec = 1'b1;
            end
        end
        4'b1000: begin // LT
            if (flag[0] != flag[3]) begin
                exec = 1'b1;
            end
        end
        4'b1001: begin // LTU
            if (flag[1] == 1'b0) begin
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
