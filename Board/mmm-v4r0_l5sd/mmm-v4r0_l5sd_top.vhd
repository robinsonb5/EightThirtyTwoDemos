library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Toplevel_Config.all;

entity mmm_v4r0_l5sd_top is
port(
--	clk_100mhz_n : in std_logic;
	clk_100mhz_p : in std_logic;

	UART_U1_TXD : out std_logic;
	UART_U1_RXD : in std_logic;
	UART_U2_TXD : out std_logic;
	UART_U2_RXD : in std_logic;
	UART_D1_TXD : out std_logic;
	UART_D1_RXD : in std_logic;
	UART_D2_TXD : out std_logic;
	UART_D2_RXD : in std_logic;

	led1 : out std_logic;
	led2 : out std_logic;

	dr_clk : out std_logic;
	dr_cs_n : out std_logic;
	dr_a : out std_logic_vector(12 downto 0);
	dr_d : inout std_logic_vector(15 downto 0);
	dr_we_n : out std_logic;
	dr_ras_n : out std_logic;
	dr_cas_n : out std_logic;
	dr_cke : out std_logic;
	dr_ba : out std_logic_vector(1 downto 0);
	dr_dqm : out std_logic_vector(1 downto 0);
	
	sd_m_cdet : out std_logic;
	sd_m_clk : out std_logic; -- SPI clk
	sd_m_cmd : out std_logic; -- SPI MOSI
	sd_m_d0 : in std_logic; -- SPI MISO
	sd_m_d1 : out std_logic;
	sd_m_d2 : out std_logic;
	sd_m_d3 : out std_logic; -- SPI CS
	
	AUDIO_L : out std_logic;
	AUDIO_R : out std_logic

);
end entity;

architecture rtl of mmm_v4r0_l5sd_top is

	-- Internal signals

	component TRELLIS_IO
	generic(
		DIR : string := "BIDIR"
	);
	port(
		B : inout std_logic;
		I : in std_logic;
		T : in std_logic;
		O : out std_logic
	);
	end component;

	signal ps2k_dat_in : std_logic;
	signal ps2k_dat_out : std_logic;
	signal ps2k_clk_in : std_logic;
	signal ps2k_clk_out : std_logic;
	signal ps2m_dat_in : std_logic;
	signal ps2m_dat_out : std_logic;
	signal ps2m_clk_in : std_logic;
	signal ps2m_clk_out : std_logic;

	signal sdcard_miso : std_logic;
	signal sdcard_mosi : std_logic;
	signal sdcard_cs : std_logic;
	signal sdcard_clk : std_logic;

	signal pcm_l : signed(15 downto 0);
	signal pcm_r : signed(15 downto 0);

	signal clk_sdram : std_logic;
	signal clk_sys : std_logic;
	signal clk_slow : std_logic;
	signal clk_none : std_logic;
	signal pll_locked : std_logic;

	signal vga_r : unsigned(3 downto 0);
	signal vga_g : unsigned(3 downto 0);
	signal vga_b : unsigned(3 downto 0);
	signal vga_hs : std_logic;
	signal vga_vs : std_logic;

	signal vga_r_i : unsigned(7 downto 0);
	signal vga_g_i : unsigned(7 downto 0);
	signal vga_b_i : unsigned(7 downto 0);
	signal vga_window : std_logic;

	signal dr_drive_dq : std_logic;
	signal dr_dq_in : std_logic_vector(15 downto 0);
	signal dr_dq_out : std_logic_vector(15 downto 0);

	signal reset_n : std_logic;

	signal rxd : std_logic;
	signal txd : std_logic;

begin

	led1<='0';
	led2<='0';

	UART_U1_TXD <= txd;
	UART_U2_TXD <= txd;
	UART_D1_TXD <= txd;
	UART_D2_TXD <= txd;
	rxd <= UART_U1_RXD;

	dr_d <= dr_dq_out when dr_drive_dq='1' else (others => 'Z');
	dr_dq_in <= dr_d;

	clocks : entity work.pll
	port map (
		clk_i => clk_100mhz_p,
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_none,
		reset => '0',
		locked => pll_locked
	);

	dr_clk <= clk_sdram;

	reset_n <= pll_locked;

	vt : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => 1000
	)
	port map(
		clk => clk_sys,
		slowclk => clk_slow,
		reset_in => reset_n,
		txd => txd,
		rxd => rxd,

		unsigned(vga_red) => vga_r_i,
		unsigned(vga_green) => vga_g_i,
		unsigned(vga_blue) => vga_b_i,
		vga_hsync => vga_hs,
		vga_vsync => vga_vs,
		vga_window => vga_window,

		spi_miso => sdcard_miso,
		spi_mosi => sdcard_mosi,
		spi_cs => sdcard_cs,
		spi_clk => sdcard_clk,
		
		ps2k_clk_in => ps2k_clk_in,
		ps2k_clk_out => ps2k_clk_out,
		ps2k_dat_in => ps2k_dat_in,
		ps2k_dat_out => ps2k_dat_out,
		ps2m_clk_in => ps2m_clk_in,
		ps2m_clk_out => ps2m_clk_out,
		ps2m_dat_in => ps2m_dat_in,
		ps2m_dat_out => ps2m_dat_out,

		-- SDRAM
		sdr_cs => dr_cs_n,
		sdr_drive_data => dr_drive_dq,
		sdr_data_in => dr_dq_in,
		sdr_data_out => dr_dq_out,
		sdr_addr => dr_a,
		sdr_we => dr_we_n,
		sdr_cas => dr_cas_n,
		sdr_ras => dr_ras_n,
		sdr_dqm => dr_dqm,
		sdr_ba => dr_ba,
		sdr_cke => dr_cke,
		
		signed(audio_l) => pcm_l,
		signed(audio_r) => pcm_r
--		trace_out => trace
	);

	-- PS/2 tristating
	-- Leave SP/2 unconnected for now...

	-- Instantiate IOs explicitly to avoid potential issues with tristate signals.
--	ps2kd : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KDAT+ps2_pmod_offset), I => '0',	T => ps2k_dat_out, O => ps2k_dat_in );
--	ps2kc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KCLK+ps2_pmod_offset), I => '0',	T => ps2k_clk_out, O => ps2k_clk_in );
--	ps2md : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MDAT+ps2_pmod_offset), I => '0',	T => ps2m_dat_out, O => ps2m_dat_in );
--	ps2mc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MCLK+ps2_pmod_offset), I => '0',	T => ps2m_clk_out, O => ps2m_clk_in );

	-- Sigma Delta audio
	genaudio: if Toplevel_UseAudio=true generate
		COMPONENT hybrid_pwm_sd_2ndorder
		PORT
		(
			clk	:	IN STD_LOGIC;
			reset_n : in std_logic;
	--		terminate : in std_logic;
			d_l	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			q_l	:	OUT STD_LOGIC;
			d_r	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			q_r	:	OUT STD_LOGIC
		);
		END COMPONENT;
		signal pcm_l_msb : std_logic;
		signal pcm_r_msb : std_logic;
	begin
		pcm_l_msb <= not pcm_l(15);
		pcm_r_msb <= not pcm_r(15);

		audio_sd: component hybrid_pwm_sd_2ndorder
			port map
			(
				clk => clk_slow,
				reset_n => '1',
				d_l(15) => pcm_l_msb,
				d_l(14 downto 0) => std_logic_vector(pcm_l(14 downto 0)),
				q_l => AUDIO_L,
				d_r(15) => pcm_r_msb,
				d_r(14 downto 0) => std_logic_vector(pcm_r(14 downto 0)),
				q_r => AUDIO_R
			);

	end generate;	

	sd_m_d3 <= sdcard_cs;
	sd_m_cmd <= sdcard_mosi;
	sd_m_clk <= sdcard_clk;
	sdcard_miso <= sd_m_d0;

end architecture;

