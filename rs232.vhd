-- пакет констант
package my_parameters is
type RS232_states is (sleep, start, drx, stop);
end my_parameters;

-- библиотеки
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_parameters.all;
entity rs232 is
Port	(clock		:in std_logic;
		 rx			:in std_logic;
		 tx			:out std_logic;
		 mode		:out std_logic_vector (2 downto 0)
		);
end rs232;
architecture behavior of rs232 is
Component divider is
generic (N: natural := 12);
port
(clock: in std_logic;
go: in std_logic;
clk: out std_logic);
end component;
type RX_DATA is array (0 to 3) of std_logic_vector (7 downto 0);
signal n_bit: natural range 0 to 100;
signal clk: std_logic;
signal n_byte: natural range 0 to 100;
signal cnt: std_logic;
signal recieve: std_logic;
signal go: std_logic;
signal state,next_state:RS232_states;
signal period: std_logic;
signal sent: std_logic;
Begin
	
m1: divider generic map (N =>2) port map (clock,go,clk);
tx <='1';	
	
process(rx, state)
	begin
		if(state /=sleep and state/=stop) then go <='0';
		elsif rx'event and rx='0' then
			go <='1';
		end if;
end process;
	
process(clk)
	variable cycle: natural;
	begin
	if (clk'event and clk ='1') then
		if (rx ='1') then
			if cycle > 10
				then period <='0';
				cycle:=0;
			else period<='1';
				cycle:= cycle+1;
			end if;
		else cycle:=0;
		end if;
	end if;
end process;

process (clk, go)
	begin
	if go ='1' then state <= start;
	elsif (clk'event and clk='0') then
		state<= next_state;
	end if;
end process;

process (state,clk,n_bit,n_byte)
variable buf: RX_data;
	begin
		if (clk'event and clk='1') then
			case state is
				when sleep => cnt  <='0';
							  sent <='0';
				when start => cnt  <='0';
							  sent <='0';
							  recieve <= rx;
				when drx =>	  cnt  <='1';
							  sent <='0';
							  buf(n_byte)(n_bit) := rx;
							  if (n_bit = 7) then cnt <='0'; end if;
				when stop =>  cnt   <='0';
							  sent  <='1';
							  if (n_byte = 3)
								then mode <= buf(2)(7)&buf(2)(6)&buf(2)(5);
							  end if;
				when others => null;
			end case;
		end if;
end process;
	
process (state, recieve, n_bit)
	begin
		case state is
			when sleep => next_state<= sleep;
			when start => if recieve='0' then next_state <= drx;
				else next_state <= sleep;
				end if;
			when drx => if n_bit = 7
				then next_state <= stop;
				else next_state <= drx;
				end if;
			when stop => next_state<=sleep;
			when others => null;
		end case;
end process;

process (clk, cnt)
	begin
			if clk'event and clk='0'
				then 
					if cnt'event and cnt='1'
						then n_bit <= 0;
					end if;
					if n_bit = 7 then n_bit<=0;	
						else n_bit<=n_bit+1;
					end if;
			end if;
end process;

process (sent, period)
	begin
		if period ='0'
			then n_byte <=0;
		elsif sent'event and sent ='1' and n_bit = 7
			then n_byte <= n_byte+1;
		end if;
end process;
end behavior;
	
				