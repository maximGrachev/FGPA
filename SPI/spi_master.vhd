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
	constant DATA0: byte:=50;
	
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
		acceleration: out std_logic_vector(15 downto 0);
	);

end spi_master;

architecture behavior of spi_master is

	type adxl_regs 
	
	signal new_data: std_logic; -- ������� ���������� ����� ������ � �������
	signal init_ready: std_logic; -- ������� ��������� �������������
	signal clk: std_logic; -- ���������� �������� ������
	signal sclk_ena: std_logic; -- ������� ���������� ������ clk � ����� sclk
	signal wd: std_logic; -- ������ �� ����������� ������� � ������ ������ ����� ������ ������
	signal cnt: std_logic; -- ������ ���������� ����� ���
	signal state, next_state: spi_states; -- ������� ��������� ���
	signal n_bit: natural range 0 to 8*(ALL_READ_REGS + 1) - 1; -- ������� ���
	signal num_init: natural range 0 to ALL_INIT_REGS; -- ����� ��������������������� ���������
	signal num_read: natural range 0 to ALL_READ_REGS; -- ����� ����������� ���������
	
	begin	
			
		-- ������������ ������� � ����� SCLK
	sclk <= <���. �������> when sclk_ena = '0' else clk;
	-- ������� ����������� ���������� ��������� ���
		process (state, wd, init_ready, n_bit, new_data, num_read)

		begin
		
			case (state) is
			
				when sleep => 
					if (init_ready = '0') then next_state <= <ninoiyiea>;
					elsif (wd = '1') then next_state <= <ninoiyiea>;
					else next_state <= <ninoiyiea>;
					end if;
					
				when init => 
					if (n_bit = 15) then next_state <= <ninoiyiea>;
					else next_state <= <ninoiyiea>;
					end if;
					
				when int_status => 
					if (n_bit = 15) then next_state <= <ninoiyiea>;
					else next_state <= <ninoiyiea>;
					end if;
					
				when d_ready => 
					if (new_data = '0') then next_state <= <ninoiyiea>;
					else next_state <= <ninoiyiea>;
					end if;
					
				when read_data => 
					if (n_bit = (8*(ALL_READ_REGS + 1) - 1)) then next_state <= <ninoiyiea>;
					else next_state <= <ninoiyiea>;
					end if;
					
				when others => null;
				
			end case;
			
		end process;

	-- �������� �������� ��� �� ������� ������ clk � �����������
	-- ������� �� ������� ����������� ������ ������� cnt
			process (<������ ����������������>)
			<��������� ��� ���������� ��������>;
			-- ������� ������������ ������� ���������� ����� ���
			end process;

			process (<������ ����������������>)
				
				begin
				
				if (clk'event and clk = '0') then
					
					case (state) is
				
						when sleep => 
							cnt <= '0';
						when init => 
							cnt <= '1';
						when int_status => 
							cnt <= <���. �������>;
						when read_data => 
							cnt <= <���. �������>;
						when d_ready => 
							cnt <= '0';
						when others => null;
						
					end case;
					
				end if;
				
			end process;

	-- ���������� ������ � ����� ��������� ���
			process (<������ ����������������>)
				
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
			
	-- ������� ������������ �������� � ������ SDI � CS
			process (clock, state, n_bit, num_init, num_read)
				
				-- �������� ��� ���������� �������� ������
				variable buf_8: std_logic_vector(7 downto 0);
				variable buf_16: std_logic_vector(15 downto 0);
				
				begin
				
					if (clock'event and clock = '1') then
						
						case (state) is
				
							when sleep => 
								sdi <= '0'; cs <= '1'; 
								sclk_ena <= '0';
								
							when init => 
								cs <= '0'; 
								sclk_ena <= '1';
								buf_16 := <���� R/W � M/S> & conv_std_logic_vector(INIT_ADDRESES(num_init), 6)&conv_std_logic_vector(CTRL_DATA(num_init), 8);
								sdi <= buf_16(15 - n_bit);
								
							when int_status =>
								cs <= <���. �������>; 
								sclk_ena <= <���. �������>;
								buf_8 := <���� R/W � M/S> &	conv_std_logic_vector(<�����>, 6);
								sdi <= buf_8(7 - n_bit);
							
							when read_data =>
								cs <= <���. �������>; 
								sclk_ena <= <���. �������>;
								buf_8 := <���� R/W � M/S> & conv_std_logic_vector(<�����>, 6);
								sdi <= buf_8(7 - n_bit);
								
							when d_ready => 
								sdi <= '0';
								cs <= <���. �������>; 
								sclk_ena <= <���. �������>;
								
							when others => null;
							
						end case;
						
					end if;
				
			end process;

	-- �������, ����������� ������ ������ � ����� SDO Slave
	-- � ������������ ����������� ��������
			process (<������ ����������������>)
				
				variable data: data_regs;
				
				begin
				
					if (clk'event and clk = '1') then
					
						case (state) is
				
							when sleep => 
								num_read <= 0;
								new_data <= '0';
								<�����> <= <������� ����> & <������� ����>;
							
							when init => 
								if (n_bit = 15) then
									if (num_init = ALL_INIT_REGS - 1) then
										init_ready <= <���. �������>;
									else init_ready <= <���. �������>;
										 num_init <= num_init + 1;
									end if;
								end if;
				
							when int_status => 
									if (n_bit = <����� ����>) then
										new_data <= sdo;
									end if;
									
							when read_data => 
									if (n_bit > <����� ����>) then
										data(num_read)(7 - (n_bit rem 8)) := sdo;
										if (n_bit rem 8 = 7) then
											num_read <= num_read + 1;
										end if;
									end if;
							when others => null;
						if (n_bit = (8*(ALL_READ_REGS + 1) - 1)) then next_state <= <ninoiyiea>;
									else next_state <= <ninoiyiea>;
								  end if;	
						end case;
						
					end if;
				
			end process;	
	
end behavior;