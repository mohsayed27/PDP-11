Library ieee;
use ieee.std_logic_1164.all;

entity register_n is
	generic (n: integer:=16); 
	port ( 
        D : in  std_logic_vector (n-1 downto 0);
        Q : out std_logic_vector (n-1 downto 0);
        clk : in  std_logic;
        en  : in  std_logic;
        rst : in  std_logic  );
end register_n;

architecture reg_n_arch of register_n is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others=> '0'); 
        elsif rising_edge(clk) and en = '1' then
            q <= d;
        end if;
    end process;
end reg_n_arch ; -- reg_n_arch


