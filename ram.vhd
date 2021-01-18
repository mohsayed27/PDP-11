LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
    generic (n: integer:= 16); 
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0);
		mfc : OUT std_logic
);
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2**16 -1) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type := (
        0=>"0001111010110000",
	1=>"0000000001100100",
	2=>"0001111010010000",
	3=>"0000000000001010",
	4=>"0001010110110000",
	5=>"0000000000000100",
	6=>"0010010110010000",
	7=>"0000000000000100",
	8=>"1100000000100000",
	9=>"1100000000100000",
	10=>"1111100000000000",
	11=>"1001100000100000",
	12=>"1110010100000100",
	13=>"1111000000000000",
	14=>"0000000000001010",
		OTHERS => "0000000000000000"
		--others => std_logic_vector(to_unsigned(0, 16))
		);
		
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we='1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
					mfc  <= '1' ;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
		
END syncrama;