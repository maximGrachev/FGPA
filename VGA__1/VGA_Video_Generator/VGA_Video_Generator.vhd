library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity VGA_Video_Generator is
	
	port(
		clk: in std_logic;
		row: in natural range 0 to 899;
		column: in natural range 0 to 1599;
		video_on: in boolean;
		R: out std_logic_vector(3 downto 0);
		G: out std_logic_vector(3 downto 0);
		B: out std_logic_vector(3 downto 0)
	);

end VGA_Video_Generator;

architecture behavior of VGA_Video_Generator is
begin	
		
	process (clk, video_on)
		
		constant Wcol: natural:= 144;
		
	begin
		
		if (video_on=true) then
			
			if (clk'event and clk='1') then
				
				case column/Wcol is
				
				when 0 => R<=(1=>'0', others=>'1');
						  G<=(1=>'0', others=>'1');
						  B<=(1=>'0', others=>'1');
						  
				when 1 => R<=(1=>'0', others=>'1');
						  G<=(1=>'0', others=>'1');
						  B<=(others=>'0');
						  
				when 2 => R<=(others=>'0');
						  G<=(1=>'0', others=>'1');
						  B<=(1=>'0', others=>'1');
						  
				when 3 => R<=(others=>'0');
						  G<=(1=>'0', others=>'1');
						  B<=(others=>'0');
						  
				when 4 => R<=(1=>'0', others=>'1');
						  G<=(others=>'0');
						  B<=(1=>'0', others=>'1');
						  
				when 5 => R<=(1=>'0', others=>'1');
						  G<=(others=>'0');
						  B<=(others=>'0');
						  
				when 6 => R<=(others=>'0');
						  G<=(others=>'0');
						  B<=(1=>'0', others=>'1');
						  
				when 7 => R<=(others=>'0');
						  G<=(others=>'0');
						  B<=(others=>'0');
						  
				when others=>null;
				end case;
					
			end if;
			
		else 
			R<=(others=>'0');
			G<=(others=>'0');
			B<=(others=>'0');
		end if;
				
	end process;	
	
end behavior;