LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- CSAN entity:
-- N: Number of bits of operands (and sum)
-- C: Recursion base case adder. For instance, if N=64, and C=4, recursive principle of CSA will be applied until N=4.
-- X: Operand 1 (A)
-- Y: Operand 2 (B)
-- Cin: Carry-in
-- S: Sum
-- Cout: Carry-out
-- Ovfl: True if overflow occurred in the addition of signed operands
ENTITY CSAN IS
GENERIC (N: NATURAL := 64;
			C: NATURAL := 1);
PORT (X: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Y: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		S: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Cin: IN STD_LOGIC;
		Cout: OUT STD_LOGIC;
		Ovfl: OUT STD_LOGIC);
END CSAN;

ARCHITECTURE LogicFuncCSAN OF CSAN IS
-- signal decs
-- Carries of the upper and lower adders on left half
SIGNAL CwC0, CwC1: STD_LOGIC;
-- Sums of the upper and lower adders on left half, as well as sum of right half
SIGNAL SwC0, SwC1, SR: STD_LOGIC_VECTOR((N-1)/2 DOWNTO 0);
-- Overflow of upper and lower adders on left half (Not currently in use)
SIGNAL Ovfl0, Ovfl1: STD_LOGIC;
-- Intermediate signals, feeding into the N/2 + 1 bit MUX. Concatenation of carryout of left half adders and their sums
SIGNAL Int0, Int1: STD_LOGIC_VECTOR((N+1)/2 DOWNTO 0);
-- Result of N/2 + 1 bit MUX. Select bit is carry from right half, inputs are the intermediate signals
SIGNAL MuxResult: STD_LOGIC_VECTOR((N+1)/2 DOWNTO 0);
-- Temporary Carryout, Overflow signals. (tempO not currently in use)
SIGNAL tempC, tempO: STD_LOGIC;
BEGIN
-- C equals 1 for usage of standard full adders in base case. For non-leaf nodes, divide into left and right halves
gen: IF N > C GENERATE
-- Left half adder with Cin = 0
	left_half_upper: 
		ENTITY work.CSAN(LogicFuncCSAN)
		GENERIC MAP (N => N/2)
		PORT MAP(X=>X(N-1 DOWNTO (N+1)/2), Y=>Y(N-1 DOWNTO (N+1)/2), S=>SwC0, Cin => '0', Cout => CwC0);--, Ovfl => Ovfl0);
-- Left half adder with Cin = 1
	left_half_lower: 
		ENTITY work.CSAN(LogicFuncCSAN)
		GENERIC MAP (N => N/2)
		PORT MAP(X=>X(N-1 DOWNTO (N+1)/2), Y=>Y(N-1 DOWNTO (N+1)/2), S=>SwC1, Cin => '1', Cout => CwC1);--, Ovfl => Ovfl1);
-- Intermediate (Concatenated Cout, Sums) signals of leftmost adders 
	Int0 <= CWC0 & SwC0;
	Int1 <= CWC1 & SwC1;
-- N/2 + 1 bit, 2 channel MUX to select which carry, sum will be the output for the left half. 
-- If we think of this as a divide and conquer algorithm, this is exactly the merging step.
	mux:
		ENTITY work.Mux2cNb 
		GENERIC MAP(N => N/2 + 1, C => 1)
		PORT MAP(x1 =>	Int0, x2 => Int1, s => tempC, y => MuxResult);
		-- Ultimate Cout
		Cout <= MuxResult((N+1)/2);
		-- Upper half of sum bits
		S(N-1 DOWNTO (N+1)/2) <= MuxResult((N-1)/2 DOWNTO 0);
	--muxOvfl: 
		--ENTITY work.Mux2c1b
		--PORT MAP(x1 => Ovfl0, x2 => Ovfl1, s => tempC, y => Ovfl);

-- Right half
	right_half: 
		ENTITY work.CSAN(LogicFuncCSAN)
		GENERIC MAP (N => N/2)
		PORT MAP(
		X=>X((N-1)/2 DOWNTO 0), 
		Y=>Y((N-1)/2 DOWNTO 0), 
		S=>SR, 
		Cin => Cin, 
		Cout => tempC
		);		
		-- Lower half of sum bits
		S((N-1)/2 DOWNTO 0) <= SR;
-- Ovfl logic: if X,Y are positive (MSB 0), and S is negative (MSB 1), then overflow has occurred. Likewise, overflow is true if X,Y are negative (MSB 1) and S is positive (MSB 0).
Ovfl <= (X(N-1) AND Y(N-1) AND (NOT MuxResult((N-1)/2))) OR (NOT (X(N-1)) AND (NOT Y(N-1)) AND (MuxResult((N-1)/2)));

END GENERATE gen;

-- Recursion base case: just use a full adder
genbase: IF N <= C GENERATE
	-- Use base full adder
	base_case_fa:	
		ENTITY work.FA(LogicFuncFA) 
		GENERIC MAP (C => N)
		PORT MAP(X=>X(C-1 DOWNTO 0), Y=>Y(C-1 DOWNTO 0), S=>S(C-1 DOWNTO 0), Cin => Cin, Cout => Cout, Ovfl => Ovfl);
END GENERATE genbase;
END LogicFuncCSAN;
