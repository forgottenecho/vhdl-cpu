-- library section
library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
port(
    -- the two operands
    fromBUS : in std_logic_vector (7 downto 0); -- FIXME rename!
    fromAC : in std_logic_vector (7 downto 0);

    -- selects, controls which operation ALU performs
    ALUS : in std_logic_vector (6 downto 0); -- for ALUS7 downto ALUS1

    -- output, the result
    output : out std_logic_vector (7 downto 0) -- last dec doesn't have semicolon

);
end entity;

architecture rtl of ALU is 
    -- base input to arithmetic MUX
    signal NOTbus : std_logic_vector (7 downto 0);

    -- base inputs to logic MUX
    signal ANDresult : std_logic_vector (7 downto 0);
    signal ORresult : std_logic_vector (7 downto 0);
    signal XORresult : std_logic_vector (7 downto 0);
    signal NOTresult : std_logic_vector (7 downto 0);

    -- MUX intermediate values
    signal arithmeticIntermediate1 : std_logic_vector (7 downto 0);
    signal arithmeticIntermediate2 : std_logic_vector (7 downto 0);
    signal arithmeticOutput : std_logic_vector (7 downto 0);
    signal logicalOutput : std_logic_vector (7 downto 0);

    -- fix ALUS miswiring, original design has reverse bit ordering
    signal arithmeticMUX2Sel : std_logic_vector (1 downto 0);
    signal logicalMUXSel : std_logic_vector (1 downto 0);

begin    

    arithmeticMUX1 : entity work.MUX2to1(rtl) port map(
        a => x"00",
        b => fromAC,
        sel => ALUS(0), -- ALUS1
        y => arithmeticIntermediate1);

    arithmeticMUX2 : entity work.MUX4to1(rtl) port map(
        a => x"00",
        b => fromBUS,
        c => NOTbus,
        d => "XXXXXXXX",
        sel => arithmeticMUX2Sel,
        y => arithmeticIntermediate2);

    ParaAdder : entity work.ParaAdder8Bit(rtl) port map(
        a => arithmeticIntermediate1,
        b => arithmeticIntermediate2,
        cin => ALUS(3), -- ALUS4
        s => arithmeticOutput,
        co => open); -- carry out gets thrown away in design

    logicMUX : entity work.MUX4to1(rtl) port map(
        a => ANDresult,
        b => ORresult,
        c => XORresult,
        d => NOTresult,
        sel => logicalMUXSel,
        y => logicalOutput); 

    masterMUX: entity work.MUX2to1(rtl) port map(
        a => arithmeticOutput,
        b => logicalOutput,
        sel => ALUS(6), -- ALUS7 is at ALUS(6)
        y => output);

    -- fix ALUS miswiring
    process(ALUS(5 downto 4), ALUS(2 downto 1)) is
    begin
        arithmeticMUX2Sel <= ALUS(1) & ALUS(2); -- <ALUS2, ALUS3>
        logicalMUXSel <= ALUS(4) & ALUS(5); -- <ALUS5, ALUS6>
    end process;

    -- handle base inputs to MUXs
    process(fromBUS, fromAC) is
    begin
        -- input to arithmetic MUX
        NOTbus <= not fromBUS;

        -- inputs to logic MUX
        ANDresult <= fromBUS and fromAC;
        ORresult <= fromBUS or fromAC;
        XORresult <= fromBUS xor fromAC;
        NOTresult <= not fromAC;
    end process;

end architecture;
