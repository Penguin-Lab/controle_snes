library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_module is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           data1 : out  STD_LOGIC_VECTOR (5 downto 0);
           data2 : out  STD_LOGIC_VECTOR (5 downto 0);
           data3 : out  STD_LOGIC_VECTOR (5 downto 0);
           data4 : out  STD_LOGIC_VECTOR (5 downto 0);
           validData : out  STD_LOGIC);
end uart_module;

architecture Behavioral of uart_module is
signal dados : STD_LOGIC_VECTOR (7 downto 0);
signal state : integer;
signal dataReady : STD_LOGIC;

begin

uart1: entity work.uart_core port map
			( clock 	=> clock,
           reset 	=> reset,
           rx 		=> rx,
			  data 	=> dados,
			  dataReady => dataReady);

-- Receiving
process(clock, reset)
begin
if reset = '1' then
	data1 <= (others => '0');
	data2 <= (others => '0');
	data3 <= (others => '0');
	data4 <= (others => '0');
	state <= 0;
elsif rising_edge(clock) then
	validData <= '0';
	if dataReady = '1' then
		case state is
		when 0 =>
			if dados(7 downto 6) = "00" then
				data1 <= dados(5 downto 0);
				state <= state + 1;
			else
				state <= 0;
			end if;
		when 1 =>
			if dados(7 downto 6) = "01" then
				data2 <= dados(5 downto 0);
				state <= state + 1;
			else
				state <= 0;
			end if;
		when 2 =>
			if dados(7 downto 6) = "10" then
				data3 <= dados(5 downto 0);
				state <= state + 1;
			else
				state <= 0;
			end if;
		when 3 =>
			if dados(7 downto 6) = "11" then
				data4 <= dados(5 downto 0);
				validData <= '1';
				state <= 0;
			else
				state <= 0;
			end if;
		when others =>
			state <= 0;
		end case;
	end if;
end if;
end process;

end Behavioral;

