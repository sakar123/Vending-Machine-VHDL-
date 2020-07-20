library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity vmachine_tb is
end;

architecture bench of vmachine_tb is

  component vmachine
  Port (
      clk : in std_logic; 
      reset : in std_logic;
      Quarter,Dollar,Five: in std_logic;
      Prod_A,Prod_B,Prod_C  : in std_logic ;
      Cancel:in std_logic;
      disp_acc:out std_logic_vector (7 downto 0);
      disp_chng:out std_logic_vector (7 downto 0);
      disp_ProdA,disp_ProdB,disp_ProdC,disp_Error_Nomoney,disp_Error_NoProduct: out std_logic
   );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal Quarter,Dollar,Five: std_logic;
  signal Prod_A,Prod_B,Prod_C: std_logic;
  signal Cancel: std_logic;
  signal disp_acc: std_logic_vector (7 downto 0);
  signal disp_chng: std_logic_vector (7 downto 0);
  signal disp_ProdA,disp_ProdB,disp_ProdC,disp_Error_Nomoney,disp_Error_NoProduct: std_logic ;

  constant clock_period: time := 20 ns;
  signal stop_the_clock: boolean;

begin

  uut: vmachine port map ( clk                  => clk,
                           reset                => reset,
                           Quarter              => Quarter,
                           Dollar               => Dollar,
                           Five                 => Five,
                           Prod_A               => Prod_A,
                           Prod_B               => Prod_B,
                           Prod_C               => Prod_C,
                           Cancel               => Cancel,
                           disp_acc             => disp_acc,
                           disp_chng            => disp_chng,
                           disp_ProdA           => disp_ProdA,
                           disp_ProdB           => disp_ProdB,
                           disp_ProdC           => disp_ProdC,
                           disp_Error_Nomoney   => disp_Error_Nomoney,
                           disp_Error_NoProduct => disp_Error_NoProduct );

  stimulus: process
  begin
  
    -- Put initialisation code here
Quarter<='0';
Dollar<='0';
Five<='0';
Prod_A<='0';
Prod_B<='0';
Prod_C<='0';
Cancel<='0';
reset<='0';

reset<='1';
wait for 10ns;
reset<='0';
wait for 40ns;

    -- Put test bench stimulus code here
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Prod_A<='1';
wait for 40ns;
Prod_A<='0';
--2) insert 2 quarters and 2 Dollars and request prod_A => Disp prod_A and Change = $0.75 (Prod_A is reduced by one)
wait for 40ns;
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Prod_A<='1';
wait for 40ns;
Prod_A<='0';
wait for 40ns;

--3) insert 5 Dollars and request prod_B => Disp prod_B and Change = $1.50 (Prod_B is reduced by one)
wait for 40ns;
Five<='1';
wait for 40ns;
Five<='0';
wait for 40ns;
Prod_B<='1';
wait for 40ns;
Prod_B<='0';
wait for 40ns;
--4) insert 2 Dollars and cancel the transaction => Change = $2.0
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Cancel<='1';
wait for 40ns;
Cancel<='0';
wait for 40ns;
--5) repeat 2) ten times and the in the last time => error message (Prod_A_not_avail)
wait for 40ns;
for I in 0 to 10 loop
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Quarter<='1';
wait for 40ns;
Quarter<='0';
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Dollar<='1';
wait for 40ns;
Dollar<='0';
wait for 40ns;
Prod_A<='1';
wait for 40ns;
Prod_A<='0';   
end loop;
stop_the_clock <= true;
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