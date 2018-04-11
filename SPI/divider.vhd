library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity divider is
	
	generic (
		N: natural:=8
	);
	
	port(
		clc: in std_logic;
		dvd_out: out std_logic
	);

end divider;

architecture behavior of divider is
begin	
	
	process (clc)
		
	variable cnt: natural range 0 to N-1:=0;
	
	begin
		
		if clc'event and clc='1' then
			if cnt<N/2 then
				dvd_out<='0';
			else
				dvd_out<='1';
			end if;
				
			if cnt=N-1 then
				cnt:=0;
			else
				cnt:=cnt+1;	
			end if;	
		end if;	
	
	end process;	
	
end behavior;