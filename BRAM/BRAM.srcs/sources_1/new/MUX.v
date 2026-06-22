`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:39:20
// Design Name: 
// Module Name: MUX
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

module mux(
    input wire [31:0] in0,//CU
    input wire [31:0] in1,//ALU LS
    input wire selmux,
    output reg [31:0] out
);

always @(*) begin
    case (selmux)
        1'b0: out <= in0;
        1'b1: out <= in1;
    endcase
end

endmodule
