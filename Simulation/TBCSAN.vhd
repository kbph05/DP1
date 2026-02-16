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
-- FILE OutputFile: TEXT OPEN WRITE_MODE IS "../Documentation/OutputFiles/CSAN_LatestTestResults.txt";


-- Signals
SIGNAL TBX: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL TBY: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL TBC: STD_LOGIC;
SIGNAL DUT_S: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL DUT_Cout: STD_LOGIC;
SIGNAL DUT_Ovfl: STD_LOGIC;
-- Table
-- We do not know how many test vectors there are so we cant have this.
-- TYPE TestDataTable IS ARRAY (1 to ?) OF TestVectorOP;



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
-- This is scrapped now.
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

-- WRITE(TranscriptLine, string'("FAILURE: Sum mismatch at Measurement #" & INTEGER'IMAGE(MeasurementIndex)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Stimulus:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("A: ") & slv_to_hex(TV.inX));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("B: ") & slv_to_hex(TV.inY));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Cin: ") & INTEGER'IMAGE(conv_integer(TV.inC)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Outputs:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Expected Sum: ") & slv_to_hex(TV.outS));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Actual Sum: ") & slv_to_hex(DUT_S));
-- WRITELINE(OutputFile, TranscriptLine);
-- ASSERT DUT_S = TV.outS
-- REPORT 
-- "FAILURE: Sum mismatch" & NL &
-- "Measurement #" & INTEGER'IMAGE(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX)& NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected S: " & slv_to_hex(TV.outS) & NL &
-- "Actual S: " & slv_to_hex(DUT_S) 
-- SEVERITY WARNING
-- ;
work.Utils.append(ReasonStr, p, "-|Sum-Mismatch|-");
-- REPORT ReasonStr(1 TO p-1);

ELSE


-- REPORT
-- "SUCCESS: Sum match" & NL &
-- "Measurement #" & integer'image(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX) & NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected S: " & slv_to_hex(TV.outS) & NL &
-- "Actual S: " & slv_to_hex(DUT_S); 
-- WRITE(TranscriptLine, string'("Sum: Measurement #" & INTEGER'IMAGE(MeasurementIndex) & ": passed"));
-- WRITELINE(OutputFile, TranscriptLine);
END IF;



IF DUT_Cout /= TV.outC THEN
TVPassed := FALSE;
-- WRITE(TranscriptLine, string'("FAILURE: Carryout mismatch at Measurement #" & INTEGER'IMAGE(MeasurementIndex)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Stimulus:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("A: ") & slv_to_hex(TV.inX));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("B: ") & slv_to_hex(TV.inY));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Cin: ") & INTEGER'IMAGE(conv_integer(TV.inC)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Outputs:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Expected Cout: ") & INTEGER'IMAGE(conv_integer(TV.outC)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Actual Cout: ") & INTEGER'IMAGE(conv_integer(DUT_Cout)));
-- WRITELINE(OutputFile, TranscriptLine);
-- ASSERT DUT_Cout = TV.outC REPORT
-- "FAILURE: Carry mismatch" & NL &
-- "Measurement #" & integer'image(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX) & NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected Cout: " & INTEGER'IMAGE(conv_integer(TV.outC)) & NL &
-- "Actual Cout: " & INTEGER'IMAGE(conv_integer(DUT_Cout))
-- SEVERITY WARNING
-- ;
work.Utils.append(ReasonStr, p, "-|Cout-Mismatch|-");
-- REPORT ReasonStr(1 TO p-1);
ELSE
-- REPORT
-- "SUCCESS: Cout match" & NL &
-- "Measurement #" & integer'image(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX) & NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected Cout: " & INTEGER'IMAGE(conv_integer(TV.outC)) & NL &
-- "Actual Cout: " & INTEGER'IMAGE(conv_integer(DUT_Cout));
-- WRITE(TranscriptLine, string'("Cout: Measurement #" & INTEGER'IMAGE(MeasurementIndex) & ": passed"));
-- WRITELINE(OutputFile, TranscriptLine);

END IF;


IF DUT_Ovfl /= TV.outOvfl THEN
TVPassed := FALSE;
-- WRITE(TranscriptLine, string'("FAILURE: Overflow mismatch at Measurement #" & INTEGER'IMAGE(MeasurementIndex)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Stimulus:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("A: ") & slv_to_hex(TV.inX));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("B: ") & slv_to_hex(TV.inY));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Cin: ") & INTEGER'IMAGE(conv_integer(TV.inC)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Outputs:"));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Expected Ovfl: ") & INTEGER'IMAGE(conv_integer(TV.outOvfl)));
-- WRITELINE(OutputFile, TranscriptLine);
-- WRITE(TranscriptLine, string'("Actual Ovfl: ") & INTEGER'IMAGE(conv_integer(DUT_Ovfl)));
-- WRITELINE(OutputFile, TranscriptLine);
-- ASSERT DUT_Ovfl = TV.outOvfl REPORT
-- "FAILURE: Overflow mismatch" & NL &
-- "Measurement #" & integer'image(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX) & NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected Ovfl: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) & NL &
-- "Actual Ovfl: " & INTEGER'IMAGE(conv_integer(DUT_Ovfl))
-- SEVERITY WARNING
-- ;
work.Utils.append(ReasonStr, p, "-|Ovfl-Mismatch|-");
-- REPORT ReasonStr(1 TO p-1);
ELSE
-- REPORT
-- "SUCCESS: Overflow match" & NL &
-- "Measurement #" & integer'image(conv_integer(MeasurementIndex)) & ":" & NL &
-- "Stimulus:" & NL &
-- "A: " & slv_to_hex(TV.inX) & NL &
-- "B: " & slv_to_hex(TV.inY) & NL &
-- "Cin: " & INTEGER'IMAGE(conv_integer(TV.inC)) & NL &
-- "Expected Ovfl: " & INTEGER'IMAGE(conv_integer(TV.outOvfl)) & NL &
-- "Actual Ovfl: " & INTEGER'IMAGE(conv_integer(DUT_Ovfl));
-- WRITE(TranscriptLine, string'("Ovfl: Measurement #" & INTEGER'IMAGE(MeasurementIndex) & ": passed"));
-- WRITELINE(OutputFile, TranscriptLine);
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

