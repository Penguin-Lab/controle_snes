library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity marIO is
    Port ( clock : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
           rx : in  STD_LOGIC;
			  hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end marIO;

architecture Behavioral of marIO is

signal data1, data2, data3, data4 : std_logic_vector(5 downto 0);
signal validData : std_logic;
signal L, R : std_logic;
signal X, Y, B, A, S, Bt : std_logic;
signal Ax, Ay : std_logic_vector(7 downto 0);

signal trigger, active : std_logic;
signal hc, vc : integer;

-- Mario
signal rm : std_logic_vector (2 downto 0);
signal gm : std_logic_vector (2 downto 0);
signal bm : std_logic_vector (1 downto 0);
signal mario_on : std_logic;
signal triggerm : std_logic;

begin

----- UART:
-- Data1: 00 X Y B A L R
-- Data2: 01 S Bt Ax(4bitsH)
-- Data3: 10 Ax(4bitsL) Ay(2bitsH)
-- Data4: 11 Ay(6bitsL)
uart1: entity work.uart_module port map
			( clock => clock,
           reset => reset,
           rx => rx,
           data1 => data1,
           data2 => data2,
           data3 => data3,
           data4 => data4,
           validData => validData);

process(reset, clock)
begin
if reset = '1' then
	X <= '0';
	Y <= '0';
	B <= '0';
	A <= '0';
	L <= '0';
	R <= '0';
	S <= '0';
	Bt <= '0';
	Ax <= "01111111";
	Ay <= "01111111";
elsif rising_edge(clock) then
	if validData = '1' then
		X <= data1(5);
		Y <= data1(4);
		B <= data1(3);
		A <= data1(2);
		L <= data1(1);
		R <= data1(0);
		S <= data2(5);
		Bt <= not(data2(4));
		Ax <= data2(3 downto 0)&data3(5 downto 2);
		Ay <= data3(1 downto 0)&data4(5 downto 0);
	end if;
end if;
end process;

----- VGA:
-- Timer de 25MHz
timer_25M: entity work.timer port map
				(clock => clock,
				 reset => reset,
				 period => 1,
				 overflow => trigger);

-- VGA sync
process(clock,reset)
begin 
if reset = '1' then
hc <= 0; -- posicao horizontal do pixel
vc <= 0; -- posicao vertical do pixel
elsif rising_edge(clock) then
	if trigger = '1' then
	hc <= hc + 1;
if hc = 799 then
			hc <= 0;
		vc <= vc + 1;
		if vc = 520 then
			vc <= 0;
		end if;
	end if;
end if;
end if;
end process;

hs <=  '0' when 16 <= hc and hc < 112  else 
   '1';
vs <=  '0' when 10 <= vc and vc < 12  else 
   '1';

-- VGA graphics
active <= '0' when hc < 160 or vc < 41 else
          '1';

-- Timer 1/16 segundo (16Hz):
timer_16Hz: entity work.timer port map
				(clock => clock,
				 reset => reset,
				 period => 3_124_999,
				 overflow => triggerm);

-- Sprite Mario:
mario_sprite: entity work.mario_sprite port map
			( clock => clock,
           reset => reset,
           trigger => triggerm,
           hc => hc,
           vc => vc,
           Ax => Ax,
			  B => B,
           mario_on => mario_on,
           rm => rm,
           gm => gm,
           bm => bm);

-- saidas:
red <= "000" when active = '0' else -- sync
	  rm when mario_on = '1' else -- mario
	  "111" when vc >= 500 else -- chao
	  "000"; -- background

green <= "000" when active = '0' else -- sync
	  gm when mario_on = '1' else -- mario
	  "110" when vc >= 500 else -- chao
	  "101"; -- background
	  
blue <= "00" when active = '0' else -- sync
	  bm when mario_on = '1' else -- mario
	  "10" when vc >= 500 else -- chao
	  "11"; -- background

end Behavioral;