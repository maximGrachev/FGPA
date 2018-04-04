package VGA_params is
	type VGA_type is record
		Video: natural; 
		FP: natural; 
		Sync: natural;
		BP: natural;
		TIMING: natural;
	end record VGA_type;
	--constant H_TIMING: natural:=1600;
	--constant V_TIMING: natural:=900;
end VGA_params;
	 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VGA_params.all;

entity VGA_Timer is

	generic (
		my_VGA_horiz: VGA_type:=(640, 16, 96, 48, 800); --pixels
		my_VGA_vert: VGA_type:=(480, 10, 2, 33, 525); --lines
		H: natural:=800;
		V: natural:=525
	);
	
	port(
		clk: in std_logic;
		hsync: out std_logic;
		vsync: out std_logic;
		row: out natural;
		column: out natural;
		video_on: out std_logic	);

end VGA_Timer;

architecture behavior of VGA_Timer is
begin	
		
	process (clk)
	
	variable counter_h: natural:=0;
	variable counter_v: natural:=0;
		
	begin
		
		if (clk'event and clk='1') then
			
			--counters
			if counter_h=H-1 then
				counter_h:=0;
				if counter_v=V-1 then
					counter_v:=0;
				else
					counter_v:=counter_v+1;
				end if;
			else
				counter_h:=counter_h+1;
			end if;
		
			--hsync
			if (counter_h <= my_VGA_horiz.Video + my_VGA_horiz.FP) or 
				(counter_h > my_VGA_horiz.Video+my_VGA_horiz.FP + my_VGA_horiz.Sync) then
				hsync<='1';
			else hsync<='0';
			end if;	
			
			--vsync
			if (counter_v <= my_VGA_vert.Video + my_VGA_vert.FP) or 
				(counter_v > my_VGA_vert.Video+my_VGA_vert.FP + my_VGA_vert.Sync) then
				vsync<='1';
			else vsync<='0';
			end if;
			
			--video_on
			if (counter_h <= my_VGA_horiz.Video) and (counter_v <= my_VGA_vert.Video) then
				video_on <= '1';
			else video_on <= '0';
			end if;
			
			row <= counter_v;
			column <= counter_h;
		
		end if;
				
	end process;	
	
end behavior;