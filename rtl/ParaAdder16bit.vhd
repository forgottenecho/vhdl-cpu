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
    signal carries : std_logic_vector (14 downto 0);

begin
    Para8Bit1 : entity work.ParaAdder8bit(rtl) port map(
    a(7 downto 0) =>
    b

    );


end architecture;