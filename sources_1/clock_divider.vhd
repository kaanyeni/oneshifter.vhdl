
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock_divider is
  Port (
  clk: in std_logic;
  reset: in std_logic;
  clk_half: out std_logic;
  clk_quarter: out std_logic;
  clk_tenth: out std_logic
   );
end clock_divider;

architecture Behavioral of clock_divider is
constant ten: integer:=5; ---clock düsürmek icin counter 10Mhz
constant four: integer:=2;---25Mhz
constant two: integer:=1;----50Mhz

signal two_counter:integer;
signal four_counter:integer;
signal ten_counter:integer;

signal clk_half_temp: std_logic; --olusan yeni sinyallerin atanacagi yer
signal clk_quarter_temp: std_logic;
signal clk_tenth_temp: std_logic;

begin
process(clk,reset) is

begin
if (reset='1') then --reset 1 hersey sýfýrlandi

clk_half_temp <='0';
clk_quarter_temp <='0';
clk_tenth_temp <='0';
two_counter <= 0;
four_counter <= 0;
ten_counter <= 0;

elsif rising_edge(clk) then --degilse clock sinyali yukselen kenar icin fonksiyon calýsmaya baslar


if two_counter=two-1 then ---50mhz olusturulan kisim 
clk_half_temp <= not clk_half_temp;
two_counter <= 0;
elsif two_counter<two-1 then
two_counter <= two_counter +1;
else
two_counter <= 0;
end if;

if four_counter=four-1 then ---2 periyot icin 0, 2 periyot icin 1 (4de biri)
clk_quarter_temp <= not clk_quarter_temp;
four_counter <= 0;
elsif four_counter<four-1 then
four_counter <= four_counter +1;
else
four_counter <= 0;
end if;

if ten_counter = ten - 1 then ---5 periyot 0, 5 periyot 1, 10da biri
clk_tenth_temp <= not clk_tenth_temp;
ten_counter <= 0;
elsif ten_counter < ten - 1 then
ten_counter <= ten_counter +1;
else
ten_counter <= 0;
end if;

end if;

end process;

clk_half <= clk_half_temp; --yeni clock sinyalleri
clk_quarter <= clk_quarter_temp;
clk_tenth <= clk_tenth_temp;

end Behavioral;
