Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use ieee.numeric_std.all;

entity counter is 
generic (n: integer:=6);
port(
    cnt : out std_logic_vector (n-1 downto 0);
    clk : in std_logic;
    rst : in std_logic
);
end counter;

architecture counter_arch of counter is
    signal tmp : std_logic_vector (n-1 downto 0);
begin
    process (clk, rst)     
    begin  

          if (rst='1') then   
                 tmp <= std_logic_vector(to_unsigned(10, n));  
          elsif rising_edge(clk) then 
                 tmp <= tmp - 1;
          end if;     

    end process; 
    cnt <= tmp;
end counter_arch ; -- counter_arch


