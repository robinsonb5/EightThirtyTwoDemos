library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.sdram_controller_pkg.all;
use work.sdram_writearbiter_pkg.all;

entity sdram_writearbiter is
	port (
		clk : in std_logic;
		reset_n : in std_logic;

		requests : in writearbiter_port_requests;
		responses : out writearbiter_port_responses;
		
		request : out sdram_port_request;
		response : in sdram_port_response
	);
end entity;

architecture rtl of sdram_writearbiter is
	signal currentport : integer;
	signal nextport : integer;
	signal req : std_logic;

	type arbiterstate_t is (IDLE,WAITING);
	signal arbiterstate : arbiterstate_t;
begin

	process(requests) begin
		req<='0';
		nextport <= 0;
		for i in writearbiter_ports-1 downto 0 loop
			if requests(i).req='1' then
				req<='1';
				nextport <= i;
			end if;
		end loop;
	end process;

	process(clk) begin
		if rising_edge(clk) then
			case arbiterstate is
				when IDLE =>
					if req='1' then
						currentport<=nextport;
						arbiterstate<=WAITING;
					end if;
					
				when WAITING =>
					if requests(currentport).req='0' and requests(currentport).burst='0' then
						currentport<=0;
						arbiterstate<=IDLE;
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;

	request<=requests(currentport);
	process(currentport,response) begin
		for i in writearbiter_ports-1 downto 0 loop
			responses(i)<=response;
			if currentport/=i then
				responses(i).ack<='0';
			end if;
		end loop;
	end process;

end architecture;
