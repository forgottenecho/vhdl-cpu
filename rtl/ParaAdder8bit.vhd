library ieee;
use ieee.std_logic_1164.all;

entity ParaAdder8Bit is
port(
    a : in std_logic_vector (7 downto 0); -- 8 bit addend
    b : in std_logic_vector (7 downto 0); -- 8 bit addend
    cin : in std_logic; -- carry in

    s : out std_logic_vector (7 downto 0); -- 8 bit sum
    co: out std_logic); -- carry out
end entity;

architecture rtl of ParaAdder8Bit is
    -- store each FA's carry out (except last), to pass into the next FA
    signal carries : std_logic_vector (6 downto 0);
begin
    -- 8 full adders -> 8bit parallel adder
    fa0 : entity work.FullAdder(rtl) port map(a(0),b(0),cin,s(0),carries(0));
    fa1 : entity work.FullAdder(rtl) port map(a(1),b(1),carries(0),s(1),carries(1));
    fa2 : entity work.FullAdder(rtl) port map(a(2),b(2),carries(1),s(2),carries(2));
    fa3 : entity work.FullAdder(rtl) port map(a(3),b(3),carries(2),s(3),carries(3));
    fa4 : entity work.FullAdder(rtl) port map(a(4),b(4),carries(3),s(4),carries(4));
    fa5 : entity work.FullAdder(rtl) port map(a(5),b(5),carries(4),s(5),carries(5));
    fa6 : entity work.FullAdder(rtl) port map(a(6),b(6),carries(5),s(6),carries(6));
    fa7 : entity work.FullAdder(rtl) port map(a(7),b(7),carries(6),s(7),co);
end architecture;