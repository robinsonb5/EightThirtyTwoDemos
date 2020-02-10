
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.rom_pkg.all;

entity Interrupts_ROM is
generic
	(
		maxAddrBitBRAM : natural := maxAddrBitBRAMLimit;
		BYTE_WIDTH : natural := 8;
		BYTES : natural := 4
--		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_soc : in toROM;
	to_soc : out fromROM
);
end entity;

architecture rtl of Interrupts_ROM is

	alias be1 is from_soc.memAByteSel;
	alias we1 is from_soc.memAWriteEnable;
	alias data_in1 is from_soc.memAWrite;
	signal addr1 : integer range 0 to 2**maxAddrBitBRAM-1;
	alias data_out1 is to_soc.memARead;

	--  build up 2D array to hold the memory
	type word_t is array (0 to BYTES-1) of std_logic_vector(BYTE_WIDTH-1 downto 0);
	type ram_t is array (0 to 2 ** (maxAddrBitBRAM-1) - 1) of word_t;

	signal ram : ram_t:=
	(
     0 => (x"87",x"e9",x"c0",x"05"),
     1 => (x"59",x"5e",x"58",x"0e"),
     2 => (x"48",x"f0",x"fe",x"0e"),
     3 => (x"c1",x"68",x"78",x"c0"),
     4 => (x"b9",x"67",x"d6",x"49"),
     5 => (x"49",x"59",x"a7",x"d7"),
     6 => (x"49",x"26",x"19",x"c1"),
     7 => (x"48",x"26",x"78",x"c1"),
     8 => (x"08",x"26",x"80",x"ff"),
     9 => (x"00",x"00",x"00",x"4f"),
    10 => (x"00",x"00",x"00",x"00"),
    11 => (x"c0",x"e0",x"c0",x"00"),
    12 => (x"48",x"c4",x"f0",x"4e"),
    13 => (x"c8",x"f0",x"78",x"c0"),
    14 => (x"e0",x"da",x"d8",x"48"),
    15 => (x"48",x"c0",x"f0",x"78"),
    16 => (x"f0",x"fe",x"78",x"c1"),
    17 => (x"ff",x"78",x"c1",x"48"),
    18 => (x"fc",x"4d",x"a7",x"df"),
    19 => (x"02",x"68",x"48",x"a5"),
    20 => (x"78",x"c0",x"87",x"f9"),
    21 => (x"e1",x"c1",x"02",x"6d"),
    22 => (x"07",x"e7",x"c1",x"05"),
    23 => (x"ea",x"87",x"ce",x"48"),
    24 => (x"63",x"69",x"54",x"87"),
    25 => (x"54",x"00",x"0a",x"6b"),
    26 => (x"0a",x"6b",x"63",x"6f"),
    27 => (x"1e",x"71",x"1e",x"00"),
    28 => (x"c0",x"ff",x"1e",x"72"),
    29 => (x"c4",x"4a",x"69",x"49"),
    30 => (x"f8",x"02",x"9a",x"c0"),
    31 => (x"79",x"05",x"10",x"87"),
    32 => (x"4a",x"26",x"87",x"f3"),
    33 => (x"4f",x"26",x"49",x"26"),
		others => (others => x"00")
	);
	signal q1_local : word_t;

	-- Xilinx XST attributes
	attribute ram_style: string;
	attribute ram_style of ram: signal is "no_rw_check";

	-- Altera Quartus attributes
	attribute ramstyle: string;
	attribute ramstyle of ram: signal is "no_rw_check";

begin  -- rtl

	addr1 <= to_integer(unsigned(from_soc.memAAddr(maxAddrBitBRAM downto 2)));

	-- Reorganize the read data from the RAM to match the output
	unpack: for i in 0 to BYTES - 1 generate    
		data_out1(BYTE_WIDTH*(i+1) - 1 downto BYTE_WIDTH*i) <= q1_local((BYTES-1)-i);
	end generate unpack;
        
	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we1 = '1') then
				-- edit this code if using other than four bytes per word
				if(be1(3) = '1') then
					ram(addr1)(3) <= data_in1(7 downto 0);
				end if;
				if be1(2) = '1' then
					ram(addr1)(2) <= data_in1(15 downto 8);
				end if;
				if be1(1) = '1' then
					ram(addr1)(1) <= data_in1(23 downto 16);
				end if;
				if be1(0) = '1' then
					ram(addr1)(0) <= data_in1(31 downto 24);
				end if;
			end if;
			q1_local <= ram(addr1);
		end if;
	end process;
  
end rtl;
