-- ���������
package my_parameters is
type VGA_params is
	record
		Video: INTEGER range 0 to 2000;
		FP: INTEGER range 0 to 2000;
		Sync: INTEGER range 0 to 2000;
		BP: INTEGER range 0 to 2000;
	end record;
--Constant H_TIMING: VGA_params := (800, 800+16, 800+16+80, 800+16+80+160);
--Constant V_TIMING: VGA_params := (600, 600+1, 600+1+3, 600+1+3+21);
Constant H_TIMING: VGA_params := (12, 14, 16 ,18);
Constant V_TIMING: VGA_params := (6, 8, 10, 12);
end my_parameters;

-- ����������
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_parameters.all;

--���������� �������
Entity VGA_Timer is
Port
	(clk			: in std_logic; --�������� ������
	hsync			: out std_logic; 
	vsync			: out std_logic;
	row				: out natural range 0 to 2000;
	column			: out natural range 0 to 2000;
	video_on		: out std_logic);
end VGA_Timer;

architecture behavior of VGA_Timer is
signal videov,videoh	: std_logic;
Constant H: VGA_params := H_TIMING;
Constant V: VGA_params := V_TIMING;
signal vcount : natural range 0 to 2000;
begin
video_on <= videoh and videov;
process (clk)
variable hcount:natural range 0 to 2000 :=0;
	begin
	if clk'event and clk='1' then
			if (hcount>=0 and hcount<H.Video) then
				videoh <= '1';
				column <= hcount;
				hsync  <='1';
				hcount:=hcount+1;
			elsif hcount>=H.Video and hcount<H.FP then
				videoh <= '0';
				column <= 0;
				hsync  <='1';
				hcount:=hcount+1;
			elsif hcount>=H.FP and hcount<H.Sync then
				videoh <= '0';
				column <= 0;
				hsync  <='0';
				hcount:=hcount+1;
			elsif hcount>=H.Sync and hcount<H.BP then
			  
				videoh <= '0';
				column <= 0;
				hsync  <='1';
				hcount:=hcount+1;
			
				
			end if;
			if hcount = H.BP then hcount:=0;
			  if vcount=V.BP-1 then vcount <= 0;
			  else
			  vcount <= vcount+1;
			  end if;
			  end if;
	end if;
end process;
process (vcount,clk)
	begin
		if clk'event and clk='1' then
			if vcount>=0 and vcount<(V.Video) then
				videov <= '1';
				row <= vcount;
				vsync  <='1';
			elsif vcount>=V.Video and vcount<V.FP then
				videov <= '0';
				row <= 0;
				vsync  <='1';
			elsif vcount>=V.FP and vcount<V.Sync then
				videov <= '0';
				row <= 0;
				vsync  <='0';
			elsif vcount>=V.Sync and vcount<V.BP then
	--		  if vcount=V.BP-1 then vcount:=0;
	--		  end if;
				videov <= '0';
				row <= 0;
				vsync  <='1';
			end if;
		end if;
end process;
end behavior;