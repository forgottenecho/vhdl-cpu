library ieee;
use ieee.std_logic_1164.all;

entity MUX2to1Tb is
end entity;

architecture sim of MUX2to1Tb is
    signal a : std_logic_vector (7 downto 0) := x"AA";
    signal b : std_logic_vector (7 downto 0) := x"BB";

    signal sel : std_logic;

    signal result : std_logic_vector (7 downto 0);
    
begin
    MUX : entity work.MUX2to1(rtl) port map(
        a => a,
        b => b,
        sel => sel,
        y => result);

    process is
    begin
        sel <= '0';
        wait for 10 ns;
        sel <= '1';
        wait for 10 ns;
    end process;
end architecture;