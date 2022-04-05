library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
port(
    a : in std_logic;
    b : in std_logic;
    cin : in std_logic;
    
    s : out std_logic;
    co : out std_logic);
end entity;

architecture rtl of FullAdder is
begin
    process(a, b, cin) is
    begin
        s <= a xor b xor cin;
        co <= ((a xor b) and cin) or (a and b);
    end process;
end architecture;