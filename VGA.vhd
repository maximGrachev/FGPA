-- библиотеки
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_parameters.all;

--объ€вление объекта
Entity VGA is
Port	(clock		: in std_logic; --тактовый сигнал
	hsync			: out std_logic; 
	vsync			: out std_logic;
	R,G,B			: out std_logic_vector (3 downto 0);
	mode			: in std_logic_vector (2 downto 0);
	indicator		: out std_logic_vector(0 to 6));
end VGA;
architecture behavior of VGA is
Component segment7 is
	 port
 (
	mode: in std_logic_vector(2 downto 0);
	indicator: out std_logic_vector(0 to 6)
 );
end component;
Component pll is
PORT
	(
		inclk0		: IN STD_LOGIC;
		c0			: OUT STD_LOGIC 
	);
end component;

Component VGA_Timer is
Port
	(clk			: in std_logic; --тактовый сигнал
	hsync			: out std_logic; 
	vsync			: out std_logic;
	row				: out natural range 0 to 2000;
	column			: out natural range 0 to 2000;
	video_on		: out std_logic);
end component;

Component VGA_Video_Generator is
Port	(clk		: in std_logic; --тактовый сигнал
	row				: in natural range 0 to 2000;
	column			: in natural range 0 to 2000;
	video_on		: in std_logic;
	R,G,B			: out std_logic_vector (3 downto 0);
	mode			: in std_logic_vector (2 downto 0));
end component;
signal clk: std_logic;
signal row: natural range 0 to 2000;
signal column: natural range 0 to 2000;
signal video_on: std_logic;
begin
pll_1: pll port map (clock,clk);
ind: segment7 port map (mode, indicator);
Timer_2: VGA_Timer port map 
	(clk =>	clk,	
	hsync => hsync,		
	vsync => vsync,			
	row	 => row,			
	column => column,			
	video_on=> video_on);
Generator_3: VGA_Video_Generator port map
	(clk => clk,
	row	=> row,
	column	=> column,	
	video_on => video_on,		
	R =>R,
	G =>G,
	B =>B,
	mode => mode);
end behavior;		