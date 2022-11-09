------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Sound wrapper to mix the audio from four sound channels                  --
--                                                                          --
-- Copyright (c) 2014 - 2022 Alastair M. Robinson                           -- 
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

use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;

package sound_wrapper_pkg is
	type sound_dma_requests is array (3 downto 0) of DMAChannel_FromHost;
	type sound_dma_responses is array (3 downto 0) of DMAChannel_ToHost;
end package;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;


library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.sound_wrapper_pkg.all;

entity sound_wrapper is
	generic (
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"D";
		dmawidth : integer := 16;
		clk_frequency : integer := 1000 -- System clock frequency
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;

		dma_data : in std_logic_vector(dmawidth-1 downto 0);
		dma_requests : out sound_dma_requests;
		dma_responses : in sound_dma_responses;
		
		audio_l : out signed(23 downto 0);
		audio_r : out signed(23 downto 0);
		audio_ints : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of sound_wrapper is

	constant clk_hz : integer := clk_frequency*100000;
	constant clkdivide : integer := clk_hz/3546895;
	signal audiotick : std_logic;
	
	-- Select signals for the four channels
	signal selchan : std_logic_vector(3 downto 0);

	-- The output of each channel.  Aud0 and 3 will be summed to make the left channel
	-- while aud1 and 2 will be summed to make the right channel.
	type aud_t is array(0 to 3) of signed(21 downto 0);
	signal aud : aud_t;

	signal reg_addr : std_logic_vector(7 downto 0);
	signal req : std_logic_vector(3 downto 0);

begin

	-- Create ~3.5Mhz tick signal
	-- FIXME - will need to make this more accurate in time.

	myclkdiv: entity work.risingedge_divider
		generic map (
			divisor => clkdivide,
			bits => 6
		)
		port map (
			clk => clk,
			reset_n => reset, -- Active low
			tick => audiotick
		);

	-- Handle CPU access to hardware registers

	requestlogic : block
		signal sel : std_logic;
		signal req_d : std_logic;
		signal cpu_req : std_logic;
	begin
		sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk) begin
			if rising_edge(clk) then
				req_d <= request.req;
				cpu_req<=sel and request.req and request.wr and not req_d;
			end if;
		end process;
		
		process(clk) begin
			if rising_edge(clk) then
				response.ack<=sel and request.req and not req_d;
				response.q<=(others => '0');	-- Maybe return a version number?
			end if;
		end process;
	
		reg_addr <= "000" & request.addr(4 downto 0);

		selchan(0)<='1' when request.addr(6 downto 5)="00" else '0';
		selchan(1)<='1' when request.addr(6 downto 5)="01" else '0';
		selchan(2)<='1' when request.addr(6 downto 5)="10" else '0';
		selchan(3)<='1' when request.addr(6 downto 5)="11" else '0';

		req(0) <= cpu_req and selchan(0);
		req(1) <= cpu_req and selchan(1);
		req(2) <= cpu_req and selchan(2);
		req(3) <= cpu_req and selchan(3);

	end block;

	audiochannels : for i in 0 to 3 generate
		channel : entity work.sound_controller
			generic map (
				dmawidth => dmawidth
			)
			port map (
				clk => clk,
				reset => reset,
				audiotick => audiotick,

				reg_addr_in => reg_addr,
				reg_data_in => request.d,
				reg_data_out => open,
				reg_rw => '0',
				reg_req => req(i),

				dma_data => dma_data,
				channel_fromhost => dma_requests(i),
				channel_tohost => dma_responses(i),
				
				audio_out => aud(i),
				audio_int => audio_ints(i)
			);
	end generate;

	-- Sum the audio channels to create the output
	process(clk) begin
		if rising_edge(clk) then
			audio_l(0)<='0';
			audio_r(0)<='0';
			audio_l(23 downto 1)<=(aud(0)(21)&aud(0))+(aud(3)(21)&aud(3));
			audio_r(23 downto 1)<=(aud(1)(21)&aud(1))+(aud(2)(21)&aud(2));
		end if;
	end process;

end architecture;
