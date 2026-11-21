
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 13:56:32
// Design Name: 
// Module Name: VCore
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


module VCore (
    input wire clk,       // This EXACT name fixes your .xdc constraint error
    input wire reset,     // You'll likely need a reset button mapped in your .xdc
    output wire [3:0] led // Just an example of outputting to the board's LEDs
);

    // 1. Declare internal wires to connect your CPU to the BRAM
    wire [31:0] bram_data_out;
    wire [31:0] bram_data_in;
    wire [31:0] bram_address;
    wire [3:0]  bram_write_enable;
    wire [31:0] bram_data_out_ls;
    wire [31:0] bram_address_ls;

    // 2. Instantiate your BRAM IP (named 'he') inside VCore
    // Note: The exact port names (clka, ena, etc.) depend on how you configured the IP.
    he my_instruction_memory (
        .clka(clk),                 // Connect the board's clock to the BRAM's clock
        .ena(1'b1),                 // Enable the BRAM (always on for this example)
        .wea(bram_write_enable),    // Write enable signal from your CPU
        .addra(bram_address),       // Address signal from your CPU
        .dina(bram_data_in),        // Data going INTO the BRAM
        .douta(bram_data_out),       // Data coming OUT of the BRAM
        .enb(1'b1),
        .clkb(clk),
        .addrb(bram_address_ls),
        .doutb(bram_data_out_ls)
    );

    // 3. The rest of your CPU logic (Program Counter, ALU, Registers) goes here.
    // For now, to prevent Vivado from optimizing the BRAM away because it's "unused", 
    // let's do a dummy assignment to the LEDs just to complete the synthesis.
    
    // assign led = bram_data_out[3:0]; 
    
    wire [31:0] my_PC_read, my_reado_1, my_reado_2;
    wire [31:0] my_w_data;
    wire my_read1_en, my_read2_en, my_w_en,read4_en;
    wire [4:0] my_read_1_addr, my_read_2_addr, my_w_addr, my_mov_addr, my_RF_Opcode, my_read_4_addr;
    
    register_file my_register_file (   
        .PC_read(my_PC_read),
        .reado_1(my_reado_1),
        .reado_2 (my_reado_2),
        .reado_4(bram_data_in),
        .w_data (my_w_data),
        .read1_en(my_read1_en),
        .read2_en(my_read2_en),
        .w_en(my_w_en),
        .clk (clk),
        .read_1_addr(my_read_1_addr),
        .read_2_addr(my_read_2_addr),
        .read_4_addr(my_read_4_addr),
        .w_addr(my_w_addr),
        .RF_Opcode(my_RF_Opcode),
        .mov_addr(my_mov_addr),
        .reset(reset),
        .read4_en(read4_en)
        );
                
    wire [3:0] my_ins_cond;
    wire [3:0] my_flag;
    wire my_exec;
    wire comparator_en;
    
    Comparator my_comparator(
    .ins_cond(my_ins_cond),
    .flag(my_flag),
    .exec(my_exec),
    .w_en(comparator_en),
    .clkcmp(clk)
    );
     
    //wire [4:0] ALU_opcode;
    wire [3:0] ALU_opcode;
    wire [4:0] my_Opcode, my_LS_Opcode;
    wire [31:0] lsf_mem_read, my_imm_18;
    wire [31:0] my_lsf_input;
    wire [31:0] CU_bram_addr, CU_bram_data_out;
    wire my_selmux,my_seldemux,my_load_selmux, input_B_selmux;
        
    CU my_CU (
    .bram_data_out(bram_data_out),
    .bram_address(bram_address),
    //dead: .bram_write_enable(bram_write_enable),
    .exec(my_exec),
    .PC(my_PC_read),
    .conditional_code(my_ins_cond),
    .Opcode(my_Opcode),
    .reg1_addr(my_read_1_addr),
    .reg2_addr(my_read_2_addr),
    .reg3_addr(my_w_addr),
    .read1_en(my_read1_en),
    .read2_en(my_read2_en),
    .w_en(my_w_en),
    .ALU_Opcode(ALU_opcode),
    .clk(clk),
    .LS_Opcode(my_LS_Opcode),
    //.lsf_mem_read(my_lsf_mem_read),
    .extended_data(my_lsf_input),
    .imm_18(my_imm_18),
    .selmux(my_selmux),
    .seldemux(my_seldemux),
    .load_selmux(my_load_selmux),
    .RF_Opcode(my_RF_Opcode),
    .mov_addr(my_mov_addr),
    .input_B_selmux(input_B_selmux),
    .comparator_en(comparator_en),
    .reg4_addr(my_read_4_addr),
    .w_en_a(bram_write_enable),
    .reset(reset),
    .read4_en(read4_en)
    );
    
    //figure out how many bits is ALUOpcode in actuality
    wire [31:0]ALU_bram_addr,  ALU_w_data, my_input_B;
    
    ALU my_ALU(
    .opcode(ALU_opcode),
    .input_A(my_reado_1),   
    .input_B(my_input_B),
    .output_result(ALU_w_data),
    .flag(my_flag),
    .lsf_output_result(bram_address_ls),
    .lsf_input(my_lsf_input)    
    );
    
//add conditional_falg_register later
wire [31:0] lsf_w_data, my_lsf_mem_read;

load_store_formatter my_load_store_formatter(
    .opcode(my_LS_Opcode),
    .mem_read_data(bram_data_out_ls),
    .clk(clk),
    .output_data(lsf_w_data)
);

    wire data_in;
    wire seldemux;
    wire CU_input, LS_input;
/*
demux my_demux(
    .data_in(bram_data_out),
    .seldemux(my_seldemux),//seldemux=0 hasn't been coded yet
    .CU_input(CU_bram_data_out),
    .LS_input(my_lsf_mem_read)
    
    );
*/

/*
mux my_mux(
    .in0(CU_bram_addr),//for PC
    .in1(ALU_bram_addr),// for load ins
    .selmux(my_selmux),
    .out(bram_address)
);
*/

mux load_mux (
    .in0(ALU_w_data),
    .in1(lsf_w_data),
    .selmux(my_load_selmux),
    .out(my_w_data)
);

mux ALU_input_B (
    .in0(my_reado_2),
    .in1(my_imm_18),
    .selmux(input_B_selmux),
    .out(my_input_B)
);
       
endmodule