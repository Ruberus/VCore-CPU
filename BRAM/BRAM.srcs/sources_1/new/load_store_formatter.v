`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 17:03:53
// Design Name: 
// Module Name: load_store_formatter
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


module load_store_formatter(
    input [4:0] opcode,
    input [31:0] mem_read_data,
    input wire clk,
    output reg [31:0] output_data
    );
    
    always @(*)begin
        case (opcode)
            5'b01100:
                output_data={24'b0, mem_read_data[7:0]};
            5'b01101:
                output_data={{24{mem_read_data[7]}}, mem_read_data[7:0]};
            5'b01110:
                output_data = {16'b0, mem_read_data[15:0]};
            5'b01111:
                output_data = {{16{mem_read_data[15]}}, mem_read_data[15:0]};
            default:
                output_data = mem_read_data;
        endcase
    end
    
    
endmodule
