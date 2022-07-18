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
	dr_d : inout std_logic_vector(31 downto 0);
	dr_we_n : out std_logic;
	dr_ras_n : out std_logic;
	dr_cas_n : out std_logic;
	dr_cke : out std_logic;
	dr_ba : out std_logic_vector(1 downto 0);
	dr_dqm : out std_logic_vector(3 downto 0);
	
	sd_m_cdet : out std_logic;
	sd_m_clk : out std_logic; -- SPI clk
	sd_m_cmd : out std_logic; -- SPI MOSI
	sd_m_d0 : in std_logic; -- SPI MISO
	sd_m_d1 : out std_logic;
	sd_m_d2 : out std_logic;
	sd_m_d3 : out std_logic; -- SPI CS
	
	AUDIO_L : out std_logic;
	AUDIO_R : out std_logic;
	
	dio_p : out std_logic_vector(3 downto 0)
--	dio_n : out std_logic_vector(3 downto 0) -- Don't declare the _n pins - the _p pins are declared as
	                                         -- LVCMOS33D so their conjugate pairs will be used automatically.
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
	signal clk_video : std_logic;
	signal clk_tmds : std_logic;
	signal clk_video_src : std_logic;
	signal pll_locked : std_logic;

	signal vga_hs : std_logic;
	signal vga_vs : std_logic;
	signal vga_r_i : unsigned(7 downto 0);
	signal vga_g_i : unsigned(7 downto 0);
	signal vga_b_i : unsigned(7 downto 0);
	signal vga_window : std_logic;
	signal vga_pixel : std_logic;

	signal dr_drive_dq : std_logic;
	signal dr_dq_in : std_logic_vector(Toplevel_SDRAMWidth-1 downto 0);
	signal dr_dq_out : std_logic_vector(Toplevel_SDRAMWidth-1 downto 0);

	signal reset_n : std_logic;

	signal rxd : std_logic;
	signal txd : std_logic;

begin

	UART_U1_TXD <= txd;
	UART_U2_TXD <= txd;
	UART_D1_TXD <= txd;
	UART_D2_TXD <= txd;
	rxd <= UART_U1_RXD;

gentsdram : if Toplevel_SDRAMWidth<32 generate
	dr_d(31 downto Toplevel_SDRAMWidth) <= (others => 'Z');
end generate;
	dr_d(Toplevel_SDRAMWidth-1 downto 0) <= dr_dq_out when dr_drive_dq='1' else (others => 'Z');
	dr_dq_in(Toplevel_SDRAMWidth-1 downto 0) <= dr_d(Toplevel_SDRAMWidth-1 downto 0);

	clocks : entity work.pll
	port map (
		clk_i => clk_100mhz_p,
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_video_src,
		reset => '0',
		locked => pll_locked
	);

	dr_clk <= clk_sdram;

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
		sdr_cs => dr_cs_n,
		sdr_drive_data => dr_drive_dq,
		sdr_data_in => dr_dq_in,
		sdr_data_out => dr_dq_out,
		sdr_addr => dr_a,
		sdr_we => dr_we_n,
		sdr_cas => dr_cas_n,
		sdr_ras => dr_ras_n,
		sdr_dqm => dr_dqm(Toplevel_SDRAMWidth/8-1 downto 0),
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
		COMPONENT hybrid_2ndorder
		PORT
		(
			clk	:	IN STD_LOGIC;
			reset_n : in std_logic;
	--		terminate : in std_logic;
			d	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			q	:	OUT STD_LOGIC
		);
		END COMPONENT;
		signal aud_d_l : std_logic_vector(15 downto 0);
		signal aud_d_r : std_logic_vector(15 downto 0);
	begin
		
		process(clk_slow) begin
			if rising_edge(clk_slow) then
				aud_d_l <= not pcm_l(15) & std_logic_vector(pcm_l(14 downto 0));
				aud_d_r <= not pcm_r(15) & std_logic_vector(pcm_r(14 downto 0));
			end if;
		end process;
		
		audio_sd_l: component hybrid_2ndorder
			port map
			(
				clk => clk_slow,
				reset_n => '1',
				d => aud_d_l,
				q => AUDIO_l
			);

		audio_sd_r: component hybrid_2ndorder
			port map
			(
				clk => clk_slow,
				reset_n => '1',
				d => aud_d_r,
				q => AUDIO_r
			);

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
			out_tmds_clk : out std_logic_vector(useddr downto 0)
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
			-- TDMS clocks, which will be 5*75MHz*5 and 5*50Mhz.
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
			out_tmds_clk => dvi_clk
		);
		
		dviout_c : component ODDRX1F port map (D0 => dvi_clk(0), D1=>dvi_clk(1), Q => dio_p(3), SCLK =>clk_tmds, RST=>'0');
		dviout_r : component ODDRX1F port map (D0 => dvi_r(0), D1=>dvi_r(1), Q => dio_p(2), SCLK =>clk_tmds, RST=>'0');
		dviout_g : component ODDRX1F port map (D0 => dvi_g(0), D1=>dvi_g(1), Q => dio_p(1), SCLK =>clk_tmds, RST=>'0');
		dviout_b : component ODDRX1F port map (D0 => dvi_b(0), D1=>dvi_b(1), Q => dio_p(0), SCLK =>clk_tmds, RST=>'0');
		
	end generate;

	sd_m_d3 <= sdcard_cs;
	sd_m_cmd <= sdcard_mosi;
	sd_m_clk <= sdcard_clk;
	sdcard_miso <= sd_m_d0;

	-- LEDS.  Not so much a "blinky" as a "pulsey"...
	pwmblock : block
		signal pwmcounter : unsigned(16 downto 0);
		signal redctr : unsigned(16 downto 0);
		signal greenctr : unsigned(16 downto 0);
		signal redctr_i : unsigned(15 downto 0);
		signal greenctr_i : unsigned(15 downto 0);
	begin
		redctr_i <= redctr(16 downto 1) when redctr(16)='0' else not redctr(16 downto 1);
		greenctr_i <= greenctr(16 downto 1) when greenctr(16)='0' else not greenctr(16 downto 1);
		process(clk_sys) begin
			if rising_edge(clk_sys) then
				pwmcounter<=pwmcounter + 1;
				if pwmcounter='1'&X"FFFF" then
					redctr<=redctr+13;
					greenctr<=greenctr+7;
					led1<='1';
					led2<='1';
				end if;
				if redctr_i = pwmcounter then
					led1<='0';
				end if; 
				if greenctr_i = pwmcounter then
					led2<='0';
				end if; 
			end if;
		end process;
	end block;

end architecture;

