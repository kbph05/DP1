LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- Trying to figure out how LUTs are programmed
ENTITY Mux2c1b IS
PORT (
x1, x2 : IN STD_LOGIC;
s: IN STD_LOGIC;
y: OUT STD_LOGIC
);
END Mux2c1b;

ARCHITECTURE LogicFunc OF Mux2c1b IS
BEGIN
--y 	<= x1 WHEN s='0' ELSE
--		x2;
WITH s SELECT 
	y <= 	x1 WHEN '0',
			x2 WHEN others;

END LogicFunc;