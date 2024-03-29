-- Adapted by AMR from the Chameleon Minimig cfide.vhd file,
-- originally by Tobias Gubener.

-- spi_to_host contains data received from slave device.
-- Busy bit now has a signal of its own.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity spi_interface is
	port (
		sysclk : in std_logic;
		reset : in std_logic;

		-- Host interface
		spiclk_in : in std_logic;	-- Momentary high pulse
		host_to_spi : in std_logic_vector(7 downto 0);
		spi_to_host : out std_logic_vector(31 downto 0);
--		wide : in std_logic; -- 16-bit transfer (in only, 0xff will be transmitted for the second byte)
		trigger : in std_logic;  -- Momentary high pulse
		busy : buffer std_logic;

		-- Hardware interface
		miso : in std_logic;
		mosi : out std_logic;
		spiclk_out : out std_logic -- 50% duty cycle
	);
end entity;

architecture rtl of spi_interface is
signal sck : std_logic;
signal sd_shift : std_logic_vector(7 downto 0);
--signal sd_shift : std_logic_vector(31 downto 0);
signal shiftcnt : unsigned(5 downto 0);
begin

-----------------------------------------------------------------
-- SPI-Interface
-----------------------------------------------------------------	
	spiclk_out <= sck;
	busy <= shiftcnt(5) or trigger;
	spi_to_host <= X"000000"&sd_shift;

	PROCESS (sysclk, reset) BEGIN

		IF reset ='0' THEN 
			shiftcnt<=(others => '0');
			sck <= '0';
			mosi <= '1';
			sd_shift<=(others =>'1');
		ELSIF rising_edge(sysclk) then
			IF trigger='1' then
--				shiftcnt <= "1" & wide & wide & "111";  -- shift out 8 (or 32) bits, underflow will clear bit 5, mapped to busy
				shiftcnt <= "100111";  -- shift out 8 (or 32) bits, underflow will clear bit 5, mapped to busy
				sd_shift <= host_to_spi(7 downto 0); -- & X"FFFFFF";
				sck <= '1';
			ELSE
				IF spiclk_in='1' and busy='1' THEN
					IF sck='1' THEN
--						mosi<=sd_shift(31);
						mosi<=sd_shift(7);
						sck <='0';
					ELSE	
						sck <='1';
--						sd_shift <= sd_shift(30 downto 0)&miso;
						sd_shift <= sd_shift(6 downto 0)&miso;
						shiftcnt <= shiftcnt-1;
					END IF;
				END IF;
			END IF;
		end if;
	END PROCESS;

end architecture;
