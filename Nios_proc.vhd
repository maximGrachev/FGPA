library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
 
 entity Nios_proc is
 port
 (
	clk: in std_logic;
	reset: in std_logic;
	tx: out std_logic;
	rx: in std_logic
 );
 end Nios_proc;
 
 architecture behavior of Nios_proc is
 
	component nios_cpu is
        port (
            clk_clk       : in  std_logic := 'X'; -- clk
            reset_reset_n : in  std_logic := 'X'; -- reset_n
            uart_rxd      : in  std_logic := 'X'; -- rxd
            uart_txd      : out std_logic         -- txd
        );
    end component nios_cpu;
	 
	 begin

    u0 : component nios_cpu
        port map (
            clk_clk       => clk,       --   clk.clk
            reset_reset_n => reset,
            uart_rxd      => rx,
            uart_txd      => tx
				);
				

 end behavior;