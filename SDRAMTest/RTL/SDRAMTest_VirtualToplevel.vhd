library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10
		jtag_uart : boolean := false;
		debug : boolean := false
	);
	port (
		clk 			: in std_logic;
		slowclk		: in std_logic;
		reset_in 	: in std_logic;

		-- VGA
		vga_red 		: out unsigned(7 downto 0);
		vga_green 	: out unsigned(7 downto 0);
		vga_blue 	: out unsigned(7 downto 0);
		vga_hsync 	: out std_logic;
		vga_vsync 	: out std_logic;
		vga_window	: out std_logic;

		-- SDRAM
		sdr_drive_data : out std_logic;
		sdr_data_in		: in std_logic_vector(15 downto 0);
		sdr_data_out	: inout std_logic_vector(15 downto 0);
		sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
		sdr_dqm 		: out std_logic_vector(1 downto 0);
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

		-- UART
		rxd	: in std_logic := '1';
		txd	: out std_logic;
		rxd2 : in std_logic := '1';
		txd2 : out std_logic;

		-- Audio
		audio_l : out signed(15 downto 0);
		audio_r : out signed(15 downto 0)
);
end entity;

architecture rtl of VirtualToplevel is


component sdramtest is
generic (
	sysclk_frequency : integer := 1000
);
port (
	clk : in std_logic;
	slowclk : in std_logic;
	reset_in : in std_logic;
	DRAM_DRIVE_DQ : out std_logic;
	DRAM_DQ_IN : in std_logic_vector(15 downto 0);
	DRAM_DQ_OUT : out std_logic_vector(15 downto 0);
	DRAM_ADDR : out std_logic_vector(SDRAM_ROWS-1 downto 0);
	DRAM_LDQM : out std_logic;
	DRAM_UDQM : out std_logic;
	DRAM_WE_N : out std_logic;
	DRAM_RAS_N : out std_logic;
	DRAM_CAS_N : out std_logic;
	DRAM_CS_N : out std_logic;
	DRAM_BA : out std_logic_vector(1 downto 0);
	hs : out std_logic;
	vs : out std_logic;
	r : out unsigned(7 downto 0);
	g : out unsigned(7 downto 0);
	b : out unsigned(7 downto 0);
	vena : out std_logic;
	pixel : out std_logic
);
end component;


begin

sdr_cke<='1';

mysdramtest : component sdramtest
generic map(
	sysclk_frequency => sysclk_frequency
)
port map(
	clk => clk,
	slowclk => slowclk,
	reset_in => reset_in,
	
	DRAM_DRIVE_DQ => sdr_drive_data,
	DRAM_DQ_IN => sdr_data_in,
	DRAM_DQ_OUT => sdr_data_out,
	DRAM_ADDR => sdr_addr,
	DRAM_LDQM => sdr_dqm(0),
	DRAM_UDQM => sdr_dqm(1),
	DRAM_WE_N => sdr_we,
	DRAM_RAS_N => sdr_ras,
	DRAM_CAS_N => sdr_cas,
	DRAM_CS_N => sdr_cs,
	DRAM_BA => sdr_ba,
	hs => vga_hsync,
	vs => vga_vsync,
	r => vga_red,
	g => vga_green,
	b => vga_blue,
	vena => vga_window
);

	
end architecture;
