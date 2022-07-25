create_clock -name {clk_50} -period 20.000 -waveform {0.000 10.000} { CLOCK_50 }
create_generated_clock -name spiclk -source [get_ports {CLOCK_50}] -divide_by 16 [get_registers {substitute_mcu:controller|spi_controller:spi|sck}]

set hostclk { clk_50 }
set supportclk { clk_50 }

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

# Set pin definitions for downstream constraints
set RAM_CLK DRAM_CLK
set RAM_OUT {DRAM_DQ* DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_*DQM DRAM_CS_N DRAM_CKE}
set RAM_IN {DRAM_D*}

set VGA_OUT {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}

set FALSE_OUT {ARDUINO_IO[*] GPIO[*] LEDR[*] }
set FALSE_IN {ARDUINO_IO[*] GPIO[*] KEY[*]}

# create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tdi
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tms
set_output_delay -clock altera_reserved_tck 3 altera_reserved_tdo

set_false_path -from [get_clocks {U00|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {U00|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}]
set_false_path -from [get_clocks {U00|pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}] -to [get_clocks {U00|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]

set_false_path -from {VirtualToplevel:virtualtoplevel|sdram_cached_wide:mysdram|altsyncram:\newwritebuffer:wbstore_data_rtl_0|altsyncram_g3q1:auto_generated|ram_block1a0~PORT_B_WRITE_ENABLE_REG} -to {VirtualToplevel:virtualtoplevel|sdram_cached_wide:mysdram|*}
set_false_path -from {VirtualToplevel:virtualtoplevel|sdram_cached_wide:mysdram|altsyncram:\newwritebuffer:wbstore_flagsaddr_rtl_0|altsyncram_07n1:auto_generated|ram_block1a0~PORT_B_WRITE_ENABLE_REG} -to {VirtualToplevel:virtualtoplevel|sdram_cached_wide:mysdram|*}