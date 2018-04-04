library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LVDS_tx is
	
	port(
		tx0_in: in std_logic_vector(6 downto 0); 
		tx1_in: in std_logic_vector(6 downto 0); 
		tx2_in: in std_logic_vector(6 downto 0); 
		tx3_in: in std_logic_vector(6 downto 0);
		clk7: in std_logic; 
		tx0_out: out std_logic; 
		tx1_out: out std_logic; 
		tx2_out: out std_logic; 
		tx3_out: out std_logic; 
		txc: out std_logic
	);

end LVDS_tx;

architecture behavior of LVDS_tx is
begin	
		
	process (clk7)
	
		variable counter:integer range 0 to 6:=0;
		
	begin
		
		if(clk7'event and clk7='1') then 
			  
		
				tx0_out<=tx0_in(counter);
				tx1_out<=tx1_in(counter);
				tx2_out<=tx2_in(counter);
				tx3_out<=tx3_in(counter);
				if (counter=6) then
				   counter:=0;
		 		else 
		     		counter:=counter+1;
		
			    end if;
			
		end if;
		
		txc<=clk7;
				
	end process;	
	
end behavior;
