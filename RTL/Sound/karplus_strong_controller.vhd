------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --                                                       --
-- Copyright (c) 2022 - 2022 Alastair M. Robinson                           -- 
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


entity karplus_strong_controller is
	port (
		clk : in std_logic;
		reset_n : in std_logic;

		reg_addr_in : in std_logic_vector(7 downto 0); -- from host CPU
		reg_data_in: in std_logic_vector(31 downto 0);
		reg_data_out: out std_logic_vector(15 downto 0);
		reg_rw : in std_logic;
		reg_req : in std_logic;
		
		audio_out : out signed(23 downto 0);
		audio_in : in signed(23 downto 0)
	);
end entity;
	
architecture rtl of karplus_strong_controller is
	-- Sound channel state
	signal period : std_logic_vector(15 downto 0);
	signal periodcounter : unsigned(15 downto 0);
	signal kstick : std_logic;
	signal filterperiod : std_logic_vector(15 downto 0);
	signal filterperiodcounter : unsigned(15 downto 0);
	signal filtertick : std_logic;
	signal volume : signed(6 downto 0);
	signal trigger : std_logic;
	signal ksdata : signed(23 downto 0);
	signal sampleout : signed(30 downto 0);
begin

	volume(6)<='0'; -- Make volume effectively unsigned.

--	audio_out <= sampleout(30 downto 7);
	audio_out <= (not ksdata(23)) & ksdata(22 downto 0);

	process(clk)
	begin
		if rising_edge(clk) then

			-- Register sampleout to reduce combinational length and pipeline the multiplication
			sampleout <= ksdata * volume;

			reg_data_out<=(others => '0');
			trigger<='0';

			if reg_req='1' and reg_rw='0' then
				case reg_addr_in is
					when X"00" => -- Period
						period <= reg_data_in(15 downto 0);
					when X"04" => -- Filter Period
						filterperiod <= reg_data_in(15 downto 0);
					when X"08" => -- Volume
						if reg_data_in(6)='1' then -- Yes, I know, 0x40 and 0x3f shouldn't be the same
							volume(5 downto 0)<=(others=>'1');
						else
							volume(5 downto 0) <= signed(reg_data_in(5 downto 0));
						end if;
					when X"0C" => -- Trigger
						trigger<='1';
					when others =>
				end case;
			end if;
		end if;
	end process;


	-- Generate kstick signal 
	process(clk)
	begin
		if rising_edge(clk) then
			kstick<='0';
			periodcounter<=periodcounter-1;
			if periodcounter=X"0000" then
				periodcounter<=unsigned(period);
				kstick<='1';
			end if;
		end if;
	end process;

	-- Generate filtertick signal
	process(clk)
	begin
		if rising_edge(clk) then
			filtertick<='0';
			filterperiodcounter<=filterperiodcounter-1;
			if filterperiodcounter=X"0000" then
				filterperiodcounter<=unsigned(filterperiod);
				filtertick<='1';
			end if;
		end if;
	end process;

	-- Generate noise burst:
	noiseburst : block
		component lfsr is
			generic (
				width : integer := 32
			);
			port (
				clk : in std_logic;
				reset_n : in std_logic;
				e : in std_logic;
				save : in std_logic := '0';
				restore : in std_logic := '0';
				q : out std_logic_vector(width-1 downto 0)
			);
		end component;
		signal lfsrdata : std_logic_vector(31 downto 0);
		signal chirpctr : unsigned(11 downto 0);
		signal chirp : std_logic;
		signal ksin : unsigned(23 downto 0);
	begin
		chirplfsr : component lfsr
			generic map (
				width => 32
			)
			port map (
				clk => clk,
				reset_n => reset_n,
				e => filtertick,
				q => lfsrdata
			);
	
		process(clk,reset_n)	begin
			if reset_n='0' then
				chirp<='0';
				chirpctr<=(others=>'0');
			elsif rising_edge(clk) then
				if trigger='1' then
					chirp<='1';
					chirpctr<=(others => '1');
				end if;
				
				if chirpctr=0 then
					chirp<='0';
				end if;
				
				if kstick='1' then
					chirpctr<=chirpctr-1;
				end if;

			end if;
		end process;

		ksin <= unsigned(std_logic_vector(chirpctr(9 downto 0)) & lfsrdata(13 downto 0)) when chirp='1' else unsigned(audio_in);

		synth : entity work.karplus_strong
			generic map (
				datawidth => 24,
				depthbits => 10
			)
			port map (
				clk => clk,
				reset_n => reset_n,
				ena => kstick,
				filter_ena => filtertick,
				excite => chirp,
				d => ksin,
				signed(q) => ksdata
			);

	end block;

end architecture;
