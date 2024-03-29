library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pll is
generic (
	sdram_phase : integer := 270
);
port (
	clk_i : in std_logic;
	clk_o : out std_logic_vector(3 downto 0);
	reset : in std_logic;
	locked : out std_logic
);
end entity;

architecture rtl of pll is
begin

pll_inst : entity work.ecp5pll
generic map(
	in_hz => 100000,
	out0_hz => 120000,
	out0_tol_hz => 2000000,
	out1_hz => 120000,
	out1_tol_hz => 2000000,
	out1_deg => sdram_phase,
	out2_hz => 60000,
	out2_tol_hz => 2000000,
	out3_hz => 150000,
	out3_tol_hz => 2000000
)
port map (
	clk_i => clk_i,
	clk_o => clk_o,
	reset => reset,
	locked => locked
);

end architecture;
