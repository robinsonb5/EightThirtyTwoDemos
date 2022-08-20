------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Copyright (c) 2009 Tobias Gubener                                        -- 
-- Subdesign fAMpIGA by TobiFlex                                            --
--                                                                          --
-- Second access slot, cache and 8-word burst added by AMR                  --
--                                                                          --
-- This source file is free software: you can redistribute it and/or modify --
-- it under the terms of the GNU General Public License as published        --
-- by the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                      --
--                                                                          --
-- This source file is distributed in the hope that it will be useful,      --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU General Public License for more details.                             --
--                                                                          --
-- You should have received a copy of the GNU General Public License        --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
--                                                                          --
------------------------------------------------------------------------------
------------------------------------------------------------------------------

 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity sdram_cached is
generic
	(
		rows : integer := 12;
		cols : integer := 8;
		cache : boolean := true;
		dcache : boolean := true
	);
port
	(
-- Physical connections to the SDRAM
	drive_sdata	: out std_logic;
	sdata_in		: in std_logic_vector(15 downto 0);
	sdata_out		: inout std_logic_vector(15 downto 0);
	sdaddr		: out std_logic_vector((rows-1) downto 0);
	sd_we		: out std_logic;	-- Write enable, active low
	sd_ras		: out std_logic;	-- Row Address Strobe, active low
	sd_cas		: out std_logic;	-- Column Address Strobe, active low
	sd_cs		: out std_logic;	-- Chip select - only the lsb does anything.
	dqm			: out std_logic_vector(1 downto 0);	-- Data mask, upper and lower byte
	ba			: out std_logic_vector(1 downto 0); -- Bank?

-- Housekeeping
	sysclk		: in std_logic;
	reset		: in std_logic;
	reset_out	: out std_logic;
	reinit : in std_logic :='0';

-- Port 0 - VGA
	vga_addr : in std_logic_vector(31 downto 0) := X"00000000";
	vga_data	: out std_logic_vector(15 downto 0);
	vga_req : in std_logic := '0';
	vga_fill : out std_logic;
	vga_ack : out std_logic;
	vga_nak : out std_logic;
	vga_refresh : in std_logic :='1'; -- SDRAM won't come out of reset without this.
	vga_reservebank : in std_logic :='0'; -- Keep a bank clear for instant access in slot 1
	vga_reserveaddr : in std_logic_vector(31 downto 0) :=X"00000000";

	-- Port 1
	datawr1		: in std_logic_vector(31 downto 0);	-- Data in
	addr1		: in std_logic_vector(31 downto 0);	-- Address in
	req1		: in std_logic;
	cachevalid : out std_logic;
	bytesel	: in std_logic_vector(3 downto 0);
	wr1			: in std_logic;	-- Read (1) / write (0) 
	dataout1		: out std_logic_vector(31 downto 0);
	ack1	: buffer std_logic;
	-- Port 2 - instructions only
	Addr2		: in std_logic_vector(31 downto 0):=X"00000000";
	req2		: in std_logic:='0';
	cachevalid2 : out std_logic;
	dataout2		: out std_logic_vector(31 downto 0);
	ack2	: buffer std_logic;
	--
	flushcaches : in std_logic:='0'
	);
end;

architecture rtl of sdram_cached is

constant bank_high : integer := (rows+cols+2);
constant bank_low : integer := (rows+cols+1);

constant row_high : integer := (rows+cols);
constant row_low : integer := (cols+1);

constant col_high : integer := cols;
constant col_low : integer := 1;

signal initstate	:unsigned(3 downto 0);	-- Counter used to initialise the RAM
signal cas_dqm		:std_logic_vector(1 downto 0);	-- ...mask register for entire burst
signal init_done	:std_logic :='0';
signal datain		:std_logic_vector(15 downto 0);
signal casaddr		:std_logic_vector(31 downto 0);
signal sdwrite 		:std_logic;
signal sdata_reg	:std_logic_vector(15 downto 0);

type sdram_states is (ph0,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,ph10,ph11,ph12,ph13,ph14,ph15);
signal sdram_state		: sdram_states;

type sdram_ports is (idle,refresh,port0,port1,port2,writecache);

signal sdram_slot1 : sdram_ports :=refresh;
signal sdram_slot2 : sdram_ports :=idle;

-- Since VGA has absolute priority, we keep track of the next bank and disallow accesses
-- to either the current or next bank in the interleaved access slots.
signal slot1_bank : std_logic_vector(1 downto 0) := "00";
signal slot2_bank : std_logic_vector(1 downto 0) := "11";

signal slot1_fill : std_logic;
signal slot2_fill : std_logic;

signal slot1_ack : std_logic;
signal slot2_ack : std_logic;

-- refresh timer - once per scanline, so don't need the counter...
-- signal refreshcounter : unsigned(12 downto 0);	-- 13 bits gives us 8192 cycles between refreshes => pretty conservative.
signal refreshpending : std_logic :='0';

type writecache_states is (waitwrite,fill,finish);
signal writecache_state : writecache_states;

signal writecache_addr : std_logic_vector(31 downto 0);
signal writecache_word0 : std_logic_vector(15 downto 0);
signal writecache_word1 : std_logic_vector(15 downto 0);
signal writecache_dqm : std_logic_vector(7 downto 0);
signal writecache_req : std_logic;
signal writecache_ack : std_logic;
signal writecache_dirty : std_logic;
signal writecache_sdack : std_logic;

signal readcache_addr : std_logic_vector(31 downto 0);
signal readcache_req : std_logic;
signal readcache_req_e : std_logic;
signal readcache_ack : std_logic;
signal readcache_fill : std_logic;
signal readcache_busy : std_logic;

signal readcache2_addr : std_logic_vector(31 downto 0);
signal readcache2_req : std_logic;
signal readcache2_req_e : std_logic;
signal readcache2_ack : std_logic;
signal readcache2_fill : std_logic;
signal readcache2_busy : std_logic;

signal longword : std_logic_vector(31 downto 0);
signal longword2 : std_logic_vector(31 downto 0);

signal cache_ready : std_logic;
signal cache2_ready : std_logic;

COMPONENT TwoWayCache
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset	: IN std_logic;
		ready : out std_logic;
		cpu_addr		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		cpu_req		:	 IN STD_LOGIC;
		cpu_ack		:	 OUT STD_LOGIC;
		cpu_cachevalid		:	 OUT STD_LOGIC;
		cpu_wr		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic;
		debug : out std_logic_vector(2 downto 0)
	);
END COMPONENT;

COMPONENT DirectMappedCache
generic
	(
		cachebits : integer := 10
	);
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset	: IN std_logic;
		ready : out std_logic;
		cpu_addr		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		cpu_req		:	 IN STD_LOGIC;
		cpu_ack		:	 OUT STD_LOGIC;
		cpu_cachevalid		:	 OUT STD_LOGIC;
		cpu_wr		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic;
		debug : out std_logic_vector(2 downto 0)
	);
END COMPONENT;


COMPONENT BurstCache
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset	: IN std_logic;
		ready : out std_logic;
		cpu_addr		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		cpu_req		:	 IN STD_LOGIC;
		cpu_ack		:	 OUT STD_LOGIC;
		cpu_cachevalid		:	 OUT STD_LOGIC;
		cpu_wr		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic;
		debug : out std_logic_vector(2 downto 0)
	);
END COMPONENT;


begin

	readcache_fill <= '1' when (slot1_fill='1' and sdram_slot1=port1)
								or (slot2_fill='1' and sdram_slot2=port1)
									else '0';

	readcache2_fill <= '1' when (slot1_fill='1' and sdram_slot1=port2)
								or (slot2_fill='1' and sdram_slot2=port2)
									else '0';

	vga_fill <= '1' when (slot1_fill='1' and sdram_slot1=port0)
								or (slot2_fill='1' and sdram_slot2=port0)
									else '0';

	ack1 <= writecache_ack or readcache_ack;

	ack2 <= readcache2_ack;

	process(sysclk,reset)
	begin
	
-- Write cache implementation: (AMR)

	if reset='0' then
		writecache_req<='0';
		writecache_ack<='0';
	elsif rising_edge(sysclk) then

		writecache_ack<='0';
		writecache_dqm(7 downto 4)<="1111";

		-- 32-bit variant of writecache for ZPU...
		if req1='1' and wr1='1' and writecache_req='0' and readcache_busy='0' then
			writecache_addr(31 downto 4)<=addr1(31 downto 4);
			writecache_addr(3 downto 1)<=addr1(3 downto 1);
			writecache_word0<=datawr1(31 downto 16);
			writecache_dqm(1 downto 0)<=not (bytesel(0) & bytesel(1)); -- Are we writing the upper word?
			writecache_word1<=datawr1(15 downto 0);
			writecache_dqm(3 downto 2)<=not (bytesel(2) & bytesel(3)); -- Are we writing the lower word?
			writecache_req<='1';
			writecache_ack<='1';
		end if;
		if writecache_sdack='1' then
			writecache_req<='0';
		end if;				
	end if;
end process;


GENCACHE:
if cache=true generate
mytwc2 : component DirectMappedCache
	generic map
	(
		cachebits => 11
	)
	PORT map
	(
		clk => sysclk,
		reset => reset,
		ready => cache2_ready,
		cpu_addr => addr2,
		cpu_req => req2,
		cpu_ack => readcache2_ack,
		cpu_cachevalid => cachevalid2,
		cpu_wr => '0',
		bytesel => "0000",
		data_from_cpu => (others=>'X'),
		data_to_cpu => dataout2,
		data_from_sdram => sdata_reg,
		sdram_addr => readcache2_addr,
		sdram_req => readcache2_req,
		sdram_fill => readcache2_fill,
		busy => readcache2_busy,
		flush => flushcaches
	);
end generate;


GENDCACHE:
if dcache=true generate
mytwc : component DirectMappedCache
	generic map
	(
		cachebits => 11
	)
	PORT map
	(
		clk => sysclk,
		reset => reset,
		ready => cache_ready,
		cpu_addr => addr1,
		cpu_req => req1,
		cpu_ack => readcache_ack,
		cpu_cachevalid => cachevalid,
		cpu_wr => wr1,
		bytesel => bytesel,
		data_from_cpu => datawr1,
		data_to_cpu => dataout1,
		data_from_sdram => sdata_reg,
		data_to_sdram => open,
		sdram_addr => readcache_addr,
		sdram_req => readcache_req,
		sdram_fill => readcache_fill,
		sdram_rw => open,
		busy => readcache_busy,
		flush => flushcaches
	);
end generate;


GENNOCACHE:
if cache=false generate
	cachevalid2<='0';
	readcache2_addr<=addr2;
	process(sysclk)
	begin
		if rising_edge(sysclk) then
			if reset='0' then
				readcache2_req_e<='1';
			else
				if readcache2_ack='1' then
					readcache2_req_e<='0';
				end if;
				if req2='0' then
					readcache2_req_e<='1';
				end if;
			end if;
		end if;
	end process;

	readcache2_req<=req2 and readcache2_req_e;
	
	readcache2_ack <= '1' when (slot1_ack='1' and sdram_slot1=port2)
			or (slot2_ack='1' and sdram_slot2=port2)
				else '0';
	dataout2<=longword2;
	cache2_ready<='1';
	readcache2_busy<='0';
end generate;


GENNODCACHE:
if dcache=false generate
	cachevalid<='0';
	readcache_addr<=addr1;
	process(sysclk)
	begin
		if rising_edge(sysclk) then
			if reset='0' then
				readcache_req_e<='1';
			else
				if readcache_ack='1' then
					readcache_req_e<='0';
				end if;
				if req1='0' then
					readcache_req_e<='1';
				end if;

			end if;
		end if;
	end process;

	readcache_req<=req1 and (not wr1) and readcache_req_e;
	
	readcache_ack <= '1' when (slot1_ack='1' and sdram_slot1=port1)
			or (slot2_ack='1' and sdram_slot2=port1)
				else '0';
	dataout1<=longword;
	cache_ready<='1';
	readcache_busy<='0';
end generate;


-------------------------------------------------------------------------
-- SDRAM Basic
-------------------------------------------------------------------------
	reset_out <= init_done and cache_ready and cache2_ready;

	vga_data <= sdata_reg;
	
	process (sysclk, reset, sdwrite, datain) begin
		drive_sdata<=sdwrite;
		IF sdwrite='1' THEN	-- Keep sdram data high impedence if not writing to it.
			sdata_out <= datain;
		ELSE
			sdata_out <= "ZZZZZZZZZZZZZZZZ";
		END IF;
		
		if reset = '0' then
			initstate <= (others => '0');
			init_done <= '0';
			sdram_state <= ph0;
		ELSIF rising_edge(sysclk) THEN

			if reinit='1' then
				init_done<='0';
				initstate<="1111";
			end if;			
			
			--   sample SDRAM data
			sdata_reg <= sdata_in;

			case sdram_state is	--LATENCY=3
				when ph0 =>	sdram_state <= ph1;
				when ph1 =>	sdram_state <= ph2;
					slot1_fill<='0';
					slot2_fill<='1';
				when ph2 => sdram_state <= ph3;
					slot2_ack<='1';
				when ph3 =>	sdram_state <= ph4;
					slot2_ack<='0';
				when ph4 =>	sdram_state <= ph5;
				when ph5 => sdram_state <= ph6;
				when ph6 =>	sdram_state <= ph7;
				when ph7 =>	sdram_state <= ph8;
				when ph8 =>	sdram_state <= ph9;
				when ph9 =>	sdram_state <= ph10;
					slot2_fill<='0';
					slot1_fill<='1';
				when ph10 => sdram_state <= ph11;
					slot1_ack<='1';
				when ph11 => sdram_state <= ph12;
					slot1_ack<='0';
				when ph12 => sdram_state <= ph13;
				when ph13 => sdram_state <= ph14;
				when ph14 =>
						if initstate /= "1111" THEN -- 16 complete phase cycles before we allow the rest of the design to come out of reset.
							initstate <= initstate+1;
							sdram_state <= ph15;
						elsif init_done='1' then
							sdram_state <= ph15;
						elsif vga_refresh='1' then -- Delay here to establish phase relationship between SDRAM and VGA
							init_done <='1';
							sdram_state <= ph0;
						end if;
				when ph15 => sdram_state <= ph0;
				when others => sdram_state <= ph0;
			end case;	
		END IF;	
	end process;		


	
	process (sysclk, reset) begin


		if reset='0' then
			sdram_slot1<=refresh;
			sdram_slot2<=idle;
			slot1_bank<="00";
			slot2_bank<="11";
			sdwrite<='0';
		elsif rising_edge(sysclk) THEN -- rising edge
	
			-- FIXME - need to make sure refresh happens often enough
--			refreshcounter<=refreshcounter+"0000000000001";
			if sdram_slot1=refresh then
				refreshpending<='0';
--			elsif refreshcounter(12 downto 4)="000000000" then
--				refreshpending<='1';
			elsif vga_refresh='1' then
				refreshpending<='1';
			end if;

			sdwrite<='0';
			sd_cs <='1';
			sd_ras <= '1';
			sd_cas <= '1';
			sd_we <= '1';
			sdaddr <= (others => 'X');
			ba <= "00";
			dqm <= "00";  -- safe defaults for everything...

			-- The following block only happens during reset.
			if init_done='0' then
				if sdram_state =ph2 then
					case initstate is
						when "0010" => --PRECHARGE
							sdaddr(10) <= '1'; 	--all banks
							sd_cs <='0';
							sd_ras <= '0';
							sd_cas <= '1';
							sd_we <= '0';
						when "0011"|"0100"|"0101"|"0110"|"0111"|"1000"|"1001"|"1010"|"1011"|"1100" => --AUTOREFRESH
							sd_cs <='0'; 
							sd_ras <= '0';
							sd_cas <= '0';
							sd_we <= '1';
						when "1101" => --LOAD MODE REGISTER
							sd_cs <='0';
							sd_ras <= '0';
							sd_cas <= '0';
							sd_we <= '0';
--							ba <= "00";
	--						sdaddr <= "001000100010"; --BURST=4 LATENCY=2
--							sdaddr <= "001000110010"; --BURST=4 LATENCY=3
--							sdaddr <= "001000110000"; --noBURST LATENCY=3
							sdaddr <= (others => '0');
							sdaddr(5 downto 0) <= "110011";  --BURST=8, LATENCY=3, BURST WRITES
--							sdaddr <= "000000110010"; --BURST=4 LATENCY=3, BURST WRITES
						when others =>	null;	--NOP
					end case;
				END IF;
			else		


-- Time slot control			
				writecache_sdack<='0';
				vga_nak<='0';
				vga_ack<='0';
				case sdram_state is

					when ph2 => -- ACTIVE for first access slot

						cas_dqm <= "00";

						sdram_slot1<=idle;
						if refreshpending='1' and sdram_slot2=idle then	-- refreshcycle
							sdram_slot1<=refresh;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							sd_cas <= '0'; --AUTOREFRESH
						elsif vga_req='1' then
							if vga_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle then
								sdram_slot1<=port0;
								sdaddr <= vga_addr(row_high downto row_low);
								ba <= vga_addr(bank_high downto bank_low);
								slot1_bank <= vga_addr(bank_high downto bank_low);
								casaddr <= vga_addr(31 downto 4) & "0000"; -- read whole cache line in burst mode.
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
								vga_ack<='1'; -- Signal to VGA controller that it can bump bankreserve
							end if;
						elsif writecache_req='1'
								and sdram_slot2/=writecache
								and (writecache_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle)
									then
							sdram_slot1<=writecache;
							sdaddr <= writecache_addr(row_high downto row_low);
							ba <= writecache_addr(bank_high downto bank_low);
							slot1_bank <= writecache_addr(bank_high downto bank_low);
							cas_dqm <= writecache_dqm(1 downto 0);
							casaddr <= writecache_addr;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the DMA Cache that it didn't get this cycle
						elsif readcache_req='1' --req1='1' and wr1='1'
								and (readcache_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle) then
							sdram_slot1<=port1;
							sdaddr <= readcache_addr(row_high downto row_low);
							ba <= readcache_addr(bank_high downto bank_low);
							slot1_bank <= readcache_addr(bank_high downto bank_low); -- slot1 bank
							cas_dqm <= "00";
							casaddr <= readcache_addr(31 downto 2) & "00";
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the VGA controller that it didn't get this cycle
						elsif readcache2_req='1' --req1='1' and wr1='1'
								and (readcache2_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle) then
							sdram_slot1<=port2;
							sdaddr <= readcache2_addr(row_high downto row_low);
							ba <= readcache2_addr(bank_high downto bank_low);
							slot1_bank <= readcache2_addr(bank_high downto bank_low); -- slot1 bank
							cas_dqm <= "00";
							casaddr <= readcache2_addr(31 downto 2) & "00";
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the VGA controller that it didn't get this cycle
						end if;
						
						-- SLOT 2
						 -- Second word of burst write
						if sdram_slot2=writecache then
							sdwrite<='1';
							datain <= writecache_word1;
							dqm <= writecache_dqm(3 downto 2);
							writecache_sdack<='1'; -- End write burst after 32 bits.
						end if;

						-- Second word of reads if bypassing the cache
						if sdram_slot2=port1 and dcache=false then
							longword(15 downto 0)<=sdata_in;
						end if;
						if sdram_slot2=port2 and cache=false then
							longword2(15 downto 0)<=sdata_in;
						end if;


					when ph3 =>
						-- Third word of burst write
						if sdram_slot2=writecache then
							dqm <= "11"; -- Mask off end of write burst
						end if;


					when ph4 =>
						 -- Final word of burst write
						if sdram_slot2=writecache then
							-- Issue precharge command to terminate the burst.
							sdaddr(10)<='0'; -- Precharge only the one bank.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=slot2_bank;
							dqm <= "11"; -- Mask off end of write burst
						end if;


					when ph5 => -- Read command
						if sdram_slot1=port0 or sdram_slot1=port1 or sdram_slot1=port2 then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '1'; -- Auto precharge.
							ba <= slot1_bank;
							sd_cs <= '0';

							dqm <= cas_dqm;

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						end if;

					when ph6 =>

					when ph7 =>
				
					when ph8 =>

					when ph9 =>
						if sdram_slot1=writecache then -- Write command
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '0';  -- Don't use auto-precharge for writes.
							sd_cs <= '0';
							ba<=slot1_bank;

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '0'; -- Write

							sdwrite<='1';
							datain <= writecache_word0;
							dqm <= writecache_dqm(1 downto 0);
						end if;

						-- First word of reads if bypassing the cache
						if sdram_slot1=port1 and dcache=false then
							longword(31 downto 16)<=sdata_in;
						end if;
						if sdram_slot1=port2 and cache=false then
							longword2(31 downto 16)<=sdata_in;
						end if;

					when ph10 =>
						-- Slot 1
						-- Next word of burst write
						if sdram_slot1=writecache then
							sdwrite<='1';
							datain <= writecache_word1;
							dqm <= writecache_dqm(3 downto 2);
							writecache_sdack<='1'; -- End write burst after 32 bits.
						end if;					
						
						-- Slot 2, active command
						
						cas_dqm <= "00";

						sdram_slot2<=idle;
						if refreshpending='1' or sdram_slot1=refresh then
							sdram_slot2<=idle;
						elsif writecache_req='1'
								and sdram_slot1/=writecache
								and (writecache_addr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (writecache_addr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=writecache;
							sdaddr <= writecache_addr(row_high downto row_low);
							ba <= writecache_addr(bank_high downto bank_low);
							slot2_bank <= writecache_addr(bank_high downto bank_low);
							cas_dqm <= writecache_dqm(1 downto 0);
							casaddr <= writecache_addr;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						elsif readcache_req='1' -- req1='1' and wr1='1'
								and (readcache_addr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (readcache_addr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=port1;
							sdaddr <= readcache_addr(row_high downto row_low);
							ba <= readcache_addr(bank_high downto bank_low);
							slot2_bank <= readcache_addr(bank_high downto bank_low);
							cas_dqm <= "00";
							casaddr <= readcache_addr(31 downto 2) & "00"; -- We no longer mask off LSBs for burst read
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						elsif readcache2_req='1' -- req1='1' and wr1='1'
								and (readcache2_addr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (readcache2_addr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=port2;
							sdaddr <= readcache2_addr(row_high downto row_low);
							ba <= readcache2_addr(bank_high downto bank_low);
							slot2_bank <= readcache2_addr(bank_high downto bank_low);
							cas_dqm <= "00";
							casaddr <= readcache2_addr(31 downto 2) & "00"; -- We no longer mask off LSBs for burst read
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						end if;
						
						-- Second word of reads if bypassing the cache
						if sdram_slot1=port1 and dcache=false then
							longword(15 downto 0)<=sdata_in;
						end if;
						if sdram_slot1=port2 and cache=false then
							longword2(15 downto 0)<=sdata_in;
						end if;

				
					when ph11 =>
						-- third word of burst write
						if sdram_slot1=writecache then
							dqm<="11"; -- Mask off end of burst
						end if;


					when ph12 =>
						if sdram_slot1=writecache then
							-- Issue precharge command to terminate the burst.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=slot1_bank;
							sdaddr(10)<='0'; -- Precharge only the one bank.
							dqm<="11"; -- Mask off end of burst
						end if;

					
					-- Phase 13 - CAS for second window...
					when ph13 =>
						if sdram_slot2=port1 then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '1'; -- Auto precharge.
							ba <= slot2_bank;
							sd_cs <= '0';

							dqm <= "00";

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						elsif sdram_slot2=port2 then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '1'; -- Auto precharge.
							ba <= slot2_bank;
							sd_cs <= '0';

							dqm <= "00";

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						end if;

					when ph14 =>

					when ph15 =>

					when ph0 =>

					when ph1 =>
						if sdram_slot2=writecache then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '0';  -- Don't use auto-precharge for writes.
							ba <= slot2_bank;
							sd_cs <= '0';

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '0'; -- Write
							
							sdwrite<='1';
							datain <= writecache_word0;
							dqm <= writecache_dqm(1 downto 0);
						end if;
						
						-- First word of reads if bypassing the cache
						if sdram_slot2=port1 and dcache=false then
							longword(31 downto 16)<=sdata_in;
						end if;
						if sdram_slot2=port2 and cache=false then
							longword2(31 downto 16)<=sdata_in;
						end if;

					when others =>
						null;
						
				end case;

			END IF;	
		END IF;	
	END process;		
END;
