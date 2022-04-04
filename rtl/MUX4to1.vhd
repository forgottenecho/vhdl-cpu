library ieee;
use ieee.std_logic_1164.all;

entity MUX4to1 is
port(
    -- inputs
    a : in std_logic_vector (7 downto 0);
    b : in std_logic_vector (7 downto 0);
    c : in std_logic_vector (7 downto 0);
    d : in std_logic_vector (7 downto 0);
    sel : in std_logic_vector (1 downto 0);

    -- output
    y : out std_logic_vector (7 downto 0) -- don't put semicolon here
);
end entity;

architecture rtl of MUX4to1 is
begin
    process(a, b, sel) is 
    begin
        case sel is
            when "00" => y <= a;
            when "01" => y <= b;
            when "10" => y <= c;
            when "11" => y <= d;
            when others => y <= "XXXXXXXX";
        end case;
    end process;
end architecture;
