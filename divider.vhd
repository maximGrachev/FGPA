-- aeaeeioaee
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

Entity divider is
generic (N: natural := 12);
port
(clock: in std_logic;
go: in std_logic;
clk: out std_logic);
end divider;

architecture Behavior_divider of divider is
begin
 process(clock)
 variable cnt1: natural;
 begin
 if go ='1' then cnt1:=0;
  elsif clock'event and clock = '1' then
    if cnt1 < N/2 then
      clk <= '1';
      else
     clk <= '0';
     end if;
    if cnt1 = N-1 then cnt1 := 0;
    else cnt1 := cnt1+1;
    end if;
 end if;
  end process;
end  Behavior_divider;