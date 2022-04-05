library ieee;
use ieee.std_logic_1164.all;

entity ParaAdder8BitTb is
end entity;

architecture sim of ParaAdder8BitTb is
    signal testA : std_logic_vector (7 downto 0);
    signal testB : std_logic_vector (7 downto 0);
    signal testCin : std_logic;

    signal s : std_logic_vector (7 downto 0);
    signal co : std_logic;
begin
    ParaAdder: entity work.ParaAdder8Bit(rtl) port map(
        a => testA,
        b => testB,
        cin => testCin,
        
        s => s,
        co => co);

    process is
    begin
        -- 69 + 42 = 0x6F
        testA <= x"45";
        testB <= x"2A";
        testCin <= '0';
        wait for 10 ns;

        -- 69 + 42 + 1 = 0x70
        testA <= x"45";
        testB <= x"2A";
        testCin <= '1';
        wait for 10 ns;
        
        -- 255 + 255 = 0x1FE
        testA <= x"FF";
        testB <= x"FF";
        testCin <= '0';
        wait for 10 ns;

        -- 255 + 255 + 1 = 0x1FF
        testA <= x"FF";
        testB <= x"FF";
        testCin <= '1';
        wait for 10 ns;
        
        -- 0 + 13 + 1 = 0x0E
        testA <= x"00";
        testB <= x"13";
        testCin <= '1';
        wait for 10 ns;
    end process;

end architecture;