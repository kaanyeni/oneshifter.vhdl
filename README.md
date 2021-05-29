# oneshifter.vhdl
Programin Yaptiklari:
generic ve kayma hizi degistirilebilen bir one shifter (kaydirici) programidir.
program 100 Mhz ana calisma frekansina sahiptir.
sel fonksiyonu ile kontrol edilir sel=0 ise 100MHz sel=1 ise 50Mhz sel=2 ise 25Mhz sel=3 ise 10Mhz frekanslarinda calisir.
led degiskeninin bir uzunlugu generic olarak degistirilebilir
program kaymaya soldan saga dogru baslamaktadir
rst ile sifirlanabilir
test benchlerden test soncları gozlemlenebilir.


Kodlarin Aciklamalari:
1) Clock ayarlaması yapan fonksiyon kodu:
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
constant ten: integer:=5; ---clock d¨us¨urmek icin counter 10Mhz
constant four: integer:=2;---25Mhz
1constant two: integer:=1;----50Mhz
signal two_counter:integer;
signal four_counter:integer;
signal ten_counter:integer;
signal clk_half_temp: std_logic; --olusan yeni sinyallerin atanacagi yer
signal clk_quarter_temp: std_logic;
signal clk_tenth_temp: std_logic;
begin
process(clk,reset) is
begin
if (reset=’1’) then --reset 1 her sey sıfırlandi
clk_half_temp <=’0’;
clk_quarter_temp <=’0’;
clk_tenth_temp <=’0’;
two_counter <= 0;
four_counter <= 0;
ten_counter <= 0;
elsif rising_edge(clk) then --degilse clock sinyali yukselen kenar icin fonksiyon calısmaya
if two_counter=two-1 then --- 50mhz olusturulan kisim
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
if ten_counter = ten - 1 then ---5 periyot 0, 5 periyot 1, (10da biri)
clk_tenth_temp <= not clk_tenth_temp;
2ten_counter <= 0;
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
1. Kodun A¸cıklaması: A¸cıklama satırları verilse de detaylı a¸cıklayacak olursak;
Main fonksiyondan ¸ca˘gırılan clock_divider fonksiyonmuzun de˘gi¸skenleri mainden gelen
de˘gerlere g¨ore ayarlandı. Daha sonra fonksiyonda kullanılacak de˘gi¸sken ve sinyaller
tanımlandı. Reset butonu durumuna g¨ore e˘ger basılmı¸s ise her ¸seyin sıfırlayacak bir
if yapısı kuruldu. Main fonksiyondan gelen select de˘gerine g¨ore buradaki if
fonksiyonlarına g¨ore clock ayarlamaları yapılır.Frekans, 50 Mhz i¸cin
yarıya d¨u¸s¨ur¨ul¨ur, 25 Mhz i¸cin 4’de birine ve 10Mhz i¸cin de 10 da birine d¨u¸serek
olu¸sturulmu¸s olur. Daha sonra da olu¸san yeni clock sinyallerini main’e g¨onderir.
2)Bit Shifter Yapan Fonksiyon Kodu:
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
3signal right_left_not:std_logic;
begin
process(clk,reset,start) is
begin
if reset=’1’ then --reset 1 ise sifirla
started <=’0’;
counter <= 0;
right_left_not <=’1’;
led_temp <=(others=>’0’);
elsif rising_edge(clk) then
if start = ’1’ then
started<=’1’;
end if;
if started =’1’ then --start 1 ise calısmaya baslar
if counter = num_of_bits-1 then --- ct 7 ise
counter <= counter -1;
right_left_not<= ’0’; ---soldan saga kayar
led_temp(num_of_bits-1 )<= ’1’; ---son biti 1 yapar
led_temp(num_of_bits-2 downto 0)<= (others=>’0’); --geri kalan bitleri 0 yapar
elsif counter = 0 then --counter 0 ise
right_left_not<= ’1’; --sagdan sola kaymaya baslar
counter<= counter +1; --
led_temp(0)<= ’1’; ---ilk biti 1 yapar
led_temp(num_of_bits-1 downto 1)<= (others=>’0’); -- diger bitleri 0 yapar
else
if right_left_not=’1’ then --sagdan sola kayiyorsa
counter<= counter +1; --- counter 1 artti
led_temp(counter)<= ’1’; --counter biti 1 oldu
led_temp(counter-1)<= ’0’;--- bir onceki bit 0 yap.Boylece sagdan sola kaymis oldu
4else
counter<= counter -1; --soldan saga kayiyorsa counteri d¨us¨ur
led_temp(counter)<= ’1’; --biti 1 yap
led_temp(counter+1)<= ’0’; -- bir buyuk biti 0 yap boylece soldan saga kaymis oldu
end if;
end if;
end if;
end if;
end process;
led<=led_temp; --sonucari lede gonder
end Behavioral;
2. Kodun a¸cıklaması:
Main fonksiyonundan ¸ca˘gırılarak bit shift i¸slemini yapar. Reset var ise t¨um her ¸seyi
sıfırlar. Start butonuna basılmı¸s ise fonksiyon ¸calı¸sır. Ba¸slangı¸c de˘geri 0 olarak
tanımlanan bir counter ve sa˘ga yada sola kayma ayarını yapmak i¸cin
tanımlanan right_left_not sinyali ile fonksiyon shift i¸slemini yerine getirir.
Fonksiyonun nasıl ¸calı¸stı˘gı, yanındaki a¸cıklama satırları ile g¨osterilmi¸stir.
3) Main Vize Fonksiyonu:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity vize is
Generic ( num_of_bits:integer:=8); -- Led sayısını belirledik 8
Port ( clk: in std_logic; ------de˘gi¸skenleri tanımladık
reset: in std_logic; ---1 kere resete basınca her ¸sey sıfırlanıcak
start: in std_logic; ------1 kere start yapınca baslayacak
sel: in std_logic_vector(1 downto 0);--------- frekansı secmek icin
led: out std_logic_vector(num_of_bits-1 downto 0)-------- cıkıs
5);
end vize;
architecture Behavioral of vize is
component clock_divider is ----frekans ayarı icin
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
signal led_temp: std_logic_vector(num_of_bits-1 downto 0); --clock divider component ayarlam
signal clk_selected: std_logic;
signal clk_half: std_logic;
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
6clk => clk_selected,
reset => reset,
start => start,
led => led_temp
);
clk_selected <= clk_tenth when sel= "11" else --clock ayarlamasi
clk_half when sel= "01" else
clk_quarter when sel= "10" else
clk;
led<= led_temp; --led cikis degeri
end behavioral;
3. Main Fonksiyon A¸cıklaması:
Led sayısını 8 olarak belirledik. Daha sonra kullanaca˘gımız de˘gi¸skenleri tanımladık.
Her de˘gi¸skenin ne i¸se yaradı˘gı yanındaki a¸cıklama satırında g¨osterilmi¸stir. Sonrasında
1 ve 2. Kısımlarda anlattı˘gım clock_divider ve bit_shifter fonksiyonlatrını, main
fonksiyonumuza component olarak tanımladık.Port map ayarlarını da bu componentlere g¨ore
yaptık. Daha sonra sel fonksiyonu ile frekans ayarı yapmak i¸cin sel fonksiyon
de˘gerlerine g¨ore bir selected fonksiyonu yaptık. Buna g¨ore Sel 01 ise 50 Mhz,
sel 10 ise 25Mhz ve sel 10 ise 10Mhz clock ayarı yapacak ¸sekilde ayarlandı.
Son olarak da led ¸cıkı¸sı fonksiyonların i¸slemlerine g¨ore verildi.
4) Test Bench Kodu:
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity tb_vize is
end;
architecture bench of tb_vize is
constant num_of_bits : integer:=8;
constant clock_period: time := 10 ns;
component vize
Generic ( num_of_bits:integer);
Port ( clk: in std_logic;
reset: in std_logic;
7start: in std_logic;
sel: in std_logic_vector(1 downto 0);
led: out std_logic_vector(num_of_bits-1 downto 0)
);
end component;
signal clk: std_logic;
signal reset: std_logic;
signal start: std_logic;
signal sel: std_logic_vector(1 downto 0);
signal led: std_logic_vector(num_of_bits-1 downto 0) ;
begin
-- Insert values for generic parameters !!
uut: vize generic map ( num_of_bits => num_of_bits )
port map ( clk => clk,
reset => reset,
start => start,
sel => sel,
led => led );
stimulus: process
begin
reset <= ’1’;
wait for 5 ns;
reset <= ’0’;
wait for 5 ns;
start <= ’1’;
sel <= "00";
wait for 10 ns;
start <= ’0’;
wait for 90ns;
--deneme
--reset <= ’1’;
--wait for 10 ns;
--reset <= ’0’;
--start <= ’1’;
--wait for 20 ns;
--start <= ’0’;
--wait for 120 ns;
--deneme
8sel <= "01";
wait for 100ns;
sel <= "10";
wait for 200ns;
sel <= "11";
wait for 700ns;
wait;
end process;
clocking: process
begin
clk <= ’0’, ’1’ after clock_period / 2;
wait for clock_period;
end process;
end;
