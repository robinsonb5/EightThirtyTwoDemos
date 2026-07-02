library ieee;
use ieee.std_logic_1164.all;

package JCapture_Pkg is

	component jcapture is
	generic (
		userwidth : integer := 32;
		capturewidth : integer := 32;
		capturedepth : integer := 9;
		triggerwidth : integer := 32;
		userirwidth : integer := 4; -- Can be a maxmium of 4.
		runlengthencoding : integer := 1; -- Disable to reduce logic footprint and increase speed.
		designid : integer :=  16#35ac#
	);
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		stb : in std_logic := '1'; -- Tied high if there's no incoming strobe
		capture_d : in std_logic_vector(capturewidth-1 downto 0);
		user_ir : out std_logic_vector(userirwidth-1 downto 0);
		user_ir_update : out std_logic;
		user_d : in std_logic_vector(userwidth-1 downto 0) := (others => '0');
		user_q : out std_logic_vector(userwidth-1 downto 0);
		user_update : out std_logic
	);
	end component;

end package;
