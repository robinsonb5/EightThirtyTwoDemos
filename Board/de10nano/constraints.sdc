create_clock -name {FGPA_CLK1_50} -period 20.000 -waveform {0.000 10.000} { FPGA_CLK1_50 }

derive_pll_clocks -create_base_clocks

create_generated_clock -name sdram_clock -source [get_nets {U00|pll_inst|altera_pll_i|outclk_wire[0]}] [get_ports SDRAM_CLK]
create_generated_clock -name sysclk -source [get_nets {U00|pll_inst|altera_pll_i|outclk_wire[1]}]

# SDRAM delays and multicycles

set_input_delay -clock { sdram_clock } -min 3.5 [get_ports *SDRAM_DQ*]
set_input_delay -clock { sdram_clock } -max 6.5 [get_ports *SDRAM_DQ*]

set_output_delay -clock { sdram_clock } -min -0.5 [get_ports SDRAM_*]
set_output_delay -clock { sdram_clock } -max -1.5 [get_ports SDRAM_*]

set_multicycle_path -from [get_clocks {sdram_clock}] -to [get_clocks {U00|pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup -end 2


# create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tdi
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tms
set_output_delay -clock altera_reserved_tck 3 altera_reserved_tdo

# False path to SDRAM_CLK removes meaningless hold-timing warning
set_false_path -to SDRAM_CLK 

set_false_path -to VGA_*
set_false_path -to SD_SPI_*
set_false_path -to AUDIO_*
set_false_path -to LED_*
set_false_path -from SD_SPI_*
set_false_path -from BTN_*

