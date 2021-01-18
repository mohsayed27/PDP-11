Library ieee;
use ieee.std_logic_1164.all;

entity register_MDR is
	generic (n: integer:=16); 
	port ( 
        D_ram : in  std_logic_vector (n-1 downto 0);
        D_bus : in  std_logic_vector (n-1 downto 0);
        Q : out std_logic_vector (n-1 downto 0);
        clk : in  std_logic;
        en_ram  : in  std_logic;
        en_bus  : in  std_logic;
        rst : in  std_logic  );
end register_MDR;

architecture reg_mdr_arch of register_MDR is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others=> '0'); 
        elsif rising_edge(clk) and en_ram = '1' then
            q <= d_ram;
        elsif rising_edge(clk) and en_bus = '1' then
            q <= d_bus;
        end if;
    end process;
end reg_mdr_arch ; -- reg_mdr_arch


