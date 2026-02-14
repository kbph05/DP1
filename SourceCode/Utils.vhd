LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE Utils IS
FUNCTION hex_to_slv(Hex : IN STRING; WIDTH : IN NATURAL) RETURN STD_LOGIC_VECTOR;
FUNCTION slv_to_hex(X: IN STD_LOGIC_VECTOR) RETURN STRING;
END PACKAGE;

PACKAGE BODY Utils IS
-- Helper function because the test vector file formatting is really annoying
FUNCTION hex_to_slv(Hex : IN STRING; WIDTH: IN NATURAL) RETURN STD_LOGIC_VECTOR IS
  VARIABLE Result	: STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  VARIABLE V   		: UNSIGNED(WIDTH-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
  FOR i IN 1 TO Hex'LENGTH LOOP
    V := V SLL 4;
    CASE Hex(i) IS
      WHEN '0' => V := V OR to_unsigned(0, WIDTH);
      WHEN '1' => V := V OR to_unsigned(1, WIDTH);
      WHEN '2' => V := V OR to_unsigned(2, WIDTH);
      WHEN '3' => V := V OR to_unsigned(3, WIDTH);
      WHEN '4' => V := V OR to_unsigned(4, WIDTH);
      WHEN '5' => V := V OR to_unsigned(5, WIDTH);
      WHEN '6' => V := V OR to_unsigned(6, WIDTH);
      WHEN '7' => V := V OR to_unsigned(7, WIDTH);
      WHEN '8' => V := V OR to_unsigned(8, WIDTH);
      WHEN '9' => V := V OR to_unsigned(9, WIDTH);
      WHEN 'A' | 'a' => V := V OR to_unsigned(10, WIDTH);
      WHEN 'B' | 'b' => V := V OR to_unsigned(11, WIDTH);
      WHEN 'C' | 'c' => V := V OR to_unsigned(12, WIDTH);
      WHEN 'D' | 'd' => V := V or to_unsigned(13, WIDTH);
      WHEN 'E' | 'e' => V := V OR to_unsigned(14, WIDTH);
      WHEN 'F' | 'f' => V := V OR to_unsigned(15, WIDTH);
      WHEN OTHERS => NULL;
    END CASE;
  END LOOP;
  Result := STD_LOGIC_VECTOR(V);
  RETURN Result;
END FUNCTION;

-- The other way around is also super annoying. Why arent there libraries to make this easier???
FUNCTION slv_to_hex(X: IN std_logic_vector) RETURN STRING IS
  CONSTANT HexChars : string := "0123456789ABCDEF";
  VARIABLE Hstr : string(1 TO X'LENGTH / 4);
  VARIABLE Chunk  : unsigned(3 DOWNTO 0);
BEGIN
  FOR i IN 0 TO X'LENGTH/4 - 1 LOOP
    Chunk := unsigned(X(X'HIGH-i*4 DOWNTO X'HIGH-i*4-3)); -- get 4 bits at a time. 'HIGH is the high end of the slv
    Hstr(i+1) := HexChars(to_integer(Chunk)+1); -- +1 since VHDL string index starts at 1
  END LOOP;
  RETURN Hstr;
END FUNCTION;

END PACKAGE BODY;