--
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.USB_Phy_pkg.all;
use work.JCapture_pkg.all;

entity usb_controller is
	generic(
		BlockAddress : std_logic_vector(SoC_BlockBits-1 downto 0) := X"A";
		sysclk_freq : integer := 100;
		usbclk_freq : integer := 60
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
		usb_clk : in std_logic;
		usb_in : in USB_Phy_in;
		usb_out : out USB_Phy_out
	);
end entity;

	
architecture rtl of usb_controller is
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
		component usb_interface is
		generic (
			portslog2 : integer := 1;
			ports : integer :=2 ;
			signalclk_freq : integer := 100
		);
		port (
			clk_sys : in std_logic;
			reset_n_sys : in std_logic;

			clk_signal : in std_logic;
			reset_n_signal : in std_logic;

			dp_i : in std_logic_vector(ports-1 downto 0);
			dm_i : in std_logic_vector(ports-1 downto 0);

			dp_o : out std_logic_vector(ports-1 downto 0);
			dm_o : out std_logic_vector(ports-1 downto 0);
			d_oe : out std_logic_vector(ports-1 downto 0);

			-- Outgoing data - SoC to port
			
			d_stb : in std_logic;
			d_send : in std_logic;
			d : in std_logic_vector(8 downto 0);
			
			-- Incoming data - port to SoC

			q_ready : out std_logic;
			q_ack : in std_logic;
			q : out std_logic_vector(7 downto 0);

			-- Control signals
			
			rewind : in std_logic; -- Temporary
			portselect : in std_logic_vector(portslog2 downto 0);
			portreset : in std_logic;
			portstatus : out std_logic_vector(7 downto 0)
		);
		end component;

		signal usb_status : std_logic_vector(7 downto 0);
		signal usb_port : std_logic_vector(usb_ports_log2 downto 0);
		signal usb_port_reset : std_logic;
		signal usb_d_data : std_logic_vector(8 downto 0);
		signal usb_d_stb : std_logic;
		signal usb_d_send : std_logic;

		signal usb_q_data : std_logic_vector(7 downto 0);
		signal usb_q_ready : std_logic;
		signal usb_q_ack : std_logic;
		signal usb_q_ready_d : std_logic;
		
		-- JTAG capture signals
		signal capture_d : std_logic_vector(31 downto 0);

	begin

		usb : component usb_interface
		generic map (
			portslog2 => usb_ports_log2,
			ports => usb_ports,
			signalclk_freq => 100
		)
		port map (
			-- Clocks and resets
			
			clk_sys => clk_sys,
			reset_n_sys => reset_n,
			clk_signal => clk_sys,
			reset_n_signal => reset_n,
			
			-- Physical signals
			
			dm_i => usb_in.dm,
			dp_i => usb_in.dp,
			dm_o => usb_out.dm,
			dp_o => usb_out.dp,
			d_oe => usb_out.oe,
			
			-- Outgoing data - SoC to port
			
			d_stb => usb_d_stb,
			d_send => usb_d_send,
			d => usb_d_data,
			
			-- Incoming data - port to SoC

			q_ready => usb_q_ready,
			q_ack => usb_q_ack,
			q => usb_q_data,

			-- Control signals
			
			rewind => '0',
			portselect => usb_port,
			portreset => usb_port_reset,
			portstatus => usb_status
		);

		-- Write side

		process(clk_sys) begin
			if rising_edge(clk_sys) then

				usb_d_stb <= '0';
				usb_d_send <= '0';
				
				-- Write cycle
				if usb_wr='1' then
					case usb_addr is
						when "0000" =>  -- Status, bit 15 for reset, low order bits for port no
							usb_port_reset <= usb_d(15);
							usb_port <= usb_d(usb_ports_log2 downto 0);
						when "0001" =>  -- Data
							usb_d_data <= usb_d(8 downto 0);
							usb_d_stb <= '1';
						when "0010" =>  -- Command - send: bit 0
							usb_d_send <= usb_d(0);						
						when others =>
							null;
					end case;				
				end if;
			end if;
		end process;

		-- Read side

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				usb_q_ack <= '0';

				if usb_rd='1' then
					case usb_addr is
						when "0000" => -- Status 
							usb_q(usb_q'high downto 8) <= (others => '0');
							usb_q(7 downto 0) <= usb_status;
						when "0001" =>
							usb_q(31 downto 8) <= X"000000";
							usb_q(7 downto 0) <= usb_q_data;
							usb_q_ack <= '1';
						when others =>
							null;
					end case;
				end if;
			end if;
		end process;

		-- Create a brief interrupt pulse from the ready signal.

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				usb_q_ready_d <= usb_q_ready;
				interrupt <= usb_q_ready and not usb_q_ready_d;
			end if;
		end process;
		
		-- JTAG Debugging
		
		capture_d(0) <= usb_d_send;
		capture_d(1) <= usb_d_stb;
		capture_d(10 downto 2) <= usb_d_data;
		capture_d(12 downto 11) <= usb_in.dp;
		capture_d(14 downto 13) <= usb_in.dm;
		capture_d(15) <= usb_port_reset;
		capture_d(capture_d'high downto 16) <= (others => '0');

--		jcapture_inst : component jcapture
--		generic map (
--			capturewidth => 32,
--			designid => 16#AA55#
--		)
--		port map (
--			clk => clk_sys,
--			reset_n => reset_n,
--			stb => '1',
--			capture_d => capture_d
--		);

	end block;		
	
end architecture;
