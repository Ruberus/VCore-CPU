// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Feb 17 18:58:53 2026
// Host        : Terrified-mushroom running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ he_sim_netlist.v
// Design      : he
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "he,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;

  wire [3:0]addra;
  wire clka;
  wire [15:0]dina;
  wire [15:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [15:0]NLW_U0_doutb_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.87285 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "he.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16" *) 
  (* C_READ_DEPTH_B = "16" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "16" *) 
  (* C_WRITE_DEPTH_B = "16" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[15:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20320)
`pragma protect data_block
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
A0RMn4H01JXIb0VSt2QZe6voKiQgQOU2LkNrlw==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
