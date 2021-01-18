Library ieee;
use ieee.std_logic_1164.all;

entity tristate_n is 
generic (n: integer:=16);
port(
    D : in  std_logic_vector(n-1 downto 0);
    Q : out std_logic_vector(n-1 downto 0);
    e : in  std_logic
);
end tristate_n;

architecture tristate_n_arch of tristate_n is
begin
    Q <= D  when  e = '1'
    else  (others=> 'Z');
end tristate_n_arch ; -- tristate_n_arch


