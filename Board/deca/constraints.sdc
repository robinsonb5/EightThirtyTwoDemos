create_clock -name clk50 -period 20 [get_ports {MAX10_CLK1_50}]

derive_pll_clocks

derive_clock_uncertainty

create_generated_clock -name sdram_clock -source [get_pins {sysclks|altpll_component|auto_generated|pll1|clk[0]}] [get_ports SDRAM_CLK]
create_generated_clock -name sysclk -source [get_pins {sysclks|altpll_component|auto_generated|pll1|clk[1]}] 

# SDRAM delays and multicycles

set_input_delay -clock { sdram_clock } -min 2.5 [get_ports *SDRAM_DQ*]
set_input_delay -clock { sdram_clock } -max 7.0 [get_ports *SDRAM_DQ*]

set_output_delay -clock { sdram_clock } -min -0.8 [get_ports SDRAM_*]
set_output_delay -clock { sdram_clock } -max 2.5 [get_ports SDRAM_*]

set_multicycle_path -from [get_clocks {sdram_clock}] -to [get_clocks {sysclks|altpll_component|auto_generated|pll1|clk[1]}] -setup -end 2

set_false_path -to SDRAM_CLK

set_false_path -from KEY[*]

# create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tdi
set_input_delay -clock altera_reserved_tck -clock_fall 3 altera_reserved_tms
set_output_delay -clock altera_reserved_tck 3 altera_reserved_tdo

