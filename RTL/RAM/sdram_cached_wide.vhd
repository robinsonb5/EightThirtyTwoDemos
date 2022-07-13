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

entity sdram_cached_wide is
generic
	(
		rows : integer := 12;
		cols : integer := 8;
		cache : boolean := false;
		dcache : boolean := false;
		dqwidth : integer := 32;
		dqmwidth : integer :=4
	);
port
	(
-- Physical connections to the SDRAM
	drive_sdata	: out std_logic;
	sdata_in		: in std_logic_vector(dqwidth-1 downto 0);
	sdata_out		: inout std_logic_vector(dqwidth-1 downto 0);
	sdaddr		: out std_logic_vector((rows-1) downto 0);
	sd_we		: out std_logic;	-- Write enable, active low
	sd_ras		: out std_logic;	-- Row Address Strobe, active low
	sd_cas		: out std_logic;	-- Column Address Strobe, active low
	sd_cs		: out std_logic;	-- Chip select - only the lsb does anything.
	dqm			: out std_logic_vector(dqmwidth-1 downto 0);	-- Data mask, upper and lower byte
	ba			: out std_logic_vector(1 downto 0); -- Bank?

-- Housekeeping
	sysclk		: in std_logic;
	reset		: in std_logic;
	reset_out	: out std_logic;
	reinit : in std_logic :='0';

-- Port 0 - VGA
	vga_addr : in std_logic_vector(31 downto 0) := X"00000000";
	vga_data	: out std_logic_vector(dqwidth-1 downto 0);
	vga_req : in std_logic := '0';
	vga_fill : out std_logic;
	vga_ack : out std_logic;
	vga_nak : out std_logic;
	vga_refresh : in std_logic :='1'; -- SDRAM won't come out of reset without this.
	vga_reservebank : in std_logic :='0'; -- Keep a bank clear for instant access in slot 1
	vga_reserveaddr : in std_logic_vector(31 downto 0) :=X"00000000";

	-- Port 1
	datawr1		: in std_logic_vector(31 downto 0);	-- Data in
	Addr1		: in std_logic_vector(31 downto 0);	-- Address in
	req1		: in std_logic;
	cachevalid : out std_logic;
	bytesel	: in std_logic_vector(3 downto 0);
	wr1			: in std_logic;	-- Read (1) / write (0) 
	dataout1		: out std_logic_vector(31 downto 0);
	dtack1	: buffer std_logic;
	-- Port 2 - instructions only
	Addr2		: in std_logic_vector(31 downto 0):=X"00000000";
	req2		: in std_logic:='0';
	cachevalid2 : out std_logic;
	dataout2		: out std_logic_vector(31 downto 0);
	dtack2	: buffer std_logic;
	--
	flushcaches : in std_logic:='0'
	);
end;

architecture rtl of sdram_cached_wide is

constant col_low : integer := 2;
constant col_high : integer := cols+col_low-1;

constant row_low : integer := col_high+1;
constant row_high : integer := row_low+rows-1;

constant bank_low : integer := row_high+1;
constant bank_high : integer := bank_low+1;


signal initstate	:unsigned(3 downto 0) := (others => '0');	-- Counter used to initialise the RAM
signal cas_dqm		:std_logic_vector(dqmwidth-1 downto 0);	-- ...mask register for entire burst
signal init_done	:std_logic :='0';
signal datain		:std_logic_vector(dqwidth-1 downto 0);
signal casaddr		:std_logic_vector(31 downto 0);
signal sdwrite 		:std_logic;
signal sdata_reg	:std_logic_vector(dqwidth-1 downto 0);

type sdram_states is (ph0,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,ph10,ph11,ph12,ph13,ph14,ph15);
signal sdram_state		: sdram_states;

type sdram_ports is (idle,refresh,port0,port1,port2,writecache);

signal sdram_slot1 : sdram_ports :=refresh;
signal sdram_slot2 : sdram_ports :=idle;

-- Since VGA has absolute priority, we keep track of the next bank and disallow accesses
-- to either the current or next bank in the interleaved access slots.
signal slot1_bank : std_logic_vector(1 downto 0) := "00";
signal slot2_bank : std_logic_vector(1 downto 0) := "11";
signal wb_bank : std_logic_vector(1 downto 0) := "00";

signal slot1_fill : std_logic;
signal slot2_fill : std_logic;

signal slot1_ack : std_logic;
signal slot2_ack : std_logic;

-- refresh timer - once per scanline, so don't need the counter...
-- signal refreshcounter : unsigned(12 downto 0);	-- 13 bits gives us 8192 cycles between refreshes => pretty conservative.
signal refreshpending : std_logic :='0';

signal readcache_addr : std_logic_vector(31 downto 0);
signal readcache_req : std_logic;
signal readcache_req_e : std_logic;
signal readcache_dtack : std_logic;
signal readcache_fill : std_logic;
signal readcache_busy : std_logic;

signal readcache2_addr : std_logic_vector(31 downto 0);
signal readcache2_req : std_logic;
signal readcache2_req_e : std_logic;
signal readcache2_dtack : std_logic;
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
		cpu_rw		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(dqwidth-1 downto 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(dqwidth-1 downto 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic
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
		cpu_rw		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(dqwidth-1 downto 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic
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
		cpu_rw		:	 IN STD_LOGIC;
		bytesel : in std_logic_vector(3 downto 0);
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(dqwidth-1 downto 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(dqwidth-1 downto 0);
		sdram_addr	: out std_logic_vector(31 downto 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC;
		busy : out std_logic;
		flush : in std_logic
	);
END COMPONENT;


	signal slot1write : std_logic;
	signal slot2write : std_logic;
	signal slot1writeextra : std_logic;
	signal slot2writeextra : std_logic;
	signal wbslot : std_logic;
	signal wbnextword : std_logic;
	signal wblastword : std_logic;
	signal wbwrite : std_logic;
	signal wbend : std_logic;

	-- wbflagsaddr will contain the following data:
	-- bit 31 - new row flag
	-- bits 30 downto 27 - DQMs
	-- bits 26 downto 0 - Address
	signal wbflagsaddr : std_logic_vector(31 downto 0);

	constant wbflag_newrow : integer := 31;
	subtype wbflag_dqms is natural range 30 downto 27;

	signal wbdata : std_logic_vector(31 downto 0);
	signal wbempty : std_logic;
	signal wbreq : std_logic;
	signal wback : std_logic;

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

	dtack1 <= wback and not readcache_dtack;

	dtack2 <= not readcache2_dtack;


newwritebuffer : block
	constant writebuffer_depth : integer := 8;
	constant writebuffer_mask : integer := (2**writebuffer_depth)-1;

	type writebuffer_storage_t is array(0 to (2**writebuffer_depth-1)) of std_logic_vector(31 downto 0);
	signal wbstore_flagsaddr : writebuffer_storage_t;
	signal wbstore_data : writebuffer_storage_t;
	signal wbwriteptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbreadptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbptrdiff : unsigned(writebuffer_depth-1 downto 0);
	signal wbfull : std_logic;

	signal prevaddr : std_logic_vector(31 downto 0);
	signal burstend : std_logic;
	signal wbend_d : std_logic;
	signal wbactive : std_logic;

begin

	wbptrdiff <= wbwriteptr-wbreadptr;
	wbempty <= '1' when wbwriteptr=wbreadptr else '0';
	wbfull <= '1' when wbptrdiff(wbptrdiff'high downto 2)=(2**(writebuffer_depth-2))-1 else '0';

	process(sysclk,reset) begin
		if reset='0' then
			wbreadptr<=(others => '0');
			burstend<='0';
			wbflagsaddr<=(others => '0');
			wbactive <= '0';
		elsif rising_edge(sysclk) then
			wbwrite <= '0';
			wbend <= wblastword;	-- lag by 1 clock
			wbend_d <= wbend;
			wbreq <= not wbempty; -- Lag by 1 clock
			wbflagsaddr <= wbstore_flagsaddr(to_integer(wbreadptr));
			wbdata <= wbstore_data(to_integer(wbreadptr));
			
			if init_done='1' and wbempty='0' and burstend='0' and wbnextword='1' then
				wbactive<='1';
				wbwrite<=not wbflagsaddr(wbflag_newrow);
				if wbflagsaddr(wbflag_newrow)='0' then
					wbreadptr<=wbreadptr+1;
				end if;
			end if;
			
			if (wbactive='1' or wbnextword='1') and wbflagsaddr(wbflag_newrow)='1' then
				burstend<='1';
			end if;

			if init_done='1' and wbreq='1' and wbflagsaddr(wbflag_newrow)='1' and wbslot='1' then
				wbreadptr<=wbreadptr+1;
			end if;

			if wbend='1' then
				wbactive<='0';
				burstend<='0';
			end if;			
		end if;
	end process;

	-- write side

	process(sysclk,reset)
		variable flagaddr : std_logic_vector(31 downto 0);
	begin
		if reset='0' then
			wbwriteptr<=(others => '0');
			prevaddr<=(others => '0');
		elsif rising_edge(sysclk) then
			wback<='1';
			if req1='1' and wr1='0' and dtack1='1' and wbfull='0' and readcache_busy='0' then
				flagaddr:=(others => '0');
				if prevaddr(bank_high downto row_low)/=Addr1(bank_high downto row_low) then
					flagaddr(wbflag_newrow) := '1';
				else
					flagaddr(wbflag_newrow) := '0';
					wback<='0';	-- Only acknowledge if the addresses match, so that a dummy entry gets inserted when the row changes.
				end if;
				flagaddr(bank_high downto 0) := Addr1(bank_high downto 0);
				flagaddr(wbflag_dqms) := not (bytesel(0) & bytesel(1) & bytesel(2) & bytesel(3));
				wbstore_flagsaddr(to_integer(wbwriteptr))<=flagaddr;
				wbstore_data(to_integer(wbwriteptr))<=datawr1;
				wbwriteptr<=wbwriteptr+1;
				prevaddr<=Addr1;
			end if;
		end if;
	end process;

end block;


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
		cpu_ack => readcache2_dtack,
		cpu_cachevalid => cachevalid2,
		cpu_rw => '1',
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
		cpu_ack => readcache_dtack,
		cpu_cachevalid => cachevalid,
		cpu_rw => wr1,
		bytesel => bytesel,
		data_from_cpu => datawr1,
		data_to_cpu => dataout1,
		data_from_sdram => sdata_reg,
		sdram_addr => readcache_addr,
		sdram_req => readcache_req,
		sdram_fill => readcache_fill,
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
				if readcache2_dtack='1' then
					readcache2_req_e<='0';
				end if;
				if req2='0' then
					readcache2_req_e<='1';
				end if;
			end if;
		end if;
	end process;

	readcache2_req<=req2 and readcache2_req_e;
	
	readcache2_dtack <= '1' when (slot1_ack='1' and sdram_slot1=port2)
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
				if readcache_dtack='1' then
					readcache_req_e<='0';
				end if;
				if req1='0' then
					readcache_req_e<='1';
				end if;

			end if;
		end if;
	end process;

	readcache_req<=req1 and wr1 and readcache_req_e;
	
	readcache_dtack <= '1' when (slot1_ack='1' and sdram_slot1=port1)
			or (slot2_ack='1' and sdram_slot2=port1)
				else '0';
	dataout1<=longword;
	cache_ready<='1';
	readcache_busy<='0';
end generate;


	slot1write <= '1' when sdram_slot1=writecache else '0';
	slot2write <= '1' when sdram_slot2=writecache else '0';
	slot1writeextra <= '1' when sdram_slot1=writecache and (sdram_slot2=idle or sdram_slot2=writecache) else '0';
	slot2writeextra <= '1' when sdram_slot2=writecache and (sdram_slot1=idle or sdram_slot1=writecache) else '0';

-------------------------------------------------------------------------
-- SDRAM Basic
-------------------------------------------------------------------------
	reset_out <= init_done and cache_ready and cache2_ready;

	vga_data <= sdata_reg;

	process (sdram_state,slot1write,slot2write,slot1writeextra,slot2writeextra) begin
	
		wbnextword<='0';
		wblastword<='0';
		wbslot<='0';
		case sdram_state is	--LATENCY=3
			when ph4 =>
				wbnextword<=slot1writeextra;
			when ph5 =>
				wbnextword<=slot1writeextra;
			when ph6 =>
				wbnextword<=slot1writeextra;
			when ph7 =>
				wbnextword<=slot1writeextra;
			when ph8 => 
				wbnextword<=slot1write;
			when ph9 => null;
				-- No write word here since it would clash with slot 2's RAS.
			when ph10 =>
				wbslot<=not slot1write;
				wbnextword<=slot1write;
			when ph11 =>
				wbnextword<=slot1write;
				wblastword<=slot1write;
			when ph12 =>
				wbnextword<=slot2writeextra;
			when ph13 =>
				wbnextword<=slot2writeextra;
			when ph14 =>
				wbnextword<=slot2writeextra;
			when ph15 =>
				wbnextword<=slot2writeextra;
			when ph0 => 
				wbnextword<=slot2write;
			when ph1 => null;
				-- No write word here since it would clash with slot 2's RAS.
			when ph2 =>
				wbslot<=not slot2write;
				wbnextword<=slot2write;
			when ph3 =>
				wbnextword<=slot2write;
				wblastword<=slot2write;
			when others => null;
		end case;	
	end process;		


	process (sysclk, reset, sdwrite, datain) begin
		drive_sdata<=sdwrite;
		IF sdwrite='1' THEN	-- Keep sdram data high impedence if not writing to it.
			sdata_out <= datain;
		ELSE
			sdata_out <= (others => 'Z');
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
					slot2_ack<='1';
				when ph2 => sdram_state <= ph3;
					slot2_ack<='0';
				when ph3 =>
					if init_done='1' and sdram_slot1=idle and sdram_slot2=idle then
						sdram_state<=ph2;
					else
						sdram_state<=ph4;
					end if;
				when ph4 =>	sdram_state <= ph5;
				when ph5 => sdram_state <= ph6;
				when ph6 =>	sdram_state <= ph7;
				when ph7 =>	sdram_state <= ph8;
				when ph8 =>	sdram_state <= ph9;
				when ph9 =>	sdram_state <= ph10;
					slot2_fill<='0';
					slot1_fill<='1';
					slot1_ack<='1';
				when ph10 => sdram_state <= ph11;
					slot1_ack<='0';
				when ph11 => sdram_state <= ph12;
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
			dqm <= (others => '0');  -- safe defaults for everything...

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
							sdaddr(9) <= '1'; -- SINGLE WORD WRITES
							sdaddr(5 downto 0) <= "110011";  --BURST=8, LATENCY=3
--							sdaddr <= "000000110010"; --BURST=4 LATENCY=3, BURST WRITES
						when others =>	null;	--NOP
					end case;
				END IF;
			else		


-- Time slot control			
				vga_nak<='0';
				vga_ack<='0';
				case sdram_state is

					when ph2 => -- ACTIVE for first access slot

						cas_dqm <= (others => '0');

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
								casaddr <= vga_addr(31 downto 5) & "00000"; -- read whole cache line in burst mode.
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
								vga_ack<='1'; -- Signal to VGA controller that it can bump bankreserve
							end if;
						elsif wbreq='1'
								and sdram_slot2/=writecache
								and (wbflagsaddr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle)
									then
							sdram_slot1<=writecache;
							sdaddr <= wbflagsaddr(row_high downto row_low);
							ba <= wbflagsaddr(bank_high downto bank_low);
							slot1_bank <= wbflagsaddr(bank_high downto bank_low);
							wb_bank <= wbflagsaddr(bank_high downto bank_low);
							cas_dqm <= wbflagsaddr(wbflag_dqms);
--							casaddr <= writecache_addr;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the DMA Cache that it didn't get this cycle
						elsif wbreq='0' and readcache_req='1' --req1='1' and wr1='1'
								and (readcache_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle) then
							sdram_slot1<=port1;
							sdaddr <= readcache_addr(row_high downto row_low);
							ba <= readcache_addr(bank_high downto bank_low);
							slot1_bank <= readcache_addr(bank_high downto bank_low); -- slot1 bank
							cas_dqm <= (others => '0');
							casaddr <= readcache_addr(31 downto 2) & "00";
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the VGA controller that it didn't get this cycle
						elsif wbreq='0' and readcache2_req='1' --req1='1' and wr1='1'
								and (readcache2_addr(bank_high downto bank_low)/=slot2_bank or sdram_slot2=idle) then
							sdram_slot1<=port2;
							sdaddr <= readcache2_addr(row_high downto row_low);
							ba <= readcache2_addr(bank_high downto bank_low);
							slot1_bank <= readcache2_addr(bank_high downto bank_low); -- slot1 bank
							cas_dqm <= (others => '0');
							casaddr <= readcache2_addr(31 downto 2) & "00";
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
							vga_nak<='1'; -- Inform the VGA controller that it didn't get this cycle
						end if;

					when ph3 =>

					when ph4 =>

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
						if sdram_slot2=writecache then -- Precharge the bank
							sdaddr(10)<='0'; -- Precharge only the one bank.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=wb_bank;
						end if;

					when ph7 =>
				
					when ph8 =>

					when ph9 =>
						-- First word of reads if bypassing the cache
						if sdram_slot1=port1 and dcache=false then
							longword<=sdata_in;
						end if;
						if sdram_slot1=port2 and cache=false then
							longword2<=sdata_in;
						end if;

					when ph10 =>
						
						-- Slot 2, active command
						
						cas_dqm <= (others => '0');

						sdram_slot2<=idle;
						if refreshpending='1' or sdram_slot1=refresh then
							sdram_slot2<=idle;
						elsif wbreq='1'
								and sdram_slot1/=writecache
								and (wbflagsaddr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (wbflagsaddr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=writecache;
							sdaddr <= wbflagsaddr(row_high downto row_low);
							ba <= wbflagsaddr(bank_high downto bank_low);
							slot2_bank <= wbflagsaddr(bank_high downto bank_low);
							wb_bank <= wbflagsaddr(bank_high downto bank_low);
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
--							vga_nak<='1'; -- Inform the DMA Cache that it didn't get this cycle
						elsif wbreq='0' and readcache_req='1' -- req1='1' and wr1='1'
								and (readcache_addr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (readcache_addr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=port1;
							sdaddr <= readcache_addr(row_high downto row_low);
							ba <= readcache_addr(bank_high downto bank_low);
							slot2_bank <= readcache_addr(bank_high downto bank_low);
							cas_dqm <= (others => '0');
							casaddr <= readcache_addr(31 downto 2) & "00"; -- We no longer mask off LSBs for burst read
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						elsif wbreq='0' and readcache2_req='1' -- req1='1' and wr1='1'
								and (readcache2_addr(bank_high downto bank_low)/=slot1_bank or sdram_slot1=idle)
								and (readcache2_addr(bank_high downto bank_low)/=vga_reserveaddr(bank_high downto bank_low)
									or vga_reservebank='0') then  -- Safe to use this slot with this bank?
							sdram_slot2<=port2;
							sdaddr <= readcache2_addr(row_high downto row_low);
							ba <= readcache2_addr(bank_high downto bank_low);
							slot2_bank <= readcache2_addr(bank_high downto bank_low);
							cas_dqm <= (others => '0');
							casaddr <= readcache2_addr(31 downto 2) & "00"; -- We no longer mask off LSBs for burst read
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						end if;
						
				
					when ph11 =>


					when ph12 =>

					
					-- Phase 13 - CAS for second window...
					when ph13 =>
						if sdram_slot2=port1 or sdram_slot2=port2 then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= '1'; -- Auto precharge.
							ba <= slot2_bank;
							sd_cs <= '0';

							dqm <= (others => '0');

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						end if;

					when ph14 =>
						if sdram_slot1=writecache then -- Precharge the bank
							sdaddr(10)<='0'; -- Precharge only the one bank.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=wb_bank;
						end if;
						
					when ph15 =>

					when ph0 =>

					when ph1 =>
						-- First word of reads if bypassing the cache
						if sdram_slot2=port1 and dcache=false then
							longword<=sdata_in;
						end if;
						if sdram_slot2=port2 and cache=false then
							longword2<=sdata_in;
						end if;

					when others =>
						null;
						
				end case;
				
--				if wbend='1' and (wbwrite='0' or (wbwrite='1' and wbflagsaddr(wbflag_newrow)='1')) then -- Issue precharge command
--					sd_we<='0';
--					sd_ras<='0';
--					sd_cs<='0'; -- Chip select
--					ba<=wb_bank;
--					dqm <= (others => '1'); -- Mask off end of write burst
				if wbwrite='1' and wbflagsaddr(wbflag_newrow)='0' then -- Write one word from the writebuffer
					sdaddr <= (others=>'0');
					sdaddr((cols-1) downto 0) <= wbflagsaddr(col_high downto col_low) ;--auto precharge
					sdaddr(10) <= '0';  -- Don't use auto-precharge for writes unless this is the last word.
					ba <= wb_bank;
					sd_cs <= '0';

					sd_ras <= '1';
					sd_cas <= '0'; -- CAS
					sd_we  <= '0'; -- Write
							
					sdwrite<='1';
					datain <= wbdata;
					dqm <= wbflagsaddr(wbflag_dqms);					
				end if;			

			END IF;	
		END IF;	
	END process;		
	
	
END architecture;

-- Phases                  SLOT 1                                        SLOT 2
-- (d = driving bus)
--           FPGA          SDRAM         FPGA             FPGA           SDRAM           FPGA
-- ph0                                   r 8th word                      (launch) d
-- ph1                                                    WRITE      d            d      r1
-- ph2       ACT                                          ...                     d      r2
-- ph3                     (act)                          w 2nd word d            d      r3
-- ph4                                                    w 3rd word d            d      r4
-- ph5       READ                                                                 d      r5
-- ph6       (dqm)         (read)                                                 d      r6
-- ph7       (dqm)                                                                d      r7
-- ph8       (dqm)         (launch) d                                                    r8
-- ph9       WRITE      d           d    r 1st word
-- ph10      ...                    d    r 2nd word       ACT
-- ph11      w 2nd word d           d    r 3rd word                      (act)
-- ph12      w 3rd word d           d    r 4th word
-- ph13                             d    r 5th word       READ
-- ph14                             d    r 6th word                      (read)
-- ph15                             d    r 7th word

-- (If Slot2 is unused or is writing, slot1 could write at ph5 through 8 as well.
-- Likewise slot 2 could write during ph15 through 0 if slot 1 is idle.)

