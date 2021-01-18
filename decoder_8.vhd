Library ieee;
use ieee.std_logic_1164.all;

entity decoder_8 is 
    port(
        S : in  std_logic_vector (2 downto 0);
        A : out std_logic_vector (7 downto 0);
        e : in  std_logic
    );
end decoder_8;

architecture decoder_8_arch of decoder_8 is
begin
    process(S, e)
    begin
        if (e = '0') then 
            A <= (others => '0');
        elsif (S = "000") then
            A <= (0 => '1', others => '0');
        elsif (S = "001") then
            A <= (1 => '1', others => '0');
        elsif (S = "010") then
            A <= (2 => '1', others => '0');
        elsif (S = "011") then
            A <= (3 => '1', others => '0');
        elsif (S = "100") then
            A <= (4 => '1', others => '0');
        elsif (S = "101") then
            A <= (5 => '1', others => '0');
        elsif (S = "110") then
            A <= (6 => '1', others => '0');
        elsif (S = "111") then
            A <= (7 => '1', others => '0');
        end if;
    end process;
end decoder_8_arch ; -- decoder_arch
