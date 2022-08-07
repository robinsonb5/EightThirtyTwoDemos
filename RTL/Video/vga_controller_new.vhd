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

		-- Sprite
		sprite0_sys : out DMAChannel_FromHost;
		sprite0_status : in DMAChannel_ToHost;
		spritedata : in std_logic_vector(dmawidth-1 downto 0);
		
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
	signal xpos : unsigned(11 downto 0);
	signal ypos : unsigned(11 downto 0);

	signal clkdiv : unsigned(3 downto 0);

	signal end_of_pixel : std_logic;
	signal nextword : std_logic;
	signal video_data : std_logic_vector(dmawidth-1 downto 0);

	signal vsync_r : std_logic;
	signal hsync_r : std_logic;
	signal vblank_r : std_logic;
	signal vblank_stb_vc : std_logic; -- In video clock domain
	signal vblank_stb : std_logic; -- In sys clock domain
	signal hblank_stb_vc : std_logic; -- In sys clock domain
	signal hblank_r : std_logic;
	signal vga_window_r : std_logic;
	signal vga_window_d : std_logic;
	
	signal vgachannel_valid_d : std_logic;

	signal sprite0_pointer : std_logic_vector(31 downto 0);
	signal sprite0_reqlen : std_logic_vector(DMACache_ReqLenMaxBit downto 0);
	signal sprite0_xpos : unsigned(11 downto 0);
	signal sprite0_ypos : unsigned(11 downto 0);
	signal sprite0_width : unsigned(11 downto 0);
	signal sprite0_control : std_logic_vector(7 downto 0);
	signal spritepixel : std_logic_vector(3 downto 0);

	signal cpu_req_sc : std_logic;
	signal cpu_req_vc : std_logic;
	signal cpu_data_vc : std_logic_vector(31 downto 0);
	signal cpu_addr_vc : std_logic_vector(7 downto 0);

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
		hblank_stb => hblank_stb_vc,
		vblank_stb => vblank_stb_vc,
		
		-- Pixel positions
		xpos => xpos,
		ypos => ypos,

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

	cpu_req_sc<='1' when reg_req='1' and reg_rw='0' else '0';

	cdc_cpureq: entity work.cdc_bus
	generic map (
		width => 32
	)
	port map (
		clk_d => clk_sys,
		d => reg_data_in,
		d_stb => cpu_req_sc,
		clk_q => clk_video,
		q => cpu_data_vc,
		q_stb => cpu_req_vc
	);

	cdc_cpuaddr: entity work.cdc_bus
	generic map (
		width => 8
	)
	port map (
		clk_d => clk_sys,
		d => reg_addr_in,
		d_stb => cpu_req_sc,
		clk_q => clk_video,
		q => cpu_addr_vc
	);

	-- Handle CPU writes to registers on the Video clock domain (framing, sprite position)
	
	process(clk_video,reset_n)
	begin
		if reset_n='0' then
			hsize <= TO_UNSIGNED(640-1,12);
			htotal <= TO_UNSIGNED(800-1,12);
			hsstart <= TO_UNSIGNED(656-1,12);
			hsstop <= TO_UNSIGNED(752-1,12);
			vsize <= TO_UNSIGNED(480-1,12);
			vtotal <= TO_UNSIGNED(525-1,12);
			vsstart <= TO_UNSIGNED(500-1,12);
			vsstop <= TO_UNSIGNED(502-1,12);
			clkdiv <= TO_UNSIGNED(5,4);
		elsif rising_edge(clk_video) then
			if cpu_req_vc='1' then
				case cpu_addr_vc is
					when X"04" =>
						framebuffer_pixelformat <= cpu_data_vc(7 downto 0);
						invert_hs <= cpu_data_vc(30);
						invert_vs <= cpu_data_vc(31);
					when X"08" =>
						clkdiv <= unsigned(cpu_data_vc(3 downto 0));
					when X"10" =>
						htotal <= unsigned(cpu_data_vc(11 downto 0));
					when X"14" =>
						hsize <= unsigned(cpu_data_vc(11 downto 0));
					when X"18" =>
						hsstart <= unsigned(cpu_data_vc(11 downto 0));
					when X"1c" =>
						hsstop <= unsigned(cpu_data_vc(11 downto 0));
					when X"20" =>
						vtotal <= unsigned(cpu_data_vc(11 downto 0));
					when X"24" =>
						vsize <= unsigned(cpu_data_vc(11 downto 0));
					when X"28" =>
						vsstart <= unsigned(cpu_data_vc(11 downto 0));
					when X"2c" =>
						vsstop <= unsigned(cpu_data_vc(11 downto 0));
					when X"84" =>
						sprite0_xpos <= unsigned(cpu_data_vc(11 downto 0));
					when X"88" =>
						sprite0_ypos <= unsigned(cpu_data_vc(11 downto 0));
					when X"90" =>
						sprite0_width <= unsigned(cpu_data_vc(11 downto 0));
					when others =>
						null;
				end case;
			end if;
		end if;
	end process;

	-- Handle CPU writes to registers on the system clock domain (pointers)
	
	process(clk_sys,reset_n)
	begin
		if rising_edge(clk_video) then
			framebuffer_update <= '1';
			if cpu_req_sc='1' then
				case reg_addr_in is
					when X"00" =>
						framebuffer_pointer <= reg_data_in;
						framebuffer_update <= '1';
					when X"80" =>
						sprite0_pointer <= reg_data_in;
					when X"8c" =>
						sprite0_reqlen <= reg_data_in(DMACache_ReqLenMaxBit downto 0);
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

					if spritepixel(3)='0' then
						red <= unsigned(pixel_r);
						green <= unsigned(pixel_g);
						blue <= unsigned(pixel_b);
					else
						red <= (others=>spritepixel(2));
						green <= (others=>spritepixel(1));
						blue <= (others =>spritepixel(0));
					end if;

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
		sys_newframe => vblank_stb,

		-- RAM Ports:
		ram_req => video_req,
		ram_pri => video_pri,
		ram_addr => video_addr,
		ram_ack => video_ack,
		ram_fill => video_fill,
		ram_d => video_data_in,

		-- Video ports: (can be on a different clock domain)
		video_clk => clk_video,
		video_newframe => vblank_stb_vc,
		video_req => nextword,
		video_q => video_data
	);

	sprite: block
		-- Control signals in the system clock domain
		signal vblank_stb_d : std_logic;
		-- Sprite data in the system clock domain.
		signal spritedata_sc : std_logic_vector(dmawidth-1 downto 0);
		signal spritedata_stb_sc : std_logic;
		signal spritedata_req_sc : std_logic;

		-- Sprite data in the video clock domain.
		signal spritedata_vc : std_logic_vector(dmawidth-1 downto 0);
		signal spritedata_stb_vc : std_logic;
		signal spritedata_req_vc : std_logic;
		signal spriteshift : std_logic_vector(dmawidth-1 downto 0);
		signal spriteshiftcnt : unsigned(3 downto 0);
		signal spritectr : unsigned(11 downto 0);
		signal spriteena : std_logic;
		signal spriteactive : std_logic;
		signal spritefetchctr : unsigned(DMACache_ReqLenMaxBit downto 0);
		signal spritefinished_vc : std_logic;
		signal spritefinished_sc : std_logic;
		signal spritefinished_sc_d : std_logic;
	begin

		-- Fetch logic on system clock domain.
	
		process(clk_sys,reset_n) begin
			if reset_n='0' then
				sprite0_sys.req <='0';
				sprite0_sys.setaddr <='0';
				sprite0_sys.reqlen <= (others => '0');
				sprite0_sys.setreqlen <='1';
				sprite0_sys.addr <= (others => '0');
				sprite0_sys.setaddr <= '0';
			elsif rising_edge(clk_sys) then

				vblank_stb_d<=vblank_stb;

				-- Set the fetch length and address as vblank starts.
				sprite0_sys.setaddr <='0';
				sprite0_sys.setreqlen <='0';
				if vblank_stb='1' then
					sprite0_sys.addr<=sprite0_pointer;
					sprite0_sys.setaddr<='1';
					sprite0_sys.reqlen<=unsigned(sprite0_reqlen);
					sprite0_sys.setreqlen<='1';
					spritefetchctr<=unsigned(sprite0_reqlen);
				end if;					

				-- Latch the incoming sprite data (on the SDRAM clock)
				-- and create a strobe to trigger CDC.
				spritedata_stb_sc<='0';
				if sprite0_status.valid='1' then
					spritedata_sc<=spritedata;
					spritedata_stb_sc<='1';
					spritefetchctr<=spritefetchctr-1;
				end if;
				
				sprite0_sys.req<='0';
				if spritefetchctr/=0 and (vblank_stb_d='1' or spritedata_req_sc='1') then
					sprite0_sys.req<='1';
				end if;

				spritefinished_sc_d<='0';
				spritefinished_sc<='0';
				if spritefetchctr=0 then
					spritefinished_sc<=not spritefinished_sc_d;
					spritefinished_sc_d<='1';
				end if;
				
			end if;
		end process;
		
		-- Display logic on video clock domain
		
		process(clk_video,reset_n) begin
			if reset_n='0' then
			
			elsif rising_edge(clk_video) then
				spritedata_req_vc <= '0';
				
				if ypos=sprite0_ypos then
					spriteactive<='1';
				end if;

				spritedata_req_vc<='0';
				
				if vblank_stb='1' then -- Fetch the first word of sprite data immediate after vblank
					spritedata_req_vc <= '1';
					spriteactive<='0';
				end if;

				if xpos=sprite0_xpos and spriteactive='1' then -- Fetch the second word of data as soon as we start using the first
					spritectr<=sprite0_width-1;
					spriteshiftcnt<=to_unsigned(dmawidth/4-1,4);
					spriteena<='1';
					spriteshift<=spritedata_vc;
					spritedata_req_vc <= '1';
				end if;
				
				if end_of_pixel='1' then
					if spritectr/=0 then
						spritectr<=spritectr-1;
						spriteena<='1';
						spriteshift<=spriteshift(spriteshift'high-4 downto 0) & "0000";

						spriteshiftcnt<=spriteshiftcnt-1;
						if spriteshiftcnt=0 then	-- Fetch a new word any time we run out of pixels.
							spritedata_req_vc<='1';
							spriteshift<=spritedata_vc;
							spriteshiftcnt<=to_unsigned(dmawidth/4-1,4);
						end if;

					else
						spriteena<='0';
					end if;
				end if;
				
				if spritefinished_vc='1' then
					spriteactive<='0';
				end if;

			end if;

		end process;

		spritepixel <= spriteshift(spriteshift'high downto spriteshift'high-3) when spriteena='1' else "0000";
		
		cdc_spritedata: entity work.cdc_bus
		generic map (
			width => dmawidth
		)
		port map (
			clk_d => clk_sys,
			d => spritedata_sc,
			d_stb => spritedata_stb_sc,
			clk_q => clk_video,
			q => spritedata_vc,
			q_stb => spritedata_stb_vc
		);

		cdc_spritereq: entity work.cdc_pulse
		port map (
			clk_d => clk_video,
			d => spritedata_req_vc,
			clk_q => clk_sys,
			q => spritedata_req_sc
		);

		cdc_spritefinished: entity work.cdc_pulse
		port map (
			clk_d => clk_sys,
			d => spritefinished_sc,
			clk_q => clk_video,
			q => spritefinished_vc
		);
		
	end block;
	
end architecture;
