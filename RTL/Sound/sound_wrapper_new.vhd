library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;


entity sound_wrapper_new is
	generic (
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"D";
		dmawidth : integer := 16;
		clk_frequency : integer := 1000 -- System clock frequency
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		dma_data : in std_logic_vector(dmawidth-1 downto 0);
		channel0_fromhost : out DMAChannel_FromHost;
		channel0_tohost : in DMAChannel_ToHost;
		channel1_fromhost : out DMAChannel_FromHost;
		channel1_tohost : in DMAChannel_ToHost;
		channel2_fromhost : out DMAChannel_FromHost;
		channel2_tohost : in DMAChannel_ToHost;
		channel3_fromhost : out DMAChannel_FromHost;
		channel3_tohost : in DMAChannel_ToHost;
		
		audio_l : out signed(23 downto 0);
		audio_r : out signed(23 downto 0);
		audio_ints : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of sound_wrapper_new is

	constant clk_hz : integer := clk_frequency*100000;
	constant clkdivide : integer := clk_hz/3546895;
	signal audiotick : std_logic;
	
	-- Select signals for the four channels
	signal sel0 : std_logic;
	signal sel1 : std_logic;
	signal sel2 : std_logic;
	signal sel3 : std_logic;

	-- The output of each channel.  Aud0 and 3 will be summed to make the left channel
	-- while aud1 and 2 will be summed to make the right channel.
	signal aud0 : signed(21 downto 0);
	signal aud1 : signed(21 downto 0);
	signal aud2 : signed(21 downto 0);
	signal aud3 : signed(21 downto 0);

	signal reg_addr : std_logic_vector(7 downto 0);
	signal req : std_logic_vector(3 downto 0);

begin

	-- Create ~3.5Mhz tick signal
	-- FIXME - will need to make this more accurate in time.

	myclkdiv: entity work.risingedge_divider
		generic map (
			divisor => clkdivide,
			bits => 6
		)
	port map (
			clk => clk,
			reset_n => reset, -- Active low
			tick => audiotick
		);

	-- Handle CPU access to hardware registers

	requestlogic : block
		signal sel : std_logic;
		signal req_d : std_logic;
		signal cpu_req : std_logic;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk) begin
			if rising_edge(clk) then
				req_d <= request.req;
				cpu_req<=sel and request.req and request.wr and not req_d;
			end if;
		end process;
		
		process(clk) begin
			if rising_edge(clk) then
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');	-- Maybe return a version number?
			end if;
		end process;
	
		sel0<='1' when request.addr(6 downto 5)="00" else '0';
		sel1<='1' when request.addr(6 downto 5)="01" else '0';
		sel2<='1' when request.addr(6 downto 5)="10" else '0';
		sel3<='1' when request.addr(6 downto 5)="11" else '0';
		audio_l(0)<='0';
		audio_r(0)<='0';
		audio_l(23 downto 1)<=(aud0(21)&aud0)+(aud3(21)&aud3);
		audio_r(23 downto 1)<=(aud1(21)&aud1)+(aud2(21)&aud2);

		reg_addr <= "000" & request.addr(4 downto 0);
		req(0) <= cpu_req and sel0;
		req(1) <= cpu_req and sel1;
		req(2) <= cpu_req and sel2;
		req(3) <= cpu_req and sel3;

	end block;

	channel0 : entity work.sound_controller
		generic map (
			dmawidth => dmawidth
		)
		port map (
			clk => clk,
			reset => reset,
			audiotick => audiotick,

			reg_addr_in => reg_addr,
			reg_data_in => request.d,
			reg_data_out => open,
			reg_rw => '0',
			reg_req => req(0),

			dma_data => dma_data,
			channel_fromhost => channel0_fromhost,
			channel_tohost => channel0_tohost,
			
			audio_out => aud0,
			audio_int => audio_ints(0)
		);

	channel1 : entity work.sound_controller
		generic map (
			dmawidth => dmawidth
		)
		port map (
			clk => clk,
			reset => reset,
			audiotick => audiotick,

			reg_addr_in => reg_addr,
			reg_data_in => request.d,
			reg_data_out => open,
			reg_rw => '0',
			reg_req => req(1),

			dma_data => dma_data,
			channel_fromhost => channel1_fromhost,
			channel_tohost => channel1_tohost,
			
			audio_out => aud1,
			audio_int => audio_ints(1)
		);

	channel2 : entity work.sound_controller
		generic map (
			dmawidth => dmawidth
		)
		port map (
			clk => clk,
			reset => reset,
			audiotick => audiotick,

			reg_addr_in => reg_addr,
			reg_data_in => request.d,
			reg_data_out => open,
			reg_rw => '0',
			reg_req => req(2),

			dma_data => dma_data,
			channel_fromhost => channel2_fromhost,
			channel_tohost => channel2_tohost,
			
			audio_out => aud2,
			audio_int => audio_ints(2)
		);

	channel3 : entity work.sound_controller
		generic map (
			dmawidth => dmawidth
		)
		port map (
			clk => clk,
			reset => reset,
			audiotick => audiotick,

			reg_addr_in => reg_addr,
			reg_data_in => request.d,
			reg_data_out => open,
			reg_rw => '0',
			reg_req => req(3),

			dma_data => dma_data,
			channel_fromhost => channel3_fromhost,
			channel_tohost => channel3_tohost,
			
			audio_out => aud3,
			audio_int => audio_ints(3)
		);
	
end architecture;
