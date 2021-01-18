Library ieee;
use ieee.std_logic_1164.all;

entity tristate_single is 
port(
    D : in  std_logic;
    Q : out std_logic;
    e : in  std_logic
);
end tristate_single;

architecture tristate_single_arch of tristate_single is
begin
    Q <= D  when  e = '1'
    else  'Z';
end tristate_single_arch ; -- tristate_n_arch


