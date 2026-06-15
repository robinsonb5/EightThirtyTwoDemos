library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Toplevel_Config.all;
use work.usb_phy_pkg.all;

entity icepizero_top is
port(
	clk : in std_logic; -- 25MHz

	usb_tx : out std_logic;
	usb_rx : in std_logic;

	button : in std_logic_vector(1 downto 0);
	led : out std_logic_vector(4 downto 0);

	sdram_clk  : out std_logic;
	sdram_csn  : out std_logic;
	sdram_a    : out std_logic_vector(12 downto 0);
	sdram_dq   : inout std_logic_vector(15 downto 0);
	sdram_wen  : out std_logic;
	sdram_rasn : out std_logic;
	sdram_casn : out std_logic;
	sdram_cke  : out std_logic;
	sdram_ba   : out std_logic_vector(1 downto 0);
	sdram_dqm  : out std_logic_vector(1 downto 0);
	
	sd_clk : out std_logic;
	sd_mosi : out std_logic;
	sd_csn : out std_logic;
	sd_miso : in std_logic;

	usb_dn : inout std_logic_vector(1 downto 0);
	usb_dp : inout std_logic_vector(1 downto 0);

	gpdi_dp : out std_logic_vector(3 downto 0)	-- Quasi-differential output for digital video.
	-- gpdi_dn : out std_logic_vector(3 downto 0)  -- Don't declare the _n pins - the _p pins are declared as
	                                               -- LVCMOS33D so their conjugate pairs will be used automatically.

);
end entity;

architecture rtl of icepizero_top is

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

	pll_inst : entity work.pll
	generic map (
		sdram_phase => 315
	)
	port map (
		clk_i => clk,
		reset => '0',
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_video_src,
		locked => pll_locked
	);

	sdram_clk <= clk_sdram;

	reset_n <= pll_locked and button(0);

	ps2k_clk_in <= '1';
	ps2k_dat_in <= '1';
	ps2m_clk_in <= '1';
	ps2m_dat_in <= '1';

	vt : entity work.VirtualToplevel
	generic map(
		sdram_rows => 13,
		sdram_cols => 9,
		sysclk_frequency => Toplevel_Frequency*10,
		debug => false
	)
	port map(
		clk => clk_sys,
		slowclk => clk_slow,
		videoclk => clk_video,
		reset_in => reset_n,
		txd => usb_tx,
		rxd => usb_rx,

		unsigned(vga_red) => vga_r_i,
		unsigned(vga_green) => vga_g_i,
		unsigned(vga_blue) => vga_b_i,
		vga_hsync => vga_hs,
		vga_vsync => vga_vs,
		vga_window => vga_window,
		vga_pixel => vga_pixel,

		spi_miso => sd_miso,
		spi_mosi => sd_mosi,
		spi_cs => sd_csn,
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
		
		-- USB
		usb_dp => usb_dp,
		usb_dn => usb_dn,
		
		-- Audio
		signed(audio_l) => audio_l,
		signed(audio_r) => audio_r
--		trace_out => trace
	);


	gennovideo : if Toplevel_UseVGA=false generate
		gpdi_dp <= (others => '1');
		clk_video <= clk_video_src;
	end generate;

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
--		dviout_c_n : component ODDRX1F port map (D0 => dvi_clk_n(0), D1=>dvi_clk_n(1), Q => gpdi_dn(3), SCLK =>clk_tmds, RST=>'0');
--		dviout_r_n : component ODDRX1F port map (D0 => dvi_r_n(0), D1=>dvi_r_n(1), Q => gpdi_dn(2), SCLK =>clk_tmds, RST=>'0');
--		dviout_g_n : component ODDRX1F port map (D0 => dvi_g_n(0), D1=>dvi_g_n(1), Q => gpdi_dn(1), SCLK =>clk_tmds, RST=>'0');
--		dviout_b_n : component ODDRX1F port map (D0 => dvi_b_n(0), D1=>dvi_b_n(1), Q => gpdi_dn(0), SCLK =>clk_tmds, RST=>'0');

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
		led(4 downto 3) <= "00";
	end block;

end architecture;

