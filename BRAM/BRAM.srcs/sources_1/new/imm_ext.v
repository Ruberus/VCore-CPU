`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 17:23:50
// Design Name: 
// Module Name: imm_ext
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


module imm_ext(
    input [17:0] imm_18,
    input [12:0] imm_13,
    input        selector,
    output reg [31:0] extended_data
    );
    always @(*) begin
        if(selector)begin
            extended_data={{14{imm_18[17]}}, imm_18};
        end else begin
            extended_data={{19{imm_13[12]}}, imm_13};
        end
    end
endmodule
