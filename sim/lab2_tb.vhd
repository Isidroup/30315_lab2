library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2_tb is
end entity lab2_tb;

architecture Behavioral of lab2_tb is

signal a_tb : signed(5 downto 0);
signal b_tb : signed(5 downto 0);
signal sel_tb : std_logic_vector(3 downto 0);
signal ss_tb : std_logic_vector(6 downto 0);
signal an_tb : std_logic_vector(3 downto 0);

signal display: character; -- Número mostrado en el display

component lab2
    port (
        A : in std_logic_vector(5 downto 0);
        B : in std_logic_vector(5 downto 0);
        SEL : in std_logic_vector(3 downto 0);
        SS : out std_logic_vector(6 downto 0);
        AN : out std_logic_vector(3 downto 0)
    );
end component;

begin
-- Instanciar el módulo bajo prueba
uut: lab2
    port map (
        A => std_logic_vector(a_tb),
        B => std_logic_vector(b_tb),
        SEL => sel_tb,
        SS => ss_tb,
        AN => an_tb
    );

-- Proceso de Prueba
process
begin
    -- Verificar en todos los tests que las señales internas `producto`,
    --    `abs_prod`, `mill_sgn`, `bcd `,  `bcd_digito` y `SS` se calculan y
    --    se propagan correctamente.`
    -- T1 Verificar los  casos en los que la salida SS toma los números del 0 al 9.
    --     ponemos A=1, B=0..9, y seleccionamos las unidades.
    sel_tb <= "0001";             -- Selección dígito unidades
    a_tb <= to_signed(1,6);       -- Fijar A=1
    for i in 0 to 9  loop
        b_tb <= to_signed(i,6);   -- B=0..9
        wait for 10 ns;           -- Esperar a que se propague
    end loop;
    wait for 0 ns;
    -- >>> Pon un breakpoint en la línea anterior y Comprueba T1

    -- T2 Verificar que la salida SS representa de forma correcta el signo `-`
    b_tb <= to_signed(-9,6);  -- Fijar B=-9
    sel_tb <= "1000";         -- Selección dígito signo
    wait for 10 ns;           -- Esperar a que se propague
    wait for 0 ns;
    -- >>> Pon un breakpoint en la línea anterior y Comprueba T2

    -- T3: Valores Límite. Comprobar que los productos: 31*31, -32*31, 31*-32 y -32*-32
    --   se representan correctamente en BCD y en 7 segmentos.
    --- T3.1: 31*31 = 961
    a_tb <= to_signed(31,6);  -- Fijar A=31
    b_tb <= to_signed(31,6);  -- Fijar B=31
    sel_tb <= "1000";         -- Selección dígito signo/millares
    wait for 10 ns;           -- Esperar a que se propague
    sel_tb <= "0100";         -- Selección dígito signo/millares
    wait for 10 ns;           -- Esperar a que se propague
    sel_tb <= "0010";         -- Selección dígito signo/millares
    wait for 10 ns;           -- Esperar a que se propague
    sel_tb <= "0001";         -- Selección dígito signo/millares
    wait for 10 ns;           -- Esperar a que se propague
    wait for 0 ns;
    -- >>> Pon un breakpoint en la línea anterior y Comprueba T3.1

    -- Escribe el código paro los otros tres tests:
    -- T3.2: -32*31 = -992
    -- T3.3: 31*-32 = -992
    -- T3.4: -32*-32 = 1024

    -- T4: Añade otros test que consideres necesarios para verificar el correcto
    --     funcionamiento del diseño.

    wait;
end process;

-- Número mostrado en el display en función del valor de ss_tb
                         -- abcdefg
display <= '0' when ss_tb = "0000001" else
           '1' when ss_tb = "1001111" else
           '2' when ss_tb = "0010010" else
           '3' when ss_tb = "0000110" else
           '4' when ss_tb = "1001100" else
           '5' when ss_tb = "0100100" else
           '6' when ss_tb = "0100000" else
           '7' when ss_tb = "0001101" else
           '8' when ss_tb = "0000000" else
           '9' when ss_tb = "0000100" else
           '-' when ss_tb = "1111110" else
           ' ' when ss_tb = "1111111" else
           '?';

end architecture Behavioral;

