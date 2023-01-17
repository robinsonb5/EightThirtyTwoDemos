library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity karplus_strong is
generic (
	datawidth : integer :=16;
	depthbits : integer :=12
);
port (
	clk : in std_logic;
	reset_n : in std_logic;
	ena : in std_logic;
	filter_ena : in std_logic;
	excite : in std_logic;
	d : in unsigned(datawidth-1 downto 0);
	q : out unsigned(datawidth-1 downto 0)
);
end entity;

architecture behavioural of karplus_strong is
	type storage_t is array(2**depthbits-1 downto 0) of unsigned(datawidth-1 downto 0);
	signal storage : storage_t;
	signal ptr : unsigned(depthbits-1 downto 0);
	signal filter_d : unsigned(datawidth-1 downto 0);
	signal filter_q : unsigned(datawidth-1 downto 0);
	
	component iirfilter_mono
	generic (
		signalwidth : integer;
		cbits : integer;
		immediate : integer
	);
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		ena : in std_logic;
		d : in unsigned(signalwidth-1 downto 0);
		q : out unsigned(signalwidth-1 downto 0)
	);
	end component;

begin

	filter : entity work.iirfilter_shift
		generic map (
			signalwidth => datawidth,
			cbits => 5
		)
		port map (
			clk => clk,
			reset_n => reset_n,
			ena => filter_ena,
			d => filter_d,
			q => filter_q
		);

	process(clk, reset_n) begin
		if reset_n='0' then
			filter_d(datawidth-1)<='1';
			filter_d(datawidth-2 downto 0) <= (others => '0');
			ptr<=(others => '0');
		elsif rising_edge(clk) then
			if ena='1' then
				ptr<=ptr+1;
			end if;
			filter_d<=storage(to_integer(ptr));
		end if;
	end process;

	sumandclamp : block
		signal sum : unsigned(datawidth downto 0);
		signal sum_clamped : unsigned(datawidth-1 downto 0);
		signal msbs : unsigned(1 downto 0);
	begin

		sum <= unsigned('0'&filter_q) + unsigned(d(datawidth-1)&d);
		msbs <= sum(sum'high downto sum'high-1);

		process(clk) begin
			if rising_edge(clk) then
				case msbs is
					when "00" =>
						sum_clamped<=sum(datawidth-1 downto 0);
					when "01" =>
						sum_clamped<=sum(datawidth-1 downto 0);
					when "10" =>
						sum_clamped<=(others => '1');
					when "11" =>
						sum_clamped<=(others => '0');
					when others =>
						null;
				end case;
	
				if excite='1' then
					sum_clamped<=d;
				end if;
								
				if ena='1' then
					storage(to_integer(ptr))<=sum_clamped;
				end if;

				q<=sum_clamped;

			end if;
			
		end process;
	end block;

end architecture;

