`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 19:06:33
// Design Name: 
// Module Name: four_mux
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


module four_mux(
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    input wire [1:0] four_muxsel,
    output reg output_four_mux
    );
always @(*)begin
    case (four_muxsel)
        2'b00: output_four_mux<=in0;
        2'b01: output_four_mux<=in1;
        2'b10: output_four_mux<=in2;
        2'b11: output_four_mux<=in3;
    endcase
end
endmodule
