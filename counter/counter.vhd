library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is
	
	generic (
		N: natural:=8
	);
	
	port(
		clc, rst: in std_logic;
		counter_out: out std_logic_vector(3 downto 0)
	);

end counter;

architecture behavior of counter is
begin	
	
	process (clc, rst)
	
		variable cnt: natural range 0 to N-1:=0;
		
	begin
		if rst='1' then
			cnt:=0; 
			counter_out<=(others=>'0');
		
		elsif clc'event and clc='1' then
			if cnt=N-1 then
				cnt:=0;
			else cnt:=cnt+1;
			end if;
			counter_out<=conv_std_logic_vector(cnt, 4);
		end if;
	
	end process;	
	
end behavior;


	
