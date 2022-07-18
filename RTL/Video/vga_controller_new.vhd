library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;

-- VGA controller
-- a module to handle VGA output

-- Modified for ZPU use, data bus is now 32-bits wide.

-- Self-contained, must generate timings
-- Programmable, must provide hardware registers that will respond to
-- writes.  Registers will include:  (Decode a 4k chunk)

-- 0x00 - Framebuffer pointer
-- 0x04 - pixel format

-- 0x08 - clock divisor

-- 0x10 - htotal
-- 0x14 - hsstart
-- 0x18 - hbstart
-- 0x1c - hbstop

-- 0x20 - htotal
-- 0x24 - hsstart
-- 0x28 - hbstart
-- 0x2c - hbstop

entity vga_controller_new is
	generic(
		enable_sprite : boolean := true;
		dmawidth : integer := 16
	);
	port (
		clk_sys : in std_logic;
		reset_n : in std_logic;

		reg_addr_in : in std_logic_vector(7 downto 0); -- from host CPU
		reg_data_in: in std_logic_vector(31 downto 0);
		reg_rw : in std_logic;
		reg_req : in std_logic;

		clk_video : in std_logic;
		video_req : out std_logic;
		video_pri : out std_logic;
		video_ack : in std_logic;
		video_fill : in std_logic;
		video_addr : out std_logic_vector(31 downto 0);
		video_data_in : in std_logic_vector(dmawidth-1 downto 0);

		vblank_int : out std_logic;
		hsync : out std_logic; -- to monitor
		vsync : out std_logic; -- to monitor
		red : out unsigned(7 downto 0);		-- Allow for 8bpp even if we
		green : out unsigned(7 downto 0);	-- only currently support 16-bit
		blue : out unsigned(7 downto 0);		-- 5-6-5 output
		vga_window : out std_logic;	-- '1' during the display window
		vga_pixel : out std_logic
	);
end entity;
	
architecture rtl of vga_controller_new is
	signal framebuffer_pointer : std_logic_vector(31 downto 0) := X"00000000";
	signal framebuffer_update : std_logic;
	signal framebuffer_pixelformat : std_logic_vector(7 downto 0) := X"00";
	signal hsize : unsigned(11 downto 0);
	signal htotal : unsigned(11 downto 0);
	signal hsstart : unsigned(11 downto 0);
	signal hsstop : unsigned(11 downto 0);
	signal vsize : unsigned(11 downto 0);
	signal vtotal : unsigned(11 downto 0);
	signal vsstart : unsigned(11 downto 0);
	signal vsstop : unsigned(11 downto 0);
	signal invert_hs : std_logic;
	signal invert_vs : std_logic;

	signal clkdiv : unsigned(3 downto 0);

	signal end_of_pixel : std_logic;
	signal nextword : std_logic;
	signal video_data : std_logic_vector(dmawidth-1 downto 0);

	signal vsync_r : std_logic;
	signal hsync_r : std_logic;
	signal vblank_r : std_logic;
	signal vblank_stb : std_logic;
	signal hblank_r : std_logic;
	signal vga_window_r : std_logic;
	signal vga_window_d : std_logic;
	
	signal vgachannel_valid_d : std_logic;

begin

	process(clk_video) begin
		if rising_edge(clk_video) then
			vga_pixel <= end_of_pixel;
			if end_of_pixel = '1' then
				vsync<=vsync_r xor invert_vs;
				hsync<=hsync_r xor invert_hs;
			end if;
		end if;
	end process;

	vt : entity work.video_timings
	generic map (
		hFramingBits => 12,
		vFramingBits => 12
	)
	port map (
		-- System
		clk => clk_video,
		reset_n => reset_n,
		
		-- Sync / blanking
		pixel_stb => end_of_pixel,
		hsync_n => hsync_r,
		vsync_n => vsync_r,
		hblank_n => hblank_r,
		vblank_n => vblank_r,
		vblank_stb => vblank_stb,
		
		-- Pixel positions
--		xpos : out unsigned(hFramingBits-1 downto 0);
--		ypos : out unsigned(vFramingBits-1 downto 0);

		-- Framing parameters
		clkdiv => clkdiv,
		htotal => htotal,
		hbstart => hsize,
		hsstart => hsstart,
		hsstop => hsstop,

		vtotal => vtotal,
		vbstart => vsize,
		vsstart => vsstart,
		vsstop => vsstop
	);

	vblank_int <= vblank_stb;

	-- Handle CPU access to hardware registers

	process(clk_sys,reset_n)
	begin
		if reset_n='0' then
			hsize <= TO_UNSIGNED(640,12);
			htotal <= TO_UNSIGNED(800,12);
			hsstart <= TO_UNSIGNED(656,12);
			hsstop <= TO_UNSIGNED(752,12);
			vsize <= TO_UNSIGNED(480,12);
			vtotal <= TO_UNSIGNED(525,12);
			vsstart <= TO_UNSIGNED(500,12);
			vsstop <= TO_UNSIGNED(502,12);
			clkdiv <= TO_UNSIGNED(5,4);
		elsif rising_edge(clk_sys) then
			framebuffer_update <= '1';
			if reg_req='1' and reg_rw='0' then
				case reg_addr_in is
					when X"00" =>
						framebuffer_pointer <= reg_data_in;
						framebuffer_update <= '1';
					when X"04" =>
						framebuffer_pixelformat <= reg_data_in(7 downto 0);
						invert_hs <= reg_data_in(30);
						invert_vs <= reg_data_in(31);
					when X"08" =>
						clkdiv <= unsigned(reg_data_in(3 downto 0));
					when X"10" =>
						htotal <= unsigned(reg_data_in(11 downto 0));
					when X"14" =>
						hsize <= unsigned(reg_data_in(11 downto 0));
					when X"18" =>
						hsstart <= unsigned(reg_data_in(11 downto 0));
					when X"1c" =>
						hsstop <= unsigned(reg_data_in(11 downto 0));
					when X"20" =>
						vtotal <= unsigned(reg_data_in(11 downto 0));
					when X"24" =>
						vsize <= unsigned(reg_data_in(11 downto 0));
					when X"28" =>
						vsstart <= unsigned(reg_data_in(11 downto 0));
					when X"2c" =>
						vsstop <= unsigned(reg_data_in(11 downto 0));

					when others =>
						null;
				end case;
			end if;
		end if;
	end process;


	framebuffer : block
		signal pixcounter : unsigned(1 downto 0) := (others =>'0');
		signal pixel_r : std_logic_vector(7 downto 0);
		signal pixel_g : std_logic_vector(7 downto 0);
		signal pixel_b : std_logic_vector(7 downto 0);
		signal format : std_logic_vector(9 downto 0);
	begin
	
		format <= framebuffer_pixelformat & std_logic_vector(pixcounter);

		demux : if dmawidth=32 generate
			-- Demultiplex 
			process(video_data,format) begin
				case(format) is
					when X"00"&"00" =>
						pixel_r <= video_data(31 downto 27)&"000";
						pixel_g <= video_data(26 downto 21)&"00";
						pixel_b <= video_data(20 downto 16)&"000";
					when X"00"&"01" =>
						pixel_r <= video_data(15 downto 11)&"000";
						pixel_g <= video_data(10 downto 5)&"00";
						pixel_b <= video_data(4 downto 0)&"000";
					when X"01"&"00" =>
						pixel_r <= video_data(31 downto 24);
						pixel_g <= video_data(23 downto 16);
						pixel_b <= video_data(15 downto 8);
					when others =>
						pixel_r<=(others => '0');
						pixel_g<=(others => '0');
						pixel_b<=(others => '0');
				end case;		
			end process;
		end generate;
		
		demux16 : if dmawidth=16 generate
			pixel_r <= video_data(15 downto 11)&"000";
			pixel_g <= video_data(10 downto 5)&"00";
			pixel_b <= video_data(4 downto 0)&"000";		
		end generate;


		process(clk_video)
		begin			
			if rising_edge(clk_video) then
				nextword<='0';
				if end_of_pixel='1' then

					red <= unsigned(pixel_r);
					green <= unsigned(pixel_g);
					blue <= unsigned(pixel_b);

					vga_window_r<='0';
					if hblank_r='1' and vblank_r='1' then
						vga_window_r<='1';
						-- Request next pixel from VGA cache
						if pixcounter="00" then
							nextword<='1';
							case framebuffer_pixelformat is
								when X"00" =>
									pixcounter<="01";
								when others =>
									pixcounter<="00";
							end case;
						else
							pixcounter<=pixcounter-1;
						end if;						
					end if;
				end if;
			end if;
		end process;
	end block;

	vga_window<=vga_window_r;

-- FIFO

	fifo : entity work.VideoFIFO
	generic map (
		depth => 9
	)
	port map (
		sys_clk => clk_sys,
		sys_reset_n => reset_n,
		sys_baseaddr => framebuffer_pointer,
		sys_req => framebuffer_update,

		-- RAM Ports:
		ram_req => video_req,
		ram_pri => video_pri,
		ram_addr => video_addr,
		ram_ack => video_ack,
		ram_fill => video_fill,
		ram_d => video_data_in,

		-- Video ports: (can be on a different clock domain)
		video_clk => clk_video,
		video_newframe => vblank_stb,
		video_req => nextword,
		video_q => video_data
	);

end architecture;
