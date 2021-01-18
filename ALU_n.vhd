Library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_n is
	generic (n: integer:=16); 
	port ( A,B  : in  std_logic_vector (n-1 downto 0);
		S  : in  std_logic_vector  (  4 downto 0);
		Cin  : in  std_logic;
		Cout: out std_logic;
        F   : out std_logic_vector (n-1 downto 0));
end entity;


architecture  ALU_n_arch of ALU_n is

signal 	sum, sumc, sub, subc, comp, Ap1, Am1, Bp1, Bm1    : 	std_logic_vector (n downto 0);
begin
    sum <= ('0' & A) + ('0' & B);
    sumc <= ('0' & A) + ('0' & B) + ("" & Cin);
    sub <= ('0' & A) - ('0' & B);
    subc <= ('0' & A) - ('0' & B) - ("" & Cin);
    comp <= ('0' & B) - ('0' & A);
    Ap1 <= ('0' & A) + ("" & '1');
    Am1 <= ('0' & A) - ("" & '1');
    Bp1 <= ('0' & B) + ("" & '1');
    Bm1 <= ('0' & B) - ("" & '1');
    
    
    F    <= 	
		    	B	                    when S = "00001"
		else 	sum(n-1 downto 0) 	    when S = "00010"
        else 	sumc(n-1 downto 0)	    when S = "00011"
        else    sub(n-1 downto 0)	    when S = "00100"
        else    subc(n-1 downto 0)	    when S = "00101"
        else    A and B                 when S = "00110"
        else    A or  B                 when S = "00111"
        else    A xor B                 when S = "01000"
        else    comp(n-1 downto 0)      when S = "01001"
        else    Ap1(n-1 downto 0)       when S = "10000"
        else    Am1(n-1 downto 0)       when S = "10001"
        else    (others => '0')         when S = "10010"
        else    not A                   when S = "10011"
        else    ('0' & A(n-1 downto 1)) when S = "10100"
        else    (A(0) & A(n-1 downto 1)) when S = "10101"
        else    (A(n-1) & A(n-1 downto 1)) when S = "10110"
        else    (A(n-2 downto 0) & '0') when S = "10111"
        else    (A(n-2 downto 0) & A(n-1)) when S = "11000"
        else    Bp1(n-1 downto 0)       when S = "11001"
        else    Bm1(n-1 downto 0)       when S = "11010"
        else    (others => '0');

    Cout  <=
                sum(n)                  when S = "00010"
        else    sumc(n)                 when S = "00011"
        else    sub(n)                  when S = "00100"
        else    subc(n)                 when S = "00101"
        else    comp(n)                 when S = "01001"
        else    Ap1(n)                  when S = "10000"
        else    Am1(n)                  when S = "10001"
        else    A(0)                    when S = "10100" or S = "10101" or S = "10110"
        else    A(n-1)                  when S = "10111" or S = "11000"
        else    '0';
	
end ALU_n_arch;
