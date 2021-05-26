
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vize is
  Generic ( num_of_bits:integer:=8); -- Led say�s�n� belirledik 8

  Port ( clk: in std_logic; ------de�i�kenleri tan�mlad�k
  reset: in std_logic; ---1 kere resete bas�nca her �ey s�f�rlan�cak
  start: in std_logic; ------1 kere start yap�nca baslayacak
  sel: in std_logic_vector(1 downto 0);--------- frekans� secmek icin
  led: out std_logic_vector(num_of_bits-1 downto 0)-------- c�k�s
  );
end vize;

architecture Behavioral of vize is

component clock_divider is ----frekans ayar� icin
   Port (
  clk: in std_logic; ---100 mhz
  reset: in std_logic;
  clk_half: out std_logic;---50mhz
  clk_quarter: out std_logic;----25mhz
  clk_tenth: out std_logic-----10mhz
   );
end component;


component bit_shifter is
 Generic ( num_of_bits:integer);
  Port ( clk: in std_logic;
  reset: in std_logic;
  start: in std_logic;
  led: out std_logic_vector(num_of_bits-1 downto 0)
  );
end component;

signal led_temp: std_logic_vector(num_of_bits-1 downto 0); --clock divider component ayarlamalari
signal clk_selected: std_logic;
signal clk_half:  std_logic;
signal clk_quarter: std_logic;
signal clk_tenth: std_logic;

begin

clock_unit : clock_divider
port map (
clk => clk,
reset => reset,
clk_half => clk_half,
clk_quarter => clk_quarter,
clk_tenth => clk_tenth
);


shifting_unit : bit_shifter
generic map(num_of_bits=>num_of_bits)
port map (
clk => clk_selected,
reset => reset,
start => start,
led => led_temp
);

clk_selected <= clk_tenth when sel= "11"  else --clock ayarlamasi
                clk_half when  sel= "01" else 
                clk_quarter when  sel= "10" else 
                clk; 
       
led<= led_temp; --led cikis degeri

end behavioral;
