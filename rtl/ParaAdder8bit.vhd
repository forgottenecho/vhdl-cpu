library ieee;
use ieee.std_logic_1164.all;

entity ParaAdder8Bit is
port(
    a : in std_logic_vector (7 downto 0);
    b : in std_logic_vector (7 downto 0);
    cin : in std_logic;

    s : out std_logic_vector (7 downto 0);
    co: out std_logic);
end entity;

architecture rtl of ParaAdder8Bit is
    signal carries : std_logic_vector (6 downto 0);
begin
    fa0 : entity work.FullAdder(rtl) port map(a(0),b(0),cin,s(0),carries(0));
    fa1 : entity work.FullAdder(rtl) port map(a(1),b(1),carries(0),s(1),carries(1));
    fa2 : entity work.FullAdder(rtl) port map(a(2),b(2),carries(1),s(2),carries(2));
    fa3 : entity work.FullAdder(rtl) port map(a(3),b(3),carries(2),s(3),carries(3));
    fa4 : entity work.FullAdder(rtl) port map(a(4),b(4),carries(3),s(4),carries(4));
    fa5 : entity work.FullAdder(rtl) port map(a(5),b(5),carries(4),s(5),carries(5));
    fa6 : entity work.FullAdder(rtl) port map(a(6),b(6),carries(5),s(6),carries(6));
    fa7 : entity work.FullAdder(rtl) port map(a(7),b(7),carries(6),s(7),co);
end architecture;