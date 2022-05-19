library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Toplevel_Config.all;

entity ulx3s_85f_top is
port(
	clk_25mhz : in std_logic; -- 25MHz

	ftdi_rxd : out std_logic;
	ftdi_txd : in std_logic;

	led : out std_logic_vector(7 downto 0);
	btn : in std_logic_vector(6 downto 0);

	sdram_clk : out std_logic;
	sdram_csn : out std_logic;
	sdram_a : out std_logic_vector(12 downto 0);
	sdram_d : inout std_logic_vector(15 downto 0);
	sdram_wen : out std_logic;
	sdram_rasn : out std_logic;
	sdram_casn : out std_logic;
	sdram_cke : out std_logic;
	sdram_ba : out std_logic_vector(1 downto 0);
	sdram_dqm : out std_logic_vector(1 downto 0);
	
	sd_clk : out std_logic;
	sd_cmd : out std_logic;
	sd_d3 : out std_logic;
	sd_d0 : in std_logic;

	audio_l : inout std_logic_vector(3 downto 0);
	audio_r : inout std_logic_vector(3 downto 0);

	gpdi_dp : out std_logic_vector(3 downto 0)	-- True differential output for digital video.
--	gpdi_dn : out std_logic_vector(3 downto 0);
);
end entity;

architecture rtl of ulx3s_85f_top is

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


-- Sigma Delta audio
	COMPONENT hybrid_pwm_sd
	PORT
	(
		clk	:	IN STD_LOGIC;
--		reset_n : in std_logic;
		terminate : in std_logic := '0';
		d_l	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_l	:	OUT STD_LOGIC;
		d_r	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		q_r	:	OUT STD_LOGIC
	);
	END COMPONENT;

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
	signal clk_tmds : std_logic;
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
	signal vga_pixel : std_logic;

	signal sdram_drive_dq : std_logic;
	signal sdram_dq_in : std_logic_vector(15 downto 0);
	signal sdram_dq_out : std_logic_vector(15 downto 0);

	signal trace : std_logic_vector(63 downto 0);
	signal capreset : std_logic;
	signal reset_n : std_logic;

begin

	sdram_d <= sdram_dq_out when sdram_drive_dq='1' else (others => 'Z');
	sdram_dq_in <= sdram_d;

	clk : entity work.pll
	generic map (
		sdram_phase => 180
	)
	port map (
		clk_i => clk_25mhz,
		reset    => '0',
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_tmds,
		locked   => pll_locked
	);

	sdram_clk <= clk_sdram;

	reset_n <= pll_locked and btn(0);

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
		txd => ftdi_rxd,
		rxd => ftdi_txd,

		unsigned(vga_red) => vga_r_i,
		unsigned(vga_green) => vga_g_i,
		unsigned(vga_blue) => vga_b_i,
		vga_hsync => vga_hs,
		vga_vsync => vga_vs,
		vga_window => vga_window,
		vga_pixel => vga_pixel,

		spi_miso => sd_d0,
		spi_mosi => sd_cmd,
		spi_cs => sd_d3,
		spi_clk => sd_clk,
		
		ps2k_clk_in => ps2k_clk_in,
		ps2k_clk_out => ps2k_clk_out,
		ps2k_dat_in => ps2k_dat_in,
		ps2k_dat_out => ps2k_dat_out,
		ps2m_clk_in => ps2m_clk_in,
		ps2m_clk_out => ps2m_clk_out,
		ps2m_dat_in => ps2m_dat_in,
		ps2m_dat_out => ps2m_dat_out,

		-- SDRAM
		sdr_cs => sdram_csn,
		sdr_drive_data => sdram_drive_dq,
		sdr_data_in => sdram_dq_in,
		sdr_data_out => sdram_dq_out,
		sdr_addr => sdram_a,
		sdr_we => sdram_wen,
		sdr_cas => sdram_casn,
		sdr_ras => sdram_rasn,
		sdr_dqm => sdram_dqm,
		sdr_ba => sdram_ba,
		sdr_cke => sdram_cke,
		
		signed(audio_l) => pcm_l,
		signed(audio_r) => pcm_r
--		trace_out => trace
	);


	-- Instantiate DVI out:
	genvideo: if Toplevel_UseVGA=true generate
		constant useddr : integer := 1;
		
		component dvi
		generic ( DDR_ENABLED : integer := useddr );
		port (
			pclk : in std_logic;
			tmds_clk : in std_logic; -- 10 times faster of pclk

			in_vga_red : in unsigned(7 downto 0);
			in_vga_green : in unsigned(7 downto 0);
			in_vga_blue : in unsigned(7 downto 0);

			in_vga_vsync : in std_logic;
			in_vga_hsync : in std_logic;
			in_vga_pixel : in std_logic;
			in_vga_window : in std_logic;

			out_tmds_red : out std_logic_vector(useddr downto 0);
			out_tmds_green : out std_logic_vector(useddr downto 0);
			out_tmds_blue : out std_logic_vector(useddr downto 0);
			out_tmds_clk : out std_logic_vector(useddr downto 0);
			out_tmds_red_n : out std_logic_vector(useddr downto 0);
			out_tmds_green_n : out std_logic_vector(useddr downto 0);
			out_tmds_blue_n : out std_logic_vector(useddr downto 0);
			out_tmds_clk_n : out std_logic_vector(useddr downto 0)
		); end component;
		
		component ODDRX1F
		port (
			D0 : in std_logic;
			D1 : in std_logic;
			Q : out std_logic;
			SCLK : in std_logic;
			RST : in std_logic
		); end component;

		signal dvi_r : std_logic_vector(useddr downto 0);
		signal dvi_g : std_logic_vector(useddr downto 0);
		signal dvi_b : std_logic_vector(useddr downto 0);
		signal dvi_clk : std_logic_vector(useddr downto 0);
		signal dvi_r_n : std_logic_vector(useddr downto 0);
		signal dvi_g_n : std_logic_vector(useddr downto 0);
		signal dvi_b_n : std_logic_vector(useddr downto 0);
		signal dvi_clk_n : std_logic_vector(useddr downto 0);
		
	begin

		dvi_inst : component dvi
		generic map (
			DDR_ENABLED => useddr
		)
		port map (
			pclk => clk_sys,
			tmds_clk => clk_tmds,

			in_vga_red => vga_r_i,
			in_vga_green => vga_g_i,
			in_vga_blue => vga_b_i,

			in_vga_vsync => vga_vs,
			in_vga_hsync => vga_hs,
			in_vga_pixel => vga_pixel,
			in_vga_window => vga_window,

			out_tmds_red => dvi_r,
			out_tmds_green => dvi_g,
			out_tmds_blue => dvi_b,
			out_tmds_clk => dvi_clk,
			out_tmds_red_n => dvi_r_n,
			out_tmds_green_n => dvi_g_n,
			out_tmds_blue_n => dvi_b_n,
			out_tmds_clk_n => dvi_clk_n
		);

		dviout_c : component ODDRX1F port map (D0 => dvi_clk(0), D1=>dvi_clk(1), Q => gpdi_dp(3), SCLK =>clk_tmds, RST=>'0');
		dviout_r : component ODDRX1F port map (D0 => dvi_r(0), D1=>dvi_r(1), Q => gpdi_dp(2), SCLK =>clk_tmds, RST=>'0');
		dviout_g : component ODDRX1F port map (D0 => dvi_g(0), D1=>dvi_g(1), Q => gpdi_dp(1), SCLK =>clk_tmds, RST=>'0');
		dviout_b : component ODDRX1F port map (D0 => dvi_b(0), D1=>dvi_b(1), Q => gpdi_dp(0), SCLK =>clk_tmds, RST=>'0');

	end generate;



	genaudio: if Toplevel_UseAudio=true generate
		signal pcm_l_msb : std_logic;
		signal pcm_r_msb : std_logic;
		signal l : signed(15 downto 0);
		signal r : signed(15 downto 0);
	begin
		pcm_l_msb <= not pcm_l(15);
		l <= signed(pcm_l_msb & pcm_l(14 downto 0));
		pcm_r_msb <= not pcm_r(15);
		r <= signed(pcm_r_msb & pcm_r(14 downto 0));
			
		audio_sd: component hybrid_pwm_sd
			port map
			(
				clk => clk_sys,
--				reset_n => '1',
				d_l(15) => pcm_l_msb,
				d_l(14 downto 0) => std_logic_vector(pcm_l(14 downto 0)),
				q_l => audio_l(2),
				d_r(15) => pcm_r_msb,
				d_r(14 downto 0) => std_logic_vector(pcm_r(14 downto 0)),
				q_r => audio_r(2)
			);
			audl3: component TRELLIS_IO port map ( B => audio_l(3), I => '0',	T => '1', O => open );
			audl1: component TRELLIS_IO port map ( B => audio_l(1), I => '0',	T => '1', O => open );
			audl0: component TRELLIS_IO port map ( B => audio_l(0), I => '0',	T => '1', O => open );
			audr3: component TRELLIS_IO port map ( B => audio_r(3), I => '0',	T => '1', O => open );
			audr1: component TRELLIS_IO port map ( B => audio_r(1), I => '0',	T => '1', O => open );
			audr0: component TRELLIS_IO port map ( B => audio_r(0), I => '0',	T => '1', O => open );
	end generate;	


	-- LEDS.  Not so much a "blinky" as a "pulsey"...
	pwmblock : block
		signal pwmcounter : unsigned(15 downto 0);
		signal redctr : unsigned(16 downto 0);
		signal greenctr : unsigned(16 downto 0);
		signal bluectr : unsigned(16 downto 0);
		signal redctr_i : unsigned(15 downto 0);
		signal greenctr_i : unsigned(15 downto 0);
		signal bluectr_i : unsigned(15 downto 0);
	begin
		redctr_i <= redctr(16 downto 1) when redctr(16)='0' else not redctr(16 downto 1);
		greenctr_i <= greenctr(16 downto 1) when greenctr(16)='0' else not greenctr(16 downto 1);
		bluectr_i <= bluectr(16 downto 1) when bluectr(16)='0' else not bluectr(16 downto 1);
		process(clk_sys) begin
			if rising_edge(clk_sys) then
				pwmcounter<=pwmcounter + 1;
				if pwmcounter=X"FFFF" then
					redctr<=redctr+13;
					greenctr<=greenctr+7;
					bluectr<=bluectr+19;
					led(0)<='1';
					led(1)<='1';
					led(2)<='1';
				end if;
				if redctr_i = pwmcounter then
					led(0)<='0';
				end if; 
				if greenctr_i = pwmcounter then
					led(1)<='0';
				end if; 
				if bluectr_i = pwmcounter then
					led(2)<='0';
				end if; 
			end if;
		end process;
		led(7 downto 3)<=(others => '0');
	end block;

end architecture;

