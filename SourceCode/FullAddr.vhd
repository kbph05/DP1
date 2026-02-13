library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity for a 1-bit adder so that the RTL viewer makes it look nice (and not all gates)
Entity FullAddr is
port (
		X 	: in std_logic;
		Y 	: in std_logic;
		Cin	: in std_logic;
		S		: out std_logic;
		Cout 	: out std_logic
);
end FullAddr;


architecture behavioural of FullAddr is
begin
	S <= (X xor Y)	xor Cin;
	Cout <= (X and Y) or ((X or Y) and Cin);
end architecture;