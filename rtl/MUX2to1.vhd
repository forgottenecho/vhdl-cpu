library ieee;
use ieee.std_logic_1164.all;

entity MUX2to1 is
port(
    -- inputs
    a : in std_logic_vector (7 downto 0);
    b : in std_logic_vector (7 downto 0);
    sel : in std_logic;

    -- output
    y : out std_logic_vector (7 downto 0) -- don't put semicolon here
);
end entity;

architecture rtl of MUX2to1 is
begin
    process(a, b, sel) is 
    begin
        if sel = '0' then
            y <= a;
        else
            y <= b;
        end if;
    end process;
end architecture;
