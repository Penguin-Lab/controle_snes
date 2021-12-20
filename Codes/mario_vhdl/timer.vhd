library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port ( clock 		: in  STD_LOGIC;
           reset 		: in  STD_LOGIC;
           period 	: in  INTEGER;
           overflow 	: out  STD_LOGIC);
end timer;

architecture Behavioral of timer is

signal count, nextcount : integer;

begin

process(clock, reset)
begin
	if reset = '1' then
		count <= 0;
	elsif rising_edge(clock) then
		count <= nextcount;
	end if;
end process;

nextcount <= 0 when count = period else count + 1;

overflow <= '1' when count = period else '0';

end Behavioral;

