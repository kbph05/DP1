LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY FA IS
GENERIC (
C: NATURAL := 1
);
PORT( X: IN STD_LOGIC_VECTOR(C-1 DOWNTO 0);
		Y: IN STD_LOGIC_VECTOR(C-1 DOWNTO 0);
		S: OUT STD_LOGIC_VECTOR(C-1 DOWNTO 0);
		Cin: IN STD_LOGIC;
		Cout: OUT STD_LOGIC);
END FA;

ARCHITECTURE LogicFuncFA OF FA IS
-- Basic ripple adder implementation 
SIGNAL Couts: STD_LOGIC_VECTOR(C DOWNTO 0);
BEGIN
Couts(0) <=  Cin;
gen1: FOR i IN 0 TO C-1 GENERATE
	Couts(i+1) <= 	'1' WHEN ((Couts(i) = '1' AND X(i) = '1') OR (Couts(i) = '1' AND Y(i) = '1') OR (X(i) = '1' AND Y(i) = '1')) ELSE
						'0';
	S(i) <= Couts(i) XOR X(i) XOR Y(i);

END GENERATE gen1;
Cout <= Couts(C);

END LogicFuncFA;