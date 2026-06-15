--
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;


entity usb_hid_controller is
	generic(
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"A";
		sysclk_freq : integer := 100
	);
	port (
		-- System clock / housekeeping
		clk_sys : in std_logic;
		reset_n : in std_logic;

		-- SoC interface
		request  : in SoC_Peripheral_Request;
		response : out SoC_Peripheral_Response;
		interrupt : out std_logic;
		
		-- USB interface
		usb_dp : inout std_logic_vector(1 downto 0);
		usb_dn : inout std_logic_vector(1 downto 0)
	);
end entity;

	
architecture rtl of usb_hid_controller is
	signal usb_rd : std_logic;
	signal usb_wr : std_logic;
	signal usb_sel : std_logic;
	signal usb_addr : std_logic_vector(3 downto 0);
	signal usb_d : std_logic_vector(31 downto 0);
	signal usb_q : std_logic_vector(31 downto 0);
begin

	-- Handle CPU access to hardware registers

	requestlogic : block
		signal req_d : std_logic;
		signal rd_d : std_logic;
	begin
	
		usb_sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				req_d <= request.req;
				usb_addr <= request.addr(5 downto 2);
				usb_wr <= usb_sel and request.req and request.wr and not req_d;
				usb_rd <= usb_sel and request.req and (not request.wr) and (not req_d);
				usb_d <= request.d;
			end if;
		end process;
		
		process(clk_sys)
		begin
			if rising_edge(clk_sys) then
				response.q <= usb_q;
				rd_d <= usb_rd;
				response.ack<=rd_d or usb_wr; -- Delay acknowledge of reads by one cycle.
			end if;

		end process;

	end block;

	usbblock : block
		component usb_hid_host is
		generic (
			fifodepth : integer := 6
		);
		port (
			usbclk : in std_logic;
			usbrst_n : in std_logic;
			usbtick : in std_logic;
			usb_dm : inout std_logic_vector(1 downto 0);
			usb_dp : inout std_logic_vector(1 downto 0);
			atn : out std_logic;
			connected : out std_logic_vector(1 downto 0);
			q : out std_logic_vector(15 downto 0);
			ack : in std_logic
		);
		end component;
		
		component frac_pulse is
		generic (
			freq_in : integer;
			freq_out : integer;
			counterwidth : integer := 16
		);
		port (
			clk : in std_logic;
			reset_n : in std_logic;
			q : out std_logic
		);
		end component;
		
		signal usb_atn : std_logic;
		signal usb_ack : std_logic;
		signal usb_connected : std_logic_vector(1 downto 0);
		signal usb_data : std_logic_vector(15 downto 0);
		signal usbtick : std_logic;
		
	begin

		tick : component frac_pulse 
		generic map (
			freq_in => sysclk_freq,
			freq_out => 12
		)
		port map (
			clk => clk_sys,
			reset_n => reset_n,
			q => usbtick
		);

		host : component usb_hid_host 
		port map (
			usbclk => clk_sys,
			usbrst_n => reset_n,
			usbtick => usbtick,
			usb_dm => usb_dn,
			usb_dp => usb_dp,
			atn => usb_atn,
			connected => usb_connected,
			q => usb_data,
			ack => usb_ack
		);

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				usb_ack <= '0';
				if usb_rd='1' then
					case usb_addr is
						when "0000" =>
							usb_q <= (0 => usb_atn, 1=>usb_connected(0), 2=>usb_connected(1), others => '0');
						when "0001" =>
							usb_q(31 downto 16) <= X"0000";
							usb_q(15 downto 0) <= usb_data;
							usb_ack <= '1';
						when others =>
							null;
					end case;
				end if;
			end if;
		end process;
	
		interrupt <= usb_atn;
	
	end block;		
	
end architecture;
