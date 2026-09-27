 --
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

library work;
use work.SoC_Peripheral_config.all;
use work.SoC_Peripheral_pkg.all;
use work.I2C_Phy_pkg.all;

entity I2C_controller is
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
		
		-- I2C interface
		I2C_in : in I2C_Phy_in;
		I2C_out : out I2C_Phy_out
	);
end entity;

	
architecture rtl of I2C_controller is
	signal i2c_rd : std_logic;
	signal i2c_wr : std_logic;
	signal i2c_sel : std_logic;
	signal i2c_addr : std_logic_vector(3 downto 0);
	signal i2c_d : std_logic_vector(31 downto 0);
	signal i2c_q : std_logic_vector(31 downto 0);
begin

	-- Handle CPU access to hardware registers

	requestlogic : block
		signal req_d : std_logic;
		signal rd_d : std_logic;
	begin
	
		i2c_sel <= '1' when request.addr(SoC_Block_HighBit downto SoC_Block_LowBit)=BlockAddress else '0';

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				req_d <= request.req;
				i2c_addr <= request.addr(5 downto 2);
				i2c_wr <= i2c_sel and request.req and request.wr and not req_d;
				i2c_rd <= i2c_sel and request.req and (not request.wr) and (not req_d);
				i2c_d <= request.d;
			end if;
		end process;
		
		process(clk_sys)
		begin
			if rising_edge(clk_sys) then
				response.q <= i2c_q;
				rd_d <= i2c_rd;
				response.ack<=rd_d or i2c_wr; -- Delay acknowledge of reads by one cycle.
			end if;

		end process;

	end block;

	i2cblock : block
	
		component i2chost is generic (
			clkfreq : integer := 100
		);
		port (
			clk : in std_logic;
			reset_n : in std_logic;
			
			d : in std_logic_vector(7 downto 0);
			d_stb : in std_logic;
			go : in std_logic;
			
			q : out std_logic_vector(7 downto 0);
			q_stb : in std_logic;
			q_ready : out std_logic;
			
			busy : out std_logic;
			err : out std_logic;
			
			scl_in : in std_logic;
			scl_out : out std_logic;
			sda_in : in std_logic;
			sda_out : out std_logic
		);
		end component;

		signal i2c_busy : std_logic;
		signal i2c_err : std_logic;
		signal i2c_reset : std_logic;
		
		signal i2c_d_data : std_logic_vector(7 downto 0);
		signal i2c_d_stb : std_logic;
		signal i2c_go : std_logic;
		
		signal i2c_q_stb : std_logic;
		signal i2c_q_ready : std_logic;
		signal i2c_q_data : std_logic_vector(7 downto 0);
		
		signal i2c_porttype : I2C_Port_Type;
		signal i2c_porttype_reg : I2C_Port_Type;
	begin

		i2c_porttype <= EDID  when i2c_d(3 downto 0) = X"1" else
                        SMBUS when i2c_d(3 downto 0) = X"2" else
                        GP0   when i2c_d(3 downto 0) = X"3" else
                        GP1   when i2c_d(3 downto 0) = X"4" else
                        NONE;

		i2c_inst : component i2chost 
		generic map (
			clkfreq => sysclk_freq
		)
		port map (
			clk => clk_sys,
			reset_n => i2c_reset,

			d => i2c_d_data,
			d_stb => i2c_d_stb,
			go => i2c_go,
			
			q => i2c_q_data,
			q_stb => i2c_q_stb,
			q_ready => i2c_q_ready,

			busy => i2c_busy,
			err => i2c_err,

			scl_in => i2c_in.scl,
			scl_out => i2c_out.scl,
			sda_in => i2c_in.sda,
			sda_out => i2c_out.sda	
		);
		
		i2c_out.porttype <= i2c_porttype_reg;
		
		-- Write side

		process(clk_sys) begin
			if rising_edge(clk_sys) then

				i2c_reset <= reset_n;
				i2c_d_stb <= '0';
				i2c_go <= '0';
				
				-- Write cycle
				if i2c_wr='1' then
					case i2c_addr is
						when "0000" =>  -- Status, bit 15 for reset, low order bits for port no
							i2c_reset <= not i2c_d(15);
							i2c_go <= i2c_d(8);
							i2c_porttype_reg <= i2c_porttype;
						when "0001" => -- Outgoing data
							i2c_d_data <= i2c_d(7 downto 0);
							i2c_d_stb <= '1';
						when others =>
							null;
					end case;				
				end if;
			end if;
		end process;

		-- Read side

		process(clk_sys) begin
			if rising_edge(clk_sys) then
				i2c_q_stb <= '0';
				if i2c_rd='1' then
					case i2c_addr is
						when "0000" => -- Status 
							i2c_q(i2c_q'high downto 1) <= (others => '0');
							i2c_q(0) <= i2c_q_ready;
							i2c_q(1) <= i2c_busy;
							i2c_q(2) <= i2c_err;
						when "0001" =>
							i2c_q(31 downto 8) <= X"000000";
							i2c_q(7 downto 0) <= i2c_q_data;
							i2c_q_stb <= '1';
						when others =>
							null;
					end case;
				end if;
			end if;
		end process;

	end block;		
	
end architecture;
