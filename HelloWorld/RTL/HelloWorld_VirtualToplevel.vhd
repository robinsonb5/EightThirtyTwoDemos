library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.rom_pkg.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000 -- Sysclk frequency * 10
	);
	port (
		clk 			: in std_logic;
		slowclk		: in std_logic;
		reset_in 	: in std_logic;

		-- VGA
		vga_red 		: out unsigned(7 downto 0);
		vga_green 	: out unsigned(7 downto 0);
		vga_blue 	: out unsigned(7 downto 0);
		vga_hsync 	: out std_logic;
		vga_vsync 	: buffer std_logic;
		vga_window	: out std_logic;

		-- SDRAM
		sdr_data		: inout std_logic_vector(15 downto 0);
		sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
		sdr_dqm 		: out std_logic_vector(1 downto 0);
		sdr_we 		: out std_logic;
		sdr_cas 		: out std_logic;
		sdr_ras 		: out std_logic;
		sdr_cs		: out std_logic;
		sdr_ba		: out std_logic_vector(1 downto 0);
--		sdr_clk		: out std_logic;
		sdr_cke		: out std_logic;

		-- SPI signals
		spi_miso		: in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
		spi_mosi		: out std_logic;
		spi_clk		: out std_logic;
		spi_cs 		: out std_logic;
		
		-- PS/2 signals
		ps2k_clk_in : in std_logic := '1';
		ps2k_dat_in : in std_logic := '1';
		ps2k_clk_out : out std_logic;
		ps2k_dat_out : out std_logic;
		ps2m_clk_in : in std_logic := '1';
		ps2m_dat_in : in std_logic := '1';
		ps2m_clk_out : out std_logic;
		ps2m_dat_out : out std_logic;

		-- UART
		rxd	: in std_logic;
		txd	: out std_logic;
		
		-- Audio
		audio_l : out signed(15 downto 0);
		audio_r : out signed(15 downto 0)
);
end entity;

architecture rtl of VirtualToplevel is

constant sysclk_hz : integer := sysclk_frequency*500;
constant uart_divisor : integer := sysclk_hz/1152;
constant maxAddrBit : integer := 31;

signal reset_n : std_logic := '0';
signal reset_counter : unsigned(15 downto 0) := X"FFFF";

-- UART signals

signal ser_txdata : std_logic_vector(7 downto 0);
signal ser_txready : std_logic;
signal ser_rxdata : std_logic_vector(7 downto 0);
signal ser_rxrecv : std_logic;
signal ser_txgo : std_logic;
signal ser_rxint : std_logic;

-- CPU signals

signal mem_busy : std_logic;
signal mem_rom : std_logic;
signal rom_ack : std_logic;
signal from_mem : std_logic_vector(31 downto 0);
signal cpu_addr : std_logic_vector(31 downto 0);
signal to_cpu : std_logic_vector(31 downto 0);
signal from_cpu : std_logic_vector(31 downto 0);
signal cpu_req : std_logic; 
signal cpu_ack : std_logic; 
signal cpu_wr : std_logic; 
signal cpu_bytesel : std_logic_vector(3 downto 0);
signal mem_rd : std_logic; 
signal mem_wr : std_logic; 

signal to_rom : ToROM;
signal from_rom : FromROM;

begin

ps2k_dat_out<='1';
ps2k_clk_out<='1';
ps2m_dat_out<='1';
ps2m_clk_out<='1';

audio_l <= X"0000";
audio_r <= X"0000";

sdr_cke <='0'; -- Disable SDRAM for now
sdr_cs <='1'; -- Disable SDRAM for now

sdr_data <=(others => 'Z');
sdr_addr <=(others => '1');
sdr_dqm <=(others => '1');
sdr_we <='1';
sdr_cas <='1';
sdr_ras <='1';
sdr_ba <=(others => '1');

spi_mosi <='1';
spi_clk <='1';
spi_cs<='1';


-- Reset counter.

process(clk)
begin
	if reset_in='0' then
		reset_counter<=X"FFFF";
		reset_n<='0';
	elsif rising_edge(clk) then
		reset_counter<=reset_counter-1;
		if reset_counter=X"0000" then
			reset_n<='1';
		end if;
	end if;
end process;


-- UART

myuart : entity work.simple_uart
	generic map(
		enable_tx=>true,
		enable_rx=>true
	)
	port map(
		clk => slowclk,
		reset => reset_n, -- active low
		txdata => ser_txdata,
		txready => ser_txready,
		txgo => ser_txgo,
		rxdata => ser_rxdata,
		rxint => ser_rxint,
		txint => open,
		clock_divisor => to_unsigned(uart_divisor,16),
		rxd => rxd,
		txd => txd
	);


-- Hello World ROM

	rom : entity work.HelloWorld_rom
	generic map(
		maxAddrBitBRAM => 6
	)
	port map(
		clk => slowclk,
		from_soc => to_rom,
		to_soc => from_rom
	);

	
-- Main CPU

	mem_rom <='1' when cpu_addr(31 downto 28)=X"0" else '0';
	mem_rd<='1' when cpu_req='1' and cpu_wr='0' and mem_rom='0' else '0';
	mem_wr<='1' when cpu_req='1' and cpu_wr='1' and mem_rom='0' else '0';

	to_rom.MemAAddr<=cpu_addr(15 downto 2);
	to_rom.MemAWrite<=from_cpu;
	to_rom.MemAByteSel<=cpu_bytesel;
	to_rom.MemAWriteEnable<=(cpu_wr and cpu_req) when cpu_addr(31)='0' else '0';

	to_rom.MemBWriteEnable<='0';
	
	to_cpu<=from_rom.MemARead when cpu_addr(31)='0' else from_mem;

	cpu_ack <= '1' when mem_busy='0' or rom_ack='1' else '0';
	
	process(slowclk)
	begin
		if rising_edge(slowclk) then
			rom_ack<=cpu_req and mem_rom;
		end if;	
	end process;
	
	cpu : entity work.eightthirtytwo_cpu
	port map
	(
		clk => slowclk,
		reset_n => reset_n,

		-- cpu fetch interface

		addr => cpu_addr(31 downto 2),
		d => to_cpu,
		q => from_cpu,
		bytesel => cpu_bytesel,
		wr => cpu_wr,
		req => cpu_req,
		ack => cpu_ack
	);



process(slowclk)
begin
	if rising_edge(slowclk) then
		mem_busy<='1';
		ser_txgo<='0';
		
		-- Write from CPU?
		if mem_wr='1' and mem_busy='1' then
			case cpu_addr(31 downto 28) is
				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is
						when X"C0" => -- UART
							ser_txdata<=from_cpu(7 downto 0);
							ser_txgo<='1';
							mem_busy<='0';
							
						when others =>
							mem_busy<='0';
							null;
					end case;
				when others =>
					mem_busy<='0';
					null;
			end case;

		elsif mem_rd='1' and mem_busy='1' then -- Read from CPU?
			case cpu_addr(31 downto 28) is

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is
						when X"C0" => -- UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser_rxrecv&ser_txready&ser_rxdata;
							ser_rxrecv<='0';	-- Clear rx flag.
							mem_busy<='0';

						when others =>
							mem_busy<='0';
							null;
					end case;

				when others =>
					mem_busy<='0';
					null;
			end case;
		end if;


		-- Set this after the read operation has potentially cleared it.
		if ser_rxint='1' then
			ser_rxrecv<='1';
		end if;

	end if; -- rising-edge(clk)

end process;
	
end architecture;
