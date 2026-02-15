library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- WORK SUMMARY (to add to project log excel):
-- 2/13:	12-2:00 pm - fixed the carries of fastripple, fixed issue with the types not matching with baseline
-- 2/11: 2-8:00 pm - wrote a new version of rippleaddr; using now a seperate entity for a 1 bit adder rather than the rtl showing a bunch of gates, this way
--							will contain each adder in a box - a lot cleaner
-- 2/10: 3-5:00 pm - wrote first version of rippleaddr and fastripple architecture - one entity, one architecture, all in one file 

-- Take the FullAddr entity to make 64 full adders into a ripple adder
Entity RCAN is
generic( 
	N : natural := 64
);
port (
		X, Y 	: in std_logic_vector(N-1 downto 0);
		Cin	: in std_logic;
		S		: out std_logic_vector(N-1 downto 0);
		Cout 	: out std_logic;
		Ovfl	: out std_logic
);
end RCAN;

-- FastRipple Adder
architecture Baseline of RCAN is

signal carries : std_logic_vector(N-1 downto 0);
signal tempC	: std_logic;

begin
--		S[0]:
		U0 : entity work.FullAddr(behavioural) port map(X => X(0), Y => Y(0), Cin => Cin, S => S(0), Cout => carries(0));
--		S[62:1]:
		gen0 : for i in 1 to N-2 generate
			U1 : entity work.FullAddr(behavioural) port map(X => X(i), Y => Y(i), Cin => carries(i-1), S => S(i), Cout => carries(i));
		end generate gen0;
--		S[63:
		U3 : entity work.FullAddr(behavioural) port map(X => X(N-1), Y => Y(N-1), Cin => carries(N-2), S => S(N-1), Cout => tempC);
		Cout <= tempC;
		Ovfl <= tempC XOR carries(N-2);
end architecture;

-- Synthesized ripple adder:
architecture FastRipple of RCAN is

begin
PROCESS(X, Y)
VARIABLE tempS : STD_LOGIC_VECTOR(N DOWNTO 0);
BEGIN
tempS := std_logic_vector((resize(unsigned(X), N+1) + resize(unsigned(Y),N+1) + resize( ( unsigned( std_logic_vector'('0' & Cin)) ),N+1 )   ) );
Ovfl <= (X(N-1) AND Y(N-1) AND (NOT tempS((N-1)))) OR (NOT (X(N-1)) AND (NOT Y(N-1)) AND (tempS((N-1))));
S <= tempS(N-1 DOWNTO 0);
Cout <= tempS(N);
END PROCESS;


end architecture;
