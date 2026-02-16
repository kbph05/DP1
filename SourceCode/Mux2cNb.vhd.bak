LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux2cNb IS
GENERIC (N: NATURAL := 2;
			C: NATURAL := 1);
PORT (x1, x2: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		s: IN STD_LOGIC;
		y: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);
END Mux2cNb;

ARCHITECTURE LogicFuncMux2cNb OF Mux2cNb IS
BEGIN
gen: FOR i IN 0 TO N-1 GENERATE
WITH s SELECT 
y(i) <= 	x1(i) WHEN '0',
			x2(i) WHEN others;	
			
END GENERATE gen;



END LogicFuncMux2cNb;