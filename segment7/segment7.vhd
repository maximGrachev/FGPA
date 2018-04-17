library ieee;
use ieee.std_logic_1164.all;

entity segment7 is
	
	port(
		clock: in std_logic;
		data_in: in std_logic_vector(3 downto 0);
		data_out: out std_logic_vector(0 to 6);
	);

end divider;

architecture behavior of segment7 is
begin	
	
	process (data, clock)
		
	begin
		
		if (clock'event and clock = '1') then
		
			case(data_in) is
				when "0000" => data_out<="0000001"; -- 0
				when "0001" => data_out<="1001111"; -- 1
				when "0010" => data_out<="0010010"; -- 2
				when "0011" => data_out<="0000110"; -- 3
				when "0100" => data_out<="1001100"; -- 4
				when "0101" => data_out<="0100100"; -- 5
				when "0110" => data_out<="0100000"; -- 6
				when "0111" => data_out<="0001111"; -- 7
				when "1000" => data_out<="0000000"; -- 8
				when "1001" => data_out<="0000100"; -- 9
				when "1010" => data_out<="1111110"; -- minus
				when others=>null;
			end case;
				
		end if;
	
	end process;	
	
end behavior;