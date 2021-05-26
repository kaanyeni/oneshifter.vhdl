
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tb_clock_divider is
end;

architecture bench of tb_clock_divider is

  component clock_divider
    Port (
    clk: in std_logic;
    reset: in std_logic;
    clk_half: out std_logic;
    clk_quarter: out std_logic;
    clk_tenth: out std_logic
     );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal clk_half: std_logic;
  signal clk_quarter: std_logic;
  signal clk_tenth: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: clock_divider port map ( clk         => clk,
                                reset       => reset,
                                clk_half    => clk_half,
                                clk_quarter => clk_quarter,
                                clk_tenth   => clk_tenth );

  stimulus: process
  begin
  
    -- Put initialisation code here
reset<='1';
wait for 100ns;
reset<='0';


    -- Put test bench stimulus code here

    --stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  