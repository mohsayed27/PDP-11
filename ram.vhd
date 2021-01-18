LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
    generic (n: integer:= 6); 
	PORT(

		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2**N -1) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL ram : ram_type := (
        6     => X"00000066",
        7     => X"00000077",
        8     => X"00000088",
        9     => X"00000099",
        10    => X"000000AA",
        OTHERS => X"00000000"
        );
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;