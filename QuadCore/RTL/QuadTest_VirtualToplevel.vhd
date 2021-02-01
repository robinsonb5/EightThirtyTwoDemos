library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.rom_pkg.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10 MHz
		jtag_uart : boolean := false
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
		rxd2	: in std_logic :='1';
		txd2	: out std_logic;
		
		-- Audio
		audio_l : out signed(15 downto 0);
		audio_r : out signed(15 downto 0)
);
end entity;

architecture rtl of VirtualToplevel is

constant sysclk_hz : integer := sysclk_frequency*1000;
constant uart_divisor : integer := sysclk_hz/1152;
constant maxAddrBit : integer := 31;

signal reset_n : std_logic := '0';
signal reset_counter : unsigned(15 downto 0) := X"FFFF";

-- Millisecond counter
signal millisecond_counter : unsigned(31 downto 0) := X"00000000";
signal millisecond_tick : unsigned(19 downto 0);


-- UART signals

signal ser_txdata : std_logic_vector(7 downto 0);
signal ser_txready : std_logic;
signal ser_rxdata : std_logic_vector(7 downto 0);
signal ser_rxrecv : std_logic;
signal ser_txgo : std_logic;
signal ser_rxint : std_logic;


-- Interrupt signals

constant int_max : integer := 1;
signal int_triggers : std_logic_vector(int_max downto 0);
signal int_status : std_logic_vector(int_max downto 0);
signal int_ack : std_logic;
signal int_req : std_logic;
signal int_enabled : std_logic :='0'; -- Disabled by default
signal int_trigger : std_logic;


-- Timer register block signals

signal timer_reg_req : std_logic;
signal timer_tick : std_logic;

-- Mutex signals

signal mutex_trigger : std_logic;
signal mutex : std_logic;


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

signal to_rom : ToROM;
signal from_rom : FromROM;

-- 2nd CPU signals

signal mem_rom2 : std_logic;
signal rom_ack2 : std_logic;
signal cpu_addr2 : std_logic_vector(31 downto 0);
signal to_cpu2 : std_logic_vector(31 downto 0);
signal from_cpu2 : std_logic_vector(31 downto 0);
signal cpu_req2 : std_logic; 
signal cpu_ack2 : std_logic; 
signal cpu_wr2 : std_logic; 
signal cpu_bytesel2 : std_logic_vector(3 downto 0);

signal mem_addr : std_logic_vector(31 downto 0);
signal mem_data : std_logic_vector(31 downto 0);
signal mem_req_cpu1 : std_logic;
signal mem_req_cpu2 : std_logic;
signal mem_req : std_logic;
signal mem_req_d : std_logic;
signal mem_wr : std_logic;
signal mem_cpu : std_logic;

signal to_rom2 : ToROM;
signal from_rom2 : FromROM;

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


-- Timer
process(clk)
begin
	if rising_edge(clk) then
		millisecond_tick<=millisecond_tick+1;
		if millisecond_tick=sysclk_frequency*100 then
			millisecond_counter<=millisecond_counter+1;
			millisecond_tick<=X"00000";
		end if;
	end if;
end process;


-- UART

jtag:
if jtag_uart=true generate
myuart : entity work.jtag_uart
	generic map(
		enable_tx=>true,
		enable_rx=>true
	)
	port map(
		clk => clk,
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
end generate;

nojtag:
if jtag_uart=false generate
myuart : entity work.simple_uart
	generic map(
		enable_tx=>true,
		enable_rx=>true
	)
	port map(
		clk => clk,
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
end generate;
	
mytimer : entity work.timer_controller
  generic map(
		prescale => sysclk_frequency, -- Prescale incoming clock
		timers => 0
  )
  port map (
		clk => clk,
		reset => reset_n,

		reg_addr_in => cpu_addr(7 downto 0),
		reg_data_in => from_cpu,
		reg_rw => '0', -- we never read from the timers
		reg_req => timer_reg_req,

		ticks(0) => timer_tick -- Tick signal is used to trigger an interrupt
	);


-- Interrupt controller

intcontroller: entity work.interrupt_controller
generic map (
	max_int => int_max
)
port map (
	clk => clk,
	reset_n => reset_n,
	trigger => int_triggers, -- Again, thanks ISE.
	ack => int_ack,
	int => int_req,
	status => int_status
);

int_triggers<=(0=>timer_tick, 1=>mutex_trigger, others => '0');


-- ROM

	rom : entity work.QuadTest_rom
	generic map(
		maxAddrBitBRAM => 15
	)
	port map(
		clk => clk,
		from_soc => to_rom,
		to_soc => from_rom,
		from_soc2 => to_rom2,
		to_soc2 => from_rom2
	);

	
-- Main CPU

	mem_rom <='1' when cpu_addr(31 downto 28)=X"0" else '0';
	mem_req_cpu1 <='1' when cpu_req='1' and mem_rom='0' else '0';
--	mem_rd<='1' when cpu_req='1' and cpu_wr='0' and mem_rom='0' else '0';
--	mem_wr<='1' when cpu_req='1' and cpu_wr='1' and mem_rom='0' else '0';

	to_rom.MemAAddr<=cpu_addr(15 downto 2);
	to_rom.MemAWrite<=from_cpu;
	to_rom.MemAByteSel<=cpu_bytesel;

-- cpu2

	mem_rom2 <='1' when cpu_addr2(31 downto 28)=X"0" else '0';
	mem_req_cpu2 <='1' when cpu_req2='1' and mem_rom2='0' else '0';
--	mem_rd2<='1' when cpu_req2='1' and cpu_wr2='0' and mem_rom2='0' else '0';
--	mem_wr2<='1' when cpu_req2='1' and cpu_wr2='1' and mem_rom2='0' else '0';

	to_rom2.MemAAddr<=cpu_addr2(15 downto 2);
	to_rom2.MemAWrite<=from_cpu2;
	to_rom2.MemAByteSel<=cpu_bytesel2;
	
	process(clk)
	begin
		if reset_n='0' then
			mem_req<='0';
		elsif rising_edge(clk) then

			-- cpu 1

			rom_ack<=cpu_req and mem_rom;

			if cpu_addr(31)='0' then
				to_cpu<=from_rom.MemARead;
			else
				to_cpu<=from_mem;
			end if;

			if ((mem_busy='0' and mem_cpu='0') or rom_ack='1') and cpu_ack='0' then
				cpu_ack<='1';
			else
				cpu_ack<='0';
			end if;

			if cpu_addr(31)='0' then
				to_rom.MemAWriteEnable<=(cpu_wr and cpu_req);
			else
				to_rom.MemAWriteEnable<='0';
			end if;

			-- cpu 2

			rom_ack2<=cpu_req2 and mem_rom2;

			if cpu_addr2(31)='0' then
				to_cpu2<=from_rom2.MemARead;
			else
				to_cpu2<=from_mem;
			end if;

			if ((mem_busy='0' and mem_cpu='1') or rom_ack2='1') and cpu_ack2='0' then
				cpu_ack2<='1';
			else
				cpu_ack2<='0';
			end if;

			if cpu_addr2(31)='0' then
				to_rom2.MemAWriteEnable<=(cpu_wr2 and cpu_req2);
			else
				to_rom2.MemAWriteEnable<='0';
			end if;
			
			-- Launch a memory cycle if required.
			
			if mem_req='0' then
				if mem_req_cpu1='1' then
					mem_cpu<='0';	-- 1st cpu
					mem_req<='1';
					mem_addr<=cpu_addr;
					mem_data<=from_cpu;
					mem_wr<=cpu_wr;
				elsif mem_req_cpu2='1' then
					mem_cpu<='1';	-- 2nd cpu
					mem_req<='1';
					mem_addr<=cpu_addr2;
					mem_data<=from_cpu2;
					mem_wr<=cpu_wr2;
				end if;
			elsif mem_req='1' and ((mem_cpu='0' and cpu_ack='1') or (mem_cpu='1' and cpu_ack2='1')) then
				mem_req<='0';
				mem_wr<='0';
			end if;
			
		end if;	
	end process;
	
	cpu : entity work.eightthirtytwo_cpu
	generic map
	(
		littleendian => true,
		interrupts => false,
		dualthread => true,
		forwarding => true
	)
	port map
	(
		clk => clk,
		reset_n => reset_n,
		interrupt => '0', -- int_req,

		-- cpu fetch interface

		addr => cpu_addr(31 downto 2),
		d => to_cpu,
		q => from_cpu,
		bytesel => cpu_bytesel,
		wr => cpu_wr,
		req => cpu_req,
		ack => cpu_ack
	);


	cpu2 : entity work.eightthirtytwo_cpu
	generic map
	(
		littleendian => true,
		interrupts => false,
		dualthread => true,
		forwarding => true
	)
	port map
	(
		clk => clk,
		reset_n => reset_n,
		interrupt => '0', -- int_req,

		-- cpu fetch interface

		addr => cpu_addr2(31 downto 2),
		d => to_cpu2,
		q => from_cpu2,
		bytesel => cpu_bytesel2,
		wr => cpu_wr2,
		req => cpu_req2,
		ack => cpu_ack2
	);



process(clk)
begin
	if reset_n='0' then
		mutex<='0';
	elsif rising_edge(clk) then
		mem_busy<='1';
		ser_txgo<='0';
		int_ack<='0';
		timer_reg_req<='0';
		mutex_trigger<='0';

		mem_req_d<=mem_req;

		-- Write from CPU?
		if mem_wr='1' and mem_req='1' and mem_req_d='0' and mem_busy='1' then
			case mem_addr(31)&mem_addr(10 downto 8) is
				when X"C" =>	-- Timer controller at 0xFFFFFC00
					timer_reg_req<='1';
					mem_busy<='0';	-- Timer controller never blocks the CPU

				when X"F" =>	-- Peripherals
					case mem_addr(7 downto 0) is

						when X"B0" => -- Interrupts
							int_enabled<=mem_data(0);
							mem_busy<='0';

						when X"C0" => -- UART
							ser_txdata<=mem_data(7 downto 0);
							ser_txgo<='1';
							mem_busy<='0';
							
						when X"F0" => -- MUTEX
							mutex<='0';
							mutex_trigger<='1';
							mem_busy<='0';

						when others =>
							mem_busy<='0';
							null;
					end case;
				when others =>
					mem_busy<='0';
					null;
			end case;

		elsif mem_req='1' and mem_req_d='0' and mem_busy='1' then -- Read from CPU?
			case mem_addr(31 downto 28) is

				when X"F" =>	-- Peripherals
					case mem_addr(7 downto 0) is

						when X"B0" => -- Interrupt
							from_mem<=(others=>'X');
							from_mem(int_max downto 0)<=int_status;
							int_ack<='1';
							mem_busy<='0';

						when X"C0" => -- UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser_rxrecv&ser_txready&ser_rxdata;
							ser_rxrecv<='0';	-- Clear rx flag.
							mem_busy<='0';

						when X"C8" => -- Millisecond counter
							from_mem<=std_logic_vector(millisecond_counter);
							mem_busy<='0';
							
						when X"F0" => -- MUTEX
							from_mem<=(others=>'0');
							from_mem(0)<=mutex;
							mutex<='1';
							mem_busy<='0';
							
						when X"F4" => -- CPU ID
							from_mem<=(others=>'0');
							from_mem(0)<=mem_cpu;
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
