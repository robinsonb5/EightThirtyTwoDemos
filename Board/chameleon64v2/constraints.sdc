
## Copyright (C) 1991-2011 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 11.1 Build 216 11/23/2011 Service Pack 1 SJ Web Edition"

## DATE    "Fri Jul 06 23:05:47 2012"

##
## DEVICE  "EP3C25Q240C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_50} -period 20 -waveform { 0.000 0.500 } [get_ports {clk50m}]

set sysclk {U00|altpll_component|auto_generated|pll1|clk[1]}


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks 
create_generated_clock -name sd1clk_pin -source [get_pins {U00|altpll_component|auto_generated|pll1|clk[0]}] [get_ports {ram_clk}]


#**************************************************************
# Set Clock Latency
#**************************************************************


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty;

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock sd1clk_pin -max 5.8 [get_ports ram_d*]
set_input_delay -clock sd1clk_pin -min 3.2 [get_ports ram_d*]

# Delays for async signals - not necessary, but might as well avoid
# having unconstrained ports in the design
#set_input_delay -clock sysclk -min 0.0 [get_ports {UART_RX}]
#set_input_delay -clock sysclk -max 0.0 [get_ports {UART_RX}]

set_input_delay 0.5 -clock [get_clocks ${sysclk}] [get_ports {
	altera_reserved_tdi altera_reserved_tms ba_in dotclk_n
	ioef phi2_n ps2iec[*] reset_btn romlh spi_miso ir_data low_d[*]}]

set_input_delay 0.5 -clock [get_clocks ${sysclk}] [get_ports {
	usart_cts }]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock sd1clk_pin -max 1.5 [get_ports ram_*]
set_output_delay -clock sd1clk_pin -min -0.8 [get_ports ram_*]
set_output_delay -clock sd1clk_pin -max 0.5 [get_ports ram_clk]
set_output_delay -clock sd1clk_pin -min 0.5 [get_ports ram_clk]

set_output_delay 0.5 -clock [get_clocks ${sysclk}] [get_ports {
	altera_reserved_tdo game_out irq_out
	mmc_cs ps2iec_sel rw_out sa15_out sa_oe sd_dir sd_oe
	ser_out_clk ser_out_dat ser_out_rclk spi_clk spi_mosi }]

	
# Delays for async signals - not necessary, but might as well avoid
# having unconstrained ports in the design
#set_output_delay -clock sysclk -min 0.0 [get_ports UART_TX]
#set_output_delay -clock sysclk -max 0.0 [get_ports UART_TX]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to {iec_* sigma_l sigma_r low_a[*] low_d[*] spi_mosi spi_clk mmc_cs usart_rx}
set_false_path -from { low_d[*] spi_miso nmi_in freeze_btn usart_tx usart_clk usart_rts}

# Asynchronous signal, so not important timing-wise
#set_false_path -from {*uart|txd} -to {UART_TX}

#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -from [get_clocks {sd1clk_pin}] -to [get_clocks {U00|altpll_component|auto_generated|pll1|clk[1]}] -setup -end 2

#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************
