Library ieee;
use ieee.std_logic_1164.all;

entity CPU is
    generic (n: integer:=32);
    port (
	clk    : IN std_logic_vector ; 
        my_bus : INOUT std_logic_vector (15 downto 0)
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

begin

end CPU_arch ; 