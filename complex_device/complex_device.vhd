library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity complex_device is
	
	port(
		clock, rst: in std_logic;
		Q: out std_logic_vector(3 downto 0)
	);

end complex_device;

architecture behavior of complex_device is

component counter is
	
	generic (
		N: natural:=8
	);
	
	port(
		clc, rst: in std_logic;
		counter_out: out std_logic_vector(3 downto 0)
	);

end component;

component divider is
	
	generic (
		N: natural:=2
	);
	
	port(
		clc: in std_logic;
		dvd_out: out std_logic
	);

end component;

signal temp: std_logic;

begin	
	
		comp_counter: counter 
		
			generic map (N=>10)
			port map (
				clc=>temp,
				rst=>rst,
				counter_out=>Q
		);
		
		comp_divider: divider 
		
			generic map (N=>120)
			port map (clock, temp);
	
end behavior;


	
