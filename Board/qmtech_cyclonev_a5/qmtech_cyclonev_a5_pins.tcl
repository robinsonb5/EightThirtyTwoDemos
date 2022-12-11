#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50
set_location_assignment PIN_M9 -to CLOCK_50

#============================================================
# SDRAM
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CKE
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_RAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_WE_N

set_location_assignment PIN_H20 -to DRAM_ADDR[12]
set_location_assignment PIN_H18 -to DRAM_ADDR[11]
set_location_assignment PIN_N19 -to DRAM_ADDR[10]
set_location_assignment PIN_J19 -to DRAM_ADDR[9]
set_location_assignment PIN_J18 -to DRAM_ADDR[8]
set_location_assignment PIN_K17 -to DRAM_ADDR[7]
set_location_assignment PIN_K16 -to DRAM_ADDR[6]
set_location_assignment PIN_L18 -to DRAM_ADDR[5]
set_location_assignment PIN_L19 -to DRAM_ADDR[4]
set_location_assignment PIN_L17 -to DRAM_ADDR[3]
set_location_assignment PIN_M16 -to DRAM_ADDR[2]
set_location_assignment PIN_M20 -to DRAM_ADDR[1]
set_location_assignment PIN_M18 -to DRAM_ADDR[0]
set_location_assignment PIN_P18 -to DRAM_BA[1]
set_location_assignment PIN_P19 -to DRAM_BA[0]
set_location_assignment PIN_T19 -to DRAM_CAS_N
set_location_assignment PIN_G17 -to DRAM_CKE
set_location_assignment PIN_G18 -to DRAM_CLK
set_location_assignment PIN_P17 -to DRAM_CS_N
set_location_assignment PIN_E16 -to KEY
set_location_assignment PIN_J17 -to RESET_N
set_location_assignment PIN_V19 -to LEDR
set_location_assignment PIN_U20 -to DRAM_WE_N
set_location_assignment PIN_P16 -to DRAM_RAS_N
set_location_assignment PIN_AA22 -to DRAM_DQ[0]
set_location_assignment PIN_AB22 -to DRAM_DQ[1]
set_location_assignment PIN_Y22 -to DRAM_DQ[2]
set_location_assignment PIN_Y21 -to DRAM_DQ[3]
set_location_assignment PIN_W22 -to DRAM_DQ[4]
set_location_assignment PIN_W21 -to DRAM_DQ[5]
set_location_assignment PIN_V21 -to DRAM_DQ[6]
set_location_assignment PIN_U22 -to DRAM_DQ[7]
set_location_assignment PIN_M21 -to DRAM_DQ[8]
set_location_assignment PIN_M22 -to DRAM_DQ[9]
set_location_assignment PIN_T22 -to DRAM_DQ[10]
set_location_assignment PIN_R21 -to DRAM_DQ[11]
set_location_assignment PIN_R22 -to DRAM_DQ[12]
set_location_assignment PIN_P22 -to DRAM_DQ[13]
set_location_assignment PIN_N20 -to DRAM_DQ[14]
set_location_assignment PIN_N21 -to DRAM_DQ[15]
set_location_assignment PIN_K22 -to DRAM_DQ[16]
set_location_assignment PIN_K21 -to DRAM_DQ[17]
set_location_assignment PIN_J22 -to DRAM_DQ[18]
set_location_assignment PIN_J21 -to DRAM_DQ[19]
set_location_assignment PIN_H21 -to DRAM_DQ[20]
set_location_assignment PIN_G22 -to DRAM_DQ[21]
set_location_assignment PIN_G21 -to DRAM_DQ[22]
set_location_assignment PIN_F22 -to DRAM_DQ[23]
set_location_assignment PIN_E22 -to DRAM_DQ[24]
set_location_assignment PIN_E20 -to DRAM_DQ[25]
set_location_assignment PIN_D22 -to DRAM_DQ[26]
set_location_assignment PIN_D21 -to DRAM_DQ[27]
set_location_assignment PIN_C21 -to DRAM_DQ[28]
set_location_assignment PIN_B22 -to DRAM_DQ[29]
set_location_assignment PIN_A22 -to DRAM_DQ[30]
set_location_assignment PIN_B21 -to DRAM_DQ[31]
set_location_assignment PIN_U21 -to DRAM_DQM[0]
set_location_assignment PIN_L22 -to DRAM_DQM[1]
set_location_assignment PIN_K20 -to DRAM_DQM[2]
set_location_assignment PIN_E21 -to DRAM_DQM[3]

set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_WE_N
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_RAS_N
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_DQM[*]
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_DQ[*]
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_DQ
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_CS_N
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_ADDR[*]
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_BA[1]
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_BA[0]
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_BA
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_CAS_N
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_CKE
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to DRAM_CLK
set_instance_assignment -name FAST_INPUT_REGISTER ON -to DRAM_DQ[*]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to DRAM_DQ
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to DRAM_DQ[*]


#============================================================
# VGA
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_B[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_G[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_HS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_R[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_VS

set_location_assignment PIN_E9 -to VGA_B[3]
set_location_assignment PIN_G8 -to VGA_B[2]
set_location_assignment PIN_H8 -to VGA_B[1]
set_location_assignment PIN_L7 -to VGA_B[0]
set_location_assignment PIN_J7 -to VGA_G[5]
set_location_assignment PIN_K7 -to VGA_G[4]
set_location_assignment PIN_A8 -to VGA_G[3]
set_location_assignment PIN_J8 -to VGA_G[2]
set_location_assignment PIN_A7 -to VGA_G[1]
set_location_assignment PIN_B6 -to VGA_G[0]
set_location_assignment PIN_H9 -to VGA_HS
set_location_assignment PIN_C6 -to VGA_R[4]
set_location_assignment PIN_B7 -to VGA_R[3]
set_location_assignment PIN_A5 -to VGA_R[2]
set_location_assignment PIN_D6 -to VGA_R[1]
set_location_assignment PIN_B5 -to VGA_R[0]
set_location_assignment PIN_J9 -to VGA_VS
set_location_assignment PIN_D9 -to VGA_B[4]

set_location_assignment PIN_J17 -to RESET_N
set_location_assignment PIN_AB17 -to UART_RX
set_location_assignment PIN_AB18 -to UART_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RESET_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_TX

set_location_assignment PIN_C20 -to SD_CLK
set_location_assignment PIN_A20 -to SD_CS
set_location_assignment PIN_B20 -to SD_MOSI
set_location_assignment PIN_D19 -to SD_MISO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_CS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_MOSI
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SD_MISO

set_location_assignment PIN_AB21 -to sigma_r
set_location_assignment PIN_AB20 -to sigma_l
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sigma_r
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sigma_l



