library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Simplistic IIR low-pass filter, implemented with bit shifting.
-- function is simply y += b * (x - y)
-- where b=1/(1<<cbits)

entity iirfilter_shift is
	generic (
		signalwidth : integer :=16;
		cbits : integer := 5;
		highpass : boolean := false
	);
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		ena : in std_logic;
		d : in unsigned(signalwidth-1 downto 0);
		q : out unsigned(signalwidth-1 downto 0)
	);
end entity;

architecture behavioural of iirfilter_shift is
	constant midpoint : unsigned(signalwidth+cbits-1 downto 0) := to_unsigned(2 ** (signalwidth+cbits-2),signalwidth+cbits);
	signal acc : unsigned(signalwidth+cbits-1 downto 0);
	signal acc_new : unsigned(signalwidth+cbits-1 downto 0);
	signal delta : unsigned(signalwidth+cbits downto 0);
	signal delta_ext : unsigned(signalwidth+cbits-1 downto 0);
begin

	delta <= unsigned('0' & d & to_unsigned(0,cbits)) - unsigned('0' & acc);
	delta_ext(signalwidth+cbits-1 downto signalwidth) <= (others => delta(delta'high));
	delta_ext(signalwidth-1 downto 0) <= delta(signalwidth+cbits-1 downto cbits);
	acc_new <= acc + delta_ext;

	process(clk, reset_n) begin
		if reset_n='0' then
			acc <= midpoint;
		elsif rising_edge(clk) then
			if ena='1' then
				acc <= acc_new;
			end if;
		end if;
	end process;

	genhighpass : if highpass=true generate
		q <= midpoint + acc - d;
	end generate;
	
	genlowpass : if highpass=false generate
		q <= acc(signalwidth+cbits-1 downto cbits);	
	end generate;

end architecture;

