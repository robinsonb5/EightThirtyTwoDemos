--
-- Copyright (c) 2015 Emanuel Stiebler
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.
--
-- $Id$
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.math_real.all; -- to calculate log2 bit size

library unisim;
use unisim.vcomponents.all;

library work;
use work.Toplevel_Config.all;

entity esa11_7a102t_top is
port (
	i_100MHz_P, i_100MHz_N: in std_logic;
	UART1_TXD: out std_logic;
	UART1_RXD: in std_logic;
	FPGA_SD_SCLK, FPGA_SD_CMD, FPGA_SD_D3: out std_logic;
	FPGA_SD_D0: in std_logic;
	-- two onboard green LEDs next to yellow and red
	--FPGA_LED2, FPGA_LED3: out std_logic;
	-- DDR3 ------------------------------------------------------------------
	ddr3_dq                  : inout  std_logic_vector(15 downto 0);       -- mcb3_dram_dq
	ddr3_addr                : out    std_logic_vector(13 downto 0);    -- mcb3_dram_a
	ddr3_ba                  : out    std_logic_vector(2 downto 0);-- mcb3_dram_ba
	ddr3_ras_n               : out    std_logic;                                         -- mcb3_dram_ras_n
	ddr3_cas_n               : out    std_logic;                                         -- mcb3_dram_cas_n
	ddr3_we_n                : out    std_logic;                                         -- mcb3_dram_we_n
	ddr3_odt                 : out    std_logic;                                         -- mcb3_dram_odt
	ddr3_cke                 : out    std_logic;                                         -- mcb3_dram_cke
	ddr3_dm	                : out    std_logic_vector(1 downto 0);                      -- mcb3_dram_dm
	ddr3_dqs_p               : inout  std_logic_vector(1 downto 0);                      -- mcb3_dram_udqs
	ddr3_dqs_n               : inout  std_logic_vector(1 downto 0);                      -- mcb3_dram_udqs_n
--	ddr3_ck_p                : out    std_logic;                                         -- mcb3_dram_ck
--	ddr3_ck_n                : out    std_logic;                                         -- mcb3_dram_ck_n
	ddr3_reset_n             : out    std_logic;
	
	M_EXPMOD0, M_EXPMOD1, M_EXPMOD2, M_EXPMOD3: inout std_logic_vector(7 downto 0); -- EXPMODs
--	M_7SEG_A, M_7SEG_B, M_7SEG_C, M_7SEG_D, M_7SEG_E, M_7SEG_F, M_7SEG_G, M_7SEG_DP: out std_logic;
--	M_7SEG_DIGIT: out std_logic_vector(3 downto 0);
	--	seg: out std_logic_vector(7 downto 0); -- 7-segment display
	--	an: out std_logic_vector(3 downto 0); -- 7-segment display
	M_LED: out std_logic_vector(2 downto 0);
	-- PS/2 keyboard
	PS2_A_DATA, PS2_A_CLK, PS2_B_DATA, PS2_B_CLK: inout std_logic;
	-- HDMI
	VID_D_P, VID_D_N: out std_logic_vector(2 downto 0);
	VID_CLK_P, VID_CLK_N: out std_logic;
	-- VGA
	VGA_RED, VGA_GREEN, VGA_BLUE: out unsigned(7 downto 0);
	VGA_SYNC_N, VGA_BLANK_N, VGA_CLOCK_P: out std_logic;
	VGA_HSYNC, VGA_VSYNC: out std_logic;
--	M_BTN: in std_logic_vector(4 downto 0);
	M_HEX: in std_logic_vector(3 downto 0)
);
end entity;

architecture Behavioral of esa11_7a102t_top is

signal reset : std_logic;
signal sysclk : std_logic;
signal slowclk : std_logic;
signal videoclk : std_logic;
signal tmdsclk : std_logic;

alias PS2_MCLK : std_logic is PS2_B_CLK;
alias PS2_MDAT : std_logic is PS2_B_DATA;
alias PS2_CLK : std_logic is PS2_A_CLK;
alias PS2_DAT : std_logic is PS2_A_DATA;

signal ps2m_clk_in : std_logic;
signal ps2m_clk_out : std_logic;
signal ps2m_dat_in : std_logic;
signal ps2m_dat_out : std_logic;

signal ps2k_clk_in : std_logic;
signal ps2k_clk_out : std_logic;
signal ps2k_dat_in : std_logic;
signal ps2k_dat_out : std_logic;

signal vga_r : unsigned(7 downto 0);
signal vga_g : unsigned(7 downto 0);
signal vga_b : unsigned(7 downto 0);
signal hsync_n : std_logic;
signal vsync_n : std_logic;
signal vga_window : std_logic;
signal vga_pixel : std_logic;
signal clk_locked : std_logic;
signal pll_reset : std_logic;

signal audio_l : signed(15 downto 0);
signal audio_r : signed(15 downto 0);

	component pll is
	port (
		clk_in1_p : in std_logic;
		clk_in1_n : in std_logic;
		reset : in std_logic;
		locked : out std_logic;
		clk_out1 : out std_logic;
		clk_out2 : out std_logic;
		clk_out3 : out std_logic;
		clk_out4 : out std_logic
	);
	end component;
	
begin

	pll_reset<='0';

	sysclks: component pll
    port map(clk_in1_p => i_100MHz_P,
             clk_in1_n => i_100MHz_N,
             reset => pll_reset,
             locked => clk_locked,
             clk_out1 => sysclk,
             clk_out2 => slowclk,
             clk_out3 => videoclk,
             clk_out4 => tmdsclk
    );

	ps2m_dat_in<=PS2_MDAT;
	PS2_MDAT <= '0' when ps2m_dat_out='0' else 'Z';
	ps2m_clk_in<=PS2_MCLK;
	PS2_MCLK <= '0' when ps2m_clk_out='0' else 'Z';
	
	ps2k_dat_in<=PS2_DAT;
	PS2_DAT <= '0' when ps2k_dat_out='0' else 'Z';
	ps2k_clk_in<=PS2_CLK;
	PS2_CLK <= '0' when ps2k_clk_out='0' else 'Z';
	

--    G_dvi_sdr: if not C_dvid_ddr generate
--      tmds_rgb <= dvid_red(0) & dvid_green(0) & dvid_blue(0);
--      tmds_clk <= dvid_clock(0);
--    end generate;

--    G_dvi_ddr: if C_dvid_ddr generate
--    -- vendor specific modules to
--    -- convert 2-bit pairs to DDR 1-bit
--    G_vga_ddrout: entity work.ddr_dvid_out_se
--    port map (
--      clk       => clk_pixel_shift,
--      clk_n     => '0', -- inverted shift clock not needed on xilinx
--      in_red    => dvid_red,
--      in_green  => dvid_green,
--      in_blue   => dvid_blue,
--      in_clock  => dvid_clock,
--      out_red   => tmds_rgb(2),
--      out_green => tmds_rgb(1),
--      out_blue  => tmds_rgb(0),
--      out_clock => tmds_clk
--    );
--    end generate;

--    -- differential output buffering for HDMI clock and video
--    hdmi_output: entity work.hdmi_out
--    port map (
--        tmds_in_clk => tmds_clk, -- clk_25MHz or tmds_clk
--        tmds_out_clk_p => VID_CLK_P,
--        tmds_out_clk_n => VID_CLK_N,
--        tmds_in_rgb => tmds_rgb,
--        tmds_out_rgb_p => VID_D_P,
--        tmds_out_rgb_n => VID_D_N
--    );

process(sysclk)
begin
	if rising_edge(sysclk) then
		reset <= clk_locked;
	end if;
end process;

project: entity work.VirtualToplevel
	generic map (
		sdram_rows => 13,
		sdram_cols => 10,
		sysclk_frequency => 1000 -- Sysclk frequency * 10
	)
	port map (
		clk => sysclk,
		slowclk => slowclk,
		videoclk => videoclk,
		reset_in => reset,
	
		-- VGA
		-- vga_red => vga_red(9 downto 2),
		-- vga_green => vga_green(9 downto 2),
		-- vga_blue => vga_blue(9 downto 2),

		vga_red => vga_r,
		vga_green => vga_g,
		vga_blue => vga_b,
		vga_hsync => hsync_n,
		vga_vsync => vsync_n,
		vga_window => vga_window,
		vga_pixel => vga_pixel,

		-- SDRAM
--		sdr_data => DR_D,
--		sdr_addr => DR_A(12 downto 0),
--		sdr_dqm(1) => DR_DQMH,
--		sdr_dqm(0) => DR_DQML,
--		sdr_we => DR_WE_N,
--		sdr_cas => DR_CAS_N,
--		sdr_ras => DR_RAS_N,
--		sdr_cs => DR_CS_N,
--		sdr_ba => DR_BA,
--		sdr_cke => DR_CKE,

		-- SD Card
		spi_cs => FPGA_SD_D3,
		spi_miso => FPGA_SD_D0,
		spi_mosi => FPGA_SD_CMD,
		spi_clk => FPGA_SD_SCLK,

		-- PS/2
		ps2k_clk_in => ps2k_clk_in,
		ps2k_dat_in => ps2k_dat_in,
		ps2k_clk_out => ps2k_clk_out,
		ps2k_dat_out => ps2k_dat_out,
		ps2m_clk_in => ps2m_clk_in,
		ps2m_dat_in => ps2m_dat_in,
		ps2m_clk_out => ps2m_clk_out,
		ps2m_dat_out => ps2m_dat_out,

		-- UART
		rxd => UART1_RXD,
		txd => UART1_TXD,
		
		audio_l => audio_l,
		audio_r => audio_r
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

		signal dvi_r_i : std_logic;
		signal dvi_g_i : std_logic;
		signal dvi_b_i : std_logic;
		signal dvi_c_i : std_logic;
		
	begin

		dvi_inst : component dvi
		generic map (
			DDR_ENABLED => useddr
		)
		port map (
			pclk => videoclk,
			tmds_clk => tmdsclk,

			in_vga_red => vga_r,
			in_vga_green => vga_g,
			in_vga_blue => vga_b,

			in_vga_vsync => vsync_n,
			in_vga_hsync => hsync_n,
			in_vga_pixel => vga_pixel,
			in_vga_window => vga_window,

			out_tmds_red => dvi_r,
			out_tmds_green => dvi_g,
			out_tmds_blue => dvi_b,
			out_tmds_clk => dvi_clk
		);

		dviddr_c : ODDR generic map (DDR_CLK_EDGE=>"SAME_EDGE")
		port map(q => dvi_c_i,c=>tmdsclk,ce=>'1',d1=>dvi_clk(0),d2=>dvi_clk(1));
		dviddr_r : ODDR generic map (DDR_CLK_EDGE=>"SAME_EDGE")
		port map(q => dvi_r_i,c=>tmdsclk,ce=>'1',d1=>dvi_r(0),d2=>dvi_r(1));
		dviddr_g : ODDR generic map (DDR_CLK_EDGE=>"SAME_EDGE")
		port map(q => dvi_g_i,c=>tmdsclk,ce=>'1',d1=>dvi_g(0),d2=>dvi_g(1));
		dviddr_b : ODDR generic map (DDR_CLK_EDGE=>"SAME_EDGE")
		port map(q => dvi_b_i,c=>tmdsclk,ce=>'1',d1=>dvi_b(0),d2=>dvi_b(1));

	    dviout_c: obufds port map(i => dvi_c_i, o => VID_CLK_P, ob => VID_CLK_N);
	    dviout_r: obufds port map(i => dvi_r_i, o => VID_D_P(2), ob => VID_D_N(2));
	    dviout_g: obufds port map(i => dvi_g_i, o => VID_D_P(1), ob => VID_D_N(1));
	    dviout_b: obufds port map(i => dvi_b_i, o => VID_D_P(0), ob => VID_D_N(0));
		
	end generate;

	gennovideo: if Toplevel_UseVGA=false generate
	    dviotu_c: obuftds port map(i => '0', t=>'1', o => VID_CLK_P, ob => VID_CLK_N);
	    dviotu_r: obuftds port map(i => '0', t=>'1', o => VID_D_P(2), ob => VID_D_N(2));
	    dviotu_g: obuftds port map(i => '0', t=>'1', o => VID_D_P(1), ob => VID_D_N(1));
	    dviotu_b: obuftds port map(i => '0', t=>'1', o => VID_D_P(0), ob => VID_D_N(0));
	end generate;

VGA_SYNC_N <= '1';
VGA_BLANK_N <= vga_window;
VGA_CLOCK_P <= slowclk;
VGA_VSYNC <= vsync_n;
VGA_HSYNC <= hsync_n;
vga_red <= vga_r;
vga_green <= vga_g;
vga_blue <= vga_b;

M_LED<=(others => '0');

end Behavioral;
