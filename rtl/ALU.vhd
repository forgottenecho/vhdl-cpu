-- library section
library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
port(
    -- data inputs
    fromDR : in std_logic_vector (7 downto 0);
    fromAC : in std_logic_vector (7 downto 0);

    -- selects
    ALUS : in std_logic_vector (6 downto 0); -- for ALUS7 downto ALUS1

    -- outputs
    output : out std_logic_vector (7 downto 0) -- last dec doesn't have semicolon

);
end entity;

architecture rtl of ALU is 
    signal ANDresult : std_logic_vector (7 downto 0);
    signal ORresult : std_logic_vector (7 downto 0);
    signal XORresult : std_logic_vector (7 downto 0);
    signal NOTresult : std_logic_vector (7 downto 0);

    signal arithmeticOutput : std_logic_vector (7 downto 0);
    signal logicalOutput : std_logic_vector (7 downto 0);

    -- fix ALUS miswiring
    signal logicalMUXSel : std_logic_vector (1 downto 0);

begin
    masterMUX: entity work.MUX2to1 port map(
        a => arithmeticOutput,
        b => logicalOutput,
        sel => ALUS(6), -- ALUS7 is at ALUS(6)
        y => output);

    logicMUX : entity work.MUX4to1 port map(
        a => ANDresult,
        b => ORresult,
        c => XORresult,
        d => NOTresult,
        sel => logicalMUXSel,
        y => logicalOutput); 

    -- fix ALUS miswiring
    process(ALUS(5 downto 4), ALUS(2 downto 1)) is
    begin
        logicalMUXSel <= ALUS(4) & ALUS(5); -- <ALUS5, ALUS6>
    end process;

    -- handle inputs to logicMUX
    process(fromDR, fromAC) is
    begin
        ANDresult <= fromDR and fromAC;
        ORresult <= fromDR or fromAC;
        XORresult <= fromDR xor fromAC;
        NOTresult <= not fromAC;
    end process;

end architecture;
