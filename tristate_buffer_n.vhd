Library ieee;
use ieee.std_logic_1164.all;

entity tristate_buffer_n is 
generic (n: integer:=32);
port(
    A : in  std_logic_vector(n-1 downto 0);
    Y : out std_logic_vector(n-1 downto 0);
    e : in  std_logic
);
end tristate_buffer_n;

architecture tristate_buffer_n_arch of tristate_buffer_n is
begin
    Y <= 
            A   when    e = '1'
    else    (others=> 'Z');
end tristate_buffer_n_arch ; -- tristate_buffer_n_arch


