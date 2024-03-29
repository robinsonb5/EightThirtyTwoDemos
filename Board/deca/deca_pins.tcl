#============================================================
# CLOCK
#============================================================
set_location_assignment PIN_M9 -to ADC_CLK_10
set_instance_assignment -name IO_STANDARD "2.5 V" -to ADC_CLK_10
set_location_assignment PIN_M8 -to MAX10_CLK1_50
set_instance_assignment -name IO_STANDARD "2.5 V" -to MAX10_CLK1_50
set_location_assignment PIN_P11 -to MAX10_CLK2_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to MAX10_CLK2_50


#============================================================
# UART
#============================================================
set_location_assignment PIN_Y18 -to UART_RXD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_RXD
set_location_assignment PIN_W18 -to UART_TXD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to UART_TXD


#============================================================
# KEY
#============================================================
set_location_assignment PIN_H21 -to KEY[0]
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to KEY[0]
set_location_assignment PIN_H22 -to KEY[1]
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to KEY[1]

#============================================================
# LED
#============================================================
set_location_assignment PIN_C7 -to LED[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[0]
set_location_assignment PIN_C8 -to LED[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[1]
set_location_assignment PIN_A6 -to LED[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[2]
set_location_assignment PIN_B7 -to LED[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[3]
set_location_assignment PIN_C4 -to LED[4]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[4]
set_location_assignment PIN_A5 -to LED[5]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[5]
set_location_assignment PIN_B4 -to LED[6]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[6]
set_location_assignment PIN_C5 -to LED[7]
set_instance_assignment -name IO_STANDARD "1.2 V" -to LED[7]

#============================================================
# CapSense Button
#============================================================
set_location_assignment PIN_AB2 -to CAP_SENSE_I2C_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CAP_SENSE_I2C_SCL
set_location_assignment PIN_AB3 -to CAP_SENSE_I2C_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CAP_SENSE_I2C_SDA

#============================================================
# Audio
#============================================================
set_location_assignment PIN_R14 -to AUDIO_BCLK
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_BCLK
set_location_assignment PIN_P15 -to AUDIO_DIN_MFP1
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_DIN_MFP1
set_location_assignment PIN_P18 -to AUDIO_DOUT_MFP2
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_DOUT_MFP2
set_location_assignment PIN_M22 -to AUDIO_GPIO_MFP5
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_GPIO_MFP5
set_location_assignment PIN_P14 -to AUDIO_MCLK
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_MCLK
set_location_assignment PIN_N21 -to AUDIO_MISO_MFP4
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_MISO_MFP4
set_location_assignment PIN_M21 -to AUDIO_RESET_n
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_RESET_n
set_location_assignment PIN_P19 -to AUDIO_SCLK_MFP3
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_SCLK_MFP3
set_location_assignment PIN_P20 -to AUDIO_SCL_SS_n
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_SCL_SS_n
set_location_assignment PIN_P21 -to AUDIO_SDA_MOSI
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_SDA_MOSI
set_location_assignment PIN_N22 -to AUDIO_SPI_SELECT
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_SPI_SELECT
set_location_assignment PIN_R15 -to AUDIO_WCLK
set_instance_assignment -name IO_STANDARD "1.5 V" -to AUDIO_WCLK

#============================================================
# SDRAM
#============================================================
set_location_assignment PIN_E21 -to DDR3_A[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[0]
set_location_assignment PIN_V20 -to DDR3_A[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[1]
set_location_assignment PIN_V21 -to DDR3_A[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[2]
set_location_assignment PIN_C20 -to DDR3_A[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[3]
set_location_assignment PIN_Y21 -to DDR3_A[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[4]
set_location_assignment PIN_J14 -to DDR3_A[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[5]
set_location_assignment PIN_V18 -to DDR3_A[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[6]
set_location_assignment PIN_U20 -to DDR3_A[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[7]
set_location_assignment PIN_Y20 -to DDR3_A[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[8]
set_location_assignment PIN_W22 -to DDR3_A[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[9]
set_location_assignment PIN_C22 -to DDR3_A[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[10]
set_location_assignment PIN_Y22 -to DDR3_A[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[11]
set_location_assignment PIN_N18 -to DDR3_A[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[12]
set_location_assignment PIN_V22 -to DDR3_A[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[13]
set_location_assignment PIN_W20 -to DDR3_A[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_A[14]
set_location_assignment PIN_D19 -to DDR3_BA[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_BA[0]
set_location_assignment PIN_W19 -to DDR3_BA[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_BA[1]
set_location_assignment PIN_F19 -to DDR3_BA[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_BA[2]
set_location_assignment PIN_E20 -to DDR3_CAS_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_CAS_n
set_location_assignment PIN_B22 -to DDR3_CKE
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_CKE
set_location_assignment PIN_E18 -to DDR3_CK_n
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_CK_n
set_location_assignment PIN_D18 -to DDR3_CK_p
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_CK_p
set_location_assignment PIN_N15 -to DDR3_CLK_50
set_instance_assignment -name IO_STANDARD "1.5 V" -to DDR3_CLK_50
set_location_assignment PIN_F22 -to DDR3_CS_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_CS_n
set_location_assignment PIN_N19 -to DDR3_DM[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DM[0]
set_location_assignment PIN_J15 -to DDR3_DM[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DM[1]
set_location_assignment PIN_L20 -to DDR3_DQ[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[0]
set_location_assignment PIN_L19 -to DDR3_DQ[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[1]
set_location_assignment PIN_L18 -to DDR3_DQ[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[2]
set_location_assignment PIN_M15 -to DDR3_DQ[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[3]
set_location_assignment PIN_M18 -to DDR3_DQ[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[4]
set_location_assignment PIN_M14 -to DDR3_DQ[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[5]
set_location_assignment PIN_M20 -to DDR3_DQ[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[6]
set_location_assignment PIN_N20 -to DDR3_DQ[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[7]
set_location_assignment PIN_K19 -to DDR3_DQ[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[8]
set_location_assignment PIN_K18 -to DDR3_DQ[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[9]
set_location_assignment PIN_J18 -to DDR3_DQ[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[10]
set_location_assignment PIN_K20 -to DDR3_DQ[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[11]
set_location_assignment PIN_H18 -to DDR3_DQ[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[12]
set_location_assignment PIN_J20 -to DDR3_DQ[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[13]
set_location_assignment PIN_H20 -to DDR3_DQ[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[14]
set_location_assignment PIN_H19 -to DDR3_DQ[15]
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_DQ[15]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_DQS_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_DQS_n[1]
set_location_assignment PIN_L14 -to DDR3_DQS_p[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_DQS_p[0]
set_location_assignment PIN_K14 -to DDR3_DQS_p[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.5-V SSTL CLASS I" -to DDR3_DQS_p[1]
set_location_assignment PIN_G22 -to DDR3_ODT
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_ODT
set_location_assignment PIN_D22 -to DDR3_RAS_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_RAS_n
set_location_assignment PIN_U19 -to DDR3_RESET_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_RESET_n
set_location_assignment PIN_E22 -to DDR3_WE_n
set_instance_assignment -name IO_STANDARD "SSTL-15 CLASS I" -to DDR3_WE_n

#============================================================
# Flash
#============================================================
set_location_assignment PIN_P12 -to FLASH_DATA[0]
set_location_assignment PIN_V4 -to FLASH_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FLASH_DATA[1]
set_location_assignment PIN_V5 -to FLASH_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FLASH_DATA[2]
set_location_assignment PIN_P10 -to FLASH_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FLASH_DATA[3]
set_location_assignment PIN_R12 -to FLASH_DCLK
set_location_assignment PIN_R10 -to FLASH_NCSO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FLASH_NCSO
set_location_assignment PIN_W10 -to FLASH_RESET_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FLASH_RESET_n

#============================================================
# G-Sensor
#============================================================
set_location_assignment PIN_E9 -to G_SENSOR_CS_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_CS_n
set_location_assignment PIN_B5 -to G_SENSOR_SCLK
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_SCLK
set_location_assignment PIN_E8 -to G_SENSOR_INT1
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_INT1
set_location_assignment PIN_D5 -to G_SENSOR_SDO
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_SDO
set_location_assignment PIN_D7 -to G_SENSOR_INT2
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_INT2
set_location_assignment PIN_C6 -to G_SENSOR_SDI
set_instance_assignment -name IO_STANDARD "1.2 V" -to G_SENSOR_SDI

#============================================================
# HDMI-TX
#============================================================
set_location_assignment PIN_C10 -to HDMI_I2C_SCL
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2C_SCL
set_location_assignment PIN_B15 -to HDMI_I2C_SDA
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2C_SDA
set_location_assignment PIN_A9 -to HDMI_I2S[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2S[0]
set_location_assignment PIN_A11 -to HDMI_I2S[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2S[1]
set_location_assignment PIN_A8 -to HDMI_I2S[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2S[2]
set_location_assignment PIN_B8 -to HDMI_I2S[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_I2S[3]
set_location_assignment PIN_A10 -to HDMI_LRCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_LRCLK
set_location_assignment PIN_A7 -to HDMI_MCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_MCLK
set_location_assignment PIN_D12 -to HDMI_SCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_SCLK
set_location_assignment PIN_A20 -to HDMI_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_CLK
set_location_assignment PIN_C18 -to HDMI_TX_D[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[0]
set_location_assignment PIN_D17 -to HDMI_TX_D[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[1]
set_location_assignment PIN_C17 -to HDMI_TX_D[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[2]
set_location_assignment PIN_C19 -to HDMI_TX_D[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[3]
set_location_assignment PIN_D14 -to HDMI_TX_D[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[4]
set_location_assignment PIN_B19 -to HDMI_TX_D[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[5]
set_location_assignment PIN_D13 -to HDMI_TX_D[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[6]
set_location_assignment PIN_A19 -to HDMI_TX_D[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[7]
set_location_assignment PIN_C14 -to HDMI_TX_D[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[8]
set_location_assignment PIN_A17 -to HDMI_TX_D[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[9]
set_location_assignment PIN_B16 -to HDMI_TX_D[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[10]
set_location_assignment PIN_C15 -to HDMI_TX_D[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[11]
set_location_assignment PIN_A14 -to HDMI_TX_D[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[12]
set_location_assignment PIN_A15 -to HDMI_TX_D[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[13]
set_location_assignment PIN_A12 -to HDMI_TX_D[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[14]
set_location_assignment PIN_A16 -to HDMI_TX_D[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[15]
set_location_assignment PIN_A13 -to HDMI_TX_D[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[16]
set_location_assignment PIN_C16 -to HDMI_TX_D[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[17]
set_location_assignment PIN_C12 -to HDMI_TX_D[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[18]
set_location_assignment PIN_B17 -to HDMI_TX_D[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[19]
set_location_assignment PIN_B12 -to HDMI_TX_D[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[20]
set_location_assignment PIN_B14 -to HDMI_TX_D[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[21]
set_location_assignment PIN_A18 -to HDMI_TX_D[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[22]
set_location_assignment PIN_C13 -to HDMI_TX_D[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_D[23]
set_location_assignment PIN_C9 -to HDMI_TX_DE
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_DE
set_location_assignment PIN_B11 -to HDMI_TX_HS
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_HS
set_location_assignment PIN_B10 -to HDMI_TX_INT
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_INT
set_location_assignment PIN_C11 -to HDMI_TX_VS
set_instance_assignment -name IO_STANDARD "1.8 V" -to HDMI_TX_VS

#============================================================
# Light Sensor
#============================================================
set_location_assignment PIN_Y8 -to LIGHT_I2C_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LIGHT_I2C_SCL
set_location_assignment PIN_AA8 -to LIGHT_I2C_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LIGHT_I2C_SDA
set_location_assignment PIN_AA9 -to LIGHT_INT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LIGHT_INT

#============================================================
# MIPI
#============================================================
set_location_assignment PIN_V3 -to MIPI_CORE_EN
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_CORE_EN
set_location_assignment PIN_M1 -to MIPI_I2C_SCL
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_I2C_SCL
set_location_assignment PIN_M2 -to MIPI_I2C_SDA
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_I2C_SDA
set_location_assignment PIN_E10 -to MIPI_LP_MC_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MC_n
set_location_assignment PIN_E11 -to MIPI_LP_MC_p
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MC_p
set_location_assignment PIN_A3 -to MIPI_LP_MD_n[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_n[0]
set_location_assignment PIN_C2 -to MIPI_LP_MD_n[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_n[1]
set_location_assignment PIN_B2 -to MIPI_LP_MD_n[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_n[2]
set_location_assignment PIN_A2 -to MIPI_LP_MD_n[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_n[3]
set_location_assignment PIN_A4 -to MIPI_LP_MD_p[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_p[0]
set_location_assignment PIN_C3 -to MIPI_LP_MD_p[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_p[1]
set_location_assignment PIN_B1 -to MIPI_LP_MD_p[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_p[2]
set_location_assignment PIN_B3 -to MIPI_LP_MD_p[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to MIPI_LP_MD_p[3]
set_location_assignment PIN_U3 -to MIPI_MCLK
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_MCLK
set_location_assignment PIN_N5 -to MIPI_MC_p
set_instance_assignment -name IO_STANDARD LVDS -to MIPI_MC_p
set_location_assignment PIN_R2 -to MIPI_MD_p[0]
set_instance_assignment -name IO_STANDARD LVDS -to MIPI_MD_p[0]
set_location_assignment PIN_N1 -to MIPI_MD_p[1]
set_instance_assignment -name IO_STANDARD LVDS -to MIPI_MD_p[1]
set_location_assignment PIN_T2 -to MIPI_MD_p[2]
set_instance_assignment -name IO_STANDARD LVDS -to MIPI_MD_p[2]
set_location_assignment PIN_N2 -to MIPI_MD_p[3]
set_instance_assignment -name IO_STANDARD LVDS -to MIPI_MD_p[3]
set_location_assignment PIN_T3 -to MIPI_RESET_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_RESET_n
set_location_assignment PIN_U1 -to MIPI_WP
set_instance_assignment -name IO_STANDARD "2.5 V" -to MIPI_WP

#============================================================
# Ethernet
#============================================================
set_location_assignment PIN_R4 -to NET_COL
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_COL
set_location_assignment PIN_P5 -to NET_CRS
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_CRS
set_location_assignment PIN_R5 -to NET_MDC
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_MDC
set_location_assignment PIN_N8 -to NET_MDIO
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_MDIO
set_location_assignment PIN_V9 -to NET_PCF_EN
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to NET_PCF_EN
set_location_assignment PIN_R3 -to NET_RESET_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RESET_n
set_location_assignment PIN_U5 -to NET_RXD[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RXD[0]
set_location_assignment PIN_U4 -to NET_RXD[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RXD[1]
set_location_assignment PIN_R7 -to NET_RXD[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RXD[2]
set_location_assignment PIN_P8 -to NET_RXD[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RXD[3]
set_location_assignment PIN_T6 -to NET_RX_CLK
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RX_CLK
set_location_assignment PIN_P4 -to NET_RX_DV
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RX_DV
set_location_assignment PIN_V1 -to NET_RX_ER
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_RX_ER
set_location_assignment PIN_U2 -to NET_TXD[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TXD[0]
set_location_assignment PIN_W1 -to NET_TXD[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TXD[1]
set_location_assignment PIN_N9 -to NET_TXD[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TXD[2]
set_location_assignment PIN_W2 -to NET_TXD[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TXD[3]
set_location_assignment PIN_T5 -to NET_TX_CLK
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TX_CLK
set_location_assignment PIN_P3 -to NET_TX_EN
set_instance_assignment -name IO_STANDARD "2.5 V" -to NET_TX_EN

#============================================================
# Power Monitor
#============================================================
set_location_assignment PIN_Y4 -to PMONITOR_ALERT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PMONITOR_ALERT
set_location_assignment PIN_Y3 -to PMONITOR_I2C_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PMONITOR_I2C_SCL
set_location_assignment PIN_Y1 -to PMONITOR_I2C_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PMONITOR_I2C_SDA

#============================================================
# Humidity and Temperature Sensor
#============================================================
set_location_assignment PIN_AB9 -to RH_TEMP_DRDY_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RH_TEMP_DRDY_n
set_location_assignment PIN_Y10 -to RH_TEMP_I2C_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RH_TEMP_I2C_SCL
set_location_assignment PIN_AA10 -to RH_TEMP_I2C_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RH_TEMP_I2C_SDA

#============================================================
# MicroSD Card
#============================================================
set_location_assignment PIN_T20 -to SD_CLK
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_CLK
set_location_assignment PIN_T21 -to SD_CMD
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_CMD
set_location_assignment PIN_U22 -to SD_CMD_DIR
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_CMD_DIR
set_location_assignment PIN_T22 -to SD_D0_DIR
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_D0_DIR
set_location_assignment PIN_U21 -to SD_D123_DIR
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_D123_DIR
set_location_assignment PIN_R18 -to SD_DAT[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_DAT[0]
set_location_assignment PIN_T18 -to SD_DAT[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_DAT[1]
set_location_assignment PIN_T19 -to SD_DAT[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_DAT[2]
set_location_assignment PIN_R20 -to SD_DAT[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_DAT[3]
set_location_assignment PIN_R22 -to SD_FB_CLK
set_instance_assignment -name IO_STANDARD "1.5 V" -to SD_FB_CLK
set_location_assignment PIN_P13 -to SD_SEL

#============================================================
# SW
#============================================================
set_location_assignment PIN_J21 -to SW[0]
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to SW[0]
set_location_assignment PIN_J22 -to SW[1]
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to SW[1]

#============================================================
# Board Temperature Sensor
#============================================================
set_location_assignment PIN_AB4 -to TEMP_CS_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to TEMP_CS_n
set_location_assignment PIN_AA1 -to TEMP_SC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to TEMP_SC
set_location_assignment PIN_Y2 -to TEMP_SIO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to TEMP_SIO

#============================================================
# USB
#============================================================
set_location_assignment PIN_H11 -to USB_CLKIN
set_instance_assignment -name IO_STANDARD "1.2 V" -to USB_CLKIN
set_location_assignment PIN_J11 -to USB_CS
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_CS
set_location_assignment PIN_E12 -to USB_DATA[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[0]
set_location_assignment PIN_E13 -to USB_DATA[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[1]
set_location_assignment PIN_H13 -to USB_DATA[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[2]
set_location_assignment PIN_E14 -to USB_DATA[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[3]
set_location_assignment PIN_H14 -to USB_DATA[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[4]
set_location_assignment PIN_D15 -to USB_DATA[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[5]
set_location_assignment PIN_E15 -to USB_DATA[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[6]
set_location_assignment PIN_F15 -to USB_DATA[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DATA[7]
set_location_assignment PIN_J13 -to USB_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_DIR
set_location_assignment PIN_D8 -to USB_FAULT_n
set_instance_assignment -name IO_STANDARD "1.2 V" -to USB_FAULT_n
set_location_assignment PIN_H12 -to USB_NXT
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_NXT
set_location_assignment PIN_E16 -to USB_RESET_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_RESET_n
set_location_assignment PIN_J12 -to USB_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB_STP


# SDRAM
# =====
set_location_assignment PIN_Y17 -to SDRAM_A[0]
set_location_assignment PIN_W14 -to SDRAM_A[1]
set_location_assignment PIN_U15 -to SDRAM_A[2]
set_location_assignment PIN_R13 -to SDRAM_A[3]
set_location_assignment PIN_Y13 -to SDRAM_A[4]
set_location_assignment PIN_AB11 -to SDRAM_A[5]
set_location_assignment PIN_AA11 -to SDRAM_A[6]
set_location_assignment PIN_AB12 -to SDRAM_A[7]
set_location_assignment PIN_AA12 -to SDRAM_A[8]
set_location_assignment PIN_AB13 -to SDRAM_A[9]
set_location_assignment PIN_V14 -to SDRAM_A[10]
set_location_assignment PIN_AA13 -to SDRAM_A[11]
set_location_assignment PIN_AB14 -to SDRAM_A[12]
set_location_assignment PIN_AA20 -to SDRAM_DQ[0]
set_location_assignment PIN_AA19 -to SDRAM_DQ[1]
set_location_assignment PIN_AB21 -to SDRAM_DQ[2]
set_location_assignment PIN_AB20 -to SDRAM_DQ[3]
set_location_assignment PIN_AB19 -to SDRAM_DQ[4]
set_location_assignment PIN_Y16 -to SDRAM_DQ[5]
set_location_assignment PIN_V16 -to SDRAM_DQ[6]
set_location_assignment PIN_AB18 -to SDRAM_DQ[7]
set_location_assignment PIN_AA15 -to SDRAM_DQ[8]
set_location_assignment PIN_Y14 -to SDRAM_DQ[9]
set_location_assignment PIN_W15 -to SDRAM_DQ[10]
set_location_assignment PIN_AB15 -to SDRAM_DQ[11]
set_location_assignment PIN_W16 -to SDRAM_DQ[12]
set_location_assignment PIN_AB16 -to SDRAM_DQ[13]
set_location_assignment PIN_V15 -to SDRAM_DQ[14]
set_location_assignment PIN_W17 -to SDRAM_DQ[15]
set_location_assignment PIN_V11 -to SDRAM_BA[0]
set_location_assignment PIN_V13 -to SDRAM_BA[1]
# CKE not connected on XS 2.2/2.4.
set_location_assignment PIN_AA16 -to SDRAM_CKE
set_location_assignment PIN_AA14 -to SDRAM_CLK
set_location_assignment PIN_W12 -to SDRAM_nCAS
set_location_assignment PIN_W11 -to SDRAM_nRAS
set_location_assignment PIN_AB10 -to SDRAM_nWE
set_location_assignment PIN_V12 -to SDRAM_nCS
# DQML/DQMH not connected on XS 2.2/2.4
set_location_assignment PIN_Y11 -to SDRAM_DQML
set_location_assignment PIN_W13 -to SDRAM_DQMH

# SDRAM set_instance_assignment
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[12]
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to SDRAM_A[11]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[10]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[9]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[8]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[7]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_A[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[15]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[14]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[13]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[12]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[11]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[10]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[9]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[8]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[7]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[6]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[5]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[4]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[3]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[2]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQ[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_BA[1]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_BA[0]
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQMH
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_DQML
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_CKE
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_nCAS
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_nRAS
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_nWE
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to SDRAM_nCS

set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[0]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[1]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[2]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[3]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[4]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[5]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[6]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[7]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[8]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[9]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[10]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[11]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[12]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[13]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[14]
set_instance_assignment -name FAST_OUTPUT_ENABLE_REGISTER ON -to SDRAM_DQ[15]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[0]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[1]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[2]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[3]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[4]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[5]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[6]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[7]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[8]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[9]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[10]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[11]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[12]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[13]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[14]
set_instance_assignment -name FAST_INPUT_REGISTER ON -to SDRAM_DQ[15]

set_location_assignment PIN_U6 -to BBB_PWR_BUT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BBB_PWR_BUT
set_location_assignment PIN_AA2 -to BBB_SYS_RESET_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BBB_SYS_RESET_n

set_location_assignment PIN_V10 -to VGA_B[0]
set_location_assignment PIN_AA6 -to VGA_B[1]
set_location_assignment PIN_AB6 -to VGA_B[2]
set_location_assignment PIN_AB7 -to VGA_G[0]
set_location_assignment PIN_R11 -to VGA_G[1]
set_location_assignment PIN_V7 -to VGA_G[2]
set_location_assignment PIN_W7 -to VGA_HS
set_location_assignment PIN_U7 -to VGA_R[0]
set_location_assignment PIN_Y7 -to VGA_R[1]
set_location_assignment PIN_AA7 -to VGA_R[2]
set_location_assignment PIN_W6 -to VGA_VS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to VGA_*


