vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/blk_mem_gen_v8_4_12
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap blk_mem_gen_v8_4_12 modelsim_lib/msim/blk_mem_gen_v8_4_12
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" \
"D:/data_for_programs/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/data_for_programs/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_12  -incr -mfcu  "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" \
"../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../data_for_programs/2025.2/Vivado/data/rsb/busdef" \
"../../../BRAM.gen/sources_1/ip/he/sim/he.v" \
"../../../BRAM.srcs/sources_1/new/ALU.v" \
"../../../BRAM.srcs/sources_1/new/CU.v" \
"../../../BRAM.srcs/sources_1/new/Register_file.v" \
"../../../BRAM.srcs/sources_1/new/comparator.v" \
"../../../BRAM.srcs/sources_1/new/VCore.v" \

vlog -work xil_defaultlib \
"glbl.v"

