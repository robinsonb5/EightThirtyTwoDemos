library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.math_real.all;

library work;
use work.board_config.all;

package sdram_controller_pkg is

	constant sdram_width : integer := board_sdram_width;
	constant sdram_dqmwidth : integer := board_sdram_width/8;
	constant sdram_rowbits : integer := board_sdram_rowbits;
	constant sdram_colbits : integer := board_sdram_colbits;

	constant sdram_col_low : integer := sdram_width/16; -- Correct only for 16 or 32 bit wide RAM
	constant sdram_col_high : integer := sdram_colbits+sdram_col_low-1;

	constant sdram_row_low : integer := sdram_col_high+1;
	constant sdram_row_high : integer := sdram_row_low+sdram_rowbits-1;

	constant sdram_bank_low : integer := sdram_row_high+1;
	constant sdram_bank_high : integer := sdram_bank_low+1;

	type sdram_port_request is record
		addr : std_logic_vector(31 downto 0);
		d : std_logic_vector(31 downto 0);
		wr : std_logic;
		bytesel : std_logic_vector(3 downto 0);
		req : std_logic;
		pri : std_logic;
	end record;
	
	type sdram_port_response is record
		busy : std_logic;	-- Indicate that the port is able to accept a write
		ack : std_logic;	-- For DMA ports, acknowledge the read request, for CPU port indicates a write was accepted
		burst : std_logic;	-- High while a burst is in progress
		strobe : std_logic; -- A high pulse for each 32-bit word of the transfer.
		q : std_logic_vector(31 downto 0); -- Data from SDRAM.
	end record;

	type sdram_phy_out is record
		drive : std_logic;
		d : std_logic_vector(sdram_width-1 downto 0);
		a : std_logic_vector(sdram_rowbits-1 downto 0);
		cas : std_logic;
		ras : std_logic;
		we : std_logic;
		cs : std_logic;
		cke : std_logic;
	end record;

	type sdram_phy_in is record
		q : std_logic_vector(sdram_width-1 downto 0);
	end record;

end package;

