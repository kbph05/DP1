library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- WORK SUMMARY (to add to project log excel):
-- 2/13:	12-2:00 pm - fixed the carries of fastripple, fixed issue with the types not matching with baseline
-- 2/11: 2-8:00 pm - wrote a new version of rippleaddr; using now a seperate entity for a 1 bit adder rather than the rtl showing a bunch of gates, this way
--							will contain each adder in a box - a lot cleaner
-- 2/10: 3-5:00 pm - wrote first version of rippleaddr and fastripple architecture - one entity, one architecture, all in one file 

-- Take the FullAddr entity to make 64 full adders into a ripple adder
Entity RippleAddr is
generic( 
	N : natural := 64
);
port (
		X, Y 	: in std_logic_vector(N-1 downto 0);
		Cin	: in std_logic;
		S		: out std_logic_vector(N-1 downto 0);
		Cout 	: out std_logic
);
end RippleAddr;

-- FastRipple Adder
architecture FastRipple of RippleAddr is

signal carries : std_logic_vector(N-1 downto 0);

begin
--		S[0]:
		U0 : entity work.FullAddr(behavioural) port map(X => X(0), Y => Y(0), Cin => Cin, S => S(0), Cout => carries(0));
--		S[62:1]:
		gen0 : for i in 1 to N-2 generate
			U1 : entity work.FullAddr(behavioural) port map(X => X(i), Y => Y(i), Cin => carries(i-1), S => S(i), Cout => carries(i));
		end generate gen0;
--		S[63:
		U3 : entity work.FullAddr(behavioural) port map(X => X(N-1), Y => Y(N-1), Cin => carries(N-2), S => S(N-1), Cout => Cout);
end architecture;

-- Synthesized ripple adder:
architecture Baseline of RippleAddr is
 begin
	process(X,Y)
	begin
		for i in 1 to N-1 loop 
			S <= std_logic_vector(signed(X) + signed(Y));
		end loop;
	end process;
end architecture;
