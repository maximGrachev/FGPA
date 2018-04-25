library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity decoder is
	
	port(
		clock: in std_logic;
		data_in: in std_logic_vector(15 downto 0);
		s: out natural range 0 to 11;
		val_2: out natural range 0 to 10;
		val_1: out natural range 0 to 10;
		val_0: out natural range 0 to 10
	);

end decoder;

architecture behavior of decoder is
begin	
	
	process (data_in, clock)
	
	variable temp_data: integer range -511 to 511 := 0;
		
	begin
		
		if (clock'event and clock = '1') then
		
			temp_data := conv_integer(data_in and "0000001111111111");
			
			if (temp_data < 0) then
				s <= 10;
				temp_data := -temp_data;
			else
				s <= 11;
			end if;
			
			val_2 <= temp_data/100;
			val_1 <= (temp_data/10) rem 10;
			val_0 <= temp_data rem 10;
	
		end if; 
		
	end process;	
	
end behavior;