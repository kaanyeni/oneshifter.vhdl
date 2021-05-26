
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
    start: in std_logic;
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
               port map ( clk         => clk,
                          reset       => reset,
                          start       => start,
                          sel         => sel,
                          led         => led );

  stimulus: process
  begin
  
reset <= '1';
wait for 5 ns;
reset <= '0';
wait for 5 ns;
start <= '1';
sel <= "00";

wait for 10 ns;
start <= '0';
wait for 90ns;

--deneme
--reset <= '1';
--wait for 10 ns;
--reset <= '0';
--start <= '1';
--wait for 20 ns;
--start <= '0';

--wait for 120 ns;
--deneme


sel <= "01";
wait for 100ns;
sel <= "10";
wait for 200ns;
sel <= "11";
wait for 700ns;

    wait;
  end process;
  
  
clocking: process
  begin
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;

  end process;


end;