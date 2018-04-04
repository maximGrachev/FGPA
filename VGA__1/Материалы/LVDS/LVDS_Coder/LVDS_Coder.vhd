library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LVDS_Coder is
	
	port(
		clk: in std_logic;
		hsync: in std_logic;
		vsync: in std_logic;
		de: in std_logic;
		R: in std_logic_vector(7 downto 0);
		G: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		tx0: out std_logic_vector(6 downto 0); 
		tx1: out std_logic_vector(6 downto 0); 
		tx2: out std_logic_vector(6 downto 0); 
		tx3: out std_logic_vector(6 downto 0)
	);

end LVDS_Coder;

architecture behavior of LVDS_Coder is
begin	
		
	process (clk)
		
	begin
		
		if(clk'event and clk='1') then
	
			tx0<=(6=>G(0), 5=>R(5), 4=>R(4), 3=>R(3), 2=>R(2), 1=>R(1), 0=>R(0));
			tx1<=(6=>B(1), 5=>B(0), 4=>G(5), 3=>G(4), 2=>G(3), 1=>G(2), 0=>G(1));
			tx2<=(6=>DE, 5=>vsync, 4=>hsync, 3=>B(5), 2=>B(4), 1=>B(3), 0=>B(2));
			tx3<=(6=>'0', 5=>B(7), 4=>B(6), 3=>G(7), 2=>G(6), 1=>R(7), 0=>R(6));
			
		end if;
				
	end process;	
	
end behavior;