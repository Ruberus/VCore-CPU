`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 18:43:29
// Design Name: 
// Module Name: demux
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


module demux(
    input wire [31:0] data_in,
    input wire seldemux,
    output reg [31:0] CU_input, LS_input
    );
    
always @(*) begin

    case (seldemux)
     1'b0: CU_input<=data_in;
     1'b1: LS_input<=data_in;
    endcase
end
endmodule
