library ieee;
use ieee.std_logic_1164.all;

entity MUX4to1Tb is
end entity;

architecture sim of MUX4to1Tb is
    signal a : std_logic_vector (7 downto 0) := x"AA";
    signal b : std_logic_vector (7 downto 0) := x"BB";
    signal c : std_logic_vector (7 downto 0) := x"CC";
    signal d : std_logic_vector (7 downto 0) := x"DD";

    signal sel : std_logic_vector (1 downto 0);

    signal result : std_logic_vector (7 downto 0);
    
begin
    MUX : entity work.MUX4to1(rtl) port map(
        a => a,
        b => b,
        c => c,
        d => d,
        sel => sel,
        y => result);

    -- mux each possible input to the output variable "result"
    process is
    begin
        sel <= "00";
        wait for 10 ns;
        sel <= "01";
        wait for 10 ns;
        sel <= "10";
        wait for 10 ns;
        sel <= "11";
        wait for 10 ns;
    end process;
end architecture;