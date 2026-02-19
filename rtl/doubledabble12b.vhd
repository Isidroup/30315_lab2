-- doubledabble12b.vhd
-- Proyecto: EDig 30315
-- Descripcion:
-- Created : 2020/02/17 19:25:20
-- Last modified: 2026/02/01 20:58:15
--
--  Implementa la conversion binario->BCD utilizando el algoritmo double-dabble
--  ref: https://johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html

------------------------------------------------------------
--                     12-bit Example                     --
--                                                        --
--                  B  B  B  B  B  B  B  B  B  B  B  B    --
--                  I  I  I  I  I  I  I  I  I  I  I  I    --
--                  N  N  N  N  N  N  N  N  N  N  N  N    --
--                  1  1  9  8  7  6  5  4  3  2  1  0    --
--     '0 '0 '0 '0' 1  0  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  V__V__V__V  |  |  |  |  |  |  |  |  |    --
--      |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |  |  |    --
--      |  |  | \__________/ |  |  |  |  |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  |  V__V__V__V  |  |  |  |  |  |  |  |    --
--      |  |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |  |    --
--      |  |  |  | \__________/ |  |  |  |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  |  |  V__V__V__V  |  |  |  |  |  |  |    --
--      |  |  |  |  | /IF>4THEN+3\ |  |  |  |  |  |  |    --
--      |  |  |  |  | \__________/ |  |  |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  V__V__V__V  V__V__V__V  |  |  |  |  |  |    --
--      |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |  |    --
--      |  | \__________/\__________/ |  |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  V__V__V__V  V__V__V__V  |  |  |  |  |    --
--      |  |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |  |    --
--      |  |  | \__________/\__________/ |  |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  |  V__V__V__V  V__V__V__V  |  |  |  |    --
--      |  |  |  | /IF>4THEN+3\/IF>4THEN+3\ |  |  |  |    --
--      |  |  |  | \__________/\__________/ |  |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  V__V__V__V  V__V__V__V  V__V__V__V  |  |  |    --
--      | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |  |    --
--      | \__________/\__________/\__________/ |  |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  V__V__V__V  V__V__V__V  V__V__V__V  |  |    --
--      |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |  |    --
--      |  | \__________/\__________/\__________/ |  |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      |  |  |  V__V__V__V  V__V__V__V  V__V__V__V  |    --
--      |  |  | /IF>4THEN+3\/IF>4THEN+3\/IF>4THEN+3\ |    --
--      |  |  | \__________/\__________/\__________/ |    --
--      |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |    --
--      B  B  B  B  B  B  B  B  B  B  B  B  B  B  B  B    --
--      C  C  C  C  C  C  C  C  C  C  C  C  C  C  C  C    --
--      D  D  D  D  D  D  D  D  D  D  D  D  D  D  D  D    --
--      1  1  1  1  1  1  9  8  7  6  5  4  3  2  1  0    --
--      5  4  3  2  1  0                                  --
--     \__________/\__________/\__________/\__________/   --
--        1000's      100's         10's        1's       --
--                                                        --
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity doubledabble12b is
  port (
    BIN : in std_logic_vector(11 downto 0); -- Num binario 12 bits
    BCD : out std_logic_vector(15 downto 0) -- BCD: M(15:12) C(11:8) D(7:4) U(3:0)
  );
end doubledabble12b;

architecture RTL of doubledabble12b is
  signal c0, c1, c2, c3, c4, c5, c6, c7, c8, c9 : unsigned(3 downto 0);
  signal c10, c11, c12, c13, c14, c15, c16 : unsigned(3 downto 0);
  signal c20, c21, c22, c23 : unsigned(3 downto 0);

  -- LUT para implementar la funci?n IF>4THEN+3
  type lut is array (0 to 15) of unsigned(3 downto 0);
  constant ifgt4_add3 : lut := (
  "0000", "0001", "0010", "0011", "0100",        --  0 ..  4 salida = entrada
  "1000", "1001", "1010", "1011", "1100",        --  5 ..  9 salida = entrada + 3
  "0000", "0000", "0000", "0000", "0000", "0000" -- 10 .. 15 entradas no validas
  );

begin

  c0 <= unsigned('0' & BIN(11 downto 9));
  c1 <= ifgt4_add3(to_integer(c0));
  c2 <= ifgt4_add3(to_integer(c1(2 downto 0) & BIN(8)));
  c3 <= ifgt4_add3(to_integer(c2(2 downto 0) & BIN(7)));
  c4 <= ifgt4_add3(to_integer(c3(2 downto 0) & BIN(6)));
  c5 <= ifgt4_add3(to_integer(c4(2 downto 0) & BIN(5)));
  c6 <= ifgt4_add3(to_integer(c5(2 downto 0) & BIN(4)));
  c7 <= ifgt4_add3(to_integer(c6(2 downto 0) & BIN(3)));
  c8 <= ifgt4_add3(to_integer(c7(2 downto 0) & BIN(2)));
  c9 <= ifgt4_add3(to_integer(c8(2 downto 0) & BIN(1)));

  c10 <= '0' & c1(3) & c2(3) & c3(3);
  c11 <= ifgt4_add3(to_integer(c10));
  c12 <= ifgt4_add3(to_integer(c11(2 downto 0) & c4(3)));
  c13 <= ifgt4_add3(to_integer(c12(2 downto 0) & c5(3)));
  c14 <= ifgt4_add3(to_integer(c13(2 downto 0) & c6(3)));
  c15 <= ifgt4_add3(to_integer(c14(2 downto 0) & c7(3)));
  c16 <= ifgt4_add3(to_integer(c15(2 downto 0) & c8(3)));

  c20 <= '0' & c11(3) & c12(3) & c13(3);
  c21 <= ifgt4_add3(to_integer(c20));
  c22 <= ifgt4_add3(to_integer(c21(2 downto 0) & c14(3)));
  c23 <= ifgt4_add3(to_integer(c22(2 downto 0) & c15(3)));

  BCD <= std_logic_vector('0' & c21(3) & c22(3) & c23 & c16 & c9 & BIN(0));

end architecture;

