library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;

-- Sound controller
-- a module to handle a single channel of DMA-driven 8-bit audio, with
-- six bit volume control, giving 14-bit output.
-- (These specifications might sound familiar to ex-Amiga users!)

-- To achieve Amiga-accurate pitches we need a clock of
-- 3546895 Hz (PAL) or 3579545 (NTSC)


entity sound_controller is
	port (
		clk : in std_logic;
		reset : in std_logic;
		audiotick : in std_logic;

		reg_addr_in : in std_logic_vector(7 downto 0); -- from host CPU
		reg_data_in: in std_logic_vector(31 downto 0);
		reg_data_out: out std_logic_vector(15 downto 0);
		reg_rw : in std_logic;
		reg_req : in std_logic;

		dma_data : in std_logic_vector(15 downto 0);
		channel_fromhost : out DMAChannel_FromHost;
		channel_tohost : in DMAChannel_ToHost;
		
		audio_out : out signed(13 downto 0);
		audio_int : out std_logic
	);
end entity;
	
architecture rtl of sound_controller is
	-- Sound channel state
	signal datapointer : std_logic_vector(31 downto 0);
	signal datalen : unsigned(15 downto 0);
	signal repeatpointer : std_logic_vector(31 downto 0);
	signal repeatlen : unsigned(15 downto 0);
	signal period : std_logic_vector(15 downto 0);
	signal periodcounter : unsigned(15 downto 0);
	signal volume : signed(6 downto 0);

	-- Sound data
	signal hibyte : std_logic;
	signal sampleword : std_logic_vector(15 downto 0);
	signal sample : signed(7 downto 0);
	signal sampleout : signed(14 downto 0);
	signal sampletick : std_logic; 	-- single pulse on underflow of period counter
	signal trigger : std_logic;

begin

	volume(6)<='0'; -- Make volume effectively unsigned.


	-- Multiplexer, selects between high and low byte of the sampleword.
	sample <= signed(sampleword(15 downto 8)) when hibyte='1' else signed(sampleword(7 downto 0));
	audio_out<=sampleout(13 downto 0);

	-- Handle CPU access to hardware registers
	
	process(clk,reset)
	begin
		if reset='0' then
			channel_fromhost.reqlen <= (others => '0');
			channel_fromhost.setreqlen <='1';
			volume(5 downto 0) <= (others => '0');
		elsif rising_edge(clk) then

			-- Register sampleout to reduce combinational length and pipeline the multiplication
			sampleout <= sample * volume;

			channel_fromhost.setaddr <='0';
			channel_fromhost.setreqlen <='0';
			channel_fromhost.req <='0';
			reg_data_out<=(others => '0');
			trigger<='0';

			if sampletick='1' then
				if hibyte='0' and datalen/=X"0000" then
					-- request one sample
					channel_fromhost.req<='1';
					datalen<=datalen-1;
				else
					hibyte<='0';
					if datalen=X"0000" then
						channel_fromhost.addr <= datapointer;
						channel_fromhost.setaddr <='1';			
						channel_fromhost.reqlen <= repeatlen;
						datalen <= repeatlen;
						channel_fromhost.setreqlen <='1';
					end if;
				end if;
			-- Channel fetch
			end if;

			if channel_tohost.valid='1' then
				sampleword<=dma_data;
				hibyte <= '1'; -- First or second sample from the word?
			end if;

			if reg_req='1' and reg_rw='0' then
				case reg_addr_in is
					when X"00" =>	-- Data pointer
						datapointer <= reg_data_in;
					when X"04" => -- Data length
						repeatlen <= unsigned(reg_data_in(15 downto 0));
					when X"08" => -- Trigger
						channel_fromhost.addr <= datapointer;
						channel_fromhost.setaddr <='1';			
						channel_fromhost.reqlen <= repeatlen;
						datalen <= repeatlen;
						channel_fromhost.setreqlen <='1';
						trigger<='1';
						hibyte<='1';
					when X"0c" => -- Period
						period <= reg_data_in(15 downto 0);
					when X"10" => -- Volume
						if reg_data_in(6)='1' then -- Yes, I know, 0x40 and 0x3f shouldn't be the same
							volume(5 downto 0)<=(others=>'1');
						else
							volume(5 downto 0) <= signed(reg_data_in(5 downto 0));
						end if;
					when others =>
				end case;
			end if;
		end if;
	end process;


-- Generate sampletick signal from audiotick and period counter
process(clk)
begin
	if rising_edge(clk) then
		sampletick<='0';
		if audiotick='1' then
			periodcounter<=periodcounter-1;
			if periodcounter=X"0000" or trigger='1' then
				periodcounter<=unsigned(period);
				sampletick<='1';
			end if;
		end if;
	end if;
end process;

end architecture;
