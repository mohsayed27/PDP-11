Library ieee;
use ieee.std_logic_1164.all;

entity register_1 is
	port ( 
        d : in  std_logic;
        q : out std_logic;
        clk : in  std_logic;
        en  : in  std_logic;
        rst : in  std_logic  );
end register_1;

architecture reg_arch of register_1 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= '0'; 
        elsif rising_edge(clk) and en = '1' then
            q <= d;
        end if;
    end process;
end reg_arch ; -- reg_arch


