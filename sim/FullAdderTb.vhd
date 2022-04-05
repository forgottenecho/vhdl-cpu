library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- for unsigned numbers and "+" operator

entity FullAdderTb is
end entity;

architecture sim of FullAdderTb is
    signal testSeq : unsigned (2 downto 0) := "000";
    signal outputSum : std_logic;
    signal outputCarry : std_logic;
begin
    adder : entity work.FullAdder(rtl) port map(
        a => testSeq(0),
        b => testSeq(1),
        cin => testSeq(2),

        s => outputSum,
        co => outputCarry);
        
    process is
    begin
        wait for 10 ns;
        testSeq <= testSeq + 1;
    end process;
end architecture;