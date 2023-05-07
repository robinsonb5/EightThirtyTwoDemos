------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- SDRAM Write buffer                                                       --
--                                                                          --
-- Copyright (c) 2022 Alastair M. Robinson                                  -- 
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
use ieee.numeric_std.all;

library work;
use work.sdram_controller_pkg.all;

entity sdram_writebuffer is
port (
	sysclk : in std_logic;
	reset_n : in std_logic;
	cpu_req : in sdram_port_request;
	cpu_ack : out sdram_port_response;
	ram_req : out std_logic;
	ram_stb : out std_logic;
	ram_flagsaddr : out std_logic_vector(31 downto 0);
	ram_q : out std_logic_vector(sdram_width-1 downto 0);
	ram_firstword : in std_logic;
	ram_nextword : in std_logic;
	ram_lastword : in std_logic
);
end entity;

architecture behavioural of sdram_writebuffer is
	constant writebuffer_depth : integer := 8;
	constant writebuffer_mask : integer := (2**writebuffer_depth)-1;

	type writebuffer_addrstorage_t is array(0 to (2**writebuffer_depth-1)) of std_logic_vector(31 downto 0);
	type writebuffer_storage_t is array(0 to (2**writebuffer_depth-1)) of std_logic_vector(sdram_width-1 downto 0);
	attribute ramstyle : string;
	signal wbstore_flagsaddr : writebuffer_addrstorage_t;
	signal wbstore_data : writebuffer_storage_t;
	signal wbflagsaddr : std_logic_vector(31 downto 0);
	signal wbdata : std_logic_vector(sdram_width-1 downto 0);

	constant wbflag_newrow : integer := 31;
	subtype wbflag_dqms is natural range 30 downto 31-sdram_dqmwidth;

	signal wbwriteptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbreadptr : unsigned(writebuffer_depth-1 downto 0);
	signal wbptrdiff : unsigned(writebuffer_depth-1 downto 0);
	signal wbempty : std_logic;
	signal wbfull : std_logic;

	signal wback : std_logic;

	signal prevaddr : std_logic_vector(31 downto 0);
	signal burstend : std_logic;
	signal wbend : std_logic;
	signal wbend_d : std_logic;
	signal wbactive : std_logic;
	signal wb_wrena : std_logic;
	signal wb_req : std_logic;
begin

	cpu_ack.busy <= wbfull;
	cpu_ack.ack <= wback;
	cpu_ack.burst<='0';
	cpu_ack.strobe<='0';
	cpu_ack.nak <= '0';
	cpu_ack.q <= (others =>'X');
	cpu_ack.err <= '0';

	ram_req <= wb_req;
	ram_flagsaddr <= wbflagsaddr;
	ram_q <= wbdata;

	wbptrdiff <= wbwriteptr-wbreadptr;
	wbempty <= '1' when wbwriteptr=wbreadptr else '0';
	wbfull <= '1' when wbptrdiff(wbptrdiff'high downto 2)=(2**(writebuffer_depth-2))-1 else '0';
	wb_wrena<= '1' when cpu_req.req='1' and cpu_req.wr='1' and wback='0'
		and wbfull='0' else '0';

	process(sysclk,reset_n) begin
		if reset_n='0' then
			wbreadptr<=(others => '0');
			burstend<='0';
			wbflagsaddr<=(others => '0');
			wbactive <= '0';
		elsif rising_edge(sysclk) then
			ram_stb <= '0';
			wbend <= ram_lastword;	-- lag by 1 clock
			wbend_d <= wbend;
			wb_req <= not wbempty; -- Lag by 1 clock
			wbflagsaddr <= wbstore_flagsaddr(to_integer(wbreadptr));
			wbdata <= wbstore_data(to_integer(wbreadptr));
			
			if wbempty='0' and burstend='0' and ram_nextword='1' then
				wbactive<='1';
				ram_stb<=not wbflagsaddr(wbflag_newrow);
				if wbflagsaddr(wbflag_newrow)='0' then
					wbreadptr<=wbreadptr+1;
				end if;
			end if;
			
			if (wbactive='1' or ram_nextword='1') and wbflagsaddr(wbflag_newrow)='1' then
				burstend<='1';
			end if;

			if wb_req='1' and wbflagsaddr(wbflag_newrow)='1' and ram_firstword='1' then
				wbreadptr<=wbreadptr+1;
			end if;

			if wbend='1' then
				wbactive<='0';
				burstend<='0';
			end if;			
		end if;
	end process;

	-- write side - 32bit RAM
	-- Each incoming word is written verbatim into the writebuffer.

	wbwritethirtytwo: if sdram_width=32 generate
		process(sysclk,reset_n)
			variable flagaddr : std_logic_vector(31 downto 0);
		begin
			if reset_n='0' then
				wbwriteptr<=(others => '0');
				prevaddr<=(others => '0');
			elsif rising_edge(sysclk) then
				wback<='0';
				if wb_wrena='1' then
					flagaddr:=(others => '0');
					if prevaddr(sdram_bank_high downto sdram_row_low)/=cpu_req.addr(sdram_bank_high downto sdram_row_low) then
						flagaddr(wbflag_newrow) := '1';
					else
						flagaddr(wbflag_newrow) := '0';
						wback<='1';	-- Only acknowledge if the addresses match, so that a dummy entry gets inserted when the row changes.
					end if;
					flagaddr(sdram_bank_high downto 0) := cpu_req.addr(sdram_bank_high downto 0);
					flagaddr(wbflag_dqms) := not (cpu_req.bytesel(0) & cpu_req.bytesel(1) & cpu_req.bytesel(2) & cpu_req.bytesel(3));
					wbstore_flagsaddr(to_integer(wbwriteptr))<=flagaddr;
					wbstore_data(to_integer(wbwriteptr))<=cpu_req.d(sdram_width-1 downto 0);
					wbwriteptr<=wbwriteptr+1;
					prevaddr<=cpu_req.addr;
				end if;
			end if;
		end process;
	end generate;

	-- write side - 16bit RAM
	-- Each incoming word is split into two halves before being written into the writebuffer.

	wbwritesixteen: if sdram_width=16 generate
		signal secondword : std_logic;
		signal secondaddress : std_logic_vector(31 downto 0);
		signal seladdr : std_logic_vector(31 downto 0);
		signal selword : std_logic_vector(15 downto 0);
		signal selbs : std_logic_vector(1 downto 0);
	begin
		process(sysclk) begin
			if rising_edge(sysclk) then
				secondaddress <= std_logic_vector(unsigned(cpu_req.addr) + 2);
			end if;
		end process;

		seladdr<=secondaddress when secondword='1' else cpu_req.addr;
		selword<=cpu_req.d(31 downto 16) when secondword='1' else cpu_req.d(15 downto 0);
		selbs <= cpu_req.bytesel(1 downto 0) when secondword='1' else cpu_req.bytesel(3 downto 2);

		process(sysclk,reset_n)
			variable flagaddr : std_logic_vector(31 downto 0);
		begin
			if reset_n='0' then
				wbwriteptr<=(others => '0');
				prevaddr<=(others => '0');
			elsif rising_edge(sysclk) then

				wback<='0';
				if wb_wrena='1' then
					flagaddr:=(others => '0');
					if prevaddr(sdram_bank_high downto sdram_row_low)/=cpu_req.addr(sdram_bank_high downto sdram_row_low) then
						flagaddr(wbflag_newrow) := '1';
					else
						flagaddr(wbflag_newrow) := '0';
						secondword<=not secondword;
						wback<=secondword;	-- Only acknowledge if the addresses match, so that a dummy entry gets inserted when the row changes.
					end if;
					flagaddr(sdram_bank_high downto 0) := seladdr(sdram_bank_high downto 0);
					flagaddr(wbflag_dqms) := not (selbs(0) & selbs(1));
					wbstore_flagsaddr(to_integer(wbwriteptr))<=flagaddr;
					wbstore_data(to_integer(wbwriteptr))(15 downto 0)<=selword;
					wbwriteptr<=wbwriteptr+1;
					prevaddr<=seladdr;
				else
					secondword<='0';
				end if;
			end if;
		end process;
	end generate;
	
end architecture;

