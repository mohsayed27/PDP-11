Library ieee;
use ieee.std_logic_1164.all;

entity decoder_16 is 
    port(
        S : in  std_logic_vector (3 downto 0);
        A : out std_logic_vector (15 downto 0);
        e : in  std_logic
    );
end decoder_16;

architecture decoder_16_arch of decoder_16 is
begin
    process(S, e)
    begin
        if (e = '0') then 
            A <= (others => '0');
        elsif (S = "0000") then
            A <= (0 => '1', others => '0');
        elsif (S = "0001") then
            A <= (1 => '1', others => '0');
        elsif (S = "0010") then
            A <= (2 => '1', others => '0');
        elsif (S = "0011") then
            A <= (3 => '1', others => '0');
        elsif (S = "0100") then
            A <= (4 => '1', others => '0');
        elsif (S = "0101") then
            A <= (5 => '1', others => '0');
        elsif (S = "0110") then
            A <= (6 => '1', others => '0');
        elsif (S = "0111") then
            A <= (7 => '1', others => '0');
        elsif (S = "1000") then
            A <= (8 => '1', others => '0');
        elsif (S = "1001") then
            A <= (9 => '1', others => '0');
        elsif (S = "1010") then
            A <= (10 => '1', others => '0');
        elsif (S = "1011") then
            A <= (11 => '1', others => '0');
        elsif (S = "1100") then
            A <= (12 => '1', others => '0');
        elsif (S = "1101") then
            A <= (13 => '1', others => '0');
        elsif (S = "1110") then
            A <= (14 => '1', others => '0');
        elsif (S = "1111") then
            A <= (15 => '1', others => '0');
        end if;
    end process;
end decoder_16_arch ; -- decoder_arch
