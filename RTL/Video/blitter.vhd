library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

use work.DMACache_pkg.ALL;

package blitter_pkg is
	constant blitterchannels : integer := 3; -- Channel 0 is output, 1 to blitterchannels-1 are inputs 
	type blitter_dma_requests is array (blitterchannels-2 downto 0) of DMAChannel_FromHost;
	type blitter_dma_responses is array (blitterchannels-2 downto 0) of DMAChannel_ToHost;
end package;


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
use work.blitter_pkg.all;

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
		dma_requests : out blitter_dma_requests;
		dma_responses : in blitter_dma_responses;
		dma_data : in std_logic_vector(dmawidth-1 downto 0);

		to_sdram : out sdram_port_request;
		from_sdram : in sdram_port_response;

		interrupt : out std_logic
	);
end entity;

-- Blitter's register map is as follows:

-- A 64-byte block appears n times in the memory map, once for each channel.
-- The general registers are aliased in each channel's block so it doesn't matter which one is written to.
-- (The first image is recommended.)

-- 0x00 - Rows (writing activates the blitter) 
-- 0x04 - Active (bit map of active channels - 0: output channel, ignored.  1 onwards: input channels )

-- 0x08 - Function select

-- 0x0c - 0x2c - currently free.

-- Per channel:
-- 0x30 - Address
-- 0x34 - Modulo - number of bytes to add after each row is transferred - in bytes.
-- 0x38 - Span - number of words (not bytes!) in each row of data.
-- 0x3c - Data - a constant which can be written if DMA for the channel is disabled.


architecture rtl of blitter is
	constant bltdest : integer := 0;
	constant bltsrc1 : integer := 1;
	
	type blitterchannel is record
		address  : unsigned(31 downto 0);
		modulo   : signed(15 downto 0);
		span     : unsigned(15 downto 0);
		data     : std_logic_vector(dmawidth-1 downto 0);
	end record;

	signal channels_active : std_logic_vector(blitterchannels-1 downto 0);
	signal channels_valid_n : std_logic_vector(blitterchannels-1 downto 1);
	signal function_select : std_logic_vector(7 downto 0);
	signal function_q : std_logic_vector(dmawidth-1 downto 0);

	signal rows : unsigned(15 downto 0) := (others => '0');

	type channels_t is array(blitterchannels-1 downto 0) of blitterchannel;
	signal channels : channels_t;
	
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
		signal setrows : std_logic;
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
				-- any read access will return the number of rows in bits 15 downto 0.
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');
				response.q(15 downto 0)<=std_logic_vector(rows);
			end if;
		end process;

		process(clk_sys,reset_n) begin
			if reset_n='0' then
				interrupt<='0';
			elsif rising_edge(clk_sys) then
				-- Clear the interrupt on any register read.
				if sel='1' and request.req='1' and request.wr='0' then
					interrupt<='0';
				end if;

				-- Raise an interrupt when a blit completes.
				if channels_active(0)='1' and rows=0 then
					interrupt<='1';
				end if;
			end if;
		end process;

		cpuchannel <= to_integer(unsigned(request.addr(7 downto 6)));


		setrows <= '1' when cpu_req='1' and running='0' and request.addr(5 downto 0) = "00"&X"0" else '0';

		process(clk_sys,reset_n) begin
			if reset_n='0' then
				rows <= (others => '0');
			elsif rising_edge(clk_sys) then

				if running='1' and write_newrow='1' then
					rows<=rows-1;
				end if;

				if setrows='1' then
					rows <= unsigned(request.d(15 downto 0));
				end if;

			end if;
		end process;


		process(clk_sys) begin
			if rising_edge(clk_sys) then

				if channels_active(0)='1' and rows=0 then
					channels_active(0)<='0';
				end if;
	
				if cpu_req='1' and running='0' then
					case request.addr(5 downto 0) is

						-- Writing to the Rows register activates the blitter
						when "00"&X"0" =>
							channels_active(0)<='1';

						-- The Active register
						when "00"&X"4" =>
							channels_active<=request.d(blitterchannels-1 downto 0);

						-- Function select
						when "00"&X"8" =>
							function_select<=request.d(7 downto 0);

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
					end if;
					
					if read_newrow='1' then
						for i in 1 to blitterchannels-1 loop
							channels(i).address<=unsigned(signed(channels(i).address)+channels(i).modulo+signed(channels(i).span&"00"));
						end loop;
					end if;

					-- Capture incoming DMA data.
					for i in 1 to blitterchannels-1 loop
						if dma_responses(i-1).valid='1' then
							channels(i).data<=dma_data;
						end if;
					end loop;
					
				end if;

			end if;
		end process;	

	end block;

	-- Temporary debugging - monitor incoming data for erroneous data.
	debugging : block
		attribute noprune : boolean;
		signal error : std_logic;
		attribute noprune of error : signal is true;
	begin
		process(clk_sys,reset_n) begin
			if rising_edge(clk_sys) then
				if reset_n='0' then
					error<='0';
				else
					for i in 1 to blitterchannels-1 loop
						if dma_responses(i-1).valid='1' then
							if dma_data(31 downto 24)/=X"00" then
								error <= '1';
							end if;
						end if;
					end loop;
				end if;
			end if;
		end process;
	end block;

	-- Compute various functions of the source data, and multiplex between them

	functionblock : block
		constant function_wordwise : natural := 7;
		constant function_shiftright : natural := 6;
		constant function_a : integer := 0;
		constant function_a_xor_b : integer := 1;
		constant function_a_plus_b : integer := 2;
		constant function_a_plus_b_clamped : integer := 3;
		-- Incoming data with some extra bits between the bytes
		signal a : std_logic_vector((dmawidth/8+dmawidth)-1 downto 0);
		signal b : std_logic_vector((dmawidth/8+dmawidth)-1 downto 0);
		signal q_t : std_logic_vector((dmawidth/8+dmawidth)-1 downto 0);
		signal q : std_logic_vector((dmawidth/8+dmawidth)-1 downto 0);
	begin

		-- Unpack source data with a guard bit between each byte
		process(channels(1).data) begin
			for i in dmawidth/8-1 downto 0 loop
				a(i*9+7 downto i*9) <= channels(1).data(i*8+7 downto i*8);
			end loop;
		end process;

		process(channels(2).data) begin
			for i in dmawidth/8-1 downto 0 loop
				b(i*9+7 downto i*9) <= channels(2).data(i*8+7 downto i*8);
			end loop;
		end process;

		-- In wordwise mode, bridge pairs of unpacked bytes with '1's.
		process(function_select) begin
			for i in dmawidth/16-1 downto 0 loop
				a(i*18+8) <= function_select(function_wordwise);
				b(i*18+8) <= function_select(function_wordwise);
				a(i*18+17) <= '0';
				b(i*18+17) <= '0';
			end loop;
		end process;

		-- Compute the function
		process(function_select,a,b)
			variable f : integer;
		begin
			f := to_integer(unsigned(function_select(3 downto 0)));
			case f is
				when function_a_plus_b =>
					q_t <= std_logic_vector(unsigned(a) + unsigned(b));

				when function_a_plus_b_clamped =>
					q_t <= std_logic_vector(unsigned(a) + unsigned(b));

				when others =>
					q_t<=a;
			end case;
		end process;

		q <= '0'&q_t(q_t'high downto 1) when function_select(function_shiftright)='1' else q_t;

		-- Pack the result	
		process(q) begin
			for i in dmawidth/8-1 downto 0 loop
				function_q(i*8+7 downto i*8) <= q(i*9+7 downto i*9);
			end loop;
		end process;

	end block;
	

	writeblock : block
		signal rowcounter : unsigned(15 downto 0);
		type writestate_t is (IDLE,WAITSRC,WAITACK);
		signal writestate : writestate_t;
		signal sdram_req : std_logic;
	begin

		write_newword<='1' when writestate=WAITSRC and src_ready='1' and rowcounter/=0 else '0';
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
							to_sdram.d<=function_q;
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
		signal channels_fetch : std_logic_vector(blitterchannels-1 downto 1);
		signal running_d : std_logic;
		signal newrow_d : std_logic;
		signal lastrow : std_logic;
	begin
	
		-- If any source channels are selected we must wait for data to be read.
		-- Otherwise we're using constant data and can proceed immediately.
		src_ready <= '1' when or_reduce(
				(channels_active(blitterchannels-1 downto 1)
					and channels_valid_n(blitterchannels-1 downto 1))) = '0'
						else '0';


		lastrow <= '1' when rows=1 else '0';
		read_newrow<=(write_newrow and not lastrow) or (running and not running_d);
		
		process(clk_sys) begin
			if rising_edge(clk_sys) then
			
				for i in 1 to blitterchannels-1 loop
					if dma_responses(i-1).valid='1' then
						channels_valid_n(i)<='0';
					end if;
					if dma_responses(i-1).done='1' then
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
					dma_requests(i-1).req<='0';
					if write_newword='1' or read_newrow='1' then
						dma_requests(i-1).req<=channels_active(i);
						channels_valid_n(i)<='1';
					end if;
				end loop;
	
			end if;
		end process;
		
		requestloop: for i in 1 to blitterchannels-1 generate
			dma_requests(i-1).setaddr<=channels_active(i) and read_newrow;
			dma_requests(i-1).setreqlen<=channels_active(i) and read_newrow;
			dma_requests(i-1).addr<=std_logic_vector(channels(i).address);
			dma_requests(i-1).reqlen<=channels(i).span;
		end generate;

	end block;

end architecture;

