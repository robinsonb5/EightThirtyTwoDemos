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

	component pll is
	port (
		clk_i : in std_logic;
		clk_o : out std_logic_vector(3 downto 0);
		reset : in std_logic :='0';
		locked : out std_logic
	);
	end component;

-- Sigma Delta audio
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

	signal sdram_drive_dq : std_logic;
	signal sdram_dq_in : std_logic_vector(15 downto 0);
	signal sdram_dq_out : std_logic_vector(15 downto 0);

	signal trace : std_logic_vector(63 downto 0);
	signal capreset : std_logic;
	signal reset_n : std_logic;

begin

	sdram_dq <= sdram_dq_out when sdram_drive_dq='1' else (others => 'Z');
	sdram_dq_in <= sdram_dq;

	clk : component pll
	port map (
		clk_i => clk_i,
		clk_o(0) => clk_sys,
		clk_o(1) => clk_sdram,
		clk_o(2) => clk_slow,
		clk_o(3) => clk_none,
		locked => pll_locked
	);

	sdram_clk <= clk_sdram;

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

	-- PS/2 tristating

	-- Instantiate IOs explicitly to avoid potential issues with tristate signals.
	ps2kd : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KDAT+ps2_pmod_offset), I => '0',	T => ps2k_dat_out, O => ps2k_dat_in );
	ps2kc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_KCLK+ps2_pmod_offset), I => '0',	T => ps2k_clk_out, O => ps2k_clk_in );
	ps2md : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MDAT+ps2_pmod_offset), I => '0',	T => ps2m_dat_out, O => ps2m_dat_in );
	ps2mc : component TRELLIS_IO port map ( B => ps2_pmod(PMOD_PS2_MCLK+ps2_pmod_offset), I => '0',	T => ps2m_clk_out, O => ps2m_clk_in );

	--ps2_pmod_in<=P6_pmod_high;
--	ps2_pmod(0) <= 'Z' when ps2k_dat_out='1' else '0';
--	ps2_pmod(1) <= 'Z' when ps2m_dat_out='1' else '0';
--	ps2_pmod(2) <= 'Z' when ps2k_clk_out='1' else '0';
--	ps2_pmod(3) <= 'Z' when ps2m_clk_out='1' else '0';

--	ps2k_dat_in<=ps2_pmod(0);
--	ps2m_dat_in<=ps2_pmod(1);
--	ps2k_clk_in<=ps2_pmod(2);
--	ps2m_clk_in<=ps2_pmod(3);


	genvideo: if Toplevel_UseVGA=true generate
		-- Dither the video down to 4 bits per gun.

		mydither : entity work.video_vga_dither
			generic map(
				outbits => 4
			)
			port map(
				clk=>clk_sys,
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
	audio_l_msb <= not audio_l(15);
	audio_r_msb <= not audio_r(15);

	audio_sd: component hybrid_pwm_sd_2ndorder
		port map
		(
			clk => clk_slow,
			reset_n => '1',
			d_l(15) => audio_l_msb,
			d_l(14 downto 0) => std_logic_vector(audio_l(14 downto 0)),
			q_l => sigmadelta_pmod(0),
			d_r(15) => audio_r_msb,
			d_r(14 downto 0) => std_logic_vector(audio_r(14 downto 0)),
			q_r => sigmadelta_pmod(1)
		);

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
			mclk => i2s_pmod(PMOD_I2S_DA_MCLK),
			sclk => i2s_pmod(PMOD_I2S_DA_SCLK),
			lrclk => i2s_pmod(PMOD_I2S_DA_LRCK),
			sdata => i2s_pmod(PMOD_I2S_DA_SDIN)
		);

	end generate;	


	-- PMOD-based SD card socket
	genpmodsd : if use_pmod_sdcard=true generate
		-- Instantiate a TRELLIS_IO manually to create an input from the "inout" PMOD ports.
		sdcardmiso : component TRELLIS_IO port map ( B => sdcard_pmod(PMOD_SD_MISO), I => '0',	T => '1', O => sdcard_miso );
		sdcard_pmod(PMOD_SD_CS) <= sdcard_cs;
		sdcard_pmod(PMOD_SD_MOSI) <= sdcard_mosi;
		sdcard_pmod(PMOD_SD_CLK) <= sdcard_clk;
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

--	capblock : block
--		signal capd : std_logic_vector(63 downto 0);
--		signal capq : std_logic_vector(63 downto 0);
--		signal capu : std_logic;
--	begin

--		cap : entity work.jcapture
--		port map(
--			clk => clk_sys,
--			reset_n => pll_locked,
--			d => capd,
--			q => capq,
--			update => capu
--		);

--		capd <= trace;
--		process(clk_sys) begin
--			if rising_edge(clk_sys) then
--				if capu='1' then
--					capreset<=capq(0);
--					led_red <= capq(1);
--					led_green <= capq(2);
--					led_blue <= capq(3);
--				end if;
--			end if;
--		end process;

--	end block;

end architecture;

