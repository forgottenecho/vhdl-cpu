library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
port(
    a : in std_logic; -- addend
    b : in std_logic; -- addend
    cin : in std_logic; -- carry in
    
    s : out std_logic; -- sum bit
    co : out std_logic); -- carry out
end entity;

architecture rtl of FullAdder is
begin
    
    -- perform a + b = <co,s>
    process(a, b, cin) is
    begin
        s <= a xor b xor cin;
        co <= ((a xor b) and cin) or (a and b);
    end process;
    
end architecture;