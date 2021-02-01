
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.rom_pkg.all;

entity QuadTest_rom is
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
	to_soc : out fromROM;
	from_soc2 : in toROM := (memAWriteEnable=>'0', others => (others=>'0'));
	to_soc2 : out fromROM
);
end entity;

architecture rtl of QuadTest_rom is

	alias be1 is from_soc.memAByteSel;
	alias we1 is from_soc.memAWriteEnable;
	alias data_in1 is from_soc.memAWrite;
	signal addr1 : integer range 0 to 2**maxAddrBitBRAM-1;
	alias data_out1 is to_soc.memARead;

	alias be2 is from_soc2.memAByteSel;
	alias we2 is from_soc2.memAWriteEnable;
	alias data_in2 is from_soc2.memAWrite;
	signal addr2 : integer range 0 to 2**maxAddrBitBRAM-1;
	alias data_out2 is to_soc2.memARead;

	--  build up 2D array to hold the memory
	type word_t is array (0 to BYTES-1) of std_logic_vector(BYTE_WIDTH-1 downto 0);
	type ram_t is array (0 to 2 ** (maxAddrBitBRAM-1) - 1) of word_t;

	signal ram : ram_t:=
	(
     0 => (x"04",x"87",x"da",x"01"),
     1 => (x"58",x"0e",x"87",x"dd"),
     2 => (x"0e",x"5a",x"59",x"5e"),
     3 => (x"00",x"00",x"29",x"27"),
     4 => (x"4a",x"26",x"0f",x"00"),
     5 => (x"48",x"26",x"49",x"26"),
     6 => (x"08",x"26",x"80",x"ff"),
     7 => (x"00",x"2a",x"27",x"4f"),
     8 => (x"27",x"4f",x"00",x"00"),
     9 => (x"00",x"00",x"00",x"7d"),
    10 => (x"dc",x"d1",x"4f",x"4f"),
    11 => (x"c0",x"c0",x"c1",x"4e"),
    12 => (x"49",x"dc",x"d1",x"86"),
    13 => (x"89",x"48",x"cc",x"d1"),
    14 => (x"c0",x"03",x"89",x"d0"),
    15 => (x"40",x"40",x"40",x"40"),
    16 => (x"81",x"d0",x"87",x"f6"),
    17 => (x"c1",x"50",x"c0",x"05"),
    18 => (x"87",x"f9",x"05",x"89"),
    19 => (x"d1",x"4c",x"ca",x"d1"),
    20 => (x"ad",x"74",x"4d",x"ca"),
    21 => (x"c4",x"87",x"c6",x"02"),
    22 => (x"f5",x"0f",x"6c",x"8c"),
    23 => (x"e4",x"cd",x"af",x"87"),
    24 => (x"04",x"4a",x"27",x"87"),
    25 => (x"27",x"4c",x"00",x"00"),
    26 => (x"00",x"00",x"04",x"4a"),
    27 => (x"02",x"ad",x"74",x"4d"),
    28 => (x"0f",x"24",x"87",x"c4"),
    29 => (x"fd",x"00",x"87",x"f7"),
    30 => (x"00",x"00",x"00",x"87"),
    31 => (x"4e",x"dc",x"d1",x"00"),
    32 => (x"86",x"c0",x"c0",x"c1"),
    33 => (x"cd",x"98",x"00",x"86"),
    34 => (x"98",x"00",x"87",x"e6"),
    35 => (x"5e",x"0e",x"87",x"fc"),
    36 => (x"0e",x"5d",x"5c",x"5b"),
    37 => (x"4a",x"71",x"86",x"fc"),
    38 => (x"4c",x"66",x"e0",x"c0"),
    39 => (x"c0",x"4b",x"cc",x"d1"),
    40 => (x"05",x"9a",x"72",x"7e"),
    41 => (x"cd",x"d1",x"87",x"cc"),
    42 => (x"48",x"cc",x"d1",x"4b"),
    43 => (x"c1",x"50",x"f0",x"c0"),
    44 => (x"9a",x"72",x"87",x"cd"),
    45 => (x"87",x"e4",x"c0",x"02"),
    46 => (x"72",x"4d",x"66",x"d4"),
    47 => (x"75",x"49",x"72",x"1e"),
    48 => (x"87",x"dc",x"ca",x"4a"),
    49 => (x"ee",x"c4",x"4a",x"26"),
    50 => (x"72",x"53",x"11",x"81"),
    51 => (x"ca",x"4a",x"75",x"49"),
    52 => (x"4a",x"70",x"87",x"ce"),
    53 => (x"9a",x"72",x"8c",x"c1"),
    54 => (x"87",x"df",x"ff",x"05"),
    55 => (x"06",x"ac",x"b7",x"c0"),
    56 => (x"e4",x"c0",x"87",x"dd"),
    57 => (x"87",x"c5",x"02",x"66"),
    58 => (x"c3",x"4a",x"f0",x"c0"),
    59 => (x"4a",x"e0",x"c0",x"87"),
    60 => (x"7a",x"97",x"0a",x"73"),
    61 => (x"8c",x"83",x"c1",x"0a"),
    62 => (x"01",x"ac",x"b7",x"c0"),
    63 => (x"d1",x"87",x"e3",x"ff"),
    64 => (x"dd",x"02",x"ab",x"cc"),
    65 => (x"4c",x"66",x"d8",x"87"),
    66 => (x"c1",x"1e",x"66",x"dc"),
    67 => (x"49",x"6b",x"97",x"8b"),
    68 => (x"86",x"c4",x"0f",x"74"),
    69 => (x"80",x"c1",x"48",x"6e"),
    70 => (x"d1",x"58",x"a6",x"c4"),
    71 => (x"ff",x"05",x"ab",x"cc"),
    72 => (x"48",x"6e",x"87",x"e6"),
    73 => (x"4d",x"26",x"8e",x"fc"),
    74 => (x"4b",x"26",x"4c",x"26"),
    75 => (x"31",x"30",x"4f",x"26"),
    76 => (x"35",x"34",x"33",x"32"),
    77 => (x"39",x"38",x"37",x"36"),
    78 => (x"44",x"43",x"42",x"41"),
    79 => (x"0e",x"00",x"46",x"45"),
    80 => (x"5d",x"5c",x"5b",x"5e"),
    81 => (x"ff",x"4b",x"71",x"0e"),
    82 => (x"9c",x"4c",x"13",x"4d"),
    83 => (x"c1",x"87",x"d7",x"02"),
    84 => (x"1e",x"66",x"d4",x"85"),
    85 => (x"66",x"d4",x"49",x"74"),
    86 => (x"74",x"86",x"c4",x"0f"),
    87 => (x"87",x"c6",x"05",x"a8"),
    88 => (x"05",x"9c",x"4c",x"13"),
    89 => (x"48",x"75",x"87",x"e9"),
    90 => (x"4c",x"26",x"4d",x"26"),
    91 => (x"4f",x"26",x"4b",x"26"),
    92 => (x"5c",x"5b",x"5e",x"0e"),
    93 => (x"86",x"e8",x"0e",x"5d"),
    94 => (x"c0",x"59",x"a6",x"c4"),
    95 => (x"c0",x"4d",x"66",x"e8"),
    96 => (x"48",x"a6",x"c8",x"4c"),
    97 => (x"97",x"6e",x"78",x"c0"),
    98 => (x"48",x"6e",x"4b",x"bf"),
    99 => (x"a6",x"c4",x"80",x"c1"),
   100 => (x"02",x"9b",x"73",x"58"),
   101 => (x"c8",x"87",x"ce",x"c6"),
   102 => (x"d6",x"c5",x"02",x"66"),
   103 => (x"48",x"a6",x"cc",x"87"),
   104 => (x"80",x"fc",x"78",x"c0"),
   105 => (x"4a",x"73",x"78",x"c0"),
   106 => (x"02",x"8a",x"e0",x"c0"),
   107 => (x"c3",x"87",x"c2",x"c3"),
   108 => (x"fc",x"c2",x"02",x"8a"),
   109 => (x"02",x"8a",x"c2",x"87"),
   110 => (x"8a",x"87",x"e4",x"c2"),
   111 => (x"87",x"f1",x"c2",x"02"),
   112 => (x"c2",x"02",x"8a",x"c4"),
   113 => (x"8a",x"c2",x"87",x"eb"),
   114 => (x"87",x"e5",x"c2",x"02"),
   115 => (x"c2",x"02",x"8a",x"c3"),
   116 => (x"8a",x"d4",x"87",x"e7"),
   117 => (x"87",x"f4",x"c0",x"02"),
   118 => (x"ff",x"c0",x"02",x"8a"),
   119 => (x"02",x"8a",x"ca",x"87"),
   120 => (x"c1",x"87",x"f1",x"c0"),
   121 => (x"df",x"c1",x"02",x"8a"),
   122 => (x"df",x"02",x"8a",x"87"),
   123 => (x"02",x"8a",x"c8",x"87"),
   124 => (x"c4",x"87",x"cd",x"c1"),
   125 => (x"e3",x"c0",x"02",x"8a"),
   126 => (x"02",x"8a",x"c3",x"87"),
   127 => (x"c2",x"87",x"e5",x"c0"),
   128 => (x"87",x"c8",x"02",x"8a"),
   129 => (x"d3",x"02",x"8a",x"c3"),
   130 => (x"87",x"f9",x"c1",x"87"),
   131 => (x"ca",x"48",x"a6",x"cc"),
   132 => (x"87",x"d1",x"c2",x"78"),
   133 => (x"c2",x"48",x"a6",x"cc"),
   134 => (x"87",x"c9",x"c2",x"78"),
   135 => (x"d0",x"48",x"a6",x"cc"),
   136 => (x"87",x"c1",x"c2",x"78"),
   137 => (x"1e",x"66",x"f0",x"c0"),
   138 => (x"1e",x"66",x"f0",x"c0"),
   139 => (x"4a",x"75",x"85",x"c4"),
   140 => (x"49",x"6a",x"8a",x"c4"),
   141 => (x"c8",x"87",x"c8",x"fc"),
   142 => (x"a4",x"49",x"70",x"86"),
   143 => (x"87",x"e5",x"c1",x"4c"),
   144 => (x"c1",x"48",x"a6",x"c8"),
   145 => (x"87",x"dd",x"c1",x"78"),
   146 => (x"1e",x"66",x"f0",x"c0"),
   147 => (x"4a",x"75",x"85",x"c4"),
   148 => (x"49",x"6a",x"8a",x"c4"),
   149 => (x"0f",x"66",x"f0",x"c0"),
   150 => (x"84",x"c1",x"86",x"c4"),
   151 => (x"c0",x"87",x"c6",x"c1"),
   152 => (x"c0",x"1e",x"66",x"f0"),
   153 => (x"f0",x"c0",x"49",x"e5"),
   154 => (x"86",x"c4",x"0f",x"66"),
   155 => (x"f4",x"c0",x"84",x"c1"),
   156 => (x"48",x"a6",x"c8",x"87"),
   157 => (x"ec",x"c0",x"78",x"c1"),
   158 => (x"48",x"a6",x"d0",x"87"),
   159 => (x"80",x"f8",x"78",x"c1"),
   160 => (x"e0",x"c0",x"78",x"c1"),
   161 => (x"ab",x"f0",x"c0",x"87"),
   162 => (x"c0",x"87",x"da",x"06"),
   163 => (x"d4",x"03",x"ab",x"f9"),
   164 => (x"49",x"66",x"d4",x"87"),
   165 => (x"4a",x"73",x"91",x"ca"),
   166 => (x"d4",x"8a",x"f0",x"c0"),
   167 => (x"a1",x"72",x"48",x"a6"),
   168 => (x"c1",x"80",x"f4",x"78"),
   169 => (x"02",x"66",x"cc",x"78"),
   170 => (x"c4",x"87",x"e9",x"c1"),
   171 => (x"c4",x"49",x"75",x"85"),
   172 => (x"69",x"48",x"a6",x"89"),
   173 => (x"ab",x"e4",x"c1",x"78"),
   174 => (x"c4",x"87",x"d8",x"05"),
   175 => (x"b7",x"c0",x"48",x"66"),
   176 => (x"87",x"cf",x"03",x"a8"),
   177 => (x"c1",x"49",x"ed",x"c0"),
   178 => (x"66",x"c4",x"87",x"fa"),
   179 => (x"88",x"08",x"c0",x"48"),
   180 => (x"d0",x"58",x"a6",x"c8"),
   181 => (x"66",x"d8",x"1e",x"66"),
   182 => (x"66",x"f8",x"c0",x"1e"),
   183 => (x"66",x"f8",x"c0",x"1e"),
   184 => (x"1e",x"66",x"dc",x"1e"),
   185 => (x"f6",x"49",x"66",x"d8"),
   186 => (x"86",x"d4",x"87",x"e4"),
   187 => (x"4c",x"a4",x"49",x"70"),
   188 => (x"c0",x"87",x"e1",x"c0"),
   189 => (x"cf",x"05",x"ab",x"e5"),
   190 => (x"48",x"a6",x"d0",x"87"),
   191 => (x"80",x"c4",x"78",x"c0"),
   192 => (x"80",x"f4",x"78",x"c0"),
   193 => (x"87",x"cc",x"78",x"c1"),
   194 => (x"1e",x"66",x"f0",x"c0"),
   195 => (x"f0",x"c0",x"49",x"73"),
   196 => (x"86",x"c4",x"0f",x"66"),
   197 => (x"4b",x"bf",x"97",x"6e"),
   198 => (x"80",x"c1",x"48",x"6e"),
   199 => (x"73",x"58",x"a6",x"c4"),
   200 => (x"f2",x"f9",x"05",x"9b"),
   201 => (x"e8",x"48",x"74",x"87"),
   202 => (x"26",x"4d",x"26",x"8e"),
   203 => (x"26",x"4b",x"26",x"4c"),
   204 => (x"1e",x"c0",x"1e",x"4f"),
   205 => (x"d0",x"1e",x"c4",x"cd"),
   206 => (x"66",x"d0",x"1e",x"a6"),
   207 => (x"87",x"f0",x"f8",x"49"),
   208 => (x"4f",x"26",x"8e",x"f4"),
   209 => (x"71",x"86",x"fc",x"1e"),
   210 => (x"49",x"c0",x"ff",x"4a"),
   211 => (x"c0",x"c4",x"48",x"69"),
   212 => (x"58",x"a6",x"c4",x"98"),
   213 => (x"f3",x"02",x"98",x"70"),
   214 => (x"48",x"79",x"72",x"87"),
   215 => (x"4f",x"26",x"8e",x"fc"),
   216 => (x"72",x"1e",x"73",x"1e"),
   217 => (x"e7",x"c0",x"02",x"9a"),
   218 => (x"c1",x"48",x"c0",x"87"),
   219 => (x"06",x"a9",x"72",x"4b"),
   220 => (x"82",x"72",x"87",x"d1"),
   221 => (x"73",x"87",x"c9",x"06"),
   222 => (x"01",x"a9",x"72",x"83"),
   223 => (x"87",x"c3",x"87",x"f4"),
   224 => (x"72",x"3a",x"b2",x"c1"),
   225 => (x"73",x"89",x"03",x"a9"),
   226 => (x"2a",x"c1",x"07",x"80"),
   227 => (x"87",x"f3",x"05",x"2b"),
   228 => (x"4f",x"26",x"4b",x"26"),
   229 => (x"c4",x"1e",x"75",x"1e"),
   230 => (x"a1",x"b7",x"71",x"4d"),
   231 => (x"c1",x"b9",x"ff",x"04"),
   232 => (x"07",x"bd",x"c3",x"81"),
   233 => (x"04",x"a2",x"b7",x"72"),
   234 => (x"82",x"c1",x"ba",x"ff"),
   235 => (x"fe",x"07",x"bd",x"c1"),
   236 => (x"2d",x"c1",x"87",x"ee"),
   237 => (x"c1",x"b8",x"ff",x"04"),
   238 => (x"04",x"2d",x"07",x"80"),
   239 => (x"81",x"c1",x"b9",x"ff"),
   240 => (x"26",x"4d",x"26",x"07"),
   241 => (x"86",x"f8",x"1e",x"4f"),
   242 => (x"c5",x"02",x"bf",x"f0"),
   243 => (x"05",x"bf",x"f0",x"87"),
   244 => (x"bf",x"f4",x"87",x"fb"),
   245 => (x"c4",x"90",x"c2",x"48"),
   246 => (x"80",x"c1",x"58",x"a6"),
   247 => (x"70",x"58",x"a6",x"c8"),
   248 => (x"1e",x"dc",x"d0",x"1e"),
   249 => (x"f0",x"87",x"ca",x"fd"),
   250 => (x"48",x"78",x"c0",x"48"),
   251 => (x"4f",x"26",x"8e",x"f0"),
   252 => (x"f0",x"86",x"f8",x"1e"),
   253 => (x"87",x"c5",x"02",x"bf"),
   254 => (x"fb",x"05",x"bf",x"f0"),
   255 => (x"48",x"bf",x"f4",x"87"),
   256 => (x"a6",x"c4",x"90",x"c2"),
   257 => (x"c8",x"80",x"c2",x"58"),
   258 => (x"1e",x"70",x"58",x"a6"),
   259 => (x"fc",x"1e",x"f4",x"d0"),
   260 => (x"48",x"f0",x"87",x"df"),
   261 => (x"f0",x"48",x"78",x"c0"),
   262 => (x"00",x"4f",x"26",x"8e"),
   263 => (x"6c",x"6c",x"65",x"48"),
   264 => (x"72",x"66",x"20",x"6f"),
   265 => (x"74",x"20",x"6d",x"6f"),
   266 => (x"61",x"65",x"72",x"68"),
   267 => (x"64",x"25",x"20",x"64"),
   268 => (x"00",x"00",x"00",x"0a"),
   269 => (x"6c",x"6c",x"65",x"48"),
   270 => (x"72",x"66",x"20",x"6f"),
   271 => (x"74",x"20",x"6d",x"6f"),
   272 => (x"61",x"65",x"72",x"68"),
   273 => (x"64",x"25",x"20",x"64"),
   274 => (x"64",x"25",x"00",x"0a"),
		others => (others => x"00")
	);
	signal q1_local : word_t;
	signal q2_local : word_t;

	-- Xilinx XST attributes
	attribute ram_style: string;
	attribute ram_style of ram: signal is "no_rw_check";

	-- Altera Quartus attributes
	attribute ramstyle: string;
	attribute ramstyle of ram: signal is "no_rw_check";

begin  -- rtl

	-- port 1

	addr1 <= to_integer(unsigned(from_soc.memAAddr(maxAddrBitBRAM downto 2)));

	-- Reorganize the read data from the RAM to match the output
	unpack_port1: for i in 0 to BYTES - 1 generate    
		data_out1(BYTE_WIDTH*(i+1) - 1 downto BYTE_WIDTH*i) <= q1_local((BYTES-1)-i);
	end generate;
        
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

	-- port 2

	addr2 <= to_integer(unsigned(from_soc2.memAAddr(maxAddrBitBRAM downto 2)));

	-- Reorganize the read data from the RAM to match the output
	unpack_port2: for i in 0 to BYTES - 1 generate    
		data_out2(BYTE_WIDTH*(i+1) - 1 downto BYTE_WIDTH*i) <= q2_local((BYTES-1)-i);
	end generate;

	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we2 = '1') then
				-- edit this code if using other than four bytes per word
				if(be2(3) = '1') then
					ram(addr2)(3) <= data_in2(7 downto 0);
				end if;
				if be2(2) = '1' then
					ram(addr2)(2) <= data_in2(15 downto 8);
				end if;
				if be2(1) = '1' then
					ram(addr2)(1) <= data_in2(23 downto 16);
				end if;
				if be2(0) = '1' then
					ram(addr2)(0) <= data_in2(31 downto 24);
				end if;
			end if;
			q2_local <= ram(addr2);
		end if;
	end process;

end rtl;
