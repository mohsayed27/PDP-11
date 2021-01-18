Library ieee;
use ieee.std_logic_1164.all;
entity PLA_ALL is 

    port (
        IR: in std_logic_vector(15 downto 0);
        address_out: out std_logic_vector(7 downto 0)
    );

end PLA_ALL;

Library ieee;
use ieee.std_logic_1164.all;
entity PLA_2_OP is

    port (
        src_add_mode: in std_logic_vector(2 downto 0);
        F: out std_logic_vector(7 downto 0)
    );

end PLA_2_OP;

Library ieee;
use ieee.std_logic_1164.all;
entity PLA_1_OP is

    port (
        dst_add_mode: in std_logic_vector(2 downto 0);
        F: out std_logic_vector(7 downto 0)
    );

end PLA_1_OP;

Library ieee;
use ieee.std_logic_1164.all;
entity PLA_NO_OP is 

    port (
        IR: in std_logic_vector(15 downto 0);
        F: out std_logic_vector(7 downto 0)
    );

end PLA_NO_OP;







architecture PLA_2_OP_arch of PLA_2_OP is
    signal A: std_logic_vector(2 downto 0);
begin

    A <= src_add_mode;

    F(7 downto 6) <= "00";
    F(2 downto 0) <= "000";

    F(5) <= A(2);
    F(4) <= ((not A(2)) and (not A(1)) and A(0)) or ((not A(2)) and A(1));
    F(3) <= A(1) or (not (A(2) or A(1) or A(0)));
    

end PLA_2_OP_arch;


architecture PLA_1_OP_arch of PLA_1_OP is
    signal A: std_logic_vector(2 downto 0);
begin

    A <= dst_add_mode;

    F(7) <= '0';
    F(6) <= '1';
    F(2 downto 0) <= "000";

    F(5) <= (not A(2)) and (not A(1)) and A(0);
    F(4) <= A(2);
    F(3) <= A(1);
    

end PLA_1_OP_arch;


architecture PLA_NO_OP_arch of PLA_NO_OP is
    signal A: std_logic_vector(1 downto 0);
begin

    A <= IR(11 downto 10);

    F <= "11111111" when ((not A(1)) and (not A(0))) = '1' else --HLT
        "11001100" when (A(1) and (not A(0))) = '1'; --NO OP
        -- else RESET

end PLA_NO_OP_arch;


architecture PLA_ALL_arch of PLA_ALL is

    component PLA_2_OP is

        port (
            src_add_mode: in std_logic_vector(2 downto 0);
            F: out std_logic_vector(7 downto 0)
        );
    
    end component;

    component PLA_1_OP is

        port (
            dst_add_mode: in std_logic_vector(2 downto 0);
            F: out std_logic_vector(7 downto 0)
        );
    
    end component;

    component PLA_NO_OP is

        port (
            IR: in std_logic_vector(15 downto 0);
            F: out std_logic_vector(7 downto 0)
        );
    
    end component;
    

    signal src_add_mode, dst_add_mode: std_logic_vector(2 downto 0);
    signal most_sig_4: std_logic_vector(3 downto 0);
    signal F_PLA_2_OP, F_PLA_1_OP, F_PLA_NO_OP: std_logic_vector(7 downto 0);

begin

    src_add_mode <= IR(8 downto 6);
    dst_add_mode <= IR(2 downto 0);
    most_sig_4 <= IR(15 downto 12);

    pla_2_op_label : PLA_2_OP  port map (src_add_mode, F_PLA_2_OP);
    pla_1_op_label : PLA_1_OP  port map (dst_add_mode, F_PLA_1_OP);
    pla_no_op_label: PLA_NO_OP port map (IR, F_PLA_NO_OP);

    address_out <= F_PLA_NO_OP when most_sig_4 = "1111" else
                    "10100000" when most_sig_4 = "1110" else
                    F_PLA_1_OP when most_sig_4(3 downto 1) = "110" else
                    F_PLA_2_OP;

end PLA_ALL_arch;