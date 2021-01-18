Library ieee;
use ieee.std_logic_1164.all;

entity CU is
    generic (n: integer:=32);
    port (
        src_e : in std_logic;
        dst_e : in std_logic;
        rst   : in std_logic;
        clk   : in std_logic;
        src_S : in std_logic_vector (1 downto 0);
        dst_S : in std_logic_vector (1 downto 0)
    );
end CU;

architecture CU_arch of CU is
    signal A_out, B_out, C_out, D_out : std_logic_vector (n-1 downto 0);
    signal reg_src_out , reg_dst_out       : std_logic_vector (3 downto 0);
    signal data_bus : std_logic_vector (n-1 downto 0);
    signal cnt_out  : std_logic_vector (  5 downto 0);
    signal ram_out : std_logic_vector (n-1 downto 0);
    signal ram_src_e , ram_dst_e : std_logic;

component counter is
generic (n: integer:= 6);
port(
    cnt : out std_logic_vector (n-1 downto 0);
    clk : in std_logic;
    rst : in std_logic
);
end component;

component ram is
    generic (n: integer:= 6);
    port(
        clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0)
    );
end component;

component tristate_buffer_n is
    generic (n: integer);
    port (
        A : in  std_logic_vector(n-1 downto 0);
        Y : out std_logic_vector(n-1 downto 0);
        e : in  std_logic
    );
end component;

component register_n is
    generic (n: integer);
    port (
        D : in  std_logic_vector (n-1 downto 0);
        Q : out std_logic_vector (n-1 downto 0);
        clk : in  std_logic;
        en  : in  std_logic;        
        rst : in  std_logic
    );
end component;

component decoder is
    port(
        S : in  std_logic_vector (1 downto 0);
        A : out std_logic_vector (3 downto 0);
        e : in  std_logic
    );
end component;

begin
    R  :	ram	generic map (6)
            port map (clk, ram_dst_e, cnt_out, data_bus, ram_out );
    
    Ctr :   counter	generic map (6)
            port map (cnt_out, clk, rst);

    Tr :    tristate_buffer_n	generic map (n)
            port map (ram_out, data_bus, ram_src_e);

    dst_dec : decoder port map (dst_S, reg_dst_out, dst_e);
    ram_src_e <= not src_e;

    A  :	register_n	generic map (n)
            port map (data_bus, A_out, clk, reg_dst_out(0), rst );
    B  :	register_n	generic map (n)
            port map (data_bus, B_out, clk, reg_dst_out(1), rst );
    C  :	register_n	generic map (n)
            port map (data_bus, C_out, clk, reg_dst_out(2), rst );
    D  :	register_n	generic map (n)
            port map (data_bus, D_out, clk, reg_dst_out(3), rst );

    src_dec : decoder port map (src_S, reg_src_out, src_e);
    ram_dst_e <= not dst_e;

    Ta :    tristate_buffer_n	generic map (n)
            port map (A_out, data_bus, reg_src_out(0));
    Tb :    tristate_buffer_n	generic map (n)
            port map (B_out, data_bus, reg_src_out(1));
    Tc :    tristate_buffer_n	generic map (n)
            port map (C_out, data_bus, reg_src_out(2));
    Td :    tristate_buffer_n	generic map (n)
            port map (D_out, data_bus, reg_src_out(3));
end CU_arch ; -- CU_arch
