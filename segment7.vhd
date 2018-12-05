library ieee;
use ieee.std_logic_1164.all;
entity segment7 is
 port
 (
 mode: in std_logic_vector(2 downto 0);
 indicator: out std_logic_vector(0 to 6)
 );
 end segment7;
 
 architecture Behavior of segment7 is
    begin
     process(mode)
       begin
        case mode is 
        	 when "001" =>indicator<="1001111";
       	  when "010" =>indicator<="0010010";
       	  when "011" =>indicator<="0000110"; 
        	 when "100" =>indicator<="1001100";
       	  when "101" =>indicator<="0100100";
        	 when "110" =>indicator<="0100000";
         when others => null;
        end case;
      end process;
    end Behavior;