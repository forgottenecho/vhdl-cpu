library ieee;
use ieee.std_logic_1164.all

entity ParaAdder16bit is
port(
    a : in std_logic_vector (15 downto 0)
    b : in std_logic_vector (15 downto 0)
    cin : in std_logic;

    s : out std_logic_vector (15 downto 0);
    co: out std_logic);
end entity;

architecture rtl of ParaAdder16bit is
    signal carry : std_logic;

begin
    -- lower order bits
    Para8Bit1 : entity work.ParaAdder8bit(rtl) port map(
    a => a(7 downto 0),
    b => b(7 downto 0),
    cin => cin,

    s => s(7 downto 0),
    co => carry);
        
    -- higher order bits
    Para8Bit2 : entity work.ParaAdder8bit(rtl) port map(
    a => a(15 downto 8),
    b => b(15 downto 8),
    cin => carry,

    s => s(15 downto 8)
    co => co

    );
end architecture;
