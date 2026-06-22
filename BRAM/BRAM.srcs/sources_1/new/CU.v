//version: add ins+ FSM +load ins(incomplete)
// fix input_B_selmux <= 1'b0 
// sub i fix imm and write back
module CU(
    input wire [31:0] bram_data_out,
    output reg [31:0] bram_address,
    //output reg [31:0] lsf_mem_read,
    output reg [3:0]  bram_write_enable,  
    input wire exec,                    
    input wire [31:0] PC,                 
    input wire clk,reset,
    output reg [3:0] conditional_code,w_en_a,
    output reg [4:0] Opcode, ALU_Opcode, LS_Opcode,RF_Opcode,
    output reg [4:0] reg1_addr,reg2_addr,reg3_addr,mov_addr,reg4_addr,
    output reg read1_en,read2_en,w_en,selmux,seldemux,load_selmux,input_B_selmux,
    output reg [31:0] extended_data, imm_18,
    output reg comparator_en                           
);

localparam FETCH= 3'b000;
localparam DECODE= 3'b001;
localparam EXECUTE= 3'b010;
localparam INCREMENT_PC= 3'b011;
localparam WRITE_BACK= 3'b100;
reg [2:0] state;

reg [12:0] imm_13;
reg [17:0] temp_imm_18;
reg [2:0] delay;
reg PC_write;

    always @(posedge clk) begin
    if (reset) begin
        PC_write<=1'b0;
        state<=FETCH;
    end else begin
            case(state)
                FETCH: begin
                    selmux<=1'b0;
                    seldemux=1'b0;
                    bram_address <= PC;
                    read1_en <= 1'b0;
                    read2_en <= 1'b0;
                    w_en <= 1'b0;
                    delay<=3'b000;
                    state<=DECODE;
                end
                DECODE: begin
                    Opcode<= bram_data_out[31:27];  
                    conditional_code<= bram_data_out[26:23];
                    
                    state<=EXECUTE;
                end
                EXECUTE:begin
                   //if exec=1 then we execute the ins
                    if (exec==1'b1) begin
                    case(Opcode)
                        5'b00000:begin //add ins
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            if(reg3_addr==5'b00001) begin
                                PC_write<=1'b1;
                            end
                            ALU_Opcode<=4'b0001;
                            RF_Opcode<=5'b00000;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                            load_selmux<=1'b0;
                            input_B_selmux <= 1'b0;
                                //connect reg1 and reg2 to read_addr(register file) in vcore
                                //connect ALU
                            end
                        5'b00010: begin //sub
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            ALU_Opcode<=4'b0010;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                            load_selmux<=1'b0;
                            input_B_selmux <= 1'b0;
                        end
                        5'b00100:begin
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            ALU_Opcode<=4'b0011;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                        end
                        5'b00101:begin
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            ALU_Opcode<=4'b0100;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                        end
                        5'b01000:begin
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            ALU_Opcode<=4'b1001;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                        end
                        5'b01010:begin
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            reg3_addr<=bram_data_out[12:8];
                            ALU_Opcode<=4'b1010;
                            //make read_en1 and read_en2 1
                            read1_en<=1'b1;
                            read2_en<=1'b1;
                            w_en<=1'b1;
                        end
                        5'b01100, 5'b01101,5'b01110, 5'b01111, 5'b10000: begin //load ins
                            //ls_state<=LS_FETCH_ADDR;
                                    selmux<=1'b1;
                                    imm_13<=bram_data_out[12:0];
                                    extended_data<={{19{imm_13[12]}}, imm_13};//needs to be connected to lsf_input of ALU in vcore
                                    reg1_addr<=bram_data_out[22:18]; 
                                    read1_en<=1'b1;
                                    ALU_Opcode<=4'b1100;
                                    LS_Opcode<=Opcode;
                                    RF_Opcode<=5'b00000;
                                    /*connect bram_data_out to mem_read_data
                                    lsf_mem_read<=bram_data_out; (previously written wrong line of code please recheck)
                                    different stage required? as two different data from bram_data_out is required?*/
                                    //seldemux<=1'b1;
                                    load_selmux<=1'b1;
                                    w_en<=1'b1;
                                    reg3_addr<=bram_data_out[17:13]; //can this just be re2_addr instead?
                                end                                          
                        5'b00110:begin //not
                            //[12:0] ignored bits [17:13] register 2 [22:18] register 1 [26:23] conditional code  [31:27] opcode
                            reg1_addr<=bram_data_out[22:18];
                            reg3_addr<=bram_data_out[17:13];
                            ALU_Opcode<=0101;
                            RF_Opcode<=5'b00000;
                            read1_en<=1'b1;
                            w_en<=1'b1;                           
                        end
                        5'b01011: begin //mov
                            reg1_addr<=bram_data_out[22:18];
                            RF_Opcode<=Opcode;
                            mov_addr<=bram_data_out[17:13];
                            read1_en<=1'b1;
                        end
                        5'b00111: begin //cmp
                            comparator_en<=1'b1;
                            reg1_addr<=bram_data_out[22:18];
                            reg2_addr<=bram_data_out[17:13];
                            RF_Opcode<=5'b00000;
                            ALU_Opcode<=4'b1011;
                        end
                        5'b00001: begin // addi
                            /*there is a timing issue prolly since for input_A CU->RF->ALU but for input_B CU->mux->ALU
                            maybe there is this issue with other ins as well? fix by adding more stages?*/
                            reg1_addr<=bram_data_out[22:18];
                            temp_imm_18<=bram_data_out[17:0];
                            imm_18<={{14{temp_imm_18[17]}}, temp_imm_18};
                            ALU_Opcode<=4'b0001;
                            input_B_selmux<=1'b1; 
                            read1_en<=1'b1;
                            reg3_addr <= reg1_addr;
                            w_en <= 1'b1;      
                            load_selmux<=1'b0;                                                
                        end
                        5'b00011: begin
                            reg1_addr<=bram_data_out[22:18];
                            temp_imm_18<=bram_data_out[17:0];
                            imm_18<={{14{imm_18[17]}}, imm_18};
                            ALU_Opcode<=4'b0010;
                            input_B_selmux<=1'b1;
                            read1_en<=1'b1;
                        end
                        5'b10001: begin
                        //reado_2 needs a demux
                            reg1_addr<=bram_data_out[22:18];
                            imm_13<=bram_data_out[12:0];
                            extended_data<={{19{imm_13[12]}}, imm_13};
                            ALU_Opcode<=4'b1100;
                            reg4_addr<=bram_data_out[17:13];
                            w_en_a<=0001;                            
                        end
                        5'b10010: begin
                            reg1_addr<=bram_data_out[22:18];
                            imm_13<=bram_data_out[12:0];
                            extended_data<={{19{imm_13[12]}}, imm_13};
                            ALU_Opcode<=4'b1100;
                            reg4_addr<=bram_data_out[17:13];
                            w_en_a<=0011; // check whether it would be 0010 instead 
                        end
                        5'b10011: begin
                            reg1_addr<=bram_data_out[22:18];
                            imm_13<=bram_data_out[12:0];
                            extended_data<={{19{imm_13[12]}}, imm_13};
                            ALU_Opcode<=4'b1100;
                            reg4_addr<=bram_data_out[17:13];
                            w_en_a<=0011;
                        end
                        5'b10011: begin
                            reg1_addr<=bram_data_out[22:18];
                            imm_13<=bram_data_out[12:0];
                            extended_data<={{19{imm_13[12]}}, imm_13};
                            ALU_Opcode<=4'b1100;
                            reg4_addr<=bram_data_out[17:13];
                            w_en_a<=0111;
                       end
                    endcase
                        
                    end else begin
                        read1_en<=1'b0;
                        read2_en<=1'b0;
                        w_en<=1'b0;
                    end
                    state<=WRITE_BACK;
                end
                WRITE_BACK: begin
                    /*  if (delay<2) begin
                        delay<=delay+1;
                        state<=WRITE_BACK;
                    end else begin */
                        seldemux<=1'b1;
                        w_en<=1'b1;
                        state<=INCREMENT_PC;
                    //end
                end
                INCREMENT_PC: begin
                    if (PC_write==0);
                        reg1_addr<=5'b00001;
                        reg3_addr<=5'b00001;
                        w_en<=1'b1;
                        ALU_Opcode<=4'b110;
                    state<= FETCH;
                end
                default: begin
                    state<=FETCH;
                end
        endcase                   
end
end
    
//BRAM address is taken as an input by the BRAM, the instruction will come out through bram_data_out
    
endmodule