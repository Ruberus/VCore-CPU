//fix read en
//reado_4 doesn't have an enable flag
module register_file (PC_read, reado_1, reado_2, reado_4, w_data, read_1_addr,read_4_addr, read_2_addr, w_addr, read1_en, read2_en, w_en, clk, RF_Opcode, mov_addr);

output reg [31:0] reado_1, reado_2, reado_4;
output wire [31:0]PC_read;
input [31:0] w_data;
input read1_en, read2_en, w_en;
input clk;
input [4:0] read_1_addr, read_2_addr, w_addr, RF_Opcode, mov_addr, read_4_addr;

reg [31:0] registers [31:0];

initial begin
registers[0]=32'b0;
registers[1]=32'b0;
registers[2]=32'b00000000000000000000000000000000;
registers[3]=32'b00000000000000000000000000000001;
registers[4]=32'b0;
end

assign PC_read = registers[1];

always @(posedge clk) begin
    if (RF_Opcode==5'b01011) begin
        registers[mov_addr] <= registers[read_1_addr];
    end
    else
        if (w_en)
            begin
            registers[w_addr] <= w_data;
        end

        if(read1_en)
            begin
            reado_1 <= registers[read_1_addr];
        end

        if(read2_en)
            begin
            reado_2 <= registers[read_2_addr];
        end
       reado_4 <= registers[read_4_addr];
    end


endmodule