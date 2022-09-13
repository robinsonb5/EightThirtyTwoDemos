library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.sdram_controller_pkg.all;
use work.sound_wrapper_pkg.all;

entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10
		jtag_uart : boolean := false;
		debug : boolean := false
	);
	port (
		clk 		: in std_logic;
		slowclk		: in std_logic;
		videoclk	: in std_logic;
		reset_in 	: in std_logic;

		-- VGA
		vga_red 	: out unsigned(7 downto 0);
		vga_green 	: out unsigned(7 downto 0);
		vga_blue 	: out unsigned(7 downto 0);
		vga_hsync 	: out std_logic;
		vga_vsync 	: buffer std_logic;
		vga_window	: out std_logic;
		vga_pixel	: out std_logic;

		-- SDRAM
		sdr_drive_data  : out std_logic;
		sdr_data_in		: in std_logic_vector(sdram_width-1 downto 0) := (others => '0');
		sdr_data_out	: inout std_logic_vector(sdram_width-1 downto 0);
		sdr_addr		: out std_logic_vector(sdram_rows-1 downto 0);
		sdr_dqm 		: out std_logic_vector(sdram_dqmwidth-1 downto 0);
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

	constant Peripheral_Blocks : integer := 4;

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
	constant maxAddrBit : integer := 31;

	signal reset_n : std_logic := '0';
	signal reset : std_logic := '0';
	signal reset_counter : unsigned(15 downto 0) := X"FFFF";

	-- Interrupt signals

	constant int_max : integer := 2;
	signal int_triggers : std_logic_vector(int_max downto 0);

	-- Timer register block signals

	signal timer_reg_req : std_logic;
	signal timer_tick : std_logic;


	-- Plumbing between DMA controllers and SDRAM

	signal video_to_sdram : sdram_port_request;
	signal sdram_to_video : sdram_port_response;

	signal dma_to_sdram : sdram_port_request;
	signal sdram_to_dma : sdram_port_response;

	signal dma_data : std_logic_vector(31 downto 0);

	signal dmachannel_requests : DMAChannels_FromHost;
	signal dmachannel_responses : DMAChannels_ToHost;

	constant dmachannel_sprite : integer := 0;
	constant dmachannel_audio_low : integer := 1;

	-- Audio channel plumbing

	signal audio_reg_req : std_logic;
	signal audio_ints : std_logic_vector(3 downto 0);
	signal audio_int : std_logic;
	
	signal audio_l_i : signed(23 downto 0);
	signal audio_r_i : signed(23 downto 0);

	-- VGA register block signals

	signal vblank_int : std_logic;
	signal vga_vsync_i : std_logic;


	-- SDRAM signals
	signal sdr_ready : std_logic;

	-- CPU signals
	signal cpu_reset : std_logic;
	signal cpu_int : std_logic;
	signal soft_reset_n : std_logic;
	
	signal mem_peripherals : std_logic;
	signal peripherals_ack : std_logic;
	signal from_peripherals : std_logic_vector(31 downto 0);

	signal mem_ram : std_logic;
	signal ram_ack : std_logic;
	signal from_ram : std_logic_vector(31 downto 0);

	signal mem_rom : std_logic;
	signal rom_ack : std_logic;
	signal from_rom : std_logic_vector(31 downto 0);

	signal cpu_addr : std_logic_vector(31 downto 0);
	signal to_cpu : std_logic_vector(31 downto 0);
	signal from_cpu : std_logic_vector(31 downto 0);
	signal cpu_req : std_logic; 
	signal cpu_ack : std_logic; 
	signal cpu_wr : std_logic; 
	signal cpu_bytesel : std_logic_vector(3 downto 0);
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


	-- Main CPU

	mem_peripherals <= '1' when cpu_addr(31)='1' else '0';
	mem_rom <='1' when cpu_addr(31 downto 26)=X"0"&"00" else '0';
	mem_ram <='1' when mem_peripherals='0' and mem_rom='0' else '0';
		
	process(clk)
	begin
		if rising_edge(clk) then

			if mem_rom='1' then
				to_cpu<=from_rom;
			elsif mem_peripherals='1' then
				to_cpu<=from_peripherals;
			else
				to_cpu<=from_ram;
			end if;

			if (ram_ack='1' or rom_ack='1' or peripherals_ack='1') and cpu_ack='0' then
				cpu_ack<='1';
			else
				cpu_ack<='0';
			end if;
	
		end if;	
	end process;
	
	cpu_reset<=reset_n and soft_reset_n;
	
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


	peripheralblock : block
		signal peripheral_req : SoC_Peripheral_Request;
		type responses_t is array (0 to Peripheral_Blocks-1) of SoC_Peripheral_Response;
		signal peripheral_responses : responses_t;
	begin

		-- Interrupts

		audio_int <= '0' when audio_ints="0000" else '1';
		int_triggers<=(0=>timer_tick, 1=>vblank_int, 2=>audio_int, others => '0');

		-- Standard peripheral block

		standardperipherals : entity work.Peripheral_Standard
			generic map (
				BlockAddress => X"F",
				sysclk_frequency => sysclk_frequency,
				external_interrupts => 3
			)
			port map (
				clk => clk,
				reset_n => cpu_reset,
				request => peripheral_req,
				response => peripheral_responses(0),

				-- CPU / system signals		
				soft_reset_n => soft_reset_n,
				flush_caches => flushcaches,

				-- Interupt signals
				interrupt_triggers => int_triggers,
				interrupt => cpu_int,

				-- SPI signals
				spi_miso => spi_miso,
				spi_mosi => spi_mosi,
				spi_clk => spi_clk,
				spi_cs => spi_cs,
				
				-- PS/2 signals
				ps2k_clk_in => ps2k_clk_in,
				ps2k_dat_in => ps2k_dat_in,
				ps2k_clk_out => ps2k_clk_out,
				ps2k_dat_out => ps2k_dat_out,
				ps2m_clk_in => ps2m_clk_in,
				ps2m_dat_in => ps2m_dat_in,
				ps2m_clk_out => ps2m_clk_out,
				ps2m_dat_out => ps2m_dat_out,

				-- UARTs
				rxd => rxd,
				txd => txd,
				rxd2 => rxd2,
				txd2 => txd2
			);

		-- Video
		
		video : entity work.vga_controller_new
			generic map (
				BlockAddress => X"E",
				dmawidth => 32
			)
			port map (
			clk_sys => clk,
			reset_n => reset_in,

			request => peripheral_req,
			response => peripheral_responses(1),

			-- Sprite
			sprite0_sys => dmachannel_requests(dmachannel_sprite),
			sprite0_status => dmachannel_responses(dmachannel_sprite),
			spritedata => dma_data,

			-- Video
			
			clk_video => videoclk,
			
			to_sdram => video_to_sdram,
			from_sdram => sdram_to_video,

			vblank_int => vblank_int,
			hsync => vga_hsync,
			vsync => vga_vsync_i,
			red => vga_red,
			green => vga_green,
			blue => vga_blue,
			vga_window => vga_window,
			vga_pixel => vga_pixel
		);

		vga_vsync<=vga_vsync_i;


		-- Audio controller
			
		audio : entity work.sound_wrapper_new
			generic map(
				BlockAddress => X"D",
				dmawidth => 32,
				clk_frequency => sysclk_frequency -- Prescale incoming clock
			)
		port map (
			clk => clk,
			reset => cpu_reset,

			request => peripheral_req,
			response => peripheral_responses(2),

			dma_data => dma_data,
			dma_requests(0) => dmachannel_requests(dmachannel_audio_low),
			dma_requests(1) => dmachannel_requests(dmachannel_audio_low+1),
			dma_requests(2) => dmachannel_requests(dmachannel_audio_low+2),
			dma_requests(3) => dmachannel_requests(dmachannel_audio_low+3),
			dma_responses(0) => dmachannel_responses(dmachannel_audio_low),
			dma_responses(1) => dmachannel_responses(dmachannel_audio_low+1),
			dma_responses(2) => dmachannel_responses(dmachannel_audio_low+2),
			dma_responses(3) => dmachannel_responses(dmachannel_audio_low+3),

			audio_l => audio_l_i,
			audio_r => audio_r_i,
			audio_ints => audio_ints
		);

		audio_l<=audio_l_i(23 downto 8);
		audio_r<=audio_r_i(23 downto 8);

		-- Timer
			
		timer : entity work.timer_controller_new
		generic map(
			BlockAddress => X"C",
			prescale => sysclk_frequency, -- Prescale incoming clock
			timers => 0
		)
		port map (
			clk => clk,
			reset => reset_n,

			request => peripheral_req,
			response => peripheral_responses(3),

			ticks(0) => timer_tick -- Tick signal is used to trigger an interrupt
		);

		
		-- Peripherals

		process(clk,reset_n) begin
			if rising_edge(clk) then
				
				peripheral_req.addr<=cpu_addr;
				peripheral_req.wr<=cpu_wr;
				peripheral_req.d<=from_cpu;
				peripheral_req.req<=mem_peripherals and cpu_req;

				peripherals_ack<='0';
				for I in 0 to Peripheral_Blocks-1 loop
					if peripheral_responses(I).ack='1' then
						peripherals_ack<='1';
						from_peripherals<=peripheral_responses(i).q;
					end if;
				end loop;
			end if;
		end process;
	end block;


	-- ROM

	romblock : block
		signal rom_wr : std_logic;
	begin
		process(clk) begin
			if rising_edge(clk) then
				if mem_rom='1' then
					rom_wr<=(cpu_wr and cpu_req);
				else
					rom_wr<='0';
				end if;
				rom_ack<=cpu_req and mem_rom;
			end if;
		end process;

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
		
	end block;

	
	-- SDRAM block and state machine
	sdramlogic : block
		type sdram_states is (idle, waiting, pause);
		signal sdram_state : sdram_states;

		signal cpu_to_sdram : sdram_port_request;
		signal cpu_to_cache : sdram_port_request;
		signal cache_to_sdram : sdram_port_request;

		signal sdram_to_cpu : sdram_port_response;
		signal cache_to_cpu : sdram_port_response;
		signal sdram_to_cache : sdram_port_response;
		
	begin	
	
		-- SDRAM

		mysdram : entity work.sdram_controller
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

				video_req => video_to_sdram,
				video_ack => sdram_to_video,

				cache_req => cache_to_sdram,
				cache_ack => sdram_to_cache,

				cpu_req => cpu_to_sdram,
				cpu_ack => sdram_to_cpu,

				dma_req => dma_to_sdram,
				dma_ack => sdram_to_dma
			);
	
		-- Combinational to take effect one cycle sooner.
		ram_ack <= '1' when sdram_state=waiting and (sdram_to_cpu.ack='1' or cache_to_cpu.ack='1') else '0';

		-- Endian byte mangling
		from_ram(7 downto 0)<=cache_to_cpu.q(31 downto 24);
		from_ram(15 downto 8)<=cache_to_cpu.q(23 downto 16);
		from_ram(23 downto 16)<=cache_to_cpu.q(15 downto 8);
		from_ram(31 downto 24)<=cache_to_cpu.q(7 downto 0);

		cpu_to_sdram.addr<=cpu_addr;
		cpu_to_cache.addr<=cpu_addr;

		process(clk,reset_n) begin
			if reset_n='0' then
				sdram_state<=idle;
			elsif rising_edge(clk) then

				-- Endian byte mangling
				cpu_to_sdram.bytesel <= cpu_bytesel(0)&cpu_bytesel(1)&cpu_bytesel(2)&cpu_bytesel(3);
				cpu_to_sdram.d(31 downto 24) <= from_cpu(7 downto 0);
				cpu_to_sdram.d(23 downto 16) <= from_cpu(15 downto 8);
				cpu_to_sdram.d(15 downto 8) <= from_cpu(23 downto 16);
				cpu_to_sdram.d(7 downto 0) <= from_cpu(31 downto 24);

				case sdram_state is
					when idle =>
						if cpu_req='1' and mem_ram='1' and sdram_to_cpu.busy='0' and cache_to_cpu.busy='0' then
							cpu_to_sdram.wr<=cpu_wr;
							cpu_to_sdram.req<=cpu_wr;
							cpu_to_cache.wr<=cpu_wr;
							cpu_to_cache.req<='1'; -- The cache needs to know about writes, too.
							sdram_state<=waiting;
						end if;

					when waiting =>	
						if sdram_to_cpu.ack='1' or cache_to_cpu.ack='1' then
							cpu_to_sdram.wr<='0';
							cpu_to_sdram.req<='0';
							cpu_to_cache.wr<='0';
							cpu_to_cache.req<='0';
							sdram_state<=pause;
						end if;

					when pause =>
						sdram_state<=idle;

					when others =>
						null;
				end case;

			end if; -- rising-edge(clk)

		end process;

		cpucache : entity work.FourWayCache
			generic map
			(
				cachemsb => 11,
				burstlog2 => 1+sdram_width/16 -- Correct only for 16- or 32-bit wide RAM
			)
			PORT map
			(
				clk => clk,
				reset => reset_n,
				flush => flushcaches,
				to_cpu => cache_to_cpu,
				from_cpu => cpu_to_cache,
				to_sdram => cache_to_sdram,
				from_sdram => sdram_to_cache
			);

	end block;


	-- DMA controller

	mydmacache : entity work.DMACache
		port map(
			clk => clk,
			reset_n => cpu_reset,

			channels_from_host => dmachannel_requests,
			channels_to_host => dmachannel_responses,

			data_out => dma_data,

			-- SDRAM interface
			to_sdram => dma_to_sdram,
			from_sdram => sdram_to_dma
		);

end architecture;

