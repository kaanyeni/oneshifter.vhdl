
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_shifter is
  Generic ( num_of_bits:integer);

  Port ( clk: in std_logic;
  reset: in std_logic;
  start: in std_logic;
 -- sel: in std_logic_vector(1 downto 0);
  led: out std_logic_vector(num_of_bits-1 downto 0)
  );
end bit_shifter;



architecture Behavioral of bit_shifter is
signal started: std_logic;
signal led_temp: std_logic_vector (num_of_bits-1 downto 0); --- 8 bitlik led vektoru
signal counter: integer range 0 to num_of_bits-1;
signal right_left_not:std_logic;

begin



process(clk,reset,start) is
begin
if reset='1' then --reset 1 ise sifirla
started <='0'; 
counter <= 0;
right_left_not <='1';
led_temp <=(others=>'0');
elsif rising_edge(clk) then

if start = '1' then
started<='1';


end if;


if started ='1' then --start 1 ise calýsmaya baslar

    if counter = num_of_bits-1 then  --- ct 7 ise
    counter <= counter -1;
    right_left_not<= '0'; ---soldan saga kayar
    
    led_temp(num_of_bits-1 )<= '1'; ---son biti 1 yapar
    led_temp(num_of_bits-2 downto 0)<= (others=>'0'); --geri kalan bitleri 0 yapar
    
    elsif  counter = 0 then --counter 0 ise

    right_left_not<= '1'; --sagdan sola kaymaya baslar
    counter<= counter +1; --

    led_temp(0)<= '1'; ---ilk biti 1 yapar
    led_temp(num_of_bits-1 downto 1)<= (others=>'0'); -- diger bitleri 0 yapar
    
    else

        if right_left_not='1' then --sagdan sola kayiyorsa
        counter<= counter +1; --- counter 1 artti
        
        led_temp(counter)<= '1'; --counter biti 1 oldu
        led_temp(counter-1)<= '0';---onceki bit 0 olduguna gore sagdan sola kaymis oldu
        
        else
        counter<= counter -1; --soldan saga kayiyorsa counteri düsür
        
                
        led_temp(counter)<= '1'; --counter bitini 1 yap
        led_temp(counter+1)<= '0'; --1 buyuk biti 0 yap boylece soldan saga kaymis oldu
        
        end if;

end if;


end if;


end if;


end process;

led<=led_temp; --sonucari lede gonder

end Behavioral;




