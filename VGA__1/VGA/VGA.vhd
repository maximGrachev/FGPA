library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VGA_params.all;

entity VGA is
	
	port(
		clock: in std_logic;
		hsync, vsync: out std_logic;
		R, G, B: out std_logic_vector (3 downto 0)
	);

end VGA;

architecture behavior of VGA is

component pll108MHz is
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
end component;

component VGA_Timer is

	generic (
		my_VGA_horiz: VGA_type:=(1152, 64, 128, 256, 1600); --pixels
		my_VGA_vert: VGA_type:=(864, 1, 3, 32, 900); --lines
		H: natural:=1600;
		V: natural:=900
	);
	
	port(
		clk: in std_logic;
		hsync: out std_logic;
		vsync: out std_logic;
		row: out natural;
		column: out natural;
		video_on: out boolean
	);

end component;

component VGA_Video_Generator is
	
	port(
		clk: in std_logic;
		row: in natural range 0 to 899;
		column: in natural range 0 to 1599;
		video_on: in boolean;
		R: out std_logic_vector(3 downto 0);
		G: out std_logic_vector(3 downto 0);
		B: out std_logic_vector(3 downto 0)
	);

end component;

signal temp_clk: std_logic;
signal temp_row, temp_column: natural;
signal temp_video_on: boolean;

begin	
	
		comp_pll108MHz: pll108MHz 
		
			port map (
				inclk0=>clock,
				c0=>temp_clk
		);
		
		comp_VGA_Timer: VGA_Timer 
		
			port map (
				clk=>temp_clk,
				hsync=>hsync,
				vsync=>vsync,
				row=>temp_row,
				column=>temp_column,
				video_on=>temp_video_on
		);
		
		comp_VGA_Video_Generator: VGA_Video_Generator 
		
			port map (
				clk=>temp_clk,
				row=> temp_row,
				column=>temp_column,
				video_on=>temp_video_on,
				R=>R,
				G=>G,
				B=>B
		);
	
end behavior;


	
