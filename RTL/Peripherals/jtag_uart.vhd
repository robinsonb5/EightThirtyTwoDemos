library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- JTAG uart - setup as drop-in replacement for simple_uart.vhd
-- but directs data over JTAG to nios2-terminal.


entity jtag_uart is
	generic(
		counter_bits : natural := 16;
		enable_rx : boolean := true;
		enable_tx : boolean := true
	);
	port(
		clk : in std_logic;
		reset : in std_logic;
		txdata : in std_logic_vector(7 downto 0);
		txgo : in std_logic;			-- trigger transmission
		txready : out std_logic;	-- ready to transmit
		rxdata : out std_logic_vector(7 downto 0);

		rxint : out std_logic;	-- Interrupt, momentary pulse when character received
		txint : out std_logic;	-- Interrupt, momentary pulse when data has finished sending

		clock_divisor : unsigned(15 downto 0) := X"0A2C";

		-- physical ports

		rxd : in std_logic;
		txd : out std_logic
	);
end jtag_uart;

architecture rtl of jtag_uart is

	signal tx_pending : std_logic;
	
	component alt_jtag_atlantic is
		generic (
			INSTANCE_ID : integer;
			LOG2_RXFIFO_DEPTH : integer;
			LOG2_TXFIFO_DEPTH : integer;
			SLD_AUTO_INSTANCE_INDEX : string
		);
		port (
			clk : in std_logic;
			rst_n : in std_logic;
			r_dat : in std_logic_vector(7 downto 0); -- data from FPGA
			r_val : in std_logic; -- data valid
			r_ena : out std_logic; -- can write (next) cycle, or FIFO not full?
			t_dat : out std_logic_vector(7 downto 0); -- data to FPGA
			t_dav : in std_logic; -- ready to receive more data
			t_ena : out std_logic; -- tx data valid
			t_pause : out std_logic -- ???
		);
	end component alt_jtag_atlantic;
	
	signal r_dat : std_logic_vector(7 downto 0);
	signal r_val : std_logic;
	signal r_ena : std_logic;
	signal t_dat : std_logic_vector(7 downto 0);
	signal t_dav : std_logic;
	signal t_ena : std_logic;
	signal t_pause : std_logic;

begin

	jtag_inst : component alt_jtag_atlantic
		generic map (
			INSTANCE_ID => 0,
			LOG2_RXFIFO_DEPTH => 3,
			LOG2_TXFIFO_DEPTH => 3,
			SLD_AUTO_INSTANCE_INDEX => "YES"
		)
		port map (
			clk => clk,
			rst_n => reset,
			r_dat => r_dat,
			r_val => r_val,
			r_ena => r_ena,
			t_dat => t_dat,
			t_dav => t_dav,
			t_ena => t_ena,
			t_pause => t_pause
		);

	process(clk)
	begin
	
		if reset='0' then
			tx_pending<='0';
		elsif rising_edge(clk) then

			txint<='0';
			rxint<='0';
			t_dav<='1';
			r_val<='0';
			txready<=not tx_pending;
			
			if t_ena = '1' then
				rxdata<=t_dat;
				rxint<='1';
			end if;
			
			if r_ena='1' and tx_pending='1' then
				r_dat<=txdata;
				r_val<='1';
				txint<='1';
				tx_pending<='0';
			end if;
			
			if txgo='1' then
				tx_pending<='1';
			end if;
						
		end if;
	end process;

end architecture;
