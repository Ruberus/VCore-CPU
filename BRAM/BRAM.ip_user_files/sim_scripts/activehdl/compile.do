transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/blk_mem_gen_v8_4_12
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap blk_mem_gen_v8_4_12 activehdl/blk_mem_gen_v8_4_12
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" -l xpm -l blk_mem_gen_v8_4_12 -l xil_defaultlib \
"D:/data_for_programs/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/data_for_programs/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_12  -v2k5 "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" -l xpm -l blk_mem_gen_v8_4_12 -l xil_defaultlib \
"../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" -l xpm -l blk_mem_gen_v8_4_12 -l xil_defaultlib \
"../../../BRAM.gen/sources_1/ip/he/sim/he.v" \
"../../../BRAM.srcs/sources_1/new/ALU.v" \
"../../../BRAM.srcs/sources_1/new/CU.v" \
"../../../BRAM.srcs/sources_1/new/Register_file.v" \
"../../../BRAM.srcs/sources_1/new/comparator.v" \
"../../../BRAM.srcs/sources_1/new/VCore.v" \

vlog -work xil_defaultlib \
"glbl.v"

