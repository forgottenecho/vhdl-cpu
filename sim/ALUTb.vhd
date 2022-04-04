library ieee;
use ieee.std_logic_1164.all;

entity ALUTb is
end entity;

architecture sim of ALUTb is 
    -- artificial AC and DR
    signal testDR : std_logic_vector(7 downto 0);
    signal testAC : std_logic_vector(7 downto 0);

    -- stores result of ALU operation
    signal result : std_logic_vector(7 downto 0);

begin
    ALU : entity work.ALU(rtl) port map(
        fromDR => testDR,
        fromAC => testAC,
        output => result);
    
    process is
    begin
        testAC <= x"AA";
        testDR <= x"FF";

        wait for 10 ns;

        -- testAC <= result;
        testAC <= result;
        
        wait for 10 ns; -- wait then loop

    end process;
end architecture;