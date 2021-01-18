library ieee;
use ieee.std_logic_1164.all;

entity registers is
    
    port(destInp :in std_logic_vector(1 downto 0);
    srcInp :in std_logic_vector(1 downto 0);
    e_dest: in std_logic;
    e_src: in std_logic;
    clk,rst: in std_logic;
    data_bus: inout std_logic_vector(15 downto 0));

end entity;

architecture registers_arch of registers is

    component register_n is
        generic (n: integer:=16);
        port ( 
            D : in  std_logic_vector (n-1 downto 0);
            Q : out std_logic_vector (n-1 downto 0);
            clk : in  std_logic;
            en  : in  std_logic;
            rst : in  std_logic  );
    end component;    

    component tristate_n is
        generic (n: integer:=16);
        port (
            D : in  std_logic_vector(n-1 downto 0);
            Q : out std_logic_vector(n-1 downto 0);
            e : in  std_logic );
    end component;    

    --signal reg_en : std_logic_vector(14 downto 0);
    signal R0_en : std_logic;
    signal R1_en : std_logic;
    signal R2_en : std_logic;
    signal R3_en : std_logic;
    signal R4_en : std_logic;
    signal R5_en : std_logic;
    signal R6_en : std_logic;
    signal R7_en : std_logic;
    signal IP_en : std_logic;
    signal Temp_en : std_logic;
    signal Y_en : std_logic;
    signal Z_en : std_logic;
    signal MDR_en : std_logic;
    signal MAR_en : std_logic;

    signal tri_R0_en : std_logic;
    signal tri_R1_en : std_logic;
    signal tri_R2_en : std_logic;
    signal tri_R3_en : std_logic;
    signal tri_R4_en : std_logic;
    signal tri_R5_en : std_logic;
    signal tri_R6_en : std_logic;
    signal tri_R7_en : std_logic;
    signal tri_IP_en : std_logic;
    signal tri_Temp_en : std_logic;
    signal tri_Z_en : std_logic;
    signal tri_MDR_en : std_logic;
    signal tri_MAR_en : std_logic;
    --signal tristate_en : std_logic_vector(11 downto 0); --without reg_Y
    
    signal R0_out : std_logic_vector(15 downto 0);
    signal R1_out : std_logic_vector(15 downto 0);
    signal R2_out : std_logic_vector(15 downto 0);
    signal R3_out : std_logic_vector(15 downto 0);
    signal R4_out : std_logic_vector(15 downto 0);
    signal R5_out : std_logic_vector(15 downto 0);
    signal R6_out : std_logic_vector(15 downto 0);
    signal R7_out : std_logic_vector(15 downto 0);
    signal IP_out : std_logic_vector(15 downto 0);
    signal Temp_out : std_logic_vector(15 downto 0);
    signal Y_out : std_logic_vector(15 downto 0);
    signal Z_out : std_logic_vector(15 downto 0);
    signal MDR_out : std_logic_vector(15 downto 0);
    signal MAR_out : std_logic_vector(15 downto 0);
    
begin
    
    
    d_dest: my_decoder port map(destInp(1 downto 0),e_dest,en_reg);
    d_src:  my_decoder port map(srcInp(1 downto 0),e_src,en_tristate);

    tri_R0: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R1: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R2: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R3: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R4: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R5: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R6: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_R7: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_IP: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_Temp: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_Z: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_MDR: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    tri_MAR: tristate  generic map(n) port map(tristate_en(0),R0_out,data_bus);
    

    R0: register_n generic map(n) port map(data_bus,R0_out,clk,R0_en,rst);
    R1: register_n generic map(n) port map(data_bus,R1_out,clk,R1_en,rst);
    R2: register_n generic map(n) port map(data_bus,R2_out,clk,R2_en,rst);
    R3: register_n generic map(n) port map(data_bus,R3_out,clk,R3_en,rst);
    R4: register_n generic map(n) port map(data_bus,R4_out,clk,R4_en,rst);
    R5: register_n generic map(n) port map(data_bus,R5_out,clk,R5_en,rst);
    R6: register_n generic map(n) port map(data_bus,R6_out,clk,R6_en,rst);
    R7: register_n generic map(n) port map(data_bus,R7_out,clk,R7_en,rst);
    IP: register_n generic map(n) port map(data_bus,IP_out,clk,IP_en,rst);
    Temp: register_n generic map(n) port map(data_bus,Temp_out,clk,Temp_en,rst);
    Y: register_n generic map(n) port map(data_bus,R0_out,clk,Y_en,rst);
    Z: register_n generic map(n) port map(data_bus,R0_out,clk,Z_en,rst);
    MDR: register_n generic map(n) port map(data_bus,R0_out,clk,MDR_en,rst);
    MAR: register_n generic map(n) port map(data_bus,R0_out,clk,MAR_en,rst);

end registers_arch;    