Library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity PLA_ALL is 

    port (
        F8: in std_logic_vector(2 downto 0); -- Control word
        F9: in std_logic; -- Control word
        F10: in std_logic; -- Control word
        F11: in std_logic; -- Control word
        zero_flag, sign_flag, carry_flag: in std_logic;
        IR: in std_logic_vector(15 downto 0);
        address_out: out std_logic_vector(7 downto 0)
    );

end PLA_ALL;

Library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity PLA_2_OP is

    port (
        src_add_mode: in std_logic_vector(2 downto 0);
        F: out std_logic_vector(7 downto 0)
    );

end PLA_2_OP;

Library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity PLA_1_OP is

    port (
        dst_add_mode: in std_logic_vector(2 downto 0);
        F: out std_logic_vector(7 downto 0)
    );

end PLA_1_OP;

Library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
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

    F <= ("11" & O"77") when A = "00" else --HLT
        ("11" & O"14") when A = "10"; --NO OP
        -- else RESET
    --('0' & a(n-1 downto 1) ) 
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
    signal two_op: std_logic;
    signal no_op: std_logic;
    signal one_op: std_logic;
    signal one_op_br: std_logic;
    signal br_code: std_logic_vector(2 downto 0);
    
    
    signal F_PLA_2_OP, F_PLA_1_OP, F_PLA_NO_OP: std_logic_vector(7 downto 0);
    signal F8_no_action: std_logic_vector(7 downto 0);
    signal F8_or_dst: std_logic_vector(7 downto 0);
    signal F8_or_indirect_src: std_logic_vector(7 downto 0);
    signal F8_or_indirect_dst: std_logic_vector(7 downto 0);
    signal F8_or_cnd: std_logic_vector(7 downto 0);
    signal F8_or_operation: std_logic_vector(7 downto 0);
    signal F8_or_direct_reg: std_logic_vector(7 downto 0);

    signal F8_out: std_logic_vector(7 downto 0);
    signal F9_out: std_logic_vector(7 downto 0);


begin

    src_add_mode <= IR(8 downto 6);
    dst_add_mode <= IR(2 downto 0);
    most_sig_4 <= IR(15 downto 12);

    two_op <= not (most_sig_4(3) and most_sig_4(2) );
    no_op <= '1' when most_sig_4 = "1111" else '0';
    one_op_br <= '1' when most_sig_4 = "1110" else '0';
    one_op <= '1' when most_sig_4(3 downto 1) = "110" else '0';
    br_code <= IR(11 downto 9);
    


    pla_2_op_label : PLA_2_OP  port map (src_add_mode, F_PLA_2_OP);
    pla_1_op_label : PLA_1_OP  port map (dst_add_mode, F_PLA_1_OP);
    pla_no_op_label: PLA_NO_OP port map (IR, F_PLA_NO_OP);

    F9_out <= F_PLA_NO_OP when no_op = '1' else
                    ("10" & O"40") when one_op_br = '1' else
                    F_PLA_1_OP when one_op = '1' else
                    F_PLA_2_OP;

    F8_no_action <= ("00" & O"00");

    F8_or_dst <= ("00" & O"00") when dst_add_mode = "000" else -- Reg direct
                ("00" & O"10") when dst_add_mode = "010" or dst_add_mode = "011" else -- Auto inc
                ("00" & O"20") when dst_add_mode = "100" or dst_add_mode = "101" else -- Auto dec
                ("00" & O"30") when dst_add_mode = "110" or dst_add_mode = "111" else -- Indexed
                ("00" & O"40") when dst_add_mode = "001"; -- Reg indirect
    

    F8_or_indirect_src <= ("00" & O"00") when src_add_mode(0) = '1' else -- indirect
                        ("00" & O"01"); -- direct

    F8_or_indirect_dst <= ("00" & O"00") when dst_add_mode(0) = '1' else -- indirect
                          ("00" & O"01"); -- direct

    F8_or_cnd <= ("00" & O"00")   when
                            br_code = "000" or (br_code = "001" and zero_flag = '1')
                            or (br_code = "010" and zero_flag = '0') or (br_code = "011" and carry_flag = '0') 
                            or (br_code = "100" and (carry_flag = '0' or zero_flag = '1'))
                            or (br_code = "101" and carry_flag = '1')
                            or (br_code = "110" and (carry_flag = '1' or zero_flag = '1'))
                            else ("00" & O"10");  

    
    F8_or_operation(7) <= '1' when   one_op = '1' else '0';
    F8_or_operation(6 downto 4) <= "000";
    F8_or_operation(3 downto 0) <=  IR(15 downto 12) when two_op = '1' else   IR(12 downto 9)    ;
    -- F8_or_operation(7) <= '0';
    -- F8_or_operation(6) <= '0' when no_op = '0' and one_op = '0' and one_op_br = '0' else -- 2 op
    --                       '1' when one_op = '1';
    -- F8_or_operation(5 downto 4) <= "00";
    -- F8_or_operation(3 downto 0) <= IR(15 downto 12) when no_op = '0' and one_op = '0' and one_op_br = '0' else -- 2 op
    --                                IR(12 downto 9) when one_op = '1';

    F8_or_direct_reg(7 downto 1) <= "0000000";
    F8_or_direct_reg(0) <= '1' when dst_add_mode = "000" else '0';

    F8_out <= F8_no_action when F8 = "000" else
                F8_or_dst when F8 = "001" else
                F8_or_indirect_src when F8 = "010" else 
                F8_or_indirect_dst when F8 = "011" else 
                F8_or_cnd when F8 = "100" else 
                F8_or_operation when F8 = "101" else 
                F8_or_direct_reg when F8 = "110";

    address_out <= F8_out or F9_out when F11 = '0'
                else "00000000";

end PLA_ALL_arch;