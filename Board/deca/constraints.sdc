create_clock -name clk50 -period 20 [get_ports {MAX10_CLK1_50}]

derive_pll_clocks
