library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.math_real.all;

library work;
use work.DMACache_pkg.ALL;
use work.DMACache_config.ALL;
use work.sdram_controller_pkg.all;

-- Currently supports up to 8 DMA channels.

entity DMACache is
	port(
		clk : in std_logic;
		reset_n : in std_logic;

		channels_from_host : in DMAChannels_FromHost
			:= (others =>
					(
						addr => (others =>'X'),
						setaddr => '0',
						reqlen => (others =>'X'),
						setreqlen => '0',
						req => '0'
					));
		channels_to_host : out DMAChannels_ToHost;

		data_out : out std_logic_vector(31 downto 0);

		-- SDRAM interface

		to_sdram : out sdram_port_request;
		from_sdram : in sdram_port_response
	);
end entity;

architecture rtl of dmacache is

constant burstlog2 : integer := integer(log2(real(sdram_width/4))); -- Four words if RAM is 16-bit, eight if 32-bit.
constant cachemsb : integer := DMACache_MaxCacheBit + DMACache_MaxChannelsLog2;
type inputstate_t is (rd1,waitrcv,rcv);
signal inputstate : inputstate_t := rd1;


-- DMA channel state information
type DMAChannel_Internal is record
	valid_d : std_logic; -- Used to delay the valid flag
	wrptr : unsigned(DMACache_MaxCacheBit downto 0);
	wrptr_next : unsigned(DMACache_MaxCacheBit downto 0);
	addr : std_logic_vector(31 downto 0); -- Current RAM address
	count : unsigned(DMACache_ReqLenMaxBit+1 downto 0); -- Number of words to transfer.
--	fill : std_logic;	-- Add a word to the FIFO
	extend : std_logic;
end record;

type DMAChannels_Internal is array (DMACache_MaxChannel downto 0) of DMAChannel_Internal;
signal internals : DMAChannels_Internal;

type DMAChannel_Internal_Read is record
	rdptr : unsigned(DMACache_MaxCacheBit downto 0);
	pending : std_logic; -- Host has a request pending on this channel
--	drain : std_logic; -- Drain a word from the FIFO
end record;

type DMAChannels_Internal_Read is array (DMACache_MaxChannel downto 0) of DMAChannel_Internal_Read;
signal internals_read : DMAChannels_Internal_Read;

type DMAChannel_Internal_FIFO is record
	full : std_logic; -- Is the FIFO full
	empty_c : std_logic; -- Are the read and write pointers currently equal?
	empty_l : std_logic; -- Were the read and write pointers equal in the last cycle?
	empty : std_logic; -- Set whenever the address is set, cleared when empty_c drops.
end record;

type DMAChannels_Internal_FIFO is array (DMACache_MaxChannel downto 0) of DMAChannel_Internal_FIFO;
signal internals_FIFO : DMAChannels_Internal_FIFO;


-- interface to the blockram

signal cache_wraddr : std_logic_vector(cachemsb downto 0);
signal wrptr_lsb_next : unsigned(burstlog2-1 downto 0);
--signal cache_wraddr_lsb : unsigned(burstlog2-1 downto 0);
signal cache_rdaddr : std_logic_vector(cachemsb downto 0);
signal cache_wren : std_logic;
signal data_from_ram : std_logic_vector(31 downto 0);

signal activechannel : integer range 0 to DMACache_MaxChannel;
signal channelvalid : std_logic_vector(DMACache_MaxChannel downto 0);
begin

FIFOCounters:
for CHANNEL in 0 to DMACache_MaxChannel generate

	internals_FIFO(CHANNEL).full<='1' when
		internals(CHANNEL).wrptr_next(DMACache_MaxCacheBit downto burstlog2) = internals_read(CHANNEL).rdptr(DMACache_MaxCacheBit downto burstlog2)
			else '0';

	internals_FIFO(CHANNEL).empty_c<='1' when
		internals(CHANNEL).wrptr = internals_read(CHANNEL).rdptr
			else '0';

	process(clk) begin
		if rising_edge(clk) then

			if internals_FIFO(CHANNEL).empty_c='1' or channels_from_host(CHANNEL).setaddr='1' then
				internals_FIFO(CHANNEL).empty<='1';
			end if;

			if internals_FIFO(CHANNEL).empty_c='1' and activechannel=CHANNEL and inputstate=rcv then
				internals_FIFO(CHANNEL).empty<='0';
			end if;

		end if;
	end process;

--	myfifocounter : entity work.FIFO_Counter
--	generic map(
--		maxbit=>5
--	)
--	port map(
--		clk => clk,
--		reset => channels_from_host(CHANNEL).setaddr,
--		fill => internals(CHANNEL).fill,
--		drain => internals_read(CHANNEL).drain,
--		full => internals_FIFO(CHANNEL).full,
--		empty => internals_FIFO(CHANNEL).empty
--	);
end generate;

myDMACacheRAM : entity work.DMACacheRAM
	generic map
	(
		CacheWidth => 32,
		CacheAddrBits => 9
	)
	port map
	(
		clock => clk,
		data => data_from_ram,
		rdaddress => cache_rdaddr,
		wraddress => cache_wraddr,
		wren => cache_wren,
		q => data_out
	);

-- Mark the request as high priority if the fifo is nearly empty.
to_sdram.pri <= '1' when internals(0).count(15 downto 6)/=X"00"&"00"
								and internals_FIFO(0).full='0' else '0';


-- We update these outside the clock edge
-- (Limit the fetch address to begin on a burst boundary)
to_sdram.addr(31 downto burstlog2+2)<=internals(activechannel).addr(31 downto burstlog2+2);
to_sdram.addr(burstlog2+2-1 downto 0)<=(others => '0');

--cache_wraddr(burstlog2-1 downto 0)<=std_logic_vector(cache_wraddr_lsb);
cache_wraddr(cachemsb downto 0)
	<= std_logic_vector(to_unsigned(activechannel,3))
		&std_logic_vector(internals(activechannel).wrptr(DMACache_MaxCacheBit downto 0));

wrptr_lsb_next <= internals(activechannel).wrptr(burstlog2-1 downto 0) + 1;

	-- Temporary debugging - monitor incoming data for erroneous data.
	debugging : block
		attribute noprune : boolean;
		signal error : std_logic;
		attribute noprune of error : signal is true;
	begin
		process(clk,reset_n) begin
			if rising_edge(clk) then
				if reset_n='0' then
					error<='0';
				else
					if activechannel=5 and from_sdram.strobe='1' then
						if from_sdram.q(31 downto 24)/=X"00" then
							error <= '1';
						end if;
					end if;
				end if;
			end if;
		end process;
	end block;

process(clk)
	variable servicechannel : integer range 0 to DMACache_MaxChannel;
	variable serviceactive : std_logic;
begin

	if rising_edge(clk) then
		if reset_n='0' then
			inputstate<=rd1;
			for I in 0 to DMACache_MaxChannel loop
				internals(I).count<=(others => '0');
			end loop;
		end if;

		cache_wren<='0';
		
		if from_sdram.ack='1' then
			to_sdram.req<='0';
			internals(activechannel).addr<=std_logic_vector(unsigned(internals(activechannel).addr)+(sdram_width/8)*8);
			if internals(activechannel).extend='1' then -- Read an extra word for non-aligned reads.
				internals(activechannel).count<=internals(activechannel).count+(2**burstlog2);
				internals(activechannel).extend<='0';
			end if;
		end if;
		
		if from_sdram.strobe='1' and internals(activechannel).extend='0' then
			internals(activechannel).count<=internals(activechannel).count-1;
		end if;
		

		-- Request and receive data from SDRAM:
		case inputstate is
			-- First state: Read.  Check the channels in priority order.
			-- Lowest numbered channel has highest priority.
			when rd1 =>
				for I in DMACache_MaxChannel downto 0 loop
					if internals_FIFO(I).full='0'
						and internals(I).count(DMACache_ReqLenMaxBit downto 0)/=X"0000"
							and internals(I).count(DMACache_ReqLenMaxBit+1)='0' then
						activechannel <= I;
						to_sdram.req<='1';
						inputstate<=waitrcv;
					end if;
				end loop;

				for I in 0 to DMACache_MaxChannel loop
					if internals(I).count=X"0000" then
						channels_to_host(I).done<='1';
					end if;
				end loop;


			-- Wait for SDRAM, fill first word.
			when waitrcv =>
--				if sdram_nak='1' then -- Back out of a read request if the cycle's not serviced
--					to_sdram.req<='0';	-- (Allows priorities to be reconsidered.)
--					inputstate<=rd1;
--				end if;
				if from_sdram.strobe='1' then
					data_from_ram<=from_sdram.q;
					cache_wren<='1';
					inputstate<=rcv;
					internals(activechannel).wrptr(burstlog2-1 downto 0)<=(others => '0');
--					cache_wraddr_lsb<=(others => '0');
--					internals(activechannel).fill<='1';
				end if;
			when rcv =>
				if from_sdram.strobe='1' then
					data_from_ram<=from_sdram.q;
					cache_wren<='1';
					internals(activechannel).wrptr(burstlog2-1 downto 0)<=wrptr_lsb_next;
--					cache_wraddr_lsb<=cache_wraddr_lsb+1;
--					internals(activechannel).fill<='1';
				end if;

				if from_sdram.burst='0' then
					internals(activechannel).wrptr<=internals(activechannel).wrptr_next;
					internals(activechannel).wrptr_next<=internals(activechannel).wrptr_next+(2**burstlog2);
					inputstate<=rd1;
				end if;
	
			when others =>
				null;
		end case;
	
		for I in 0 to DMACache_MaxChannel loop
			if channels_from_host(I).setaddr='1' then
				internals(I).addr<=channels_from_host(I).addr;
				internals(I).extend<='1'; -- If the data isn't burst-aligned we need to read an extra burst.
				if channels_from_host(I).addr(burstlog2+1 downto 0)=std_logic_vector(to_unsigned(0,burstlog2+2)) then
					internals(I).extend<='0';
				end if;
				internals(I).wrptr<=(others =>'0');
				internals(I).wrptr_next<=(others =>'0');
				internals(I).wrptr_next(burstlog2) <= '1';
				internals(I).count<=(others=>'0');
			end if;
			if channels_from_host(I).setreqlen='1' then
				internals(I).count(DMACache_ReqLenMaxBit downto 0)<=channels_from_host(I).reqlen;
				internals(I).count(DMACache_ReqLenMaxBit+1)<='0';
				channels_to_host(I).done<='0';
			end if;
		end loop;


	-- Handle timeslicing of output registers
	-- Lowest numbered channel has highest priority
	-- req signals should always be a single pulse - must be latched 
	-- since it may be several cycles before they're serviced.

		for I in 0 to DMACache_MaxChannel loop
			if channels_from_host(I).req='1' then
				internals_read(I).pending<='1';
			end if;

--			internals_read(I).drain<='0';
			channels_to_host(I).valid<=channelvalid(I); -- Delay valid signal by one cycle, giving BRAM time to catch up.
			channelvalid(I)<='0';
		end loop;
		
		serviceactive := '0';
		for I in DMACache_MaxChannel downto 0 loop
			if (internals_read(I).pending='1' or channels_from_host(I).req='1') and internals_FIFO(I).empty='0' then
				serviceactive := '1';
				servicechannel := I;
			end if;
		end loop;

		if serviceactive='1' then
			cache_rdaddr<=std_logic_vector(to_unsigned(servicechannel,3))&std_logic_vector(internals_read(servicechannel).rdptr);
			internals_read(servicechannel).rdptr<=internals_read(servicechannel).rdptr+1;
			channelvalid(servicechannel)<='1';
--			internals_read(servicechannel).drain<='1';
			internals_read(servicechannel).pending<='0';
		end if;

		-- Reset read pointers when a new address is set
		for I in 0 to DMACache_MaxChannel loop
			if channels_from_host(I).setaddr='1' then
				internals_read(I).rdptr<=(others => '0');
				internals_read(I).rdptr(sdram_width/16 downto 0)<=
					unsigned(channels_from_host(I).addr(2+sdram_width/16 downto 2));	-- Offset to allow non-aligned accesses.
				internals_read(I).pending<='0';
			end if;
		end loop;

	end if;
end process;
		
end rtl;

