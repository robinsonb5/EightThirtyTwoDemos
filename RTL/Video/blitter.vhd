library ieee;
use ieee.std_logic_1164.all;
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
		modulo   : unsigned(15 downto 0);
		span     : unsigned(15 downto 0);
		data     : std_logic_vector(dmawidth-1 downto 0);
		selected : std_logic;
	end record;

	type channels_t is array(blitterchannels-1 downto 0) of blitterchannel;
	signal channels : channels_t;

	signal rows : unsigned(15 downto 0) := (others => '0');

	signal running : std_logic;

	signal write_newrow : std_logic;
	signal write_newword : std_logic;

begin

	dma_request.req<='0';

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
				if channels(0).selected='1' and rows=0 then
					interrupt<='1';
					channels(0).selected<='0';
				end if;
	
				if cpu_req='1' and running='0' then
					case request.addr(5 downto 0) is

						-- Writing to the Rows register activates the blitter
						when "00"&X"0" =>
							rows <= unsigned(request.d(15 downto 0));
							channels(0).selected<='1';

						-- The Active register
						when "00"&X"4" =>
							for i in 1 to blitterchannels-1 loop -- The dest channel's bit is set on writing the row count
								channels(i).selected<=request.d(i);
							end loop;

						-- Per-channel registers for address, modulo, span and data, channels addressed via bits 7,6
						when "11"&X"0" =>
							channels(cpuchannel).address<=unsigned(request.d);
						when "11"&X"4" =>
							channels(cpuchannel).modulo<=unsigned(request.d(15 downto 0));
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
						channels(0).address<=channels(0).address+channels(0).modulo;
						rows<=rows-1;
					end if;
				end if;

			end if;
		end process;	

	end block;

	writeblock : block
		signal rowcounter : unsigned(15 downto 0);
		type writestate_t is (IDLE,WAITSRC,WAITACK);
		signal writestate : writestate_t;
		signal src_ready : std_logic;
		signal sdram_req : std_logic;
	begin
	
		src_ready <= '1' when channels(1).selected='0' else '0'; -- FIXME wait for a fetch here
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
end architecture;

