`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 14.01.2026 18:51:04
// Design Name:
// Module Name: ALU
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


module ALU( opcode, input_A, input_B, output_result,lsf_output_result, flag, lsf_input);
    input [3:0] opcode;
    input signed [31:0] input_A, input_B, lsf_input;
    output reg [31:0] output_result, lsf_output_result;
    output reg [3:0] flag;
    reg [31:0] cmp_result;

    always@(*)
    begin
     //add lsf output default
     lsf_output_result = 32'b0;
     output_result = 32'b0;
     flag = 4'b0;
     cmp_result = 32'b0;

    case(opcode)
    4'b0001: {flag[1], output_result} = {1'b0, input_A} + {1'b0, input_B}; //C
    4'b0010: begin
       if ($unsigned(input_A) >= $unsigned(input_B))   // C
            begin
               flag[1] = 1;
            end

        output_result= input_A-input_B;
            end
    4'b0011: output_result= input_A&input_B;
    4'b0100: output_result= input_A|input_B;
    4'b0101: output_result= ~input_A;
    4'b0111: output_result= input_A>>input_B; //RS
    4'b1001: output_result= input_A<<input_B; //LS
    4'b1010: output_result= input_A>>>input_B; //ARS
    4'b1011: begin

            cmp_result=input_A-input_B;
            flag[0]=cmp_result[31]; //N
            if (cmp_result==32'b0)//Z
            begin
                flag[2]=1;
            end
            /*
            if($unsigned(input_B)>$unsigned(input_A))//C
            begin
                flag[1]=1;
            end */
            if ($unsigned(input_A) >= $unsigned(input_B))   // C
            begin
               flag[1] = 1;
            end
            if(input_A[31] != input_B[31] && input_A[31] != cmp_result[31])//V?
            begin
                flag[3]=1;
            end
            end
     4'b1100: begin
            lsf_output_result=lsf_input+input_A; //lsf_output is connected to memory (bram_address)
     end
     4'b1101: begin
        //output_result<=input_A+4;
        output_result=input_A+4;
     end
     endcase
     end
endmodule