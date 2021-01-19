Library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

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

component ALU_n is
	generic (n: integer:=16); 
	port ( A,B  : in  std_logic_vector (n-1 downto 0);
		S  : in  std_logic_vector  (  4 downto 0);
		Cin  : in  std_logic;
		Cout: out std_logic;
        F   : out std_logic_vector (n-1 downto 0));
end component;

component decoder_4 is 
    port(
        S : in  std_logic_vector (1 downto 0);
        A : out std_logic_vector (3 downto 0);
        e : in  std_logic
    );
end component;

component decoder_8 is 
    port(
        S : in  std_logic_vector (2 downto 0);
        A : out std_logic_vector (7 downto 0);
        e : in  std_logic
    );
end component;

component decoder_16 is 
    port(
        S : in  std_logic_vector (3 downto 0);
        A : out std_logic_vector (15 downto 0);
        e : in  std_logic
    );
end component;

component register_1 is
	port ( 
        d : in  std_logic;
        q : out std_logic;
        clk : in  std_logic;
        en  : in  std_logic;
        rst : in  std_logic  );
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

component register_MDR is
	generic (n: integer:=16); 
	port ( 
        D_ram : in  std_logic_vector (n-1 downto 0);
        D_bus : in  std_logic_vector (n-1 downto 0);
        Q : out std_logic_vector (n-1 downto 0);
        clk : in  std_logic;
        en_ram  : in  std_logic;
        en_bus  : in  std_logic;
        rst : in  std_logic  );
end component;

component PLA_ALL is 
     port (
        F8: in std_logic_vector(2 downto 0); -- Control word
        F9: in std_logic; -- Control word
        F10: in std_logic; -- Control word
        F11: in std_logic; -- Control word
        zero_flag, sign_flag, carry_flag: in std_logic;
        IR: in std_logic_vector(15 downto 0);
        address_out: out std_logic_vector(7 downto 0)
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
signal IR_en_in : std_logic;
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
signal IR_offset_en_out : std_logic;
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
signal IR_out : std_logic_vector(15 downto 0);
signal Temp_out : std_logic_vector(15 downto 0);
signal Y_out : std_logic_vector(15 downto 0);
signal Z_out : std_logic_vector(15 downto 0);
signal MDR_out : std_logic_vector(15 downto 0);
signal MAR_out : std_logic_vector(15 downto 0);
signal MDR_in : std_logic_vector(15 downto 0);

signal Rsrc_S : std_logic_vector(2 downto 0);
signal Rdest_S : std_logic_vector(2 downto 0);
signal Rsrc_en_out, Rsrc_en_in, Rdest_en_out, Rdest_en_in : std_logic;

signal ram_data_out : std_logic_vector(15 downto 0);
signal ram_data_in : std_logic_vector(15 downto 0);



signal not_memory_read_signal : std_logic;


-- ALU 
signal Flags_in, Flags_out : std_logic_vector(2 downto 0);
signal CarryF, Flags_en : std_logic;
signal ZeroF : std_logic;
signal ZF, SF, CF, F1 : std_logic;
signal SignF : std_logic;
signal Fout : std_logic_vector(15 downto 0);
signal Carryout : std_logic;
--signal ALU_S : std_logic_vector(4 downto 0);

-- Operation
signal F0_next_address : std_logic_vector(7 downto 0);
signal F1_reg_out	: std_logic_vector(3 downto 0);	
signal F2_reg_in	: std_logic_vector(2 downto 0);	
signal F3_reg_in2	: std_logic_vector(1 downto 0);	
signal F5_ALU_S	: std_logic_vector(4 downto 0);
signal F6_write : std_logic;
signal F6_read : std_logic;
signal F7_WMFC : std_logic;
signal F8_ORing : std_logic_vector(2 downto 0);	
signal F9_PLA_out : std_logic;
signal F10_HLT : std_logic;
signal F11_end : std_logic;

signal IR_offset_out : std_logic_vector(15 downto 0);	

signal PLA_address_out: std_logic_vector(7 downto 0);

signal rom_out_inside : std_logic_vector(31 downto 0);	

signal F1_reg_out_dec_en : std_logic;
signal F2_reg_in_dec_en : std_logic;
signal F3_reg_in2_dec_en : std_logic;

signal F1_reg_out_en : std_logic_vector(15 downto 0);
signal F2_reg_in_en : std_logic_vector(7 downto 0);
signal F3_reg_in2_en : std_logic_vector(3 downto 0);


signal Src_reg_in, Src_reg_out, Dest_reg_in, Dest_reg_out : std_logic_vector(7 downto 0);

signal not_clk : std_logic;

begin
	rom_we <= '0';
    not_memory_read_signal <= not memory_read_signal;
	not_clk <= not clk;
	--d_dest: my_decoder port map(destInp(1 downto 0),e_dest,en_reg);
	--d_src:  my_decoder port map(srcInp(1 downto 0),e_src,en_tristate);
	
	our_ram : ram port map( clk , memory_write_signal , MAR_out , MDR_out , ram_data_out);
	our_rom: rom port map(clk, rom_we, rom_addr, rom_data_in, rom_out_inside);

    tri_R0:   tristate_n   port map( R0_out ,data_bus ,R0_en_out);
    tri_R1:   tristate_n   port map( R1_out ,data_bus ,R1_en_out);
    tri_R2:   tristate_n   port map( R2_out ,data_bus ,R2_en_out);
    tri_R3:   tristate_n   port map( R3_out ,data_bus ,R3_en_out);
    tri_R4:   tristate_n   port map( R4_out ,data_bus ,R4_en_out);
    tri_R5:   tristate_n   port map( R5_out ,data_bus ,R5_en_out);
    tri_R6:   tristate_n   port map( R6_out ,data_bus ,R6_en_out);
    tri_R7:   tristate_n   port map( R7_out ,data_bus ,R7_en_out);
	
	tri_IR_offset:   tristate_n   port map(IR_offset_out, data_bus, IR_offset_en_out); 
	
	tri_Temp: tristate_n   port map(Temp_out, data_bus, Temp_en_out);
    tri_Z:    tristate_n   port map(Z_out, data_bus,z_en_out );
	tri_MDR:  tristate_n   port map(MDR_out, data_bus,MDR_en_out);
	
	--tri_MDR_ram:  tristate_n   port map(ram_data_out , MDR_in , memory_read_signal);
	--tri_MDR_bus:  tristate_n   port map(data_bus , MDR_in , not_memory_read_signal);

	--tri_MDR_en_ram:  tristate_single   port map( memory_read_signal, MDR_en_in_inside, memory_read_signal);
	--tri_MDR_en_bus:  tristate_single   port map( MDR_en_in , MDR_en_in_inside, not_memory_read_signal);

    R0:   register_n    port map(data_bus,R0_out,clk,R0_en_in,rst);
    R1:   register_n    port map(data_bus,R1_out,clk,R1_en_in,rst);
    R2:   register_n    port map(data_bus,R2_out,clk,R2_en_in,rst);
    R3:   register_n    port map(data_bus,R3_out,clk,R3_en_in,rst);
    R4:   register_n    port map(data_bus,R4_out,clk,R4_en_in,rst);
    R5:   register_n    port map(data_bus,R5_out,clk,R5_en_in,rst);
    R6:   register_n    port map(data_bus,R6_out,clk,R6_en_in,rst);
    R7:   register_n    port map(data_bus,R7_out,clk,R7_en_in,rst);
    IR:   register_n    port map(data_bus,IR_out,clk,IR_en_in,rst);
    Temp: register_n    port map(data_bus,Temp_out,clk,Temp_en_in,rst);
    Y:    register_n    port map(data_bus,Y_out,clk,Y_en_in,rst);
	Z:    register_n    port map(Fout,Z_out,clk,Z_en_in,rst);
	
	MDR:  register_MDR  port map(ram_data_out,data_bus,MDR_out,clk,memory_read_signal ,MDR_en_in ,rst);
	
	MAR:  register_n    port map(data_bus,MAR_out,clk,MAR_en_in,rst);

	Rom_out_register:  register_n generic map(32) port map(rom_out_inside , rom_data_out , not_clk ,'1' ,rst);

	-- ALU 

	Flags_en <= '1' when Z_en_in = '1' and (not (rom_addr = "00000001"))
	else '0';

	Flags_in <= Carryout & SignF & ZeroF;

	Flag_reg:   register_n   generic map (3)
				port map(Flags_in,Flags_out ,clk,Flags_en,rst);

	our_ALU: ALU_n 	port map(Y_out, data_bus, F5_ALU_S, CF, Carryout, Fout);

	SignF <= Fout(15);
	ZeroF <=
				'1' 	when   to_integer(unsigned(Fout))=0
				else 	'0';

	-- operatiom

	
	F0_next_address <= rom_data_out(31 downto 24);
	F1_reg_out	<= rom_data_out(23 downto 20);	
	F2_reg_in	<= rom_data_out(19 downto 17);	
	F3_reg_in2	<= rom_data_out(16 downto 15);	
	Y_en_in <= rom_data_out(14);
	F5_ALU_S	<= rom_data_out(13 downto 9);
	memory_write_signal <= rom_data_out(8);
	memory_read_signal  <= rom_data_out(7);
	F7_WMFC <= rom_data_out(6);
	F8_ORing <= rom_data_out(5 downto 3);	
	F9_PLA_out <= rom_data_out(2);
	F10_HLT <= rom_data_out(1);
	F11_end <= rom_data_out(0);

	SF <= Flags_out(1);
	ZF <= Flags_out(0);
	CF <= Flag_out(2);
	our_PLA: PLA_ALL port map(F8_ORing,F9_PLA_out,F10_HLT, F11_end,ZF,SF,CF, IR_out, PLA_address_out);

	F1_reg_out_dec_en <= '1';
	F1_reg_out_dec : decoder_16 port map (F1_reg_out, F1_reg_out_en, F1_reg_out_dec_en);

	IR_offset_out <= IR_out and (15 downto 9 => '0', 8 downto 0 => '1');
	R7_en_out <= Src_reg_out(7) or Dest_reg_out(7) or F1_reg_out_en(1); -- PLAAAAAAAA
	MDR_en_out <= F1_reg_out_en(2);
	Z_en_out <= F1_reg_out_en(3);
	Rsrc_en_out <=  F1_reg_out_en(4);
	Rdest_en_out <=  F1_reg_out_en(5);
	Temp_en_out <= F1_reg_out_en(7);
	IR_offset_en_out <= F1_reg_out_en(8);

	F2_reg_in_dec_en <= '1';
	F2_reg_in_dec : decoder_8 port map (F2_reg_in, F2_reg_in_en, F2_reg_in_dec_en);

	R7_en_in <= Src_reg_in(7) or Dest_reg_in(7) or F2_reg_in_en(1); -- PLAAAAAAAAA out
	IR_en_in <= F2_reg_in_en(2);
	Z_en_in <= F2_reg_in_en(3);
	Rsrc_en_in <= F2_reg_in_en(4);
	Rdest_en_in <= F2_reg_in_en(5);

	F3_reg_in2_dec_en <= '1';
	F3_reg_in2_dec : decoder_4 port map (F3_reg_in2, F3_reg_in2_en, F3_reg_in2_dec_en);
	MAR_en_in <= F3_reg_in2_en(1);
	MDR_en_in <= F3_reg_in2_en(2);
	Temp_en_in <= F3_reg_in2_en(3);

	rom_addr <= F0_next_address or PLA_address_out when rst ='0'
				else "00000000"; 


	Rsrc_S <= IR_out(11 downto 9);
	Rdest_S <= IR_out(5 downto 3);

	Src_reg_in_dec : decoder_8 port map (Rsrc_S ,Src_reg_in, Rsrc_en_in);

	Dest_reg_in_dec : decoder_8 port map (Rdest_S ,Dest_reg_in, Rdest_en_in);

	Src_reg_out_dec : decoder_8 port map (Rsrc_S ,Src_reg_out, Rsrc_en_out);

	Dest_reg_out_dec : decoder_8 port map (Rdest_S ,Dest_reg_out, Rdest_en_out);


	R0_en_in <= Src_reg_in(0) or Dest_reg_in(0);
	R1_en_in <= Src_reg_in(1) or Dest_reg_in(1);
	R2_en_in <= Src_reg_in(2) or Dest_reg_in(2);
	R3_en_in <= Src_reg_in(3) or Dest_reg_in(3);
	R4_en_in <= Src_reg_in(4) or Dest_reg_in(4);
	R5_en_in <= Src_reg_in(5) or Dest_reg_in(5);
	R6_en_in <= Src_reg_in(6) or Dest_reg_in(6);
	

	R0_en_out <= Src_reg_out(0) or Dest_reg_out(0);
	R1_en_out <= Src_reg_out(1) or Dest_reg_out(1);
	R2_en_out <= Src_reg_out(2) or Dest_reg_out(2);
	R3_en_out <= Src_reg_out(3) or Dest_reg_out(3);
	R4_en_out <= Src_reg_out(4) or Dest_reg_out(4);
	R5_en_out <= Src_reg_out(5) or Dest_reg_out(5);
	R6_en_out <= Src_reg_out(6) or Dest_reg_out(6);

end CPU_arch ; 


-- F(5) <= '00'
-- F(4) <= '00'
-- F(3) <= '00'
-- f(n-1 downto 0)<= ('0' & a(n-1 downto 1) ) 