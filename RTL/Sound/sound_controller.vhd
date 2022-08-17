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
	generic (
		dmawidth : integer := 16
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		audiotick : in std_logic;

		reg_addr_in : in std_logic_vector(7 downto 0); -- from host CPU
		reg_data_in: in std_logic_vector(31 downto 0);
		reg_data_out: out std_logic_vector(15 downto 0);
		reg_rw : in std_logic;
		reg_req : in std_logic;

		dma_data : in std_logic_vector(dmawidth-1 downto 0);
		channel_fromhost : out DMAChannel_FromHost;
		channel_tohost : in DMAChannel_ToHost;
		
		audio_out : out signed(21 downto 0);
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
	signal pan : std_logic_vector(1 downto 0);
	signal format : std_logic_vector(1 downto 0);
	signal mode : std_logic_vector(1 downto 0);

	-- Sound data
	signal byte : unsigned(1 downto 0);
	signal sampleword : std_logic_vector(dmawidth-1 downto 0);
	signal sample : signed(15 downto 0);
	signal sampleout : signed(22 downto 0);
	signal sampletick : std_logic; 	-- single pulse on underflow of period counter
	signal trigger : std_logic;
	
begin

	volume(6)<='0'; -- Make volume effectively unsigned.


	-- Multiplexer, selects between high and low byte of the sampleword.
	demux16 : if dmawidth=16 generate
		signal sel : std_logic_vector(3 downto 0);
	begin
		sel <= std_logic_vector(byte) & format; 
 		sample <= signed(sampleword(15 downto 8)&X"00") when sel="0100" else
		          signed(sampleword(7 downto 0)&X"00") when sel="0000" else
		          signed(sampleword(7 downto 0) & sampleword(15 downto 8));
	end generate;

	demux32 : if dmawidth=32 generate
		signal sel : std_logic_vector(3 downto 0);
	begin
		sel <= std_logic_vector(byte) & format; 
		sample <= signed(sampleword(31 downto 24)&X"00") when sel="1100" else
		          signed(sampleword(23 downto 16)&X"00") when sel="1000" else
		          signed(sampleword(15 downto 8)&X"00") when sel="0100" else
		          signed(sampleword(7 downto 0)&X"00") when sel="0000" else
		          signed(sampleword(23 downto 16) & sampleword(31 downto 24)) when sel="0101" else
		          signed(sampleword(7 downto 0) & sampleword(15 downto 8));
	end generate;

	audio_out<=sampleout(21 downto 0);

	-- Handle CPU access to hardware registers
	
	process(clk,reset)
	begin
		if reset='0' then
			channel_fromhost.req <='0';
			channel_fromhost.setaddr <='0';
			channel_fromhost.reqlen <= (others => '0');
			channel_fromhost.setreqlen <='1';
			channel_fromhost.addr <= (others => '0');
			channel_fromhost.setaddr <= '0';
			volume(5 downto 0) <= (others => '0');
			byte <="00";
			trigger <='0';
			datalen<=(others => '0');
			sampleword <= (others => '0');
			reg_data_out<=(others => '0');
			period <= (others => '0');
			sampleout <= (others => '0');
			audio_int <= '0';
			mode <= (others =>'0');
			pan <= (others =>'0');
			format <= (others =>'0');
		elsif rising_edge(clk) then

			-- Register sampleout to reduce combinational length and pipeline the multiplication
			sampleout <= sample * volume;

			channel_fromhost.setaddr <='0';
			channel_fromhost.setreqlen <='0';
			channel_fromhost.req <='0';
			reg_data_out<=(others => '0');
			trigger<='0';
			audio_int <= '0';
			if sampletick='1' then
				if byte="00" and datalen/=X"0000" then
					-- request one sample
					channel_fromhost.req<='1';
					datalen<=datalen-1;
				else
					byte<=byte-1;
				end if;
				
				if byte="01" then
					if datalen=X"0000" then
						channel_fromhost.addr <= datapointer;
						channel_fromhost.setaddr <='1';
						if dmawidth=32 then
							datalen(15)<='0';
							datalen(14 downto 0) <= repeatlen(15 downto 1);
							channel_fromhost.reqlen(15)<='0';
							channel_fromhost.reqlen(14 downto 0) <= repeatlen(15 downto 1);
						else
							datalen <= repeatlen;
							channel_fromhost.reqlen <= repeatlen;
						end if;
						channel_fromhost.setreqlen <='1';
						if repeatlen/=X"0000" then
							audio_int <= mode(0);
						end if;
					end if;
				end if;
			-- Channel fetch
			end if;
			
			if channel_tohost.valid='1' then
				sampleword<=dma_data;
				if dmawidth=16 then
					if format="00" then
						byte <= "01"; -- First of two bytes
					else
						byte <= "00"; -- Only one word
					end if;
				else
					if format="00" then
						byte <= "11"; -- First of four bytes
					else
						byte <= "01"; -- First of two words
					end if;
				end if;
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
						if dmawidth=32 then
							datalen(15)<='0';
							datalen(14 downto 0) <= repeatlen(15 downto 1);
							channel_fromhost.reqlen(15)<='0';
							channel_fromhost.reqlen(14 downto 0) <= repeatlen(15 downto 1);
						else
							datalen <= repeatlen;
							channel_fromhost.reqlen <= repeatlen;
						end if;
						channel_fromhost.setreqlen <='1';
						trigger<='1';
						byte<="01";
					when X"0c" => -- Period
						period <= reg_data_in(15 downto 0);
					when X"10" => -- Volume
						if reg_data_in(6)='1' then -- Yes, I know, 0x40 and 0x3f shouldn't be the same
							volume(5 downto 0)<=(others=>'1');
						else
							volume(5 downto 0) <= signed(reg_data_in(5 downto 0));
						end if;
					when X"14" => -- Panning
						pan <= reg_data_in(1 downto 0);
					when X"18" => -- Sample format
						format <= reg_data_in(1 downto 0);
					when X"1C" => -- Mode
						mode <= reg_data_in(1 downto 0);
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
