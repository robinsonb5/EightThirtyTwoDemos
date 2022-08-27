library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.Toplevel_Config.all;

entity sim_ghdl_top is
end entity;

architecture rtl of sim_ghdl_top is

	constant clk_period : time := 10 ns;

	-- Internal signals

	signal clk : std_logic;
	signal clk_slow : std_logic;
	signal clk_video : std_logic;

	signal reset_n : std_logic;

	signal rxd : std_logic;
	signal txd : std_logic;

begin

	-- Clock process definition
	clk_process: process begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	slowclk_process : process begin
		clk_slow <= '0';
		wait for clk_period;
		clk_slow <= '1';
		wait for clk_period;
	end process;

	reset_n <= '0', '1' after 20 ns;

	rxd <= '1';

	vt : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => 28, --Toplevel_Frequency * 10,
		debug => false
	)
	port map(
		clk => clk,
		slowclk => clk_slow,
		videoclk => clk_video,
		reset_in => reset_n,
		txd => txd,
		rxd => rxd,

		-- SDRAM
		sdr_data_in => (others => '0')
	);

	uart : block
--		constant rxmsg : string := "Byte received";
		constant sysclk_hz : integer := 28000;
		constant uart_divisor : integer := sysclk_hz/1152;
		signal uart_byte : std_logic_vector(7 downto 0);
		signal uart_rxint : std_logic;
	begin

		uartrx : entity work.simple_uart
			generic map (
				enable_rx => true,
				enable_tx => false
			)
			port map(
				clk => clk,
				reset => reset_n,
				txdata => (others => '0'),
				txgo => '0',
				rxdata => uart_byte,
				rxready => uart_rxint,

				rxint => uart_rxint,
				clock_divisor => to_unsigned(uart_divisor,16),

				rxd => txd,
				txd => rxd
			);

		process(clk)
			variable msgline : line;
			variable textline : line;
		begin
			if rising_edge(clk) then
				if uart_rxint='1' then
					if uart_byte=X"0a" then
						writeline(output,textline);
					else
--						write(msgline,rxmsg);
--						writeline(output,msgline);
						write(textline,character'val(to_integer(unsigned(uart_byte))));
					end if;
				end if;
			end if;
		end process;

	end block;

end architecture;

