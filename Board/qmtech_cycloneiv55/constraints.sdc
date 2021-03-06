create_clock -name {CLOCK_50} -period 20.000 -waveform {0.000 10.000} { CLOCK_50 }

derive_pll_clocks -create_base_clocks

create_generated_clock -name sdram_clock -source [get_pins {U00|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name sysclk -source [get_pins {U00|altpll_component|auto_generated|pll1|clk[0]}] 

derive_clock_uncertainty

set_input_delay -clock { sdram_clock } -min 3.5 [get_ports *DRAM_DQ*]
set_input_delay -clock { sdram_clock } -max 6.5 [get_ports *DRAM_DQ*]

set_output_delay -clock { sdram_clock } -min -0.5 [get_ports DRAM_*]
set_output_delay -clock { sdram_clock } -max -1.5 [get_ports DRAM_*]

set_multicycle_path -from [get_clocks {sdram_clock}] -to [get_clocks {U00|altpll_component|auto_generated|pll1|clk[0]}] -setup -end 2

set_input_delay -clock { sysclk } -min 0.5 [get_ports {RESET_N UART_RX}]
set_input_delay -clock { sysclk } -max 0.5 [get_ports {RESET_N UART_RX}]

set_output_delay -clock { sysclk } -min 0.5 [get_ports UART_TX]
set_output_delay -clock { sysclk } -max 0.5 [get_ports UART_TX]

# Multicycles for multiplier - is this valid?
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_sgn} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d1[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d2[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_sgn} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d1[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d2[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2

