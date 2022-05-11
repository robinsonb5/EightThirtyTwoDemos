library ieee;
use ieee.std_logic_1164.all;

-- Crossing clock domains safely without a FIFO.
-- Suitable for audio data, where the input code transitions significantly more
-- slowly than either clock signal.
-- A code takes three clk_d cycles and three clk_q cycles to propagate.

entity cdc_bus is
generic (
	width : integer := 16
);
port (
	clk_d : in std_logic;
	d : in std_logic_vector(width-1 downto 0);
	clk_q : in std_logic;
	q : out std_logic_vector(width-1 downto 0)
);
end entity;

architecture rtl of cdc_bus is
	signal buf : std_logic_vector(width-1 downto 0);
	signal d_req : std_logic := '0';
	signal q_ack : std_logic := '0';
begin

	-- Synchronise the q_ack signal to d clock.
	-- If it matches d_req, copy d to buf and invert d_req.
	readside : block
		signal ack_d : std_logic := '0';
		signal ack_d2 : std_logic := '0';	
	begin
		process(clk_d) begin
			if rising_edge(clk_d) then
				ack_d2<=q_ack;
				ack_d<=ack_d2;
				
				if ack_d=d_req then
					buf <= d;
					d_req<=not d_req;
				end if;
				
			end if;
		end process;
	end block;


	-- Sync d_req to clk_q domain.
	-- If it doesn't match q_ack then copy buf to q and set q_ack to match req_q.
	writeside : block
		signal req_q : std_logic := '0';
		signal req_q2 : std_logic := '0';
	begin
		process(clk_q) begin
			if rising_edge(clk_q) then
				req_q2 <= d_req;
				req_q <= req_q2;
				if req_q /= q_ack then
					q <= buf;
					q_ack <= req_q;
				end if;
			end if;
		end process;
	end block;
end;

