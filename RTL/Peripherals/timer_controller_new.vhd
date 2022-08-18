library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;

-- Timer controller module

entity timer_controller_new is
  generic(
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"C";
		prescale : integer := 1; -- Prescale incoming clock
		timers : integer := 0 -- This is a power of 2, so zero means 1 counter, 4 means 16 counters...
	);
  port (
		clk : in std_logic;
		reset : in std_logic; -- active low

		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		ticks : out std_logic_vector(2**timers-1 downto 0)
	);
end entity;
	
architecture rtl of timer_controller_new is
	constant prescale_adj : integer := prescale-1;
	signal prescale_counter : unsigned(15 downto 0);
	signal prescaled_tick : std_logic;
	type timer_counters is array (2**timers-1 downto 0) of unsigned(23 downto 0);
	signal timer_counter : timer_counters;
	signal timer_limit : timer_counters;
	signal timer_enabled : std_logic_vector(2**timers-1 downto 0);
	signal timer_index : unsigned(7 downto 0);
begin

	-- Prescaled tick
	process(clk,reset)
	begin
		if reset='0' then
			prescale_counter<=(others=>'0');
		elsif rising_edge(clk) then
			prescaled_tick<='0';
			prescale_counter<=prescale_counter-1;
			if prescale_counter=X"0000" then
				prescaled_tick<='1';
				prescale_counter<=to_unsigned(prescale_adj,16);
			end if;
		end if;
	end process;

	-- The timers proper;
	process(clk,reset)
	begin
		if reset='0' then
			for I in 0 to (2**timers-1) loop
				timer_counter(I)<=(others => '0');
			end loop;
		elsif rising_edge(clk) then
			ticks<=(others => '0');
			if prescaled_tick='1' then
				for I in 0 to (2**timers-1) loop
					if timer_enabled(I)='1' then
						timer_counter(I)<=timer_counter(I)-1;
						if timer_counter(I)=X"000000" then
							timer_counter(I)<=timer_limit(I);
							ticks(I)<='1';
						end if;
					end if;
				end loop;
			end if;
		end if;
	end process;

	-- Handle CPU access to hardware registers
	
	requestlogic : block
		signal sel : std_logic;
		signal req_d : std_logic;
		signal cpu_req : std_logic;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk) begin
			if rising_edge(clk) then
				req_d <= request.req;
				cpu_req<=sel and request.req and request.wr and not req_d;
			end if;
		end process;
		
		process(clk) begin
			if rising_edge(clk) then
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');	-- Maybe return a version number?
			end if;
		end process;
	
		process(clk,reset)
		begin
			if reset='0' then
				timer_enabled<=(others => '0');
			elsif rising_edge(clk) then
				if cpu_req='1' then -- Write access
					case request.addr(7 downto 0) is
						when X"00" =>
							timer_enabled<=request.d(2**timers-1 downto 0);
						when X"04" =>
							timer_index<=unsigned(request.d(7 downto 0));
						when X"08" =>
							timer_limit(to_integer(timer_index(timers downto 0)))<=
								unsigned(request.d(23 downto 0));					
						when others =>
							null;
					end case;
				end if;
			end if;
		end process;
	end block;
			
end architecture;
