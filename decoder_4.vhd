Library ieee;
use ieee.std_logic_1164.all;

entity decoder_4 is 
    port(
        S : in  std_logic_vector (1 downto 0);
        A : out std_logic_vector (3 downto 0);
        e : in  std_logic
    );
end decoder_4;

architecture decoder_4_arch of decoder_4 is
begin
    process(S, e)
    begin
        if (e = '0') then 
            A <= "0000";
        elsif (S = "00") then
            A <= "0001";
        elsif (S = "01") then
            A <= "0010";
        elsif (S = "10") then
            A <= "0100";
        else
            A <= "1000";
        end if;
    end process;
end decoder_4_arch ; -- decoder_arch
