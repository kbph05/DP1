LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
use work.Utils.all;

ENTITY TBCSAN IS
GENERIC (N:NATURAL := 64);
END ENTITY TBCSAN;

ARCHITECTURE TestCSAN OF TBCSAN IS
-- Constants
CONSTANT TestVectorFile : STRING := "Adder00.tvs";
CONSTANT PreStimTime: TIME := 1ns;
CONSTANT PostStimTime: TIME := 10ns; -- This should be arbitrary: it's a topology so delays are nonexistent
CONSTANT NL : string(1 to 1) := (1 => CHARACTER'VAL(10));

TYPE TestVectorOp IS RECORD
-- Inputs 
inX: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
inY: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
inC: STD_LOGIC;

-- Outputs
outS: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
outC: STD_LOGIC;
outOvfl: STD_LOGIC;
END RECORD TestVectorOp;

-- Files
FILE InputFile: TEXT OPEN READ_MODE IS "./TestVectors/" & TestVectorFile; 

-- Signals
SIGNAL TBX: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL TBY: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL TBC: STD_LOGIC;
SIGNAL DUT_S: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL DUT_Cout: STD_LOGIC;
SIGNAL DUT_Ovfl: STD_LOGIC;

BEGIN
DUT: ENTITY WORK.CSAN(LogicFuncCSAN)
GENERIC MAP (N => N)
PORT MAP (
X => TBX,
Y => TBY,
Cin => TBC,

S => DUT_S,
Cout => DUT_Cout,
Ovfl => DUT_Ovfl
);
init: 
PROCESS
-- Name of transcript file
VARIABLE TranscriptName : LINE;                    
BEGIN
WRITE(TranscriptName, string'("CSAN Test Results of Latest Run"));
-- WRITELINE(OutputFile, TranscriptName);
WAIT;
END PROCESS init;

main:
PROCESS
-- Line we are currently processing
VARIABLE CurrentLine: LINE;
VARIABLE TranscriptLine: LINE;

-- The TestVector+
VARIABLE TV: TestVectorOp;
-- Index
VARIABLE MeasurementIndex : INTEGER := 1;
-- For holding each segment of the line to set the TV
VARIABLE TempHex : STRING(1 to 16);
VARIABLE ReasonStr : STRING(1 to 2048);
VARIABLE p : NATURAL := 1;
VARIABLE TempBit : STD_LOGIC;
VARIABLE TempChar : CHARACTER;
VARIABLE TVPassed : BOOLEAN;
BEGIN
WHILE NOT ENDFILE(InputFile) LOOP
ReasonStr := (OTHERS => ' ');  
p := 1;

TVPassed := TRUE;
READLINE(InputFile, CurrentLine);
READ(CurrentLine, TempHex);
TV.inX := hex_to_slv(TempHex, 64);
-- REPORT "TVA: " & slv_to_hex(TV.inX);
READ(CurrentLine, TempChar);

READ(CurrentLine, TempHex);
TV.inY := hex_to_slv(TempHex, 64);
-- REPORT "TVB: " & slv_to_hex(TV.inY);
READ(CurrentLine, TempChar);

READ(CurrentLine, TempBit);
TV.inC := TempBit;
-- REPORT "TVCin: " & std_logic'image(TV.inC);
READ(CurrentLine, TempChar);

READ(CurrentLine, TempHex);
TV.outS := hex_to_slv(TempHex, 64);
-- REPORT "TVS: " & slv_to_hex(TV.outS);
READ(CurrentLine, TempChar);

READ(CurrentLine, TempBit);
TV.outC := TempBit;
-- REPORT "TVCout: " & std_logic'image(TV.outC);
READ(CurrentLine, TempChar);

READ(CurrentLine, TempBit);
TV.outOvfl := TempBit;
-- REPORT "TVOvfl: " & std_logic'image(TV.outOvfl);

-- Now, to actually care about the DUT.
-- Apply 'X' to all input bits, hold for PreStimTime
TBX <= (OTHERS => 'X');
TBY <= (OTHERS => 'X');
TBC <= 'X';
WAIT FOR PreStimTime;

-- Apply stimuli until outputs are stable
TBX <= TV.inX;
TBY <= TV.inY;
TBC <= TV.inC;
WAIT FOR PostStimTime;

-- Verify correct result
IF DUT_S /= TV.outS THEN
TVPassed := FALSE;
work.Utils.append(ReasonStr, p, "-|Sum-Mismatch|-");
END IF;

IF DUT_Cout /= TV.outC THEN
TVPassed := FALSE;
work.Utils.append(ReasonStr, p, "-|Cout-Mismatch|-");
END IF;

IF DUT_Ovfl /= TV.outOvfl THEN
TVPassed := FALSE;
work.Utils.append(ReasonStr, p, "-|Ovfl-Mismatch|-");
END IF;

-- One-liner describing the test vector result
IF TVPassed = FALSE THEN
REPORT  "Measurement #" & INTEGER'IMAGE(MeasurementIndex) & " Failed." & 
        " Reason:" & ReasonStr(1 to p-1) & 
        " Stimulus:" & 
        " [A: " & slv_to_hex(TV.inX) & 
        " B: " & slv_to_hex(TV.inY) &
        " Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & "]" &
        " Expected Outputs:" & 
        " [S: " & slv_to_hex(TV.outS) & 
        " Cout: " & INTEGER'IMAGE(conv_integer(TV.outC)) &
        " Ovfl: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) & "]" &
        " Actual Outputs:" & 
        " [S: " & slv_to_hex(DUT_S) & 
        " Cout: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) &
        " Ovfl: " & INTEGER'IMAGE(conv_integer(DUT_Ovfl)) & "]";
ELSE
REPORT  "Measurement #" & INTEGER'IMAGE(MeasurementIndex) & " Passed." & 
        " Stimulus:" & 
        " [A: " & slv_to_hex(TV.inX) & 
        " B: " & slv_to_hex(TV.inY) &
        " Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & "]" &
        " Expected Outputs:" & 
        " [S: " & slv_to_hex(TV.outS) & 
        " Cout: " & INTEGER'IMAGE(conv_integer(TV.outC)) &
        " Ovfl: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) & "]" &
        " Actual Outputs:" & 
        " [S: " & slv_to_hex(DUT_S) & 
        " Cout: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) &
        " Ovfl: " & INTEGER'IMAGE(conv_integer(DUT_Ovfl)) & "]";
END IF;
MeasurementIndex := MeasurementIndex + 1;
END LOOP;
WAIT;
END PROCESS main;
END TestCSAN;

