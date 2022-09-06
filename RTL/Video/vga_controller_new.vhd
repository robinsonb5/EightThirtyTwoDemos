library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.sdram_controller_pkg.all;

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
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"E";
		enable_sprite : boolean := true;
		dmawidth : integer := 32
	);
	port (
		clk_sys : in std_logic;
		reset_n : in std_logic;
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		-- Sprite
		sprite0_sys : out DMAChannel_FromHost;
		sprite0_status : in DMAChannel_ToHost;
		spritedata : in std_logic_vector(dmawidth-1 downto 0);
		
		clk_video : in std_logic;
		
		to_sdram : out sdram_port_request;
		from_sdram : in sdram_port_response;

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
	constant PIX_16BIT : std_logic_vector(3 downto 0) := X"0";
	constant PIX_32BIT : std_logic_vector(3 downto 0) := X"1";
	constant PIX_MONO : std_logic_vector(3 downto 0) := X"2";
	constant PIX_CLUT4BIT : std_logic_vector(3 downto 0) := X"3";
	constant PIX_CLUT8BIT : std_logic_vector(3 downto 0) := X"4";
	signal framebuffer_pixelformat_l : std_logic_vector(3 downto 0) := PIX_16BIT;
	signal framebuffer_pixelformat : std_logic_vector(3 downto 0) := PIX_16BIT;
	
	signal framebuffer_pointer : std_logic_vector(31 downto 0) := X"00000000";
	signal framebuffer_update : std_logic;
	
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
	signal pixdiv : unsigned(5 downto 0):=to_unsigned(1,6);

	signal end_of_pixel : std_logic;
	signal nextword : std_logic;
	signal video_data : std_logic_vector(dmawidth-1 downto 0);

	signal vsync_r : std_logic;
	signal hsync_r : std_logic;
	signal vsync_d : std_logic;
	signal hsync_d : std_logic;
	signal vblank_r : std_logic;
	signal vblank_stb_vc : std_logic; -- In video clock domain
	signal vblank_stb : std_logic; -- In sys clock domain
	signal hblank_stb_vc : std_logic; -- In sys clock domain
	signal frame_stb_vc : std_logic;
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

	signal palette_idx_w : unsigned(7 downto 0);
	signal palette_data_w : std_logic_vector(23 downto 0);
	signal palette_w : std_logic;
	signal palette_idx_r : unsigned(7 downto 0);
	signal palette_data_r : std_logic_vector(23 downto 0);

begin

	process(clk_video) begin
		if rising_edge(clk_video) then
			vga_pixel <= end_of_pixel;
			if end_of_pixel = '1' then
				vsync<=vsync_d;
				vsync_d<=vsync_r xor invert_vs;
				hsync<=hsync_d;
				hsync_d<=hsync_r xor invert_hs;
				vga_window<=vga_window_r;
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
		frame_stb => frame_stb_vc,
		
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

	requestlogic : block
		signal sel : std_logic;
		signal req_d : std_logic;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				req_d <= request.req;
				cpu_req_sc<=sel and request.req and request.wr and not req_d;
			end if;
		end process;
		
		process(clk_sys) begin
			if rising_edge(clk_sys) then
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');	-- Maybe return a version number?
			end if;
		end process;
	end block;

	cdc_cpureq: entity work.cdc_bus
	generic map (
		width => 32
	)
	port map (
		clk_d => clk_sys,
		d => request.d,
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
		d => request.addr(7 downto 0),
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
			palette_w<='0';
			if cpu_req_vc='1' then
				case cpu_addr_vc is
					when X"04" =>
						framebuffer_pixelformat_l <= cpu_data_vc(3 downto 0);
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
					when X"40" =>
						palette_idx_w <= unsigned(cpu_data_vc(7 downto 0));
					when X"44" =>
						palette_data_w <= cpu_data_vc(23 downto 0);
						palette_w<='1';
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
				case request.addr(7 downto 0) is
					when X"00" =>
						framebuffer_pointer <= request.d;
						framebuffer_update <= '1';
					when X"80" =>
						sprite0_pointer <= request.d;
					when X"8c" =>
						sprite0_reqlen <= request.d(DMACache_ReqLenMaxBit downto 0);
					when others =>
						null;
				end case;
			end if;
		end if;
	end process;


	framebuffer : block
		signal pixelshift : std_logic_vector(31 downto 0);
		signal pixcounter : unsigned(5 downto 0) := (others =>'0');
		signal pixel_r : std_logic_vector(7 downto 0);
		signal pixel_g : std_logic_vector(7 downto 0);
		signal pixel_b : std_logic_vector(7 downto 0);
		signal format : std_logic_vector(9 downto 0);
	begin
	
		format <= framebuffer_pixelformat & std_logic_vector(pixcounter);

		with framebuffer_pixelformat_l select pixdiv <=
			"01"&X"f" when PIX_MONO,
			"00"&X"7" when PIX_CLUT4BIT,
			"00"&X"3" when PIX_CLUT8BIT,
			"00"&X"1" when PIX_16BIT,
			"00"&X"0" when others;
			

		process(framebuffer_pixelformat,pixelshift) begin
			if rising_edge(clk_video) then
				case framebuffer_pixelformat is
					when PIX_CLUT4BIT =>
						palette_idx_r<=X"0"&unsigned(pixelshift(31 downto 28));
					when PIX_CLUT8BIT =>
						palette_idx_r<=unsigned(pixelshift(31 downto 24));
					when others =>
						palette_idx_r<=X"00";
				end case;
			
				case framebuffer_pixelformat is
					when PIX_MONO =>
						if pixelshift(31)='1' then
							pixel_r<=(others => '1');
							pixel_g<=(others => '1');
							pixel_b<=(others => '1');
						else
							pixel_r<=(others => '0');
							pixel_g<=(others => '0');
							pixel_b<=(others => '0');
						end if;
					when PIX_CLUT4BIT =>
						pixel_r <= palette_data_r(23 downto 16);
						pixel_g <= palette_data_r(15 downto 8);
						pixel_b <= palette_data_r(7 downto 0);
					when PIX_CLUT8BIT =>
						pixel_r <= palette_data_r(23 downto 16);
						pixel_g <= palette_data_r(15 downto 8);
						pixel_b <= palette_data_r(7 downto 0);
					when PIX_16BIT =>
						pixel_r <= pixelshift(31 downto 27)&"000";
						pixel_g <= pixelshift(26 downto 21)&"00";
						pixel_b <= pixelshift(20 downto 16)&"000";
					when PIX_32BIT =>
						pixel_r <= pixelshift(31 downto 24);
						pixel_g <= pixelshift(23 downto 16);
						pixel_b <= pixelshift(15 downto 8);
					when others =>
						pixel_r<=(others => '0');
						pixel_g<=(others => '0');
						pixel_b<=(others => '0');
						null;
				end case;
			end if;
		end process;


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

					case framebuffer_pixelformat is
						when PIX_MONO =>
							pixelshift(pixelshift'high downto 1)<=pixelshift(pixelshift'high-1 downto 0);
						when PIX_CLUT4BIT =>
							pixelshift(pixelshift'high downto 4)<=pixelshift(pixelshift'high-4 downto 0);
						when PIX_CLUT8BIT =>
							pixelshift(pixelshift'high downto 8)<=pixelshift(pixelshift'high-8 downto 0);
						when PIX_16BIT =>
							pixelshift(pixelshift'high downto 16)<=pixelshift(pixelshift'high-16 downto 0);
						when PIX_32BIT =>
							null;
						when others =>
							null;
					end case;

					vga_window_r<='0';
					if hblank_r='1' and vblank_r='1' then
						vga_window_r<='1';
						-- Request next pixel from VGA cache
						-- Update pixelformat when a new fetch starts
						if pixcounter="00" then
							pixelshift(dmawidth-1 downto 0)<=video_data;
							nextword<='1';
							pixcounter<=pixdiv;
							framebuffer_pixelformat<=framebuffer_pixelformat_l;
						else
							pixcounter<=pixcounter-1;
						end if;						
					end if;
					
					if frame_stb_vc='1' then
						pixelshift(dmawidth-1 downto 0)<=video_data;
						nextword<='1';
						pixcounter<=(others => '0');
					end if;
						
				end if;
			end if;
		end process;
	end block;

-- FIFO

	fifo : entity work.VideoFIFO
	generic map (
		depth => 9,
		dmawidth => dmawidth
	)
	port map (
		sys_clk => clk_sys,
		sys_reset_n => reset_n,
		sys_baseaddr => framebuffer_pointer,
		sys_req => framebuffer_update,
		sys_newframe => vblank_stb,

		-- RAM Ports:
		from_sdram => from_sdram,
		to_sdram => to_sdram,

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

				spritefinished_sc_d<='0';
				spritefinished_sc<='0';
				if spritefetchctr=0 then
					spritefinished_sc<=not spritefinished_sc_d;
					spritefinished_sc_d<='1';
				end if;
				
			end if;
		end process;
		
		sprite0_sys.req <='1' when spritefetchctr/=0 and spritedata_req_sc='1' else '0';

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
		
		-- FIXME - integrate the sprite shifter into a CDC module, to save at least one cycle.
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
	
	paletteram : block
		type palette_storage_t is array (0 to 255) of std_logic_vector(23 downto 0);
		signal palette_storage : palette_storage_t;	
	begin
	
		process(clk_video) begin
			if rising_edge(clk_video) then
				if palette_w = '1' then
					palette_storage(to_integer(palette_idx_w)) <= palette_data_w;
				end if;
			end if;
		end process;

		process(clk_video) begin
			if rising_edge(clk_video) then
				palette_data_r<=palette_storage(to_integer(palette_idx_r));
			end if;
		end process;
	
	end block;
	
end architecture;
