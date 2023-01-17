library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000; -- Sysclk frequency * 10 MHz
		jtag_uart : boolean := false;
		debug : boolean:=false
	);
	port (
		clk 			: in std_logic;
		slowclk		: in std_logic;
		videoclk	: in std_logic;
		reset_in 	: in std_logic;

		-- VGA
		vga_red 	: out unsigned(7 downto 0);
		vga_green 	: out unsigned(7 downto 0);
		vga_blue 	: out unsigned(7 downto 0);
		vga_hsync 	: out std_logic;
		vga_vsync 	: buffer std_logic;
		vga_window	: out std_logic;
		vga_pixel : out std_logic;

		-- SDRAM
		sdr_drive_data	: out std_logic;
		sdr_data_in		: in std_logic_vector(15 downto 0) := (others => '0');
		sdr_data_out	: out std_logic_vector(15 downto 0);
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
		rxd	: in std_logic :='1';
		txd	: out std_logic;
		rxd2	: in std_logic :='1';
		txd2	: out std_logic;
		
		-- Audio
		audio_l : out signed(15 downto 0);
		audio_r : out signed(15 downto 0)
);
end entity;

architecture rtl of VirtualToplevel is

constant sysclk_hz : integer := sysclk_frequency*1000;

signal reset_n : std_logic := '0';
signal reset : std_logic;
signal reset_counter : unsigned(15 downto 0) := X"FFFF";

-- Video signals
signal pixel_stb : std_logic;
signal hsync_n : std_logic;
signal vsync_n : std_logic;
signal hblank_n : std_logic;
signal vblank_n : std_logic;
signal xpos : unsigned(10 downto 0);
signal ypos : unsigned(10 downto 0);

begin

ps2k_dat_out<='1';
ps2k_clk_out<='1';
ps2m_dat_out<='1';
ps2m_clk_out<='1';

audio_l <= X"0000";
audio_r <= X"0000";

sdr_cke <='0'; -- Disable SDRAM for now
sdr_cs <='1'; -- Disable SDRAM for now
sdr_drive_data <='0';

sdr_data_out <=(others => 'Z');
sdr_addr <=(others => '1');
sdr_dqm <=(others => '1');
sdr_we <='1';
sdr_cas <='1';
sdr_ras <='1';
sdr_ba <=(others => '1');

spi_mosi <='1';
spi_clk <='1';
spi_cs<='1';


-- Reset counter.

process(clk)
begin
	if reset_in='0' then
		reset_counter<=X"FFFF";
		reset_n<='0';
	elsif rising_edge(clk) then
		reset_counter<=reset_counter-1;
		if reset_counter=X"0000" then
			reset_n<='1';
		end if;
	end if;
end process;

reset <= not reset_n;

-- Video generator

vtimings : entity work.video_timings
	port map (
		clk => videoclk,
		reset_n => reset_n,
		
		-- Sync / blanking
		pixel_stb => pixel_stb,
		hsync_n => hsync_n,
		vsync_n => vsync_n,
		hblank_n => hblank_n,
		vblank_n => vblank_n,
		
		-- Pixel positions
		xpos => xpos,
		ypos => ypos,
		clkdiv => to_unsigned(5,4)
	);

vga_red <= xpos(7 downto 0);
vga_green <= ypos(7 downto 0);
vga_blue <= unsigned(xpos(10 downto 7) & ypos(10 downto 7));
vga_hsync <= hsync_n;
vga_vsync <= vsync_n;
vga_window <= hblank_n and vblank_n;
vga_pixel <= pixel_stb;
	
end architecture;
