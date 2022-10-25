library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.DMACache_pkg.all;
use work.DMACache_config.all;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.sdram_controller_pkg.all;

entity blitter is
	generic(
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"B";
		dmawidth : integer := 32
	);
	port (
		clk_sys : in std_logic;
		reset_n : in std_logic;
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		-- Read data
		dma_request : out DMAChannel_FromHost;
		dma_response : in DMAChannel_ToHost;
		dma_data : in std_logic_vector(dmawidth-1 downto 0);

		to_sdram : out sdram_port_request;
		from_sdram : in sdram_port_response;

		interrupt : out std_logic
	);
end entity;

architecture rtl of blitter is
	constant blitterchannels : integer := 2;
	constant bltdest : integer := 0;
	constant bltsrc1 : integer := 1;
	
	type blitterchannel is record
		address  : unsigned(31 downto 0);
		modulo   : signed(15 downto 0);
		span     : unsigned(15 downto 0);
		data     : std_logic_vector(dmawidth-1 downto 0);
	end record;

	signal channels_active : std_logic_vector(blitterchannels-1 downto 0);
	signal channels_fetch : std_logic_vector(blitterchannels-1 downto 1);
	signal channels_valid_n : std_logic_vector(blitterchannels-1 downto 1);
	
	type channels_t is array(blitterchannels-1 downto 0) of blitterchannel;
	signal channels : channels_t;

	signal rows : unsigned(15 downto 0) := (others => '0');

	signal running : std_logic;

	signal write_newrow : std_logic;
	signal write_newword : std_logic;

	signal read_newrow : std_logic;
	signal read_ready : std_logic;

	signal src_ready : std_logic;
	
begin

	running <= '0' when rows=X"0000" else '1';


	-- Handle CPU access to hardware registers

	requestlogic : block
		signal sel : std_logic;
		signal req_d : std_logic;
		signal cpu_req : std_logic;
		signal cpuchannel : integer;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				req_d <= request.req;
				cpu_req<=sel and request.req and request.wr and not req_d;
			end if;
		end process;
		
		process(clk_sys) begin
			if rising_edge(clk_sys) then
				-- any access will clear the interrupt bit, reads will return the remaining number of rows.
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');
				response.q(15 downto 0)<=std_logic_vector(rows);
			end if;
		end process;


		cpuchannel <= to_integer(unsigned(request.addr(7 downto 6)));

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				-- Clear the interrupt on any register read.
				if sel='1' and request.req='1' and request.wr='0' then
					interrupt<='0';
				end if;

				-- Raise an interrupt when a blit completes.
				if channels_active(0)='1' and rows=0 then
					interrupt<='1';
					channels_active(0)<='0';
				end if;
	
				if cpu_req='1' and running='0' then
					case request.addr(5 downto 0) is

						-- Writing to the Rows register activates the blitter
						when "00"&X"0" =>
							rows <= unsigned(request.d(15 downto 0));
							channels_active(0)<='1';

						-- The Active register
						when "00"&X"4" =>
							channels_active<=request.d(blitterchannels-1 downto 0);

						-- Per-channel registers for address, modulo, span and data, channels addressed via bits 7,6
						when "11"&X"0" =>
							channels(cpuchannel).address<=unsigned(request.d);
						when "11"&X"4" =>
							channels(cpuchannel).modulo<=signed(request.d(15 downto 0));
						when "11"&X"8" =>
							channels(cpuchannel).span<=unsigned(request.d(15 downto 0));
						when "11"&X"C" =>
							channels(cpuchannel).data<=request.d;

						when others =>
							null;
					end case;
				end if;

				if running='1' then
					if write_newword='1' then
						channels(0).address<=channels(0).address+4;
					end if;

					if write_newrow='1' then
						channels(0).address<=unsigned(signed(channels(0).address)+channels(0).modulo);
						rows<=rows-1;
					end if;
					
					if read_newrow='1' then
						for i in 1 to blitterchannels-1 loop
							channels(i).address<=unsigned(signed(channels(i).address)+channels(i).modulo+signed(channels(i).span&"00"));
						end loop;
					end if;

					-- Capture incoming DMA data.
					for i in 1 to blitterchannels-1 loop
						if dma_response.valid='1' then
							channels(i).data<=dma_data;
						end if;
					end loop;
					
				end if;

			end if;
		end process;	

	end block;

	writeblock : block
		signal rowcounter : unsigned(15 downto 0);
		type writestate_t is (IDLE,WAITSRC,WAITACK);
		signal writestate : writestate_t;
		signal sdram_req : std_logic;
	begin

		process(channels) begin
		
		end process;

		write_newword<='1' when writestate=WAITSRC and src_ready='1' else '0';
		write_newrow <= '1' when from_sdram.ack='1' and rowcounter=0 else '0';

		to_sdram.req<=sdram_req;
		to_sdram.burst<='0';
		to_sdram.pri<='0';
		to_sdram.strobe<='0';

		process(clk_sys,reset_n) begin
			if reset_n='0' then
				writestate<=IDLE;
				sdram_req<='0';
			elsif rising_edge(clk_sys) then

				case writestate is
					when IDLE =>
						rowcounter<=channels(0).span;
						if running='1' then
							writestate<=WAITSRC;
						end if;
					when WAITSRC =>
						if running='0' then
							writestate<=IDLE;
						elsif src_ready='1' then
							sdram_req<='1'; -- Work around yosys-ghdl-plugin "wire not found $posedge" error
							to_sdram.addr<=std_logic_vector(channels(0).address);
							to_sdram.d<=channels(1).data;
							to_sdram.wr<='1';
							to_sdram.bytesel<="1111";
							rowcounter<=rowcounter-1;
							writestate<=WAITACK;
						end if;
						
					when WAITACK =>
						if from_sdram.ack='1' then
							sdram_req<='0';
							if write_newrow='1' then
								rowcounter<=channels(0).span;
							end if;
							writestate<=WAITSRC;
						end if;

				end case;
			
			end if;	
		end process;
		
	end block;
	
	
	readblock : block		
		signal running_d : std_logic;
	begin
	
		-- If any source channels are selected we must wait for data to be read.
		src_ready <= '1' when and_reduce(
				(channels_active(blitterchannels-1 downto 1)
					and channels_valid_n(blitterchannels-1 downto 1))) = '0'
						else '0';

--		read_newrow<='1' when running='1' and or_reduce(channels_fetch)='0' else '0';

		read_newrow<=write_newrow or (running and not running_d);
		
		process(clk_sys) begin
			if rising_edge(clk_sys) then

				for i in 1 to blitterchannels-1 loop
					if dma_response.valid='1' then
						channels_valid_n(i)<='0';
					end if;
					if dma_response.done='1' then
						channels_fetch(i)<='0';
					end if;
				end loop;

				if running='0' then
					for i in 1 to blitterchannels-1 loop
						channels_fetch(i)<='0';
						channels_valid_n(i)<='1';
					end loop;
				end if;

				running_d <= running;
				
				for i in 1 to blitterchannels-1 loop
					if read_newrow='1' then
						channels_fetch(i)<=channels_active(i);
					end if;
					dma_request.req<='0';
					if write_newword='1' or read_newrow='1' then
						dma_request.req<=channels_active(i);
						channels_valid_n(i)<='1';
					end if;
				end loop;
	
			end if;
		end process;
		
		requestloop: for i in 1 to blitterchannels-1 generate
			dma_request.setaddr<=channels_active(i) and read_newrow;
			dma_request.setreqlen<=channels_active(i) and read_newrow;
			dma_request.addr<=std_logic_vector(channels(i).address);
			dma_request.reqlen<=channels(i).span;
		end generate;

	end block;

end architecture;

