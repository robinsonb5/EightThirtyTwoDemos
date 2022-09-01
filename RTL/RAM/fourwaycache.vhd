-- Four way cache built from four Direct mapped caches

-- 32 bit address and data.
-- 8 word bursts, 32-bit SDRAM interface, so cachelines of 8 32-bit words

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.sdram_controller_pkg.all;

entity FourWayCache is
generic (
	addrmsb : integer := 25;
	cachemsb : integer := 11;
	burstlog2 : integer := 3
);
port (
	clk : in std_logic;
	reset : in std_logic;
	busy : out std_logic;
	flush : in std_logic;

	from_cpu : in sdram_port_request;
	to_cpu : out sdram_port_response;
	from_sdram : in sdram_port_response;
	to_sdram : out sdram_port_request
);
end entity;

architecture behavioural of FourWayCache is
	constant ways : integer := 4;
	constant cachebits : integer := cachemsb-1;
	constant tagbits : integer := cachebits-3;
	signal wayselect_ready : std_logic;
	signal wayselect_lru : std_logic_vector(1 downto 0);
	signal cpu_req_d : std_logic;
	signal cpu_req_d2 : std_logic;
	signal cache_cpu_req : std_logic_vector(ways-1 downto 0);
	signal way_hit : std_logic_vector(1 downto 0);
	signal way_chosen : std_logic_vector(1 downto 0);
	signal cache_valid : std_logic_vector(ways-1 downto 0);
	signal busy_i : std_logic;
begin

	to_sdram.addr <= from_cpu.addr;
	to_sdram.wr <= '0';

	waylogic : block
		signal way_req : std_logic;
		signal way_mru : std_logic_vector(1 downto 0);
	begin

		wayselect: entity work.wayselect
		generic map (
			cachelines => (2**(cachemsb-(burstlog2+1))),
			cacheline_slice_upper => cachemsb,
			cacheline_slice_lower => burstlog2+2
		)
		port map (
			clk => clk,
			reset_n => reset,
			ready => wayselect_ready,
			addr_in => from_cpu.addr,
			way_lru => wayselect_lru,
			req => way_req,
			way_mru => way_mru
		);

		process(clk,reset) begin
		
			if reset='0' then
				cpu_req_d<='0';
				cpu_req_d2<='0';
			elsif rising_edge(clk) then
				cpu_req_d2<=cpu_req_d;
				if from_cpu.req='1' and busy_i='0' then
					cpu_req_d<='1';
				end if;
				
				if from_cpu.req='0' then
					cpu_req_d<='0';
					cpu_req_d2<='0';
				end if;
			
			end if;
		end process;

		process(clk) begin
			if rising_edge(clk) then

				way_req <= '0';

				if from_cpu.req='0' then
					cache_cpu_req<=(others =>'0');
				end if;
				
				if cpu_req_d='1' and cpu_req_d2='0' then -- React to a delayed rising edge of cpu_req
					if from_cpu.wr='0' then -- Read cycle
						if cache_valid="0000" then
							way_chosen<=wayselect_lru;
							way_mru<=wayselect_lru;
							way_req<='1';
							case (wayselect_lru) is
								when "00" =>
									cache_cpu_req(0)<='1';
								when "01" =>
									cache_cpu_req(1)<='1';
								when "10" =>
									cache_cpu_req(2)<='1';
								when "11" =>
									cache_cpu_req(3)<='1';
								when others =>
									null;
							end case;
						else
							way_mru<=way_hit;
							way_req<='1';
						end if;
					end if;

				end if;
			
			end if;
		end process;
	end block;
	
	
	cachelogic : block
		signal cache_ready : std_logic_vector(ways-1 downto 0);
		signal cache_busy : std_logic_vector(ways-1 downto 0);
		signal cache_sdram_fill : std_logic_vector(ways-1 downto 0);
		signal cache_sdram_req : std_logic_vector(ways-1 downto 0);
		type cachedata_t is array(0 to 3) of std_logic_vector(31 downto 0);
		signal cachedata : cachedata_t;

		attribute noprune : boolean;
		signal cacheerr : std_logic;
		attribute noprune of cacheerr : signal is true;
		
	begin
	
		cacheloop: for i in 0 to ways-1 generate
			signal req : std_logic;
		begin

			req <= '1' when cache_cpu_req(i)='1' or (from_cpu.req='1' and from_cpu.wr='1') else '0';

			cacheway: entity work.DirectMappedCache
				generic map (
					cachemsb => cachemsb,
					burstlog2 => burstlog2
				)
				port map (
					clk => clk,
					reset => reset,
					ready => cache_ready(i),
					cpu_addr => from_cpu.addr,
					cpu_req => req,
					cpu_cachevalid => cache_valid(i),
					cpu_wr => from_cpu.wr,
					bytesel => from_cpu.bytesel,
					data_to_cpu => cachedata(i),
					-- SDRAM interface
					data_from_sdram => from_sdram.q,
					sdram_req => cache_sdram_req(i),
					sdram_fill => cache_sdram_fill(i),
					busy => cache_busy(i),
					flush => flush
				);
			
			cache_sdram_fill(i) <= from_sdram.burst when way_chosen=std_logic_vector(to_unsigned(i,2)) else '0';
		end generate;

		way_hit <= "00" when cache_valid(0)='1' else
			"01" when cache_valid(1)='1' else
			"10" when cache_valid(2)='1' else
			"11";

		to_cpu.q<=cachedata(0) when cache_valid(0)='1' else
			cachedata(1) when cache_valid(1)='1' else
			cachedata(2) when cache_valid(2)='1' else
			cachedata(3);
			
		to_cpu.ack<='0' when cache_valid="0000" or (from_cpu.req='0' or from_cpu.wr='1') else '1';
		to_sdram.req<='0' when cache_sdram_req="0000" else '1';
		
		busy_i <= '0' when cache_busy="0000" else '1';
		busy <= busy_i when wayselect_ready='1' and cache_ready="1111" else '1';

		process(clk) begin
			if rising_edge(clk) then
				cacheerr<='1';
				case cache_valid is
					when "0000" =>
						cacheerr<='0';
					when "0001" =>
						cacheerr<='0';
					when "0010" =>
						cacheerr<='0';
					when "0100" =>
						cacheerr<='0';
					when "1000" =>
						cacheerr<='0';
					when others =>
						null;
				end case;
			end if;
		end process;
		
	end block;

end architecture;
