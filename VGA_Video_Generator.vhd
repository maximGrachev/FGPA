-- библиотеки
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
--объ¤вление объекта
Entity VGA_Video_Generator is
Port	(clk		: in std_logic; --тактовый сигнал
	row				: in natural range 0 to 2000;
	column			: in natural range 0 to 2000;
	video_on		: in std_logic;
	mode			: in std_logic_vector (2 downto 0);
	R,G,B			: out std_logic_vector (3 downto 0));
end VGA_Video_Generator;
architecture behavior of VGA_Video_Generator is
Constant screen_wide: natural := 800;
Constant screen_height: natural := 600;
begin
process (clk, video_on, column, row, mode)
	begin
		if video_on='0' then
			R <="0000";
			G <="0000";
			B <="0000";
		elsif clk'event and clk='1' then
			case mode is
				when "001" =>
					case column/(screen_wide/8) is	
						when 0 => R <="1111";
								G <="1111";
								B <="1111";
						when 1 => R <="1000";
								G <="1000";
								B <="0000";
						when 2 => R <="0000";
								G <="1000";
								B <="1000";
						when 3 => R <="0000";
								G <="1000";
								B <="0000";
						when 4 => R <="1000";
								G <="0000";
								B <="1000";
						when 5 => R <="1000";
								G <="0000";
								B <="0000";
						when 6 => R <="0000";
								G <="0000";
								B <="1000";
						when 7 => R <="0000";
								G <="0000";
								B <="0000";
					when others => null;
					end case;
				when "010" =>
					case column rem (screen_wide/8) is
						when 0 to 1 =>
							R <="1111";
							G <="1111";
							B <="1111";
						when screen_wide/8-1 =>
							R <="1111";
							G <="1111";
							B <="1111";
						when others => null;
					end case;
					case row rem (screen_height/8) is
						when 0 to 1 =>
							R <="1111";
							G <="1111";
							B <="1111";
						when screen_height/8-1 =>
							R <="1111";
							G <="1111";
							B <="1111";
						when others => null;
					end case;
				when "011" =>
					if (column/(screen_wide/8)) + (row/(screen_height/6)) rem 2 = 0 then
						R <="1111";
						G <="1111";
						B <="1111";
					else
						R <="0000";
						G <="0000";
						B <="0000";
					end if;
				when "100" =>
					if (column/(screen_wide/8)) + (row/(screen_height/6)) rem 2 = 0 then
						R <="0000";
						G <="1100";
						B <="0000";
					else
						R <="0000";
						G <="0000";
						B <="0000";
					end if;
				when "101" => case column/(screen_wide/16) is	
						when 0 => R <="1111";
								G <="1111";
								B <="1111";
						when 1 => R <="1110";
								G <="1110";
								B <="1110";
						when 2 => R <="1101";
								G <="1101";
								B <="1101";
						when 3 => R <="1100";
								G <="1100";
								B <="1100";
						when 4 => R <="1011";
								G <="1011";
								B <="1011";
						when 5 => R <="1010";
								G <="1010";
								B <="1010";
						when 6 => R <="1001";
								G <="1001";
								B <="1001";
						when 7 => R <="1000";
								G <="1000";
								B <="1000";
						when 8 => R <="0111";
								G <="0111";
								B <="0111";
						when 9 => R <="0110";
								G <="0110";
								B <="0110";
						when 10 => R <="0101";
								G <="0101";
								B <="0101";
						when 11 => R <="0100";
								G <="0100";
								B <="0100";
						when 12 => R <="0011";
								G <="0011";
								B <="0011";
						when 13 => R <="0010";
								G <="0010";
								B <="0010";
						when 14 => R <="0001";
								G <="0001";
								B <="0001";
						when 15 => R <="0000";
								G <="0000";
								B <="0000";
					when others => null;
					end case;
				when "110" =>
					R <="1111";
					G <="1111";
					B <="1111";
					if column > (screen_wide/2 - screen_wide/20) and column < (screen_wide/2 + screen_wide/20) then
						case row is
							when screen_height/2 =>
								R <="0000";
								G <="0000";
								B <="0000";
							when screen_height/2+2 to screen_height/2+5=>
								R <="0000";
								G <="0000";
								B <="0000";
							when screen_height/2+8 to screen_height/2+13 =>
								R <="0000";
								G <="0000";
								B <="0000";
							when screen_height/2+18 to screen_height/2+25 =>
								R <="0000";
								G <="0000";
								B <="0000";
							when others => null;
						end case;
					end if;
				when others => null;
			end case;
		end if;
end process;
end behavior;
