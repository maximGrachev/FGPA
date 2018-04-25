library ieee;
use ieee.std_logic_1164.all;

entity segment7 is
	
	port(
		clock: in std_logic;
		data_in: in natural range 0 to 11;
		data_out: out std_logic_vector(0 to 6)
	);

end segment7;

architecture behavior of segment7 is
begin	
	
	process (clock, data_in)
		
	begin
		
		if (clock'event and clock = '1') then
		
			case(data_in) is
				when 0 => data_out<="0000001"; -- 0
				when 1 => data_out<="1001111"; -- 1
				when 2 => data_out<="0010010"; -- 2
				when 3 => data_out<="0000110"; -- 3
				when 4 => data_out<="1001100"; -- 4
				when 5 => data_out<="0100100"; -- 5
				when 6 => data_out<="0100000"; -- 6
				when 7 => data_out<="0001111"; -- 7
				when 8 => data_out<="0000000"; -- 8
				when 9 => data_out<="0000100"; -- 9
				when 10 => data_out<="1111110"; -- minus
				when 11 => data_out<="1111111"; -- plus(nothing) 
				when others=>null;
			end case;
				
		end if;
	
	end process;	
	
end behavior;