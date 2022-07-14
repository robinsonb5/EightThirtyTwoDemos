library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10
		jtag_uart : boolean := false;
		debug : boolean := false
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
		vga_pixel	: out std_logic;

		-- SDRAM
		sdr_drive_data  : out std_logic;
		sdr_data_in		: in std_logic_vector(31 downto 0) := (others => '0');
		sdr_data_out	: inout std_logic_vector(31 downto 0);
		sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
		sdr_dqm 		: out std_logic_vector(3 downto 0);
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

		-- UARTs
		rxd	: in std_logic := '1';
		txd	: out std_logic;
		rxd2	: in std_logic := '1';
		txd2	: out std_logic;
		
		-- Audio
		AUDIO_L : out signed(15 downto 0);
		AUDIO_R : out signed(15 downto 0)
);
end entity;

architecture rtl of VirtualToplevel is

	component debug_bridge_jtag is
	generic (
		id : natural := 16#832D#
	);
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		d : in std_logic_vector(31 downto 0);
		q : out std_logic_vector(31 downto 0);
		req : in std_logic;
		wr : in std_logic;
		ack : buffer std_logic
	);
	end component;

	constant sysclk_hz : integer := sysclk_frequency*1000;
	constant uart_divisor : integer := sysclk_hz/1152;
	constant uart2_divisor : integer := sysclk_hz/576;
	constant maxAddrBit : integer := 31;

	signal reset_n : std_logic := '0';
	signal reset : std_logic := '0';
	signal reset_counter : unsigned(15 downto 0) := X"FFFF";

	-- Millisecond counter
	signal millisecond_counter : unsigned(31 downto 0) := X"00000000";
	signal millisecond_tick : unsigned(19 downto 0);


	-- SPI Clock counter
	signal spi_tick : unsigned(8 downto 0);
	signal spiclk_in : std_logic;
	signal spi_fast : std_logic;

	-- SPI signals
	signal host_to_spi : std_logic_vector(7 downto 0);
	signal spi_to_host : std_logic_vector(31 downto 0);
	signal spi_wide : std_logic;
	signal spi_trigger : std_logic;
	signal spi_busy : std_logic;
	signal spi_active : std_logic;


	-- UART signals

	signal ser_txdata : std_logic_vector(7 downto 0);
	signal ser_txready : std_logic;
	signal ser_rxready : std_logic;
	signal ser_rxdata : std_logic_vector(7 downto 0);
	signal ser_rxrecv : std_logic;
	signal ser_txgo : std_logic;
	signal ser_rxint : std_logic;


	-- Second UART signals

	signal ser2_txdata : std_logic_vector(7 downto 0);
	signal ser2_txready : std_logic;
	signal ser2_rxready : std_logic;
	signal ser2_rxdata : std_logic_vector(7 downto 0);
	signal ser2_rxrecv : std_logic;
	signal ser2_txgo : std_logic;
	signal ser2_rxint : std_logic;


	-- Interrupt signals

	constant int_max : integer := 4;
	signal int_triggers : std_logic_vector(int_max downto 0);
	signal int_status : std_logic_vector(int_max downto 0);
	signal int_ack : std_logic;
	signal int_req : std_logic;
	signal int_enabled : std_logic :='0'; -- Disabled by default
	signal int_trigger : std_logic;


	-- Timer register block signals

	signal timer_reg_req : std_logic;
	signal timer_tick : std_logic;


	-- PS2 signals
	signal ps2_int : std_logic;

	signal kbdidle : std_logic;
	signal kbdrecv : std_logic;
	signal kbdrecvreg : std_logic;
	signal kbdsendbusy : std_logic;
	signal kbdsendtrigger : std_logic;
	signal kbdsenddone : std_logic;
	signal kbdsendbyte : std_logic_vector(7 downto 0);
	signal kbdrecvbyte : std_logic_vector(10 downto 0);

	signal mouseidle : std_logic;
	signal mouserecv : std_logic;
	signal mouserecvreg : std_logic;
	signal mousesendbusy : std_logic;
	signal mousesenddone : std_logic;
	signal mousesendtrigger : std_logic;
	signal mousesendbyte : std_logic_vector(7 downto 0);
	signal mouserecvbyte : std_logic_vector(10 downto 0);


	-- Plumbing between DMA controller and SDRAM

	signal vga_addr : std_logic_vector(31 downto 0);
	signal vga_data : std_logic_vector(31 downto 0);
	signal vga_req : std_logic;
	signal vga_fill : std_logic;
	signal vga_refresh : std_logic;
	signal vga_reservebank : std_logic; -- Keep bank clear for instant access.
	signal vga_reserveaddr : std_logic_vector(31 downto 0); -- to SDRAM

	signal dma_data : std_logic_vector(31 downto 0);

	-- Plumbing between VGA controller and DMA controller

	signal vgachannel_fromhost : DMAChannel_FromHost;
	signal vgachannel_tohost : DMAChannel_ToHost;
	signal spr0channel_fromhost : DMAChannel_FromHost;
	signal spr0channel_tohost : DMAChannel_ToHost;

	-- Audio channel plumbing

	signal aud0_fromhost : DMAChannel_FromHost;
	signal aud0_tohost : DMAChannel_ToHost;
	signal aud1_fromhost : DMAChannel_FromHost;
	signal aud1_tohost : DMAChannel_ToHost;
	signal aud2_fromhost : DMAChannel_FromHost;
	signal aud2_tohost : DMAChannel_ToHost;
	signal aud3_fromhost : DMAChannel_FromHost;
	signal aud3_tohost : DMAChannel_ToHost;

	signal audio_reg_req : std_logic;
	signal audio_ints : std_logic_vector(3 downto 0);
	signal audio_int : std_logic;
	
	signal audio_l_i : signed(23 downto 0);
	signal audio_r_i : signed(23 downto 0);

	-- VGA register block signals

	signal vga_reg_addr : std_logic_vector(11 downto 0);
	signal vga_reg_dataout : std_logic_vector(15 downto 0);
	signal vga_reg_datain : std_logic_vector(15 downto 0);
	signal vga_reg_rw : std_logic;
	signal vga_reg_req : std_logic;
	signal vga_reg_dtack : std_logic;
	signal vga_ack : std_logic;
	signal vblank_int : std_logic;
	signal vga_vsync_i : std_logic;


	-- SDRAM signals

	signal sdr_ready : std_logic;
	signal sdram_write : std_logic_vector(31 downto 0); -- 32-bit width for ZPU
	signal sdram_req : std_logic;
	signal sdram_wr : std_logic;
	signal sdram_read : std_logic_vector(31 downto 0);
	signal sdram_ack : std_logic;
	signal sdram_bytesel : std_logic_vector(3 downto 0);

	type sdram_states is (read1, read2, read3, write1, writeb, write2, write3, idle);
	signal sdram_state : sdram_states;


	-- CPU signals
	signal cpu_reset : std_logic;
	signal cpu_int : std_logic;
	signal soft_reset_n : std_logic;
	signal mem_busy : std_logic;
	signal mem_rom : std_logic;
	signal rom_ack : std_logic;
	signal from_mem : std_logic_vector(31 downto 0);
	signal from_rom : std_logic_vector(31 downto 0);
	signal cpu_addr : std_logic_vector(31 downto 0);
	signal to_cpu : std_logic_vector(31 downto 0);
	signal from_cpu : std_logic_vector(31 downto 0);
	signal cpu_req : std_logic; 
	signal cpu_ack : std_logic; 
	signal cpu_wr : std_logic; 
	signal cpu_bytesel : std_logic_vector(3 downto 0);
	signal bytesel_rev : std_logic_vector(3 downto 0);
	signal mem_rd : std_logic; 
	signal mem_wr : std_logic; 
	signal rom_wr : std_logic;
	signal mem_rd_d : std_logic; 
	signal mem_wr_d : std_logic; 
	signal cache_valid : std_logic;
	signal flushcaches : std_logic;

	-- CPU Debug signals
	signal debug_req : std_logic;
	signal debug_ack : std_logic;
	signal debug_fromcpu : std_logic_vector(31 downto 0);
	signal debug_tocpu : std_logic_vector(31 downto 0);
	signal debug_wr : std_logic;

	signal peripheral_block : std_logic_vector(3 downto 0);

begin

	sdr_cke <='1';

	-- Reset counter.

	process(clk,reset_in,sdr_ready)
	begin
		if reset_in='0' or sdr_ready='0' then
			reset_counter<=X"FFFF";
			reset_n<='0';
		elsif rising_edge(clk) then
			reset_counter<=reset_counter-1;
			if reset_counter=X"0000" then
				reset_n<='1';
			end if;
		end if;
	end process;

	reset <= not reset_n;

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


	-- UARTs

	jtaguart:
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

	regularuart:
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

	uart2 : entity work.simple_uart
		generic map(
			enable_tx=>true,
			enable_rx=>true
		)
		port map(
			clk => clk,
			reset => reset_n, -- active low
			txdata => ser2_txdata,
			txready => ser2_txready,
			txgo => ser2_txgo,
			rxdata => ser2_rxdata,
			rxready => ser2_rxready,
			rxint => ser2_rxint,
			txint => open,
			clock_divisor => to_unsigned(uart2_divisor,16),
			rxd => rxd2,
			txd => txd2
		);


-- PS2 devices

	mykeyboard : entity work.io_ps2_com
		generic map (
			clockFilter => 15,
			ticksPerUsec => sysclk_frequency/10
		)
		port map (
			clk => clk,
			reset => reset, -- active high!
			ps2_clk_in => ps2k_clk_in,
			ps2_dat_in => ps2k_dat_in,
			ps2_clk_out => ps2k_clk_out,
			ps2_dat_out => ps2k_dat_out,
			
			inIdle => open,	-- Probably don't need this
			sendTrigger => kbdsendtrigger,
			sendByte => kbdsendbyte,
			sendBusy => kbdsendbusy,
			sendDone => kbdsenddone,
			recvTrigger => kbdrecv,
			recvByte => kbdrecvbyte
		);


	mymouse : entity work.io_ps2_com
		generic map (
			clockFilter => 15,
			ticksPerUsec => sysclk_frequency/10
		)
		port map (
			clk => clk,
			reset => reset, -- active high!
			ps2_clk_in => ps2m_clk_in,
			ps2_dat_in => ps2m_dat_in,
			ps2_clk_out => ps2m_clk_out,
			ps2_dat_out => ps2m_dat_out,
			
			inIdle => open,	-- Probably don't need this
			sendTrigger => mousesendtrigger,
			sendByte => mousesendbyte,
			sendBusy => mousesendbusy,
			sendDone => mousesenddone,
			recvTrigger => mouserecv,
			recvByte => mouserecvbyte
		);


	-- SPI Timer
	process(clk)
	begin
		if rising_edge(clk) then
			spiclk_in<='0';
			spi_tick<=spi_tick+1;
			if (spi_fast='1' and spi_tick(2)='1') or spi_tick(7)='1' then
				spiclk_in<='1'; -- Momentary pulse for SPI host.
				spi_tick<='0'&X"00";
			end if;
		end if;
	end process;


	-- SPI host
	spi : entity work.spi_interface
		port map(
			sysclk => clk,
			reset => reset_n,

			-- Host interface
			spiclk_in => spiclk_in,
			host_to_spi => host_to_spi,
			spi_to_host => spi_to_host,
			trigger => spi_trigger,
			busy => spi_busy,

			-- Hardware interface
			miso => spi_miso,
			mosi => spi_mosi,
			spiclk_out => spi_clk
		);


-- DMA controller

	mydmacache : entity work.DMACache
		port map(
			clk => clk,
			reset_n => cpu_reset,

			channels_from_host(0) => vgachannel_fromhost,
			channels_from_host(1) => spr0channel_fromhost,
			channels_from_host(2) => aud0_fromhost,
			channels_from_host(3) => aud1_fromhost,
			channels_from_host(4) => aud2_fromhost,
			channels_from_host(5) => aud3_fromhost,
			
			channels_to_host(0) => vgachannel_tohost,
			channels_to_host(1) => spr0channel_tohost,
			channels_to_host(2) => aud0_tohost,
			channels_to_host(3) => aud1_tohost,
			channels_to_host(4) => aud2_tohost,
			channels_to_host(5) => aud3_tohost,

			data_out => dma_data,

			-- SDRAM interface
			sdram_addr=> vga_addr,
			sdram_reserveaddr(31 downto 0) => vga_reserveaddr,
			sdram_reserve => vga_reservebank,
			sdram_req => vga_req,
			sdram_ack => vga_ack,
			sdram_fill => vga_fill,
			sdram_data => vga_data
		);

	
	-- SDRAM
	bytesel_rev <= cpu_bytesel(0)&cpu_bytesel(1)&cpu_bytesel(2)&cpu_bytesel(3);

	mysdram : entity work.sdram_cached_wide
		generic map
		(
			rows => sdram_rows,
			cols => sdram_cols,
			cache => true,
			dcache => true,
			dqwidth => 32,
			dqmwidth => 4
		)
		port map
		(
		-- Physical connections to the SDRAM
			drive_sdata => sdr_drive_data,
			sdata_in => sdr_data_in,
			sdata_out => sdr_data_out,
			sdaddr => sdr_addr,
			sd_we	=> sdr_we,
			sd_ras => sdr_ras,
			sd_cas => sdr_cas,
			sd_cs	=> sdr_cs,
			dqm => sdr_dqm,
			ba	=> sdr_ba,

		-- Housekeeping
			sysclk => clk,
			reset => reset_in,  -- Contributes to reset, so have to use reset_in here.
			reset_out => sdr_ready,

			vga_addr => vga_addr,
			vga_data => vga_data,
			vga_fill => vga_fill,
			vga_req => vga_req,
			vga_ack => vga_ack,
			vga_refresh => vga_refresh,
			vga_reservebank => vga_reservebank,
			vga_reserveaddr => vga_reserveaddr,

			datawr1(31 downto 24) => sdram_write(7 downto 0),
			datawr1(23 downto 16) => sdram_write(15 downto 8),
			datawr1(15 downto 8) => sdram_write(23 downto 16),
			datawr1(7 downto 0) => sdram_write(31 downto 24),
			addr1 => cpu_addr,
			req1 => sdram_req,
			cachevalid => cache_valid,
			wr1 => sdram_wr, -- active low
			bytesel => sdram_bytesel, -- cpu_bytesel,
			dataout1 => sdram_read,
			dtack1 => sdram_ack,
			
			flushcaches => flushcaches
		);

	-- VGA controller
	-- Video
	
	myvga : entity work.vga_controller
		generic map (
			dmawidth => 32,
			enable_sprite => false
		)
		port map (
		clk => clk,
		reset => reset_in,

		reg_addr_in => cpu_addr(7 downto 0),
		reg_data_in => from_cpu,
		reg_rw => vga_reg_rw,
		reg_req => vga_reg_req,

		sdr_refresh => vga_refresh,

		dma_data => dma_data,
		vgachannel_fromhost => vgachannel_fromhost,
		vgachannel_tohost => vgachannel_tohost,
		spr0channel_fromhost => spr0channel_fromhost,
		spr0channel_tohost => spr0channel_tohost,

		hsync => vga_hsync,
		vsync => vga_vsync_i,
		vblank_int => vblank_int,
		red => vga_red,
		green => vga_green,
		blue => vga_blue,
		vga_window => vga_window,
		vga_pixel => vga_pixel
	);

vga_vsync<=vga_vsync_i;
	
-- Audio controller
	
myaudio : entity work.sound_wrapper
		generic map(
			dmawidth => 32,
			clk_frequency => sysclk_frequency -- Prescale incoming clock
		)
	port map (
		clk => clk,
		reset => cpu_reset,

		reg_addr_in => cpu_addr(7 downto 0),
		reg_data_in => from_cpu,
		reg_rw => '0', -- we never read from the sound controller
		reg_req => audio_reg_req,

		dma_data => dma_data,
		channel0_fromhost => aud0_fromhost,
		channel0_tohost => aud0_tohost,
		channel1_fromhost => aud1_fromhost,
		channel1_tohost => aud1_tohost,
		channel2_fromhost => aud2_fromhost,
		channel2_tohost => aud2_tohost,
		channel3_fromhost => aud3_fromhost,
		channel3_tohost => aud3_tohost,

		audio_l => audio_l_i,
		audio_r => audio_r_i,
		audio_ints => audio_ints
	);

audio_l<=audio_l_i(23 downto 8);
audio_r<=audio_r_i(23 downto 8);
	
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
	reset_n => cpu_reset,
	trigger => int_triggers, -- Again, thanks ISE.
	ack => int_ack,
	int => int_req,
	status => int_status
);

audio_int <= '0' when audio_ints="0000" else '1';
int_triggers<=(0=>timer_tick, 1=>vblank_int, 2=>ps2_int, 3=>ser2_rxint, 4=>audio_int, others => '0');


-- ROM

	rom : entity work.SoCWide_rom
	generic map(
		ADDR_WIDTH => 13
	)
	port map(
		clk => clk,		
		addr => cpu_addr(14 downto 2),
		d => from_cpu,
		q => from_rom,
		we => rom_wr,
		bytesel => cpu_bytesel
	);


-- Main CPU

	mem_rom <='1' when cpu_addr(31 downto 26)=X"0"&"00" else '0';
	mem_rd<='1' when cpu_req='1' and cpu_wr='0' and mem_rom='0' else '0';
	mem_wr<='1' when cpu_req='1' and cpu_wr='1' and mem_rom='0' else '0';
		
	process(clk)
	begin
		if rising_edge(clk) then
			rom_ack<=cpu_req and mem_rom;

			if mem_rom='1' then
				to_cpu<=from_rom;
			else
				to_cpu<=from_mem;
			end if;

			if (mem_busy='0' or rom_ack='1') and cpu_ack='0' then
				cpu_ack<='1';
			else
				cpu_ack<='0';
			end if;

			if mem_rom='1' then
				rom_wr<=(cpu_wr and cpu_req);
			else
				rom_wr<='0';
			end if;
	
		end if;	
	end process;
	
	cpu_reset<=reset_n and soft_reset_n;
	cpu_int <= int_req and int_enabled;
	
	cpu : entity work.eightthirtytwo_cpu
	generic map
	(
		multiplier => true,
		littleendian => true,
		dualthread => true,
		prefetch => true,
		interrupts => true,
		debug => debug
	)
	port map
	(
		clk => clk,
		reset_n => cpu_reset,
		interrupt => cpu_int,

		-- cpu fetch interface

		addr => cpu_addr(31 downto 2),
		d => to_cpu,
		q => from_cpu,
		bytesel => cpu_bytesel,
		wr => cpu_wr,
		req => cpu_req,
		ack => cpu_ack,
		-- Debug signals
		debug_d=>debug_tocpu,
		debug_q=>debug_fromcpu,
		debug_req=>debug_req,
		debug_wr=>debug_wr,
		debug_ack=>debug_ack		
	);
	cpu_addr(1 downto 0) <= (others => '0'); -- Ensure the low order bits are clear
	
gendebug:
if debug = true generate
	debugbridge : component debug_bridge_jtag
	port map
	(
		clk => slowclk,
		reset_n => reset_n,
		d => debug_fromcpu,
		q => debug_tocpu,
		req => debug_req,
		ack => debug_ack,
		wr => debug_wr
	);
end generate;

gennodebug:
if debug = false generate
	debug_ack <= '0';
end generate;

peripheral_block <= cpu_addr(31)&cpu_addr(10 downto 8);

process(clk,reset_n)
begin
	if reset_n='0' then
		spi_cs<='1';
		spi_active<='0';
		int_enabled<='0';
		kbdrecvreg <='0';
		mouserecvreg <='0';
		sdram_state<=idle;
		ser_rxready<='1';
		ser_rxrecv<='0';
		ser2_rxready<='1';
		ser2_rxrecv<='0';
	elsif rising_edge(clk) then
		mem_busy<='1';
		ser_txgo<='0';
		ser2_txgo<='0';
		int_ack<='0';
		timer_reg_req<='0';
		vga_reg_req<='0';
		audio_reg_req<='0';
		spi_trigger<='0';
		kbdsendtrigger<='0';
		mousesendtrigger<='0';
		flushcaches<='0';
		soft_reset_n<='1';
		
		mem_rd_d<=mem_rd;
		mem_wr_d<=mem_wr;

		-- Write from CPU?
		if mem_wr='1' and mem_wr_d='0' and mem_busy='1' then
			case peripheral_block is

				when X"E" =>	-- VGA controller at 0xFFFFFE00
					vga_reg_rw<='0';
					vga_reg_req<='1';
					mem_busy<='0';
				
				when X"D" => -- Audio controller at 0xFFFFFD00
					audio_reg_req<='1';
					mem_busy<='0'; 	-- Audio controller never blocks the CPU

				when X"C" =>	-- Timer controller at 0xFFFFFC00
					timer_reg_req<='1';
					mem_busy<='0';	-- Audio controller never blocks the CPU

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is

						when X"B0" => -- Interrupts
							int_enabled<=from_cpu(0);
							int_ack<=from_cpu(8);
							mem_busy<='0';
							
						when X"B4" => -- Cache control
							flushcaches<=from_cpu(0);
							mem_busy<='0';

						when X"C0" => -- UART
							ser_txdata<=from_cpu(7 downto 0);
							ser_txgo<='1';
							mem_busy<='0';

						when X"C4" => -- UART2
							ser2_txdata<=from_cpu(7 downto 0);
							ser2_txgo<='1';
							mem_busy<='0';

						when X"D0" => -- SPI CS
							spi_cs<=not from_cpu(0);
							spi_fast<=from_cpu(8);
							mem_busy<='0';

						when X"D4" => -- SPI Data
							spi_wide<='0';
							spi_trigger<='1';
							host_to_spi<=from_cpu(7 downto 0);
							spi_active<='1';
						
						when X"D8" => -- SPI Pump (32-bit read)
							spi_wide<='1';
							spi_trigger<='1';
							host_to_spi<=from_cpu(7 downto 0);
							spi_active<='1';

						-- Write to PS/2 registers
						when X"e0" =>
							kbdsendbyte<=from_cpu(7 downto 0);
							kbdsendtrigger<='1';
							mem_busy<='0';

						when X"e4" =>
							mousesendbyte<=from_cpu(7 downto 0);
							mousesendtrigger<='1';
							mem_busy<='0';

						when others =>
							mem_busy<='0';
							null;
					end case;
				when others =>
					sdram_bytesel<=bytesel_rev;
					sdram_wr<='0';
					sdram_req<='1';
					sdram_write<=from_cpu;
					sdram_state<=read1;	-- read/write logic doesn't need to differ.
			end case;

		elsif mem_rd='1' and mem_rd_d='0' and mem_busy='1' then -- Read from CPU?
			case cpu_addr(31 downto 28) is

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is

						when X"B0" => -- Interrupt
							from_mem<=(others=>'X');
							from_mem(int_max downto 0)<=int_status;
							mem_busy<='0';

						when X"C0" => -- UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser_rxrecv&ser_txready&ser_rxdata;
							ser_rxrecv<='0';	-- Clear rx flag.
							ser_rxready<='1';
							mem_busy<='0';

						when X"C4" => -- UART2
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser2_rxrecv&ser2_txready&ser2_rxdata;
							ser2_rxrecv<='0';	-- Clear rx flag.
							ser2_rxready<='1';
							mem_busy<='0';
							
						when X"C8" => -- Millisecond counter
							from_mem<=std_logic_vector(millisecond_counter);
							mem_busy<='0';

						when X"D0" => -- SPI Status
							from_mem<=(others=>'X');
							from_mem(15)<=spi_busy;
							mem_busy<='0';

						when X"D4" => -- SPI read (blocking)
							spi_active<='1';

						when X"D8" => -- SPI wide read (blocking)
							spi_wide<='1';
							spi_trigger<='1';
							spi_active<='1';
							host_to_spi<=X"FF";

						-- Read from PS/2 regs
						when X"E0" =>
							from_mem<=(others =>'0');
							from_mem(11 downto 0)<=kbdrecvreg & not kbdsendbusy & kbdrecvbyte(10 downto 1);
							kbdrecvreg<='0';
							mem_busy<='0';
							
						when X"E4" =>
							from_mem<=(others =>'0');
							from_mem(11 downto 0)<=mouserecvreg & not mousesendbusy & mouserecvbyte(10 downto 1);
							mouserecvreg<='0';
							mem_busy<='0';

						when others =>
							mem_busy<='0';
					end case;

				when others =>
					sdram_wr<='1';
					sdram_req<='1';
					sdram_state<=read1;
			end case;
		end if;

	-- SDRAM state machine
	
		case sdram_state is
			when read1 => -- read first word from RAM
				if sdram_ack='0' or cache_valid='1' then
					-- Endian mangling for SDRAM
					from_mem(7 downto 0)<=sdram_read(31 downto 24);
					from_mem(15 downto 8)<=sdram_read(23 downto 16);
					from_mem(23 downto 16)<=sdram_read(15 downto 8);
					from_mem(31 downto 24)<=sdram_read(7 downto 0);
					sdram_req<='0';
					sdram_state<=idle;
					mem_busy<='0';
				end if;
			when others =>
				null;

		end case;


		-- SPI cycles

		if spi_active='1' and spi_busy='0' then
			from_mem<=spi_to_host;
			spi_active<='0';
			mem_busy<='0';
		end if;


		-- Set this after the read operation has potentially cleared it.
		if ser_rxint='1' then
			ser_rxrecv<='1';
			ser_rxready<='0';
			if ser_rxdata=X"04" then -- Allow soft-reset on Ctrl-D over serial
				soft_reset_n<='0';
				ser_rxrecv<='0';
				int_enabled<='0';
			end if;
		end if;

		-- Set this after the read operation has potentially cleared it.
		if ser2_rxint='1' then
			ser2_rxrecv<='1';
			ser2_rxready<='0';
		end if;

		-- PS2 interrupt
		ps2_int <= kbdrecv or kbdsenddone
			or mouserecv or mousesenddone;
			-- mouserecv or kbdsenddone or mousesenddone ; -- Momentary high pulses to indicate retrieved data.
		if kbdrecv='1' then
			kbdrecvreg <= '1'; -- remains high until cleared by a read
		end if;
		if mouserecv='1' then
			mouserecvreg <= '1'; -- remains high until cleared by a read
		end if;	

	end if; -- rising-edge(clk)

end process;
	
end architecture;
