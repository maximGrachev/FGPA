package SPI_params is
	
	type spi_states is (sleep, init, int_status, d_ready, read_data); 
	
	subtype byte is natural range 0 to 255;
	
	constant BW_Rate: byte:=44;
	constant WORD_BW_Rate: byte:=10;
	
	constant POWER_CTRL: byte:=45;
	constant WORD_POWER_CTRL: byte:=8;
	
	constant INT_ENABLE: byte:=46;
	constant WORD_INT_ENABLE: byte:=128;
	
	constant DATA_FORMAT: byte:=49;
	constant WORD_DATA_FORMAT: byte:=0;	
		
	constant INT_SOURSE: byte:=48;	
	
	constant ALL_INIT_REGS: byte:=4;
	constant ALL_READ_REGS: byte:=3;
	constant DATA0: byte:=52;
	
	constant DISCRETE: natural:=200;
	
end  SPI_params;
	 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.SPI_params.all;

entity spi_master is

	port(
		clock: in std_logic;
		cs: out std_logic;
		sclk: out std_logic;
		sdi: out std_logic;
		sdo: in std_logic;
		acceleration: out std_logic_vector(15 downto 0)
	);

end spi_master;

architecture behavior of spi_master is
	
	component divider is
	
	generic (
		N: natural:=8
	);
	
	port(
		clc: in std_logic;
		dvd_out: out std_logic
	);

	end component;

	type adxl_regs is array (0 to ALL_INIT_REGS-1) of byte;  
	type data_regs is array (0 to ALL_READ_REGS-1) of std_logic_vector(7 downto 0);
	constant INIT_ADDRESES: adxl_regs := (BW_Rate, POWER_CTRL, INT_ENABLE, DATA_FORMAT);
	constant CTRL_DATA: adxl_regs := (WORD_BW_Rate, WORD_POWER_CTRL, WORD_INT_ENABLE, WORD_DATA_FORMAT);
	
	signal new_data: std_logic; -- признак готовности новых данных в датчике
	signal init_ready: std_logic; -- признак окончания инициализации
	signal clk: std_logic; -- внутренний тактовый сигнал
	signal sclk_ena: std_logic; -- признак разрешения выдачи clk в линию sclk
	signal wd: std_logic; -- сигнал от внутреннего таймера о начале нового цикла чтения данных
	signal cnt: std_logic; -- сигнал разрешения счета бит
	signal state, next_state: spi_states; -- сигналы состояний ЦКА
	signal n_bit: natural range 0 to 8*(ALL_READ_REGS + 1) - 1; -- счетчик бит
	signal num_init: natural range 0 to ALL_INIT_REGS; -- число проинициализарованных регистров
	signal num_read: natural range 0 to ALL_READ_REGS; -- число прочитанных регистров
	
	begin	
	
	--делитель частоты
	M_divider: divider generic map ( N => 2)
			port map
				(
				clc => clock,
				dvd_out => clk
				);
			
	-- формирование сигнала в линии SCLK
	sclk <= '1' when sclk_ena = '0' else clk;
	
	-- процесс определения следующего состояния ЦКА
		process (state, wd, init_ready, n_bit, new_data, num_read)
		
		begin
		
			
		
			case (state) is
			
				when sleep => 
					if (init_ready = '0') then next_state <= init;
					elsif (wd = '1') then next_state <= int_status;
					else next_state <= sleep;
					end if;
					
				when init => 
					if (n_bit = 15) then next_state <= sleep;
					else next_state <= init;
					end if;
					
				when int_status => 
					if (n_bit = 15) then next_state <= d_ready;
					else next_state <= int_status;
					end if;
					
				when d_ready => 
					if (new_data = '0') then next_state <= int_status;
					else next_state <= read_data;
					end if;
					
				when read_data => 
					if (n_bit = (8*(ALL_READ_REGS + 1) - 1)) then next_state <= sleep;
					else next_state <= read_data;
					end if;
					
				when others => null;
				
			end case;
			
		end process;

	-- описание счетчика бит по заднему фронту clk с асинхронным
	-- сбросом по низкому логическому уровню сигнала cnt
			process (clk, cnt)
				
				begin
				
					if (cnt = '0') then
						n_bit <= 0;
					elsif (clk'event and clk = '0') then
							n_bit <= n_bit+1;
					end if;
				
			end process;
					
			-- процесс формирования сигнала разрешения счета бит
			process (clk, state)
				
				begin
				
				if (clk'event and clk = '0') then
					
					case (state) is
				
						when sleep => 
							cnt <= '0';
						when init => 
							cnt <= '1';
						when int_status => 
							cnt <= '1';
						when read_data => 
							cnt <= '1';
						when d_ready => 
							cnt <= '0';
						when others => null;
						
					end case;
					
				end if;
				
			end process;

	-- внутренний таймер и смена состояний ЦКА
			process (clk, next_state)
				
				variable cycle: natural range 0 to DISCRETE;
				
				begin
				
					if (clk'event and clk = '1') then 
						state <= next_state;
							
							if cycle = 0 then 
								wd <= '1';	
							else wd <= '0';
							end if;
							
							if cycle = DISCRETE - 1 then 
								cycle := 0;
							else cycle := cycle + 1;
							end if;
							
					end if;
				
			end process;
			
	-- процесс формирования сигналов в линиях SDI и CS
			process (clock, state, n_bit, num_init, num_read)
				
				-- регистры для временного хранения данных
				variable buf_8: std_logic_vector(7 downto 0);
				variable buf_16: std_logic_vector(15 downto 0);
				
				begin
				
					if (clock'event and clock = '1') then
						
						case (state) is
				
							when sleep => 
								sdi <= '0'; 
								cs <= '1'; 
								sclk_ena <= '0';
								
							when init => 
								cs <= '0'; 
								sclk_ena <= '1';
								buf_16 := "00" & conv_std_logic_vector(INIT_ADDRESES(num_init), 6)&conv_std_logic_vector(CTRL_DATA(num_init), 8);
								sdi <= buf_16(15 - n_bit);
								
							when int_status =>
								cs <= '0'; 
								sclk_ena <= '1';
								buf_8 := "10" &	conv_std_logic_vector(DATA0, 6);
								sdi <= buf_8(7 - n_bit);
							
							when read_data =>
								cs <= '0'; 
								sclk_ena <= '1';
								buf_8 := "11" & conv_std_logic_vector(DATA0, 6);
								sdi <= buf_8(7 - n_bit);
								
							when d_ready => 
								sdi <= '0';
								cs <= '0'; 
								sclk_ena <= '1';
								
							when others => null;
							
						end case;
						
					end if;
				
			end process;

	-- процесс, выполняющий чтение данных с линии SDO Slave
	-- и формирование управляющих сигналов
			process (clk, state, n_bit, num_init)
				
				variable data: data_regs;
				
				begin
				
					if (clk'event and clk = '1') then
					
						case (state) is
				
							when sleep => 
								num_read <= 0;
								new_data <= '0';
								--acceleration <= <старший байт> & <младший байт>;
							
							when init => 
								if (n_bit = 15) then
									if (num_init = ALL_INIT_REGS - 1) then
										init_ready <= '1';
									else init_ready <= '0';
										 num_init <= num_init + 1;
									end if;
								end if;
				
							when int_status => 
									if (n_bit = 8) then
										new_data <= sdo;
									end if;
									
							when read_data => 
									if (n_bit > 7) then
										data(num_read)(7 - (n_bit rem 8)) := sdo;
										if (n_bit rem 8 = 7) then
											num_read <= num_read + 1;
										end if;
									end if;
							when others => null;
						
						end case;
						
					end if;
				
			end process;	
	
end behavior;