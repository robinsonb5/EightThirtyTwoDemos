library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.icesugarpro_pmod_pkg.all;
use work.Toplevel_Config.all;

entity icesugarpro_top is
port(
	clk_i : in std_logic; -- 25MHz

	txd : out std_logic;
	rxd : in std_logic;

	led_red : out std_logic;
	led_green : out std_logic;
	led_blue : out std_logic;

	sdram_clk : out std_logic;
	sdram_cs_n : out std_logic;
	sdram_a : out std_logic_vector(12 downto 0);
	sdram_dq : inout std_logic_vector(15 downto 0);
	sdram_we_n : out std_logic;
	sdram_ras_n : out std_logic;
	sdram_cas_n : out std_logic;
	sdram_cke : out std_logic;
	sdram_ba : out std_logic_vector(1 downto 0);
	sdram_dm : out std_logic_vector(1 downto 0);
	
	spisdcard_clk : out std_logic;
	spisdcard_mosi : out std_logic;
	spisdcard_cs_n : out std_logic;
	spisdcard_miso : in std_logic;

	gpdi_dp : out std_logic_vector(3 downto 0);	-- Quasi-differential output for digital video.
	gpdi_dn : out std_logic_vector(3 downto 0);

	P2_pmod_high : inout std_logic_vector(7 downto 0);
	P2_gpio : inout std_logic_vector(3 downto 0);
	P2_pmod_low : inout std_logic_vector(7 downto 0);
	P3_pmod_high : inout std_logic_vector(7 downto 0);
	P3_gpio : inout std_logic_vector(3 downto 0);
	P3_pmod_low : inout std_logic_vector(7 downto 0);
	P4_pmod_low : inout std_logic_vector(7 downto 0);
	P4_gpio : inout std_logic_vector(3 downto 0);
	P4_gpio2 : inout std_logic_vector(5 downto 0); -- Two pins not connected, so called GPIO instead of PMOD.
	P5_pmod_high : inout std_logic_vector(7 downto 0); -- Pins shared with breakout board's DAPLink.
	P5_gpio : inout std_logic_vector(3 downto 0);
	P5_pmod_low : inout std_logic_vector(7 downto 0);
	P6_pmod_high : inout std_logic_vector(7 downto 0);
	P6_gpio : inout std_logic_vector(3 downto 0);
	P6_pmod_low : inout std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of icesugarpro_top is

	-- Assign peripherals to PMODs:

	-- PS/2 keyboard and mouse
	constant ps2_pmod_offset : integer := 4; -- Set this to 4 to use the bottom row of pins, 0 to use the top row.
	alias ps2_pmod is P6_pmod_high;

	-- Audio
	alias sigmadelta_pmod is P2_pmod_low;
	alias i2s_pmod is P2_pmod_high;

	-- SD Card
	constant use_pmod_sdcard : boolean := true; -- Set to false to use the built-in (but awkwardly-placed) micro-SD slot
	alias sdcard_pmod is P5_pmod_low;

	-- VGA
	alias vga_pmod_high is P3_pmod_high;
	alias vga_pmod_low is P3_pmod_low;

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

	signal audio_l_msb : std_logic;
	signal audio_l : signed(15 downto 0);
	signal audio_r_msb : std_logic;
	signal audio_r : signed(15 downto 0);

	signal clk_sdram : std_logic;
	signal clk_sys : std_logic;
	signal clk_slow : std_logic;
	signal clk_video_src : std_logic;
	signal clk_video : std_logic;
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
	signal sdram_tristate_dq : std_logic;
	signal sdram_dq_in : std_logic_vector(15 downto 0);
	signal sdram_dq_out : std_logic_vector(15 downto 0);

	signal trace : std_logic_vector(63 downto 0);
	signal capreset : std_logic;
	signal reset_n : std_logic;

begin

	sdram_tristate_dq <= not sdram_drive_dq;
	
	gensdram_dq_ffs : for i in 0 to 15 generate
		sdram_dq_ff : component TRELLIS_IO port map ( B => sdram_dq(i), I => sdram_dq_out(i), T => sdram_tristate_dq, O => sdram_dq_in(i) );
	end generate;
--	sdram_dq <= sdram_dq_out when sdram_drive_dq='1' else (others => 'Z');
--	sdram_dq_in <= sdram_dq;

	clk : entity work.pll
	generic map (
		sdram_phase => 315
	)
	port map (
		clk_i => clk_i,
		reset => '0',
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_video_src,
		locked => pll_locked
	);

	sdram_clk <= clk_sdram;

	reset_n <= pll_locked;

	vt : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => 1000,
		debug => false
	)
	port map(
		clk => clk_sys,
		slowclk => clk_slow,
		videoclk => clk_video,
		reset_in => reset_n,
		txd => txd,
		rxd => rxd,

		unsigned(vga_red) => vga_r_i,
		unsigned(vga_green) => vga_g_i,
		unsigned(vga_blue) => vga_b_i,
		vga_hsync => vga_hs,
		vga_vsync => vga_vs,
		vga_window => vga_window,
		vga_pixel => vga_pixel,

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
		sdr_cs => sdram_cs_n,
		sdr_drive_data => sdram_drive_dq,
		sdr_data_in => sdram_dq_in,
		sdr_data_out => sdram_dq_out,
		sdr_addr => sdram_a,
		sdr_we => sdram_we_n,
		sdr_cas => sdram_cas_n,
		sdr_ras => sdram_ras_n,
		sdr_dqm => sdram_dm,
		sdr_ba => sdram_ba,
		sdr_cke => sdram_cke,
		
		signed(audio_l) => audio_l,
		signed(audio_r) => audio_r
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

		component DCSC
		generic (
			DCSMODE : string := "POS"
		);
		port (
			CLK1, CLK0 : in std_logic;
			SEL1, SEL0 : in std_logic;
			MODESEL : in std_logic;
			DCSOUT : out std_logic
		);
		end component;

		signal pcnt : unsigned(3 downto 0);
		signal clksel : std_logic_vector(1 downto 0);

		signal dvi_r : std_logic_vector(useddr downto 0);
		signal dvi_g : std_logic_vector(useddr downto 0);
		signal dvi_b : std_logic_vector(useddr downto 0);
		signal dvi_clk : std_logic_vector(useddr downto 0);
		signal dvi_r_n : std_logic_vector(useddr downto 0);
		signal dvi_g_n : std_logic_vector(useddr downto 0);
		signal dvi_b_n : std_logic_vector(useddr downto 0);
		signal dvi_clk_n : std_logic_vector(useddr downto 0);
		signal vidclks : std_logic_vector(3 downto 0);
		
	begin

		process(clk_video) begin

			-- Clock multiplexing:  Video timings are derived from a 150MHz clock.
			-- vga_pixel is high for one cycle at the start of each pixel, so by counting
			-- the number of clocks between each pulse we can determine the pixel clock and
			-- thus the appropriate TMDS clock to use.
			-- We will see a pcnt value of 1 for 75MHz modes, 2 for 50MHz modes, 3 for 37.5MHz
			-- 4 for 30MHz, and 5 for 25MHz.
			-- Since we don't seem to be able to cascade DCSCs, we're stuck with just two
			-- TDMS clocks, which will be 5*75MHz and 5*50Mhz.
			if rising_edge(clk_video) then
				if vga_pixel='1' then
					pcnt <=(others => '0');
					clksel(0)<='0';
					case pcnt is 
						when X"5" => -- 25MHz pixel clock
							clksel(0) <= '1';
						when X"2" => -- 50Mhz pixel clock
							clksel(0) <= '1';
						when others =>
							null;
					end case;
				else
					pcnt<=pcnt+1;
				end if;
			end if;
			clksel(1) <= not clksel(0);
		end process;

		vidpll : entity work.ecp5pll
		generic map(
			in_hz => 150000,
			out0_hz => 250000,
			out1_hz => 375000,
			out2_hz => 150000
		)
		port map (
			clk_i => clk_video_src,
			clk_o => vidclks
		);
		
		clkmux1 : component DCSC
		port map (
			CLK0 => vidclks(0),
			CLK1 => vidclks(1),
			SEL1 => clksel(1),
			SEL0 => clksel(0),
			MODESEL => '1',
			DCSOUT => clk_tmds
		);

		clk_video <= vidclks(2);


--		clkmux2 : component DCSC
--		port map (
--			CLK0 => clk_tmds_mux1,
--			CLK1 => vidclks(2),
--			SEL1 => clksel(3),
--			SEL0 => clksel(2),
--			MODESEL => '1',
--			DCSOUT => clk_tmds
--		);

		dvi_inst : component dvi
		generic map (
			DDR_ENABLED => useddr
		)
		port map (
			pclk => clk_video,
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
		dviout_c_n : component ODDRX1F port map (D0 => dvi_clk_n(0), D1=>dvi_clk_n(1), Q => gpdi_dn(3), SCLK =>clk_tmds, RST=>'0');
		dviout_r_n : component ODDRX1F port map (D0 => dvi_r_n(0), D1=>dvi_r_n(1), Q => gpdi_dn(2), SCLK =>clk_tmds, RST=>'0');
		dviout_g_n : component ODDRX1F port map (D0 => dvi_g_n(0), D1=>dvi_g_n(1), Q => gpdi_dn(1), SCLK =>clk_tmds, RST=>'0');
		dviout_b_n : component ODDRX1F port map (D0 => dvi_b_n(0), D1=>dvi_b_n(1), Q => gpdi_dn(0), SCLK =>clk_tmds, RST=>'0');
		
		
		-- Dither the video down to 4 bits per gun for PMOD VGA out

		mydither : entity work.video_vga_dither
			generic map(
				outbits => 4
			)
			port map(
				clk=>clk_video,
				hsync=>vga_hs,
				vsync=>vga_vs,
				vid_ena=>vga_window,
				iRed => unsigned(vga_r_i),
				iGreen => unsigned(vga_g_i),
				iBlue => unsigned(vga_b_i),
				oRed => vga_r,
				oGreen => vga_g,
				oBlue => vga_b
			);

		vga_pmod_high(7 downto 4)<=std_logic_vector(vga_r);
		vga_pmod_high(3 downto 0)<=std_logic_vector(vga_b);
		vga_pmod_low(7 downto 4)<=std_logic_vector(vga_g);
		vga_pmod_low(3 downto 0)<="00"&vga_vs&vga_hs;

	end generate;


	genaudio: if Toplevel_UseAudio=true generate
		signal i2s_mclk : std_logic;
		signal i2s_sclk : std_logic;
		signal i2s_lrclk : std_logic;
		signal i2s_sdata : std_logic;
	begin
		audio_l_msb <= not audio_l(15);
		audio_r_msb <= not audio_r(15);

		dac : entity work.i2s_dac
		generic map (
			sysclk_frequency => 100,
			mclk_to_lrclk => 256,
			samplerate => 44100,
			width => 16
		)
		port map (
			sysclk => clk_sys,
			reset_n => reset_n,
			left_in => std_logic_vector(audio_l),
			right_in => std_logic_vector(audio_r),
			--
			mclk => i2s_mclk,
			sclk => open, -- i2s_sclk,
			lrclk => i2s_lrclk,
			sdata => i2s_sdata
		);
		i2s_sclk <= '1';

		i2smclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_MCLK), I => i2s_mclk, T => '0', O => open );
		i2ssclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_SCLK), I => i2s_sclk, T => '0', O => open );
		i2slrclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_LRCK), I => i2s_lrclk, T => '0', O => open );
		i2ssdata : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_SDIN), I => i2s_sdata, T => '0', O => open );

	end generate;	

	gennoaudio: if TopLevel_UseAudio=false generate
		i2smclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_MCLK), I => '1', T => '0', O => open );
		i2ssclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_SCLK), I => '1', T => '0', O => open );
		i2slrclk : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_LRCK), I => '1', T => '0', O => open );
		i2ssdata : component TRELLIS_IO port map ( B => i2s_pmod(PMOD_I2S_DA_SDIN), I => '1', T => '0', O => open );
	end generate;

	-- PS/2 tristating

	-- Instantiate IOs explicitly to avoid potential issues with tristate signals.
	ps2kd : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KDAT+ps2_pmod_offset), I => '0',	T => ps2k_dat_out, O => ps2k_dat_in );
	ps2kc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KCLK+ps2_pmod_offset), I => '0',	T => ps2k_clk_out, O => ps2k_clk_in );
	ps2md : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MDAT+ps2_pmod_offset), I => '0',	T => ps2m_dat_out, O => ps2m_dat_in );
	ps2mc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MCLK+ps2_pmod_offset), I => '0',	T => ps2m_clk_out, O => ps2m_clk_in );


	-- PMOD-based SD card socket
	genpmodsd : if use_pmod_sdcard=true generate
		-- Instantiate a TRELLIS_IO manually to create an input from the "inout" PMOD ports.
		sdcardmiso : component TRELLIS_IO port map ( B => sdcard_pmod(PMOD_SD_MISO), I => '0', T => '1', O => sdcard_miso );
		sdcardcs : component TRELLIS_IO port map ( B => sdcard_pmod(PMOD_SD_CS), I => sdcard_cs, T => '0', O => open );
		sdcardmosi : component TRELLIS_IO port map ( B => sdcard_pmod(PMOD_SD_MOSI), I => sdcard_mosi, T => '0', O => open );
		sdcardclk : component TRELLIS_IO port map ( B => sdcard_pmod(PMOD_SD_CLK), I => sdcard_clk, T => '0', O => open );
		spisdcard_cs_n <= '1';
		spisdcard_mosi <= '1';
		spisdcard_clk <= '1';
	end generate;
	
	-- Internal SD card socket
	geninternalsd : if use_pmod_sdcard=false generate
		spisdcard_cs_n <= sdcard_cs;
		spisdcard_mosi <= sdcard_mosi;
		spisdcard_clk <= sdcard_clk;
		sdcard_miso <= spisdcard_miso;
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
					led_red<='1';
					led_green<='1';
					led_blue<='1';
				end if;
				if redctr_i = pwmcounter then
					led_red<='0';
				end if; 
				if greenctr_i = pwmcounter then
					led_green<='0';
				end if; 
				if bluectr_i = pwmcounter then
					led_blue<='0';
				end if; 
			end if;
		end process;
	end block;

end architecture;

