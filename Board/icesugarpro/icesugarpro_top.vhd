library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity icesugarpro_top is
port(
	clk_i : in std_logic; -- 25MHz
	TX : out std_logic
);
end entity;

architecture rtl of icesugarpro_top is

component pll is
port (
	clk_i : in std_logic;
	clk_o : out std_logic_vector(3 downto 0);
	reset : in std_logic :='0';
	locked : out std_logic
);
end component;

signal clk_sdram : std_logic;
signal clk_sys : std_logic;
signal clk_slow : std_logic;
signal clk_none : std_logic;

begin

	clk : component pll
	port map (
		clk_i => clk_i,
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_none
	);

	vt : entity work.VirtualToplevel
	generic map(
		sysclk_frequency => 1000
	)
	port map(
		clk => clk_sys,
		slowclk => clk_slow,
		reset_in => '1',
		txd => TX,
		spi_miso => '0'	
	);

end architecture;

