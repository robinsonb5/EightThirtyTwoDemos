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
		dqwidth : integer := 32;
		dqmwidth : integer :=4;
		tCK : integer := 10000
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

-- FIXME - add a lower-priority read DMA port and a write DMA port too.

-- Port 0 - VGA
	vga_addr : in std_logic_vector(31 downto 0) := X"00000000";
	vga_data	: out std_logic_vector(dqwidth-1 downto 0);
	vga_req : in std_logic := '0';
	vga_pri : in std_logic := '0';
	vga_fill : out std_logic;
	vga_ack : out std_logic;

	-- Port 1
	datawr1		: in std_logic_vector(31 downto 0);	-- Data in
	Addr1		: in std_logic_vector(31 downto 0);	-- Address in
	req1		: in std_logic;
	cachevalid : out std_logic;
	bytesel	: in std_logic_vector(3 downto 0);
	wr1			: in std_logic;	-- Read (1) / write (0) 
	dataout1		: out std_logic_vector(31 downto 0);
	dtack1	: buffer std_logic;
	-- Port 2 - DMA
	Addr2		: in std_logic_vector(31 downto 0):=X"00000000";
	req2		: in std_logic:='0';
	ack2		: out std_logic;
	fill2		: out std_logic;
	dataout2		: out std_logic_vector(dqwidth-1 downto 0);
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

type sdram_ports is (idle,port0,port1,port2,writecache);

signal sdram_slot1 : sdram_ports := idle;
signal sdram_slot2 : sdram_ports := idle;

-- Since VGA has absolute priority, we keep track of the next bank and disallow accesses
-- to either the current or next bank in the interleaved access slots.
signal slot1_bank : std_logic_vector(1 downto 0) := "00";
signal slot2_bank : std_logic_vector(1 downto 0) := "11";
signal wb_bank : std_logic_vector(1 downto 0) := "00";

signal slot1_fill : std_logic;
signal slot2_fill : std_logic;

signal slot1_ack : std_logic;
signal slot2_ack : std_logic;

signal refreshcounter : unsigned(12 downto 0);
signal refreshpending : std_logic :='0';

signal readcache_addr : std_logic_vector(31 downto 0);
signal readcache_req : std_logic;
signal readcache_dtack : std_logic;
signal readcache_fill : std_logic;
signal readcache_busy : std_logic;

signal longword : std_logic_vector(31 downto 0);

signal cache_ready : std_logic;

signal bankbusy : std_logic_vector(3 downto 0);

-- Rework port priority encoding:
--
-- Each port asserts req when it requires attention
-- Writes are always diverted to the writebuffer
-- We need to prioritise writes to the writebuffer and reads to the two access slots
-- along with the writebuffer

-- Priorities are: VGA, Writebuffer, CPU1, CPU2
-- The CPU port's req comes from the cache, and will thus lag behind the address somewhat.
-- We want to handle refresh separately.

-- New signals:
-- bankbusy(3 downto 0)
-- For each port:
-- addr
-- slot1ok
-- slot2ok

-- Each active command (be it access or manual refresh) will set a bankbusy bit.
-- The end of each access slot will clear the bankbusy bit.

-- Masked versions of the req signal, masked by whether or not the appropriate bank is busy.
-- (Registered, so one cycle behind.)
signal vga_req_masked : std_logic;
signal wb_req_masked : std_logic;
signal port1_req_masked : std_logic;
signal port2_req_masked : std_logic;
signal port0_extend : std_logic;

signal slot1_precharge : std_logic;
signal slot1_autoprecharge : std_logic;
signal slot1_precharge_bank : std_logic_vector(1 downto 0);
signal slot2_precharge : std_logic;
signal slot2_autoprecharge : std_logic;
signal slot2_precharge_bank : std_logic_vector(1 downto 0);

signal refresh_bank : std_logic_vector(1 downto 0);
signal refresh_req : std_logic;
signal refresh_force : std_logic;
signal refresh_ack : std_logic;
signal refresh_row : std_logic_vector(rows-1 downto 0);

COMPONENT DirectMappedCache
generic
	(
		cachemsb : integer := 11
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

	signal slot1read : std_logic;
	signal slot2read : std_logic;
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

	signal nextport : sdram_ports := idle;
	signal nextaddr		:std_logic_vector(31 downto 0);

begin

	readcache_fill <= '1' when (slot1_fill='1' and sdram_slot1=port1)
	                        or (slot2_fill='1' and sdram_slot2=port1)
	                          else '0';

	fill2 <= '1' when (slot1_fill='1' and sdram_slot1=port2)
	               or (slot2_fill='1' and sdram_slot2=port2)
	                 else '0';

	vga_fill <= '1' when (slot1_fill='1' and sdram_slot1=port0)
	                  or (slot2_fill='1' and sdram_slot2=port0)
	                    else '0';

	dtack1 <= wback and not readcache_dtack;


arbiter : block
	signal readcache_req_mask : std_logic;
begin

--	process(wbflagsaddr,bankbusy) begin
--		wb_req_masked<='0';
--		if bankbusy(to_integer(unsigned(wbflagsaddr(bank_high downto bank_low))))='0' then
--			wb_req_masked<=wbreq;
--		end if;
--	end process;

	process(sysclk) begin
		if rising_edge(sysclk) then
			vga_req_masked<='0';
			if bankbusy(to_integer(unsigned(vga_addr(bank_high downto bank_low))))='0' then
				vga_req_masked<=vga_req;
			end if;

			wb_req_masked<='0';
			if bankbusy(to_integer(unsigned(wbflagsaddr(bank_high downto bank_low))))='0' then
				wb_req_masked<=wbreq;
			end if;

			readcache_req_mask<='0';
			if bankbusy(to_integer(unsigned(Addr1(bank_high downto bank_low))))='0' then
				readcache_req_mask<=not wbreq; -- For cache coherency reasons we don't service CPU read requests while the writebuffer contains data.
			end if;

			port2_req_masked <='0';
			if bankbusy(to_integer(unsigned(Addr2(bank_high downto bank_low))))='0' then
				port2_req_masked<=req2;
			end if;
		end if;	
	end process;
	
	port1_req_masked <= readcache_req and readcache_req_mask;

	process(sysclk,port1_req_masked,port2_req_masked,vga_req_masked,wb_req_masked) begin
		if rising_edge(sysclk) then
			if port0_extend='1' or vga_req_masked='1' then
				nextport <= port0;
				nextaddr <= vga_addr(31 downto 5) & "00000";
			elsif refresh_force='1' then
				nextport<=idle;
				nextaddr <= (others => 'X');
			elsif wb_req_masked='1' then
				nextport <= writecache;
				nextaddr <= wbflagsaddr;
			elsif port1_req_masked='1' then
				nextport <= port1;
				nextaddr <= readcache_addr(31 downto 2) & "00";
			elsif port2_req_masked='1' then
				nextport <= port2;
				nextaddr <= Addr2(31 downto 5) & "00000";
			else
				nextport <= idle;
			end if;
		end if;
	end process;

end block;


newwritebuffer : block
	constant writebuffer_depth : integer := 8;
	constant writebuffer_mask : integer := (2**writebuffer_depth)-1;

	type writebuffer_storage_t is array(0 to (2**writebuffer_depth-1)) of std_logic_vector(31 downto 0);
	attribute ramstyle : string;
	signal wbstore_flagsaddr : writebuffer_storage_t;
	signal wbstore_data : writebuffer_storage_t;
--	attribute ramstyle of wbstore_flagsaddr : signal is "no-rw-check";
--	attribute ramstyle of wbstore_data : signal is "no-rw_check";

	signal wbwriteptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbreadptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbptrdiff : unsigned(writebuffer_depth-1 downto 0);
	signal wbfull : std_logic;

	signal prevaddr : std_logic_vector(31 downto 0);
	signal burstend : std_logic;
	signal wbend_d : std_logic;
	signal wbactive : std_logic;
	signal wb_wrena : std_logic;
begin

	wbptrdiff <= wbwriteptr-wbreadptr;
	wbempty <= '1' when wbwriteptr=wbreadptr else '0';
	wbfull <= '1' when wbptrdiff(wbptrdiff'high downto 2)=(2**(writebuffer_depth-2))-1 else '0';
	wb_wrena<= '1' when req1='1' and wr1='0' and dtack1='1'
		and wbfull='0' and readcache_busy='0' else '0';

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
			if wb_wrena='1' then
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
cache_inst : component DirectMappedCache
	generic map
	(
		cachemsb => 11
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


GENNODCACHE:
if cache=false generate
	signal readcache_req_e : std_logic;
begin
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
	reset_out <= init_done and cache_ready;

	vga_data <= sdata_reg;
	dataout2 <= sdata_reg;

	process (sdram_state,slot1write,slot2write,slot1writeextra,slot2writeextra) begin
	
		wbnextword<='0';
		wblastword<='0';
		wbslot<='0';
		case sdram_state is	--LATENCY=3
			when ph4 =>
				wbnextword<=slot1writeextra;
			when ph5 =>
				wbnextword<=slot1writeextra and not slot2_precharge;
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
				wbnextword<=slot2writeextra and not slot1_precharge;
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
					if init_done='1' and sdram_slot1=idle and sdram_slot2=idle and refresh_req='0' and slot2_precharge='0' then
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
					else
						init_done<='1';
					end if;
					sdram_state<=ph15;
				when ph15 => sdram_state <= ph0;
				when others => sdram_state <= ph0;
			end case;	
		END IF;	
	end process;		


	
	process (sysclk, reset) begin


		if reset='0' then
			sdram_slot1<=idle;
			sdram_slot2<=idle;
			slot1_bank<="00";
			slot2_bank<="11";
			slot1_precharge<='0';
			slot1_precharge_bank<="00";
			slot2_precharge<='0';
			slot2_precharge_bank<="00";			
			sdwrite<='0';
			bankbusy <= (others => '0');
			port0_extend<='0';
		elsif rising_edge(sysclk) THEN -- rising edge

			refresh_ack<='0';
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
				vga_ack<='0';
				ack2<='0';
				case sdram_state is

					when ph2 => -- ACTIVE for first access slot

						slot1read<='0';

						cas_dqm <= (others => '0');
						slot1_autoprecharge<='1';
						port0_extend<='0';

						sdram_slot1<=nextport;
						sdaddr <= nextaddr(row_high downto row_low);
						ba <= nextaddr(bank_high downto bank_low);
						slot1_bank <= nextaddr(bank_high downto bank_low);
						slot1_precharge_bank <= nextaddr(bank_high downto bank_low);
						casaddr <= nextaddr; -- read whole cache line in burst mode.
						if nextport/=idle then
							bankbusy(to_integer(unsigned(nextaddr(bank_high downto bank_low))))<='1';
							if port0_extend='0' then
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
							end if;
						end if;
						
--						if port0_extend='1' then
--								sdram_slot1<=port0;
--								slot1_bank <= vga_addr(bank_high downto bank_low);
--								bankbusy(to_integer(unsigned(vga_addr(bank_high downto bank_low))))<='1';
--								casaddr <= vga_addr(31 downto 5) & "00000"; -- read whole cache line in burst mode.
--								if unsigned(vga_addr(col_high downto 5)) /= (2**(col_high-4)-1) then
--									slot1_autoprecharge<=not vga_pri;
--									port0_extend<=vga_pri;
--								end if;
--								vga_ack<='1'; -- Signal to VGA controller that it can bump bankreserve						
--						elsif refresh_force='1' then
--							sdram_slot1<=idle;
						if nextport=port0 then
							slot1read<='1';
--								sdram_slot1<=nextport;
--								sdaddr <= vga_addr(row_high downto row_low);
--								ba <= vga_addr(bank_high downto bank_low);
--								slot1_bank <= vga_addr(bank_high downto bank_low);
--								bankbusy(to_integer(unsigned(vga_addr(bank_high downto bank_low))))<='1';
--								casaddr <= vga_addr(31 downto 5) & "00000"; -- read whole cache line in burst mode.
--								sd_cs <= '0'; --ACTIVE
--								sd_ras <= '0';
								if unsigned(nextaddr(col_high downto 5)) /= (2**(col_high-4)-1) then
									slot1_autoprecharge<=not vga_pri;
									port0_extend<=vga_pri;
								end if;
								vga_ack<='1'; -- Signal to VGA controller that it can bump bankreserve
--							end if;
						elsif nextport=writecache then
--							sdram_slot1<=writecache;
--							sdaddr <= wbflagsaddr(row_high downto row_low);
--							ba <= wbflagsaddr(bank_high downto bank_low);
--							slot1_bank <= wbflagsaddr(bank_high downto bank_low);
--							slot1_precharge_bank <= wbflagsaddr(bank_high downto bank_low);
							slot1_precharge<='1';
--							bankbusy(to_integer(unsigned(wbflagsaddr(bank_high downto bank_low))))<='1';
							wb_bank <= wbflagsaddr(bank_high downto bank_low);
							cas_dqm <= wbflagsaddr(wbflag_dqms);
--							casaddr <= writecache_addr;
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
						elsif nextport=port1 then
							slot1read<='1';
--							sdram_slot1<=port1;
--							sdaddr <= readcache_addr(row_high downto row_low);
--							ba <= readcache_addr(bank_high downto bank_low);
--							slot1_bank <= readcache_addr(bank_high downto bank_low); -- slot1 bank
--							bankbusy(to_integer(unsigned(readcache_addr(bank_high downto bank_low))))<='1';
--							cas_dqm <= (others => '0');
--							casaddr <= readcache_addr(31 downto 2) & "00";
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
						elsif nextport=port2 then
							slot1read<='1';
--							sdram_slot1<=port2;
--							sdaddr <= Addr2(row_high downto row_low);
--							ba <= Addr2(bank_high downto bank_low);
--							slot1_bank <= Addr2(bank_high downto bank_low); -- slot1 bank
--							bankbusy(to_integer(unsigned(Addr2(bank_high downto bank_low))))<='1';
--							cas_dqm <= (others => '0');
--							casaddr <= Addr2(31 downto 5) & "00000"; -- read whole cache line in burst mode.
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
							ack2<='1'; -- Signal to DMA controller that it can bump bankreserve
						end if;

					when ph3 =>

					when ph4 =>

					when ph5 => -- Read command
						dqm <= cas_dqm;
						if slot1read='1' then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= slot1_autoprecharge; -- Auto precharge.
							ba <= slot1_bank;
							sd_cs <= '0';
							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						end if;

					when ph6 =>
						if slot2_precharge='1' then -- Precharge the bank
							sdaddr(10)<='0'; -- Precharge only the one bank.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=slot2_precharge_bank;
						end if;

					when ph7 =>
						if refresh_req='1' and sdram_slot1 /= writecache then
							slot1_precharge<='1';
							slot1_precharge_bank<=refresh_bank;
							bankbusy(to_integer(unsigned(refresh_bank)))<='1';
							refresh_ack<='1';
							sdaddr<=refresh_row;
							ba <= refresh_bank;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						end if;							
				
					when ph8 =>
						if slot2_precharge='1' then
							bankbusy(to_integer(unsigned(slot2_precharge_bank)))<='0';
							slot2_precharge<='0';
						end if;
						if sdram_slot2/=idle and (sdram_slot1=idle or slot2_bank/=slot1_bank) then
							bankbusy(to_integer(unsigned(slot2_bank)))<='0';
						end if;

					when ph9 =>
						-- First word of reads if bypassing the cache
						if sdram_slot1=port1 and cache=false then
							longword<=sdata_in;
						end if;

					when ph10 =>
						
						slot2read<='0';
						-- Slot 2, active command
						
						cas_dqm <= (others => '0');
						sdram_slot2<=idle;
						port0_extend<='0';
						slot2_autoprecharge<='1';
						
						sdram_slot2<=nextport;
						sdaddr <= nextaddr(row_high downto row_low);
						ba <= nextaddr(bank_high downto bank_low);
						slot2_bank <= nextaddr(bank_high downto bank_low);
						slot2_precharge_bank <= nextaddr(bank_high downto bank_low);
						casaddr <= nextaddr; -- read whole cache line in burst mode.
						if nextport/=idle then
							bankbusy(to_integer(unsigned(nextaddr(bank_high downto bank_low))))<='1';
							if port0_extend='0' then
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
							end if;
						end if;

--						if port0_extend='1' then
--							sdram_slot2<=port0;
--							slot2_bank <= vga_addr(bank_high downto bank_low);
--							bankbusy(to_integer(unsigned(vga_addr(bank_high downto bank_low))))<='1';
--							casaddr <= vga_addr(31 downto 5) & "00000"; -- read whole cache line in burst mode.
--							if unsigned(vga_addr(col_high downto 5)) /= (2**(col_high-4)-1) then
--								slot2_autoprecharge<=not vga_pri;
--								port0_extend<=vga_pri;
--							end if;
						if nextport=port0 then
							slot2read<='1';
							if unsigned(nextaddr(col_high downto 5)) /= (2**(col_high-4)-1) then
								slot2_autoprecharge<=not vga_pri;
								port0_extend<=vga_pri;
							end if;
							vga_ack<='1'; -- Signal to VGA controller that it can bump bankreserve
						elsif nextport=writecache then
--							sdram_slot2<=writecache;
--							sdaddr <= wbflagsaddr(row_high downto row_low);
--							ba <= wbflagsaddr(bank_high downto bank_low);
--							slot2_bank <= wbflagsaddr(bank_high downto bank_low);
							slot2_precharge<='1';
--							bankbusy(to_integer(unsigned(wbflagsaddr(bank_high downto bank_low))))<='1';
							wb_bank <= wbflagsaddr(bank_high downto bank_low);
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
						elsif nextport=port1 then 
							slot2read<='1';
--							sdram_slot2<=port1;
--							sdaddr <= readcache_addr(row_high downto row_low);
--							ba <= readcache_addr(bank_high downto bank_low);
--							slot2_bank <= readcache_addr(bank_high downto bank_low);
--							bankbusy(to_integer(unsigned(readcache_addr(bank_high downto bank_low))))<='1';
--							casaddr <= readcache_addr(31 downto 2) & "00"; -- We no longer mask off LSBs for burst read
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
						elsif nextport=port2 then
							slot2read<='1';
--							sdram_slot2<=port2;
--							sdaddr <= Addr2(row_high downto row_low);
--							ba <= Addr2(bank_high downto bank_low);
--							slot1_bank <= Addr2(bank_high downto bank_low); -- slot1 bank
--							bankbusy(to_integer(unsigned(Addr2(bank_high downto bank_low))))<='1';
--							cas_dqm <= (others => '0');
--							casaddr <= Addr2(31 downto 5) & "00000"; -- read whole cache line in burst mode.
--							sd_cs <= '0'; --ACTIVE
--							sd_ras <= '0';
							ack2<='1'; -- Signal to DMA controller that it can bump bankreserve
						end if;
						
				
					when ph11 =>


					when ph12 =>

					
					-- Phase 13 - CAS for second window...
					when ph13 =>
						dqm <= cas_dqm;
						if slot2read='1' then
							sdaddr <= (others=>'0');
							sdaddr((cols-1) downto 0) <= casaddr(col_high downto col_low) ;--auto precharge
							sdaddr(10) <= slot2_autoprecharge; -- Auto precharge.
							ba <= slot2_bank;
							sd_cs <= '0';

							sd_ras <= '1';
							sd_cas <= '0'; -- CAS
							sd_we  <= '1'; -- Read
						end if;

					when ph14 =>
						if slot1_precharge='1' then -- Precharge the bank
							sdaddr(10)<='0'; -- Precharge only the one bank.
							sd_we<='0';
							sd_ras<='0';
							sd_cs<='0'; -- Chip select
							ba<=slot1_precharge_bank;
						end if;
						
					when ph15 =>
						if refresh_req='1' and sdram_slot2 /= writecache then
							slot2_precharge<='1';
							slot2_precharge_bank<=refresh_bank;
							bankbusy(to_integer(unsigned(refresh_bank)))<='1';
							refresh_ack<='1';
							sdaddr<=refresh_row;
							ba <= refresh_bank;
							sd_cs <= '0'; --ACTIVE
							sd_ras <= '0';
						end if;							

					when ph0 =>
						if slot1_precharge='1' then
							bankbusy(to_integer(unsigned(slot1_precharge_bank)))<='0';
							slot1_precharge<='0';
						end if;

						if sdram_slot1/=idle and (sdram_slot2=idle or slot1_bank /= slot2_bank) then
							bankbusy(to_integer(unsigned(slot1_bank)))<='0';
						end if;

					when ph1 =>
						-- First word of reads if bypassing the cache
						if sdram_slot2=port1 and cache=false then
							longword<=sdata_in;
						end if;

					when others =>
						null;
						
				end case;

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


	refreshlogic : block
		signal refresh_bank_r : std_logic_vector(1 downto 0);
		signal bank_refreshing : std_logic_vector(3 downto 0);
		signal bank_refresh_req : std_logic_vector(3 downto 0);
		signal bank_refresh_req_masked : std_logic_vector(3 downto 0);
		signal bank_refresh_pri : std_logic_vector(3 downto 0);
		type brr is array (0 to 3) of std_logic_vector(rows-1 downto 0);
		signal bank_refresh_row : brr;
	begin
	
		refreshloop: for i in 0 to 3 generate
			bank1_refresh : entity work.sdram_refresh_schedule
			generic map (
				tCK => tCK,
				rowbits => rows
			)
			port map (
				clk => sysclk,
				reset_n => reset,
				refreshing => bank_refreshing(i),
				req => bank_refresh_req(i),
				pri => bank_refresh_pri(i),
				addr => bank_refresh_row(i)
			);
		end generate;

		bank_refresh_req_masked <= bank_refresh_req and not bankbusy;
		
		refresh_bank <= "00" when bank_refresh_req_masked(0)='1'
			else "01" when bank_refresh_req_masked(1)='1'
			else "10" when bank_refresh_req_masked(2)='1'
			else "11";

		refresh_row <= bank_refresh_row(0) when bank_refresh_req_masked(0)='1'
			else bank_refresh_row(1) when bank_refresh_req_masked(1)='1'
			else bank_refresh_row(2) when bank_refresh_req_masked(2)='1'
			else bank_refresh_row(3);

		process(sysclk) begin
			if rising_edge(sysclk) then
				refresh_req <= '1';
				refresh_force <= '1';
				if bank_refresh_req_masked="0000" then
					refresh_req<='0';
				end if;
				if bank_refresh_pri="0000" then
					refresh_force<='0';
				end if;

				refresh_bank_r<=refresh_bank;
				bank_refreshing<=(others => '0');
				if refresh_ack='1' then
					bank_refreshing(to_integer(unsigned(refresh_bank_r)))<='1';
				end if;
			end if;
		end process;

	end block;

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

-- Can also refresh idle banks by performing an ACT at ph6 or 7 (or both!) followed by
-- a precharge at ph14/15
-- Maybe ACT at ph7, PRE at ph14, then ACT at ph15, PRE at ph6 to reduce the chances
-- of blocking a cycle completely?

-- Alternatively, ACT at ph4/ph12 (as long as neither slot is writing), then PRE at ph9/ph1?

-- Better yet, since we're already precharging at ph6 and ph14 when the write buffer is active
-- do the precharge there, and ACT at ph7 and ph15?  Will block that bank for the next slot,
-- but it's going to be hard to avoid that anyway.

-- For "hungry" VGA (i.e. FIFO less than half full), Read commands could omit the Autoprecharge,
-- and simply transfer to the other slot to continue the read.  Once the channel is no longer
-- hungry (or the row address wraps around) the last command to be issued will use autoprecharge
-- and return to the normal state.


