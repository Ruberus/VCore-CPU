`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 19:23:32
// Design Name: 
// Module Name: conditional_register_file
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


module conditional_register_file(
    input [3:0] input_flags,
    input       read_enable,
    output reg [3:0] output_flags
    );
    reg [3:0] flags;
    always @ (*) begin
        if (read_enable) begin
            output_flags=flags;
        end
        else begin
            flags=input_flags;
        end
    end

endmodule
