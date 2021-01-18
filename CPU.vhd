Library ieee;
use ieee.std_logic_1164.all;

entity CPU is
	
    port (
		clk,rst    : IN std_logic ; 
		
		data_bus : INOUT std_logic_vector (15 downto 0)
    );
end CPU;

architecture CPU_arch of CPU is
    
component ram is
        generic (n: integer:= 16); 
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0);
		mfc : OUT std_logic
	);
end component;

component rom is
        generic (n: integer:= 8); 
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));

end component;

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

component tristate_single is 
port(
    D : in  std_logic;
    Q : out std_logic;
    e : in  std_logic
);
end component;


signal R0_en_in : std_logic;
signal R1_en_in : std_logic;
signal R2_en_in : std_logic;
signal R3_en_in : std_logic;
signal R4_en_in : std_logic;
signal R5_en_in : std_logic;
signal R6_en_in : std_logic;
signal R7_en_in : std_logic;
signal IP_en_in : std_logic;
signal Temp_en_in : std_logic;
signal Y_en_in : std_logic;
signal Z_en_in : std_logic;
signal MDR_en_in : std_logic;
signal MAR_en_in : std_logic;

signal rom_we : std_logic;
signal rom_addr : std_logic_vector(7 downto 0);
signal rom_data_out : std_logic_vector(31 downto 0);
signal rom_data_in : std_logic_vector(31 downto 0);


signal MDR_en_in_inside : std_logic;

signal MDR_ram_Databus_en_in : std_logic;

signal R0_en_out : std_logic;
signal R1_en_out : std_logic;
signal R2_en_out : std_logic;
signal R3_en_out : std_logic;
signal R4_en_out : std_logic;
signal R5_en_out : std_logic;
signal R6_en_out : std_logic;
signal R7_en_out : std_logic;
signal IP_en_out : std_logic;
signal Temp_en_out : std_logic;
signal Z_en_out : std_logic;
signal MDR_en_out : std_logic;

signal memory_read_signal : std_logic;
signal memory_write_signal : std_logic;

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

signal MDR_in : std_logic_vector(15 downto 0);

signal ram_data_out : std_logic_vector(15 downto 0);
signal ram_data_in : std_logic_vector(15 downto 0);



signal not_memory_read_signal : std_logic;

begin
	rom_we <= '0';
    not_memory_read_signal <= not memory_read_signal;

	--d_dest: my_decoder port map(destInp(1 downto 0),e_dest,en_reg);
	--d_src:  my_decoder port map(srcInp(1 downto 0),e_src,en_tristate);
	
	our_ram : ram port map( clk , memory_write_signal , MAR_out , MDR_out , ram_data_out);
	our_rom: rom port map(clk, rom_we, rom_addr, rom_data_in, rom_data_out);

    tri_R0:   tristate_n   port map(data_bus , R0_out ,R0_en_out);
    tri_R1:   tristate_n   port map(data_bus , R1_out ,R1_en_out);
    tri_R2:   tristate_n   port map(data_bus , R2_out ,R2_en_out);
    tri_R3:   tristate_n   port map(data_bus , R3_out ,R3_en_out);
    tri_R4:   tristate_n   port map(data_bus , R4_out ,R4_en_out);
    tri_R5:   tristate_n   port map(data_bus , R5_out ,R5_en_out);
    tri_R6:   tristate_n   port map(data_bus , R6_out ,R6_en_out);
    tri_R7:   tristate_n   port map(data_bus , R7_out ,R7_en_out);
	
	tri_IP:   tristate_n   port map(data_bus  , IP_out, IP_en_out); -- there is ip out?
	
	tri_Temp: tristate_n   port map(data_bus , Temp_out, Temp_en_out);
    tri_Z:    tristate_n   port map(data_bus , Z_out   ,z_en_out );
	tri_MDR:  tristate_n   port map(data_bus , MDR_out ,MDR_en_out);
	
	tri_MDR_ram:  tristate_n   port map(ram_data_out , MDR_in , memory_read_signal);
	tri_MDR_bus:  tristate_n   port map(data_bus , MDR_in , not_memory_read_signal);

	tri_MDR_en_ram:  tristate_single   port map( memory_read_signal, MDR_en_in_inside, memory_read_signal);
	tri_MDR_en_bus:  tristate_single   port map( MDR_en_in , MDR_en_in_inside, not_memory_read_signal);

    R0:   register_n    port map(data_bus,R0_out,clk,R0_en_in,rst);
    R1:   register_n    port map(data_bus,R1_out,clk,R1_en_in,rst);
    R2:   register_n    port map(data_bus,R2_out,clk,R2_en_in,rst);
    R3:   register_n    port map(data_bus,R3_out,clk,R3_en_in,rst);
    R4:   register_n    port map(data_bus,R4_out,clk,R4_en_in,rst);
    R5:   register_n    port map(data_bus,R5_out,clk,R5_en_in,rst);
    R6:   register_n    port map(data_bus,R6_out,clk,R6_en_in,rst);
    R7:   register_n    port map(data_bus,R7_out,clk,R7_en_in,rst);
    IP:   register_n    port map(data_bus,IP_out,clk,IP_en_in,rst);
    Temp: register_n    port map(data_bus,Temp_out,clk,Temp_en_in,rst);
    Y:    register_n    port map(data_bus,Y_out,clk,Y_en_in,rst);
    Z:    register_n    port map(data_bus,Z_out,clk,Z_en_in,rst);
	
	MDR:  register_n    port map(MDR_in,MDR_out,clk, MDR_en_in_inside ,rst);
	
	MAR:  register_n    port map(data_bus,MAR_out,clk,MAR_en_in,rst);


end CPU_arch ; 