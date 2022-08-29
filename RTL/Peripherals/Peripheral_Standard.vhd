library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;

entity Peripheral_Standard is
	generic (
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"F";		
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10
		external_interrupts : integer := 3
	);
	port (
		clk      : in std_logic;
		reset_n  : in std_logic;
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		-- CPU / system signals		
		soft_reset_n : out std_logic;
		flush_caches : out std_logic;

		-- Interupt signals
		interrupt_triggers : in std_logic_vector(external_interrupts-1 downto 0);
		interrupt : out std_logic;

		-- SPI signals
		spi_miso  : in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
		spi_mosi  : out std_logic;
		spi_clk   : out std_logic;
		spi_cs    : out std_logic;
		
		-- PS/2 signals
		ps2k_clk_in  : in std_logic := '1';
		ps2k_dat_in  : in std_logic := '1';
		ps2k_clk_out : out std_logic;
		ps2k_dat_out : out std_logic;
		ps2m_clk_in  : in std_logic := '1';
		ps2m_dat_in  : in std_logic := '1';
		ps2m_clk_out : out std_logic;
		ps2m_dat_out : out std_logic;

		-- UARTs
		rxd          : in std_logic := '1';
		txd          : out std_logic;
		rxd2         : in std_logic := '1';
		txd2         : out std_logic
	);
end entity;

architecture rtl of Peripheral_Standard is

	constant internal_interrupts : integer := 2;
	constant interrupt_max : integer := internal_interrupts + external_interrupts-1;
	constant sysclk_hz : integer := sysclk_frequency*1000;
	constant uart_divisor : integer := sysclk_hz/1152;
	constant uart2_divisor : integer := sysclk_hz/576;

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

	signal int_status : std_logic_vector(interrupt_max downto 0);
	signal int_ack : std_logic;
	signal int_enabled : std_logic :='0'; -- Disabled by default

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

	signal reset : std_logic;
	signal busy : std_logic;
	signal req_d : std_logic;
	signal mem_rd : std_logic;
	signal mem_wr : std_logic;

begin

	reset<=not reset_n;

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


	-- Interrupt controller
	-- Bit 0 is serial interrupt
	-- Bit 1 is ps/2 interrupt
	-- Bits 2 onwards are external interrupts.

	interrupt_logic : block
		signal triggers : std_logic_vector(interrupt_max downto 0);
		signal serial_int : std_logic;
		signal int_req : std_logic;
	begin

		serial_int <= ser_rxint or ser2_rxint;
		triggers(0)<=serial_int;
		triggers(1)<=ps2_int;
		triggerloop: for I in 0 to external_interrupts-1 generate
			triggers(I+internal_interrupts)<=interrupt_triggers(I);
		end generate;

		intcontroller: entity work.interrupt_controller
		generic map (
			max_int => interrupt_max
		)
		port map (
			clk => clk,
			reset_n => reset_n,
			trigger => triggers,
			ack => int_ack,
			int => int_req,
			status => int_status
		);

		interrupt <= int_req and int_enabled;

	end block;


	-- Derive read and write signals from incoming address, wr and req signals.

	requestlogic : block
		signal sel : std_logic;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk) begin
			if rising_edge(clk) then
				req_d <= request.req;
				mem_wr<='0';
				mem_rd<='0';
				if sel='1' then
					if request.req='1' and req_d='0' then
						mem_wr<=request.wr;
						mem_rd<=not request.wr;
					end if;
				end if;
			end if;
		end process;
		
		process(clk) begin
			if rising_edge(clk) then
				response.ack<=sel and not busy;
			end if;
		end process;
	end block;


	process(clk,reset_n)
	begin
		if reset_n='0' then
			spi_cs<='1';
			spi_active<='0';
			int_enabled<='0';
			kbdrecvreg <='0';
			mouserecvreg <='0';
			ser_rxready<='1';
			ser_rxrecv<='0';
			ser2_rxready<='1';
			ser2_rxrecv<='0';
			soft_reset_n<='1';
		elsif rising_edge(clk) then
			busy<='1';
			ser_txgo<='0';
			ser2_txgo<='0';
			int_ack<='0';
			spi_trigger<='0';
			kbdsendtrigger<='0';
			mousesendtrigger<='0';
			flush_caches<='0';
			soft_reset_n<='1';

			-- Write from CPU?
			if mem_wr='1' and busy='1' then
				case request.addr(7 downto 0) is

					when X"B0" => -- Interrupts
						int_enabled<=request.d(0);
						int_ack<=request.d(8);
						busy<='0';
						
					when X"B4" => -- Cache control
						flush_caches<=request.d(0);
						busy<='0';

					when X"C0" => -- UART
						ser_txdata<=request.d(7 downto 0);
						ser_txgo<='1';
						busy<='0';

					when X"C4" => -- UART2
						ser2_txdata<=request.d(7 downto 0);
						ser2_txgo<='1';
						busy<='0';

					when X"D0" => -- SPI CS
						spi_cs<=not request.d(0);
						spi_fast<=request.d(8);
						busy<='0';

					when X"D4" => -- SPI Data
						spi_wide<='0';
						spi_trigger<='1';
						host_to_spi<=request.d(7 downto 0);
						spi_active<='1';
					
					when X"D8" => -- SPI Pump (32-bit read)
						spi_wide<='1';
						spi_trigger<='1';
						host_to_spi<=request.d(7 downto 0);
						spi_active<='1';

					-- Write to PS/2 registers
					when X"e0" =>
						kbdsendbyte<=request.d(7 downto 0);
						kbdsendtrigger<='1';
						busy<='0';

					when X"e4" =>
						mousesendbyte<=request.d(7 downto 0);
						mousesendtrigger<='1';
						busy<='0';

					when others =>
						busy<='0';
						null;
				end case;

			elsif mem_rd='1' and busy='1' then -- Read from CPU?
				case request.addr(7 downto 0) is
				
					when X"B0" => -- Interrupt
						response.q<=(others=>'X');
						response.q(interrupt_max downto 0)<=int_status;
						busy<='0';

					when X"C0" => -- UART
						response.q<=(others=>'X');
						response.q(9 downto 0)<=ser_rxrecv&ser_txready&ser_rxdata;
						ser_rxrecv<='0';	-- Clear rx flag.
						ser_rxready<='1';
						busy<='0';

					when X"C4" => -- UART2
						response.q<=(others=>'X');
						response.q(9 downto 0)<=ser2_rxrecv&ser2_txready&ser2_rxdata;
						ser2_rxrecv<='0';	-- Clear rx flag.
						ser2_rxready<='1';
						busy<='0';
						
					when X"C8" => -- Millisecond counter
						response.q<=std_logic_vector(millisecond_counter);
						busy<='0';

					when X"D0" => -- SPI Status
						response.q<=(others=>'X');
						response.q(15)<=spi_busy;
						busy<='0';

					when X"D4" => -- SPI read (blocking)
						spi_active<='1';

					when X"D8" => -- SPI wide read (blocking)
						spi_wide<='1';
						spi_trigger<='1';
						spi_active<='1';
						host_to_spi<=X"FF";

					-- Read from PS/2 regs
					when X"E0" =>
						response.q<=(others =>'0');
						response.q(11 downto 0)<=kbdrecvreg & not kbdsendbusy & kbdrecvbyte(10 downto 1);
						kbdrecvreg<='0';
						busy<='0';
						
					when X"E4" =>
						response.q<=(others =>'0');
						response.q(11 downto 0)<=mouserecvreg & not mousesendbusy & mouserecvbyte(10 downto 1);
						mouserecvreg<='0';
						busy<='0';

					when others =>
						busy<='0';

				end case;
			end if;

			-- SPI cycles

			if spi_active='1' and spi_busy='0' then
				response.q<=spi_to_host;
				spi_active<='0';
				busy<='0';
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

