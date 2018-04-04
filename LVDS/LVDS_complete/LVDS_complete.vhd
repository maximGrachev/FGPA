library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VGA_params.all;

entity LVDS_complete is
	
	port(
		clock: in std_logic;
		tx0, tx1, tx2, tx3, txc: out std_logic;
		debug_port: out std_logic
	);

end LVDS_complete;

architecture behavior of LVDS_complete is

component pll25_175MHz IS
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC 
	);
END component;

component VGA_Timer is

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

end component;

component VGA_Video_Generator is
	
	port(
		clk: in std_logic;
		row: in natural range 0 to 524;
		column: in natural range 0 to 799;
		video_on: in std_logic;
		R: out std_logic_vector(7 downto 0);
		G: out std_logic_vector(7 downto 0);
		B: out std_logic_vector(7 downto 0)
	);

end component;

component LVDS_Coder is
	
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

end component;

component LVDS_tx is
	
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

end component;

signal temp_clk, temp_7clk, temp_hsync, temp_vsync, temp_video_on: std_logic;
signal temp_R, temp_G, temp_B: std_logic_vector(7 downto 0);
signal temp_tx0, temp_tx1, temp_tx2, temp_tx3: std_logic_vector(6 downto 0);
signal temp_row, temp_column: natural;

begin	
	debug_port<=temp_clk;
	
		comp_pll25_175MHz: pll25_175MHz
		
			port map (
				inclk0=>clock,
				c0=>temp_clk,
				c1=>temp_7clk
				--c0=>debug_port
		);
		
		comp_VGA_Timer: VGA_Timer 
		
			port map (
				clk=>temp_clk,
				hsync=>temp_hsync,
				--hsync=>debug_port,
				vsync=>temp_vsync,
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
				R=>temp_R,
				G=>temp_G,
				B=>temp_B
		);
		
		comp_LVDS_Coder: LVDS_Coder
		
			port map(
				clk=>temp_7clk,
				hsync=>temp_hsync,
				vsync=>temp_vsync,
				de=>temp_video_on,
				R=>temp_R,
				G=>temp_G,
				B=>temp_B,
				tx0=>temp_tx0, 
				tx1=>temp_tx1,
				tx2=>temp_tx2, 
				tx3=>temp_tx3 
		);
		
		comp_LVDS_tx: LVDS_tx
		
			port map(
				tx0_in=>temp_tx0,
				tx1_in=>temp_tx1,
				tx2_in=>temp_tx2,
				tx3_in=>temp_tx3,
				clk7=>temp_7clk,
				tx0_out=>tx0,
				tx1_out=>tx1,
				tx2_out=>tx2,
				tx3_out=>tx3,
				txc=>txc
		);
	
end behavior;

