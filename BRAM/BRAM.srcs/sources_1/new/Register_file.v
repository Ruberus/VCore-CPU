//fix read en
//reado_4 doesn't have an enable flag
module register_file (PC_read, reado_1, reado_2, reado_4, w_data, read_1_addr,read_4_addr, read_2_addr, w_addr, read1_en, read2_en, read4_en, w_en, clk, RF_Opcode, mov_addr,reset, sw,sample_en,led_out);

output reg [31:0] reado_1, reado_2, reado_4;
output wire [31:0]PC_read;
input [31:0] w_data;
//input read1_en, read2_en, w_en;
input read1_en, read2_en, w_en, read4_en;
input clk,reset;
input [4:0] read_1_addr, read_2_addr, w_addr, RF_Opcode, mov_addr, read_4_addr;
input [3:0] sw; 
input sample_en;
output wire [3:0] led_out;


reg [31:0] registers [31:0];
integer i;

assign PC_read = registers[1];
assign led_out = registers[6][3:0];

always @(posedge clk) begin
    if (!reset) begin
        // Synchronous reset: clear every register and the output registers
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'b0;
        reado_1 <= 32'b0;
        reado_2 <= 32'b0;
        reado_4 <= 32'b0;
    end
    else begin
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
        if(read4_en)
        begin
          reado_4 <= registers[read_4_addr];
        end
        if (sample_en) registers[2] <= {28'b0, sw};
    end
   end

endmodule