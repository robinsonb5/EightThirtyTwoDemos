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

-- FIXME - currently only works with 32-bit RAM.  Adjust to work with 16-bit wide RAM.
 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.sdram_controller_pkg.all;

entity sdram_controller is
generic (
		tCK : integer := 10000
	);
port (
-- Physical connections to the SDRAM
	drive_sdata	: out std_logic;
	sdata_in		: in std_logic_vector(sdram_width-1 downto 0);
	sdata_out		: out std_logic_vector(sdram_width-1 downto 0);
	sdaddr		: out std_logic_vector((sdram_rowbits-1) downto 0);
	sd_we		: out std_logic;	-- Write enable, active low
	sd_ras		: out std_logic;	-- Row Address Strobe, active low
	sd_cas		: out std_logic;	-- Column Address Strobe, active low
	sd_cs		: out std_logic;	-- Chip select - only the lsb does anything.
	dqm			: out std_logic_vector(sdram_dqmwidth-1 downto 0);	-- Data mask, upper and lower byte
	ba			: out std_logic_vector(1 downto 0); -- Bank?

-- Housekeeping
	sysclk		: in std_logic;
	reset		: in std_logic;
	reset_out	: out std_logic;
	reinit : in std_logic :='0';

-- FIXME - add a lower-priority read DMA port and a write DMA port too.

	-- Read only ports:

	-- Port 0 - Video
	video_req : in sdram_port_request;
	video_ack : out sdram_port_response;

	-- Port 1
	cache_req : in sdram_port_request;
	cache_ack : out sdram_port_response;
	
	-- Port 2 - DMA
	dma_req : in sdram_port_request;
	dma_ack : out sdram_port_response;

	-- Write only ports:

	cpu_req : in sdram_port_request;
	cpu_ack : out sdram_port_response
);
end entity;

architecture rtl of sdram_controller is
	signal initstate	:unsigned(3 downto 0) := (others => '0');	-- Counter used to initialise the RAM
	signal cas_dqm		:std_logic_vector(sdram_dqmwidth-1 downto 0);	-- ...mask register for entire burst
	signal init_done	:std_logic :='0';
	signal datain		:std_logic_vector(sdram_width-1 downto 0);
	signal casaddr		:std_logic_vector(31 downto 0);
	signal sdwrite 		:std_logic;
	signal sdata_reg	:std_logic_vector(31 downto 0);

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

	signal bankbusy : std_logic_vector(3 downto 0);

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
	signal refresh_row : std_logic_vector(sdram_rowbits-1 downto 0);

	signal slot1read : std_logic;
	signal slot2read : std_logic;
	signal wbfirstword : std_logic;
	signal wbnextword : std_logic;
	signal wblastword : std_logic;
	signal wbwrite : std_logic;

	-- wbflagsaddr will contain the following data:
	-- bit 31 - new row flag
	-- bits 30 downto 27 - DQMs
	-- bits 26 downto 0 - Address
	constant wbflag_newrow : integer := 31;
	subtype wbflag_dqms is natural range 30 downto 31-sdram_dqmwidth;
	signal wbflagsaddr : std_logic_vector(31 downto 0);

	signal wbdata : std_logic_vector(sdram_width-1 downto 0);
	signal wbreq : std_logic;

	signal nextport : sdram_ports := idle;
	signal nextaddr		:std_logic_vector(31 downto 0);

begin


	arbiter : block
		signal video_req_masked : std_logic;
		signal wb_req_masked : std_logic;
		signal port1_req_masked : std_logic;
		signal port2_req_masked : std_logic;
	begin

		process(sysclk) begin
			if rising_edge(sysclk) then
				video_req_masked<='0';
				if bankbusy(to_integer(unsigned(video_req.addr(sdram_bank_high downto sdram_bank_low))))='0' then
					video_req_masked<=video_req.req;
				end if;

				wb_req_masked<='0';
				if bankbusy(to_integer(unsigned(wbflagsaddr(sdram_bank_high downto sdram_bank_low))))='0' then
					wb_req_masked<=wbreq;
				end if;

				 -- For cache coherency reasons we don't service CPU read requests while the writebuffer contains data.
				port1_req_masked<='0';
				if bankbusy(to_integer(unsigned(cache_req.addr(sdram_bank_high downto sdram_bank_low))))='0' then
					port1_req_masked<=cache_req.req and not wbreq;
				end if;

				 -- For cache coherency reasons we don't service DMA read requests while the writebuffer contains data.
				port2_req_masked <='0';
				if bankbusy(to_integer(unsigned(dma_req.addr(sdram_bank_high downto sdram_bank_low))))='0' then
					port2_req_masked<=dma_req.req and not wbreq;
				end if;
			end if;	
		end process;
		
		process(sysclk,port1_req_masked,port2_req_masked,video_req_masked,wb_req_masked) begin
			if rising_edge(sysclk) then
				-- Video port is highest priority when video_req.pri is '1', lowest priority otherwise.
				if port0_extend='1' or (video_req_masked='1' and video_req.pri='1') then
					nextport <= port0;
					nextaddr <= video_req.addr(31 downto 3 + sdram_width/16) & std_logic_vector(to_unsigned(0,3+sdram_width/16));
				elsif refresh_force='1' then
					nextport<=idle;
					nextaddr <= (others => 'X');
				elsif wb_req_masked='1' then
					nextport <= writecache;
					nextaddr <= wbflagsaddr;
				elsif port1_req_masked='1' then
					nextport <= port1;
					nextaddr <= cache_req.addr(31 downto 2) & "00";
				elsif port2_req_masked='1' then
					nextport <= port2;
					nextaddr <= dma_req.addr(31 downto 3 + sdram_width/16) & std_logic_vector(to_unsigned(0,3+sdram_width/16));
				elsif video_req_masked='1' then
					nextport <= port0;
					nextaddr <= video_req.addr(31 downto 3 + sdram_width/16) & std_logic_vector(to_unsigned(0,3+sdram_width/16));
				else
					nextport <= idle;
				end if;
			end if;
		end process;

	end block;


	-- Write buffer
	writebuffer : block
		signal slot1write : std_logic;
		signal slot2write : std_logic;
		signal slot1writeextra : std_logic;
		signal slot2writeextra : std_logic;	
	begin

		wb : entity work.sdram_writebuffer
		port map (
			sysclk => sysclk,
			reset_n => reset,
			cpu_req => cpu_req,
			cpu_ack => cpu_ack,
			ram_req => wbreq,
			ram_stb => wbwrite,
			ram_flagsaddr => wbflagsaddr,
			ram_q => wbdata,
			ram_firstword => wbfirstword,
			ram_nextword => wbnextword,
			ram_lastword => wblastword
		);

		slot1write <= '1' when sdram_slot1=writecache else '0';
		slot2write <= '1' when sdram_slot2=writecache else '0';
		slot1writeextra <= '1' when sdram_slot1=writecache and (sdram_slot2=idle or sdram_slot2=writecache) else '0';
		slot2writeextra <= '1' when sdram_slot2=writecache and (sdram_slot1=idle or sdram_slot1=writecache) else '0';


		-- scheduling of write commands and FIFO advancement

		process (sdram_state,slot1write,slot2write,slot1writeextra,slot2writeextra) begin	
			wbnextword<='0';
			wblastword<='0';
			wbfirstword<='0';
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
					wbfirstword<=not slot1write;
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
					wbfirstword<=not slot2write;
					wbnextword<=slot2write;
				when ph3 =>
					wbnextword<=slot2write;
					wblastword<=slot2write;
				when others => null;
			end case;	
		end process;		

	end block;


	-- Output ports

	output : block
		signal cacheburst : std_logic;
		signal cachestrobe : std_logic;
		signal dmaburst : std_logic;
		signal dmastrobe : std_logic;
		signal videoburst : std_logic;
		signal videostrobe : std_logic;
	begin
		cacheburst <= '1' when (slot1_fill='1' and sdram_slot1=port1) or (slot2_fill='1' and sdram_slot2=port1) else '0';
		cache_ack.q <= sdata_reg;
		cache_ack.burst <= cacheburst;
		cache_ack.strobe <= cachestrobe;
		
		dmaburst <= '1' when (slot1_fill='1' and sdram_slot1=port2) or (slot2_fill='1' and sdram_slot2=port2) else '0';
		dma_ack.q <= sdata_reg;
		dma_ack.burst <= dmaburst;
		dma_ack.strobe <= dmastrobe;

		videoburst <= '1' when (slot1_fill='1' and sdram_slot1=port0) or (slot2_fill='1' and sdram_slot2=port0) else '0';
		video_ack.q <= sdata_reg;
		video_ack.burst <= videoburst;
		video_ack.strobe <= videostrobe;

	
		--   sample SDRAM data - procedure varies with width:
		thirtytwobit : if sdram_width=32 generate
			cachestrobe<=cacheburst;
			dmastrobe<=dmaburst;
			videostrobe<=videoburst;			
			process (sysclk) begin
				if rising_edge(sysclk) then
					sdata_reg(sdram_width-1 downto 0) <= sdata_in;
				end if;
			end process;
		end generate;

		
		-- if we have sixteen bit SDRAM, we need to build the 32-bit data with a shift, and strobe on alternate cycles.	
		sixteenbit : if sdram_width=16 generate
			process (sysclk) begin
				if rising_edge(sysclk) then
					dmastrobe<=not dmastrobe;
					if dmaburst='0' then
						dmastrobe<='0';
					end if;

					videostrobe<=not videostrobe;
					if videoburst='0' then
						videostrobe<='0';
					end if;
					
					cachestrobe<= not cachestrobe;
					if cacheburst='0' then
						cachestrobe<='0';
					end if;
					sdata_reg <= sdata_in & sdata_reg(31 downto 16);
				end if;
			end process;
		end generate;

	end block;

	-------------------------------------------------------------------------
	-- SDRAM Basic
	-------------------------------------------------------------------------
	reset_out <= init_done;

	process (sysclk, reset, sdwrite, datain) begin
		drive_sdata<=sdwrite;
		sdata_out <= datain;
		
		if reset = '0' then
			initstate <= (others => '0');
			init_done <= '0';
			sdram_state <= ph0;
		ELSIF rising_edge(sysclk) THEN

			if reinit='1' then
				init_done<='0';
				initstate<="1111";
			end if;			
			
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
							sdaddr <= (others => '0');
							sdaddr(9) <= '1'; -- SINGLE WORD WRITES
							sdaddr(5 downto 0) <= "110011";  --BURST=8, LATENCY=3
						when others =>	null;	--NOP
					end case;
				END IF;
			else
				-- Time slot control			
				video_ack.ack<='0';
				dma_ack.ack<='0';
				cache_ack.ack<='0';
				case sdram_state is

					when ph0 =>
						if slot1_precharge='1' then
							bankbusy(to_integer(unsigned(slot1_precharge_bank)))<='0';
							slot1_precharge<='0';
						end if;

						if sdram_slot1/=idle and (sdram_slot2=idle or slot1_bank /= slot2_bank) then
							bankbusy(to_integer(unsigned(slot1_bank)))<='0';
						end if;

					when ph1 =>
						null;

					when ph2 => -- ACTIVE for first access slot

						slot1read<='0';

						cas_dqm <= (others => '0');
						slot1_autoprecharge<='1';
						port0_extend<='0';

						sdram_slot1<=nextport;
						sdaddr <= nextaddr(sdram_row_high downto sdram_row_low);
						ba <= nextaddr(sdram_bank_high downto sdram_bank_low);
						slot1_bank <= nextaddr(sdram_bank_high downto sdram_bank_low);
						slot1_precharge_bank <= nextaddr(sdram_bank_high downto sdram_bank_low);
						casaddr <= nextaddr; -- read whole cache line in burst mode.
						if nextport/=idle then
							bankbusy(to_integer(unsigned(nextaddr(sdram_bank_high downto sdram_bank_low))))<='1';
							if port0_extend='0' then
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
							end if;
						end if;
						
						if nextport=port0 then
							slot1read<='1';
							if unsigned(nextaddr(sdram_col_high downto 5)) /= (2**(sdram_col_high-4)-1) then
								slot1_autoprecharge<=not video_req.pri;
								port0_extend<=video_req.pri;
							end if;
							video_ack.ack<='1'; -- Signal to the video controller that we're servicing its request.
						elsif nextport=writecache then
							slot1_precharge<='1';
							wb_bank <= wbflagsaddr(sdram_bank_high downto sdram_bank_low);
							cas_dqm <= wbflagsaddr(wbflag_dqms);
						elsif nextport=port1 then
							slot1read<='1';
							cache_ack.ack<='1'; -- Signal to the cache that we're servicing its request.
						elsif nextport=port2 then
							slot1read<='1';
							dma_ack.ack<='1'; -- Signal to DMA controller that that we're servicing its request.
						end if;

					when ph3 =>
						null;

					when ph4 =>
						null;

					when ph5 => -- Read command
						dqm <= cas_dqm;
						if slot1read='1' then
							sdaddr <= (others=>'0');
							sdaddr((sdram_colbits-1) downto 0) <= casaddr(sdram_col_high downto sdram_col_low) ;--auto precharge
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
						null;

					when ph10 =>
						
						slot2read<='0';
						-- Slot 2, active command
						
						cas_dqm <= (others => '0');
						sdram_slot2<=idle;
						port0_extend<='0';
						slot2_autoprecharge<='1';
						
						sdram_slot2<=nextport;
						sdaddr <= nextaddr(sdram_row_high downto sdram_row_low);
						ba <= nextaddr(sdram_bank_high downto sdram_bank_low);
						slot2_bank <= nextaddr(sdram_bank_high downto sdram_bank_low);
						slot2_precharge_bank <= nextaddr(sdram_bank_high downto sdram_bank_low);
						casaddr <= nextaddr; -- read whole cache line in burst mode.

						if nextport/=idle then
							bankbusy(to_integer(unsigned(nextaddr(sdram_bank_high downto sdram_bank_low))))<='1';
							if port0_extend='0' then
								sd_cs <= '0'; --ACTIVE
								sd_ras <= '0';
							end if;
						end if;

						if nextport=port0 then
							slot2read<='1';
							if unsigned(nextaddr(sdram_col_high downto 5)) /= (2**(sdram_col_high-4)-1) then
								slot2_autoprecharge<=not video_req.pri;
								port0_extend<=video_req.pri;
							end if;
							video_ack.ack<='1'; -- Signal to VGA controller that we're servicing its request
						elsif nextport=writecache then
							slot2_precharge<='1';
							wb_bank <= wbflagsaddr(sdram_bank_high downto sdram_bank_low);
						elsif nextport=port1 then 
							slot2read<='1';
							cache_ack.ack<='1'; -- Signal to the cache that we're servicing its request
						elsif nextport=port2 then
							slot2read<='1';
							dma_ack.ack<='1'; -- Signal to DMA controller that we're servicing its request
						end if;
						
				
					when ph11 =>
						null;

					when ph12 =>
						null;

					
					-- Phase 13 - CAS for second window...
					when ph13 =>
						dqm <= cas_dqm;
						if slot2read='1' then
							sdaddr <= (others=>'0');
							sdaddr((sdram_colbits-1) downto 0) <= casaddr(sdram_col_high downto sdram_col_low) ;--auto precharge
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

					when others =>
						null;
						
				end case;

				if wbwrite='1' and wbflagsaddr(wbflag_newrow)='0' then -- Write one word from the writebuffer
					sdaddr <= (others=>'0');
					sdaddr((sdram_colbits-1) downto 0) <= wbflagsaddr(sdram_col_high downto sdram_col_low) ;--auto precharge
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
		type brr is array (0 to 3) of std_logic_vector(sdram_rowbits-1 downto 0);
		signal bank_refresh_row : brr;
	begin
	
		refreshloop: for i in 0 to 3 generate
			bank1_refresh : entity work.sdram_refresh_schedule
			generic map (
				tCK => tCK,
				rowbits => sdram_rowbits
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


