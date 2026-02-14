LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY CSA IS
GENERIC (N: NATURAL := 64;
			C: NATURAL := 4);
PORT (X: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Y: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		S: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Cin: IN STD_LOGIC;
		Cout: OUT STD_LOGIC);
END CSA;

ARCHITECTURE LogicFuncCSA OF CSA IS
-- signal decs
SIGNAL CwC0, CwC1: STD_LOGIC;
SIGNAL SwC0, SwC1, SR: STD_LOGIC_VECTOR((N-1)/2 DOWNTO 0);
SIGNAL Int0, Int1: STD_LOGIC_VECTOR((N+1)/2 DOWNTO 0);
SIGNAL MuxResult: STD_LOGIC_VECTOR((N+1)/2 DOWNTO 0);
SIGNAL tempC: STD_LOGIC;
BEGIN
gen: IF N > C GENERATE
	left_half_upper: 
		ENTITY work.CSA(LogicFuncCSA)
		GENERIC MAP (N => N/2)
		PORT MAP(X=>X(N-1 DOWNTO (N+1)/2), Y=>Y(N-1 DOWNTO (N+1)/2), S=>SwC0, Cin => '0', Cout => CwC0);

	left_half_lower: 
		ENTITY work.CSA(LogicFuncCSA)
		GENERIC MAP (N => N/2)
		PORT MAP(X=>X(N-1 DOWNTO (N+1)/2), Y=>Y(N-1 DOWNTO (N+1)/2), S=>SwC1, Cin => '1', Cout => CwC1);
	
	Int0 <= CWC0 & SwC0;
	Int1 <= CWC1 & SwC1;

	mux:
		ENTITY work.Mux2cNb 
		GENERIC MAP(N => N/2 + 1, C => 1)
		PORT MAP(x1 =>	Int0, x2 => Int1, s => tempC, y => MuxResult);
		Cout <= MuxResult((N+1)/2);
		S(N-1 DOWNTO (N+1)/2) <= MuxResult((N-1)/2 DOWNTO 0);

	right_half: 
		ENTITY work.CSA(LogicFuncCSA)
		GENERIC MAP (N => N/2)
		PORT MAP(
		X=>X((N-1)/2 DOWNTO 0), 
		Y=>Y((N-1)/2 DOWNTO 0), 
		S=>SR, 
		Cin => Cin, 
		Cout => tempC
		);		
		S((N-1)/2 DOWNTO 0) <= SR;
END GENERATE gen;


genbase: IF N <= C GENERATE
	-- Use base full adder
	base_case_fa:
		ENTITY work.FA(LogicFuncFA) 
		GENERIC MAP (C => N)
		PORT MAP(X=>X(C-1 DOWNTO 0), Y=>Y(C-1 DOWNTO 0), S=>S(C-1 DOWNTO 0), Cin => Cin, Cout => Cout);
END GENERATE genbase;




END LogicFuncCSA;
